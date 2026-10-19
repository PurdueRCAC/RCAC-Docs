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

# How-To: Migrate PVC Data from Geddes to Geddes2

This guide walks you through migrating your application Persistent Volume Claim (PVC) data from the Geddes cluster to the Geddes2 infrastructure.



## Overview

The migration process consists of the following steps:

1. Download kubeconfig files from Rancher
2. Export PVC YAML definitions from Geddes
3. Clean and update PVC YAML files
4. Prepare the destination environment on Geddes2
5. Deploy the migration toolbox on Geddes and Geddes2
6. Launch the destination toolbox on Geddes2 and transfer data
7. Clean up resources and restart applications



## Prerequisites

Before starting the migration:

* Ensure you have access to both Geddes and Geddes2 clusters
* Ensure `kubectl` is installed and configured
* Ensure you have permissions to:
    * View PVCs
    * Create deployments and services
    * Scale workloads
    * Create secrets



## Step 1 — Download kubeconfig from Rancher

Download the kubeconfig file for each cluster from Rancher.

If you need instructions on configuring Kubernetes contexts, see:

[Configure kubectl Contexts](migration_namespaces_workloads.md#configure-kubectl-contexts)



## Step 2 — Export PVC YAML from Geddes

You can export PVC definitions using either the provided export utility script or standard `kubectl` commands.



### Option A — Use the Export Utility Script (Recommended)

See:

[Export and Deploy YAML File](migration_namespaces_workloads.md#export-and-deploy-yaml-file)



### Option B — Use kubectl Commands

#### List PVCs in Your Namespace

```bash
kubectl --context geddes -n my-namespace get pvc
```

Example output:

```text
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                 VOLUMEATTRIBUTESCLASS   AGE
my-pvc-name       Bound    pvc-3baec850-3465-56y4-a11c-9d545ef4580f   15Gi       RWO            geddes-standard-singlenode   <unset>                 665d
```

#### Export the PVC YAML

```bash
kubectl --context geddes -n my-namespace get pvc my-pvc-name -o yaml > my-pvc-name.yaml
```



## Step 3 — Clean Up PVC YAML Before Deployment

Before deploying the PVC to Geddes2, the YAML file must be cleaned and updated.



### Clean the YAML File

Use the cleanup script provided here:

[Python Cleanup Script](migration_namespaces_workloads.md#python-cleanup-script_1)



### Update the StorageClass Name

!!! important
    Before deploying the PVC YAML to Geddes2, you must update the `storageClassName` to match an available storage class on Geddes2.

To view available storage classes on Geddes2:

```bash
kubectl --context geddes2 get storageclass
```

Open the exported YAML file and replace:

```yaml
storageClassName: geddes-standard-singlenode
```

with:

```yaml
storageClassName: <STORAGE-CLASS-NAME>
```

Use the appropriate storage class assigned to your project. If you are unsure which storage class to use, contact:

`rcachelp@purdue.edu`



## Step 4 — Prepare the Geddes2 Environment

Before transferring data, prepare the destination environment on Geddes2.



### Scale Down Applications on Geddes2

The destination PVC must not be mounted or in use during migration.

```bash
kubectl --context geddes2 -n my-namespace scale deployment <my-deployment-name> --replicas=0
```



### Scale Down Applications on Geddes

To prevent data corruption, stop workloads on the source cluster before migration.

```bash
kubectl --context geddes -n my-namespace scale deployment <my-deployment-name> --replicas=0
```



## Step 5 — Deploy the Migration Toolbox on Geddes

Deploy the rsync migration toolbox on the source cluster.



### 1. Create the SSH Password Secret

```bash
kubectl kubectl --context geddes -n my-namespace create secret generic ssh-root-password --from-literal=ROOT_PASSWORD='SuperStrongPassword!'
```



### 2. Deploy the Migration Toolbox

Update `OLD_PVC_NAME_HERE` and `<YOUR-NAMESPACE>` before deployment.

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

Apply the YAML:

```bash
kubectl kubectl --context geddes apply -f migration-toolbox.yaml
```



### 3. Retrieve the Source IP Address

```bash
kubectl kubectl --context geddes -n my-namespace get svc migration-toolbox-ssh -w
```

Wait until the `EXTERNAL-IP` is assigned.

This IP address will be used as the source endpoint during the rsync transfer.



## Step 6 — Launch the Destination Toolbox and Transfer Data

Deploy the same toolbox YAML on Geddes2.

Ensure that:

* `claimName` references the new PVC names on Geddes2
* The namespace matches your project my-namespace



### 1. Create the SSH Password Secret

```bash
kubectl create secret generic ssh-root-password --from-literal=ROOT_PASSWORD='SuperStrongPassword!'
```



### 2. Deploy the Toolbox on Geddes2

```bash
kubectl --context geddes2 apply -f migration-toolbox.yaml
```



### 3. Enter the Destination Toolbox Pod

```bash
kubectl --context geddes -n my-namespace exec -it deployment/migration-toolbox -- /bin/bash
```



### 4. Run the Rsync Transfer

Replace `SOURCE_IP_HERE` with the external IP obtained earlier.

verification and confirm that data exists before rsync.

```bash
ls -lah /mnt/data-01
du -sh /mnt/data-01
```

If you satisfied with the ls and due output, you can run rsync

```bash
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/data-01/ /mnt/data-01/
```

!!! tip
    If migrating multiple PVCs, run a separate rsync command for each mounted directory.



## Step 7 — Cleanup and Restart Applications



### Delete the Migration Toolbox Resources

!!! important
    Use a strong temporary password and delete the migration toolbox immediately after migration is complete.

Run these commands on both Geddes and Geddes2:

* Geddes

    ```bash
    kubectl --context geddes -n my-namespace delete deployment migration-toolbox
    kubectl --context geddes -n my-namespace delete svc migration-toolbox-ssh
    kubectl --context geddes -n my-namespace delete secret ssh-root-password
    ```

* Geddes2

    ```bash
    kubectl --context geddes -n my-namespace delete deployment migration-toolbox
    kubectl --context geddes -n my-namespace delete svc migration-toolbox-ssh
    kubectl --context geddes -n my-namespace delete secret ssh-root-password
    ```



### PVC validation

- PVCs are Bound
- Application pods are Running
- Data exists on Geddes2



### Scale Applications Back Up on Geddes2

```bash
kubectl --context geddes2 -n my-namespace scale deployment <your-deployment-name> --replicas=1
```

Your application should now be running on Geddes2 with migrated data.



## Migrating Multiple PVCs

If your application uses multiple PVCs (for example: config, data, and logs), you can mount them all into the same migration toolbox deployment.



### Example: Multiple PVC Volume Mounts

Add the following under the `containers` section:

```yaml
volumeMounts:
- name: vol-config
  mountPath: /mnt/config
- name: vol-data
  mountPath: /mnt/data
- name: vol-logs
  mountPath: /mnt/logs
```

Add the following under `spec.template.spec`:

```yaml
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



## Multi-PVC Rsync Commands

Run one rsync command per mount point.

!!! note
    Ensure you include trailing slashes (`/`) so the contents of the directories are copied correctly.

```bash
# Sync Config
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/config/ /mnt/config/

# Sync Data
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/data/ /mnt/data/

# Sync Logs
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/logs/ /mnt/logs/
```



## Additional Notes

* Ensure workloads remain scaled down during the entire migration process
* Verify PVC capacity and storage class compatibility before deployment
* Test applications after migration before removing old resources
* Keep backups of important data before starting the migration process
