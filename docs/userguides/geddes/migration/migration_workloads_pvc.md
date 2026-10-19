---
tags:
  - Geddes
authors:
  - jin456
  - goughes
  - fbakhit
search:
  boost: 2
---

# Guide: Migrating Workloads and PVC Data (Geddes to Geddes2)

This guide walks you through moving your **application settings** and **persistent data** from the old Geddes cluster to the new Geddes2 infrastructure.



## Step 1 — Identify & Export (Old Cluster)

Before moving, you need to capture your current configuration.

1. **Find your resources:**

    ```bash
    kubectl get deployment,pvc,service
    ```

2. **Export your YAML (Recommended):** This saves your current "live" configuration to a file.

    ```bash
    kubectl get deployment <your-deployment-name> -o yaml > app-migration.yaml
    ```



## Step 2 — Prepare the New Environment (Geddes2)

You must set up the "landing zone" on the new cluster before moving data.

1. **Update the YAML:** Open `app-migration.yaml` and update the `storageClassName` to the new Geddes2 standard (e.g., `ceph-rbd`).
2. **Apply to Geddes2:**

    ```bash
    kubectl apply -f app-migration.yaml
    ```

3. **Scale Down immediately:** The new PVC must be "unlocked" (not in use by your app) so the migration tool can write to it.

    ```bash
    kubectl scale deployment <your-deployment-name> --replicas=0
    ```



## Step 3 — Stop Apps & Launch Source "Vault" (Old Geddes)

To prevent data corruption, stop the old app and start the migration toolbox.

1. **Scale down on Old Geddes:**

    ```bash
    kubectl scale deployment <your-deployment-name> --replicas=0
    ```

2. **Create the SSH Password Secret:**

    ```bash
    kubectl create secret generic ssh-root-password --from-literal=ROOT_PASSWORD='SuperStrongPassword!'
    ```

3. **Launch the Source Toolbox:** Update the `OLD_PVC_NAME_HERE` in the YAML below. If you have **multiple PVCs**, follow the "Note" section to add more mount points.

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: migration-toolbox
      namespace: <YOUR-NAMESPACE> 
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: migration-toolbox
      template:
        metadata:
          labels:
            app: migration-toolbox
        spec:
          containers:
          - name: toolbox
            image: geddes-registry.rcac.purdue.edu/geddes-migration/pvc-migration-toolbox:1.0.0
            ports:
            - containerPort: 22
            env:
            - name: ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: ssh-root-password
                  key: ROOT_PASSWORD
            resources:
              requests:
                cpu: "200m"
                memory: "256Mi"
              limits:
                cpu: "1"
                memory: "1Gi"
            volumeMounts:
            - name: data-vol-01
              mountPath: /mnt/data-01
            # NOTE: For multiple PVCs, add more volumeMounts here (e.g., /mnt/data-02)
            command: ["/bin/bash", "-c"]
            args:
              - |
                echo "root:${ROOT_PASSWORD}" | chpasswd
                exec /usr/sbin/sshd -D
          volumes:
          - name: data-vol-01
            persistentVolumeClaim:
              claimName: OLD_PVC_NAME_HERE
          # NOTE: For multiple PVCs, add more volumes here pointing to your other PVCs
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: migration-toolbox-ssh
      namespace: <YOUR-NAMESPACE>
    spec:
      type: LoadBalancer
      ports:
        - name: ssh
          port: 2222
          targetPort: 22
      selector:
        app: migration-toolbox
    ```

4. **Get the Source IP:**

    ```bash
    kubectl get svc migration-toolbox-ssh -w
    ```

    *Wait for the **EXTERNAL-IP** to appear. This is your **Source IP**.*



## Step 4 — Launch Destination & Transfer (Geddes2)

Now, run the toolbox on the new cluster to "pull" the data.

1. **Deploy to Geddes2:** Use the same YAML from Step 3, but ensure the `claimName` points to your **New PVC Names** on Geddes2.
2. **Enter the Destination Pod:**

    ```bash
    kubectl exec -it deployment/migration-toolbox -- /bin/bash
    ```

3. **Run the Transfer (Rsync):**
    Replace `SOURCE_IP_HERE` with the IP from Step 3.

    !!! tip
        If migrating multiple PVCs, run this command for each mount path (e.g., `/mnt/data-01/`, `/mnt/data-02/`).

    ```bash
    rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/data-01/ /mnt/data-01/
    ```



## Step 5 — Cleanup & Restart

1. **Delete Migration Tools:**
    Run this on **both** clusters to release the PVCs and clean up resources.

    ```bash
    kubectl delete deployment migration-toolbox
    kubectl delete svc migration-toolbox-ssh
    ```

2. **Scale Up on Geddes2:**
    Your data is now moved. Start your application!

    ```bash
    kubectl scale deployment <your-deployment-name> --replicas=1
    ```



## Migrating Multiple PVCs at Once

If your application uses multiple disks (e.g., one for config, one for data, and one for logs), you don't need to run separate migration pods. You can mount them all into the same "Toolbox."



### Update the Deployment YAML

Add a unique entry for each disk under both volumeMounts and volumes.

```yaml
# Add this inside the "containers" section
        volumeMounts:
        - name: vol-config
          mountPath: /mnt/config
        - name: vol-data
          mountPath: /mnt/data
        - name: vol-logs
          mountPath: /mnt/logs

# Add this inside the "spec.template.spec" section
      volumes:
      - name: vol-config
        persistentVolumeClaim:
          claimName: my-app-config-pvc
      - name: vol-data
        persistentVolumeClaim:
          claimName: my-app-data-pvc
      - name: vol-logs
        persistentVolumeClaim:
          claimName: my-app-logs-pvc
```



### Multi-PVC Sync Command

Once you are inside the Destination Pod, you will need to run rsync for each directory.

!!! note
    Ensure you include the trailing slashes (/) so that the contents of the folders are moved, rather than nesting the folders inside each other.

```bash
# Sync Config
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/config/ /mnt/config/

# Sync Data
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/data/ /mnt/data/

# Sync Logs
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/logs/ /mnt/logs/
```
