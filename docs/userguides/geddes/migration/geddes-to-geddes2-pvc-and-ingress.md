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

# Migrating PVC Data and Ingress from Geddes to Geddes2

This guide covers persistent volume claim (PVC) data migration and application ingress migration from Geddes to Geddes2.

## Overview

The migration process consists of the following steps:

1. Configure the Geddes and Geddes2 kubectl contexts (see [Migrating Namespaces and Workloads](geddes-to-geddes2-namespaces-workloads.md#1-configure-kubectl-contexts))
2. Export PVC YAML definitions from Geddes
3. Clean and update PVC YAML files
4. Prepare the destination environment on Geddes2
5. Deploy the migration toolbox on Geddes and Geddes2
6. Launch the destination toolbox on Geddes2 and transfer data
7. Clean up resources and restart applications

---

## Prerequisites

Before starting the migration:

* Ensure you have access to both Geddes and Geddes2 clusters
* Ensure `kubectl` is installed and configured
* Ensure you have permissions to:

    * View PVCs
    * Create deployments and services
    * Scale workloads
    * Create secrets

---

## Step 1 — Configure kubectl Contexts

Configure the Geddes and Geddes2 kubectl contexts (see [Migrating Namespaces and Workloads](geddes-to-geddes2-namespaces-workloads.md#1-configure-kubectl-contexts)).

---

## Step 2 — Export PVC YAML from Geddes

You can export PVC definitions using either the provided export utility script or standard `kubectl` commands.

### Option A — Use the Export Utility Script (Recommended)

See the export resources utility script documented in [Migrating Namespaces and Workloads](geddes-to-geddes2-namespaces-workloads.md#example-c-export-all-resources-using-script).

---

### Option B — Use kubectl Commands

#### List PVCs in Your Namespace

```bash
kubectl --context geddes -n my-namespace get pvc
```

Example output:

```bash
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                 VOLUMEATTRIBUTESCLASS   AGE
my-pvc-name       Bound    pvc-3baec850-3465-56y4-a11c-9d545ef4580f   15Gi       RWO            geddes-standard-singlenode   <unset>                 665d
```

#### Export the PVC YAML

```bash
kubectl --context geddes -n my-namespace get pvc my-pvc-name -o yaml > my-pvc-name.yaml
```

---

## Step 3 — Clean Up PVC YAML Before Deployment

Before deploying the PVC to Geddes2, the YAML file must be cleaned and updated.

---

### Clean the YAML File

Use the cleanup utility in [Migrating Namespaces and Workloads](geddes-to-geddes2-namespaces-workloads.md#step-2-resource-cleanup-before-deployment-to-geddes2). Review its documented behavior before running it; the multiple-file cleanup script overwrites files in place.

---

### Update the StorageClass Name

!!! warning "Important"

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

`rcac-help@purdue.edu`

---

## Step 4 — Prepare the Geddes2 Environment

Before transferring data, prepare the destination environment on Geddes2.

---

### Scale Down Applications on Geddes2

The destination PVC must not be mounted or in use during migration.

```bash
kubectl --context geddes2 -n my-namespace scale deployment <my-deployment-name> --replicas=0
```

---

### Scale Down Applications on Geddes

To prevent data corruption, stop workloads on the source cluster before migration.

```bash
kubectl --context geddes -n my-namespace scale deployment <my-deployment-name> --replicas=0
```

---

## Step 5 — Deploy the Migration Toolbox on Geddes

Deploy the rsync migration toolbox on the source cluster.

---

### 1. Create the SSH Password Secret

```bash
kubectl --context geddes -n my-namespace create secret generic ssh-root-password --from-literal=ROOT_PASSWORD='SuperStrongPassword!'
```

---

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
kubectl --context geddes apply -f migration-toolbox.yaml
```

---

### 3. Retrieve the Source IP Address

```bash
kubectl --context geddes -n my-namespace get svc migration-toolbox-ssh -w
```

Wait until the `EXTERNAL-IP` is assigned.

This IP address will be used as the source endpoint during the rsync transfer.

---

## Step 6 — Launch the Destination Toolbox and Transfer Data

Deploy the same toolbox YAML on Geddes2.

Ensure that:

* `claimName` references the new PVC names on Geddes2
* The namespace matches your project my-namespace

---

### 1. Create the SSH Password Secret

```bash
kubectl --context geddes2 -n my-namespace create secret generic ssh-root-password --from-literal=ROOT_PASSWORD='SuperStrongPassword!'
```

---

### 2. Deploy the Toolbox on Geddes2

```bash
kubectl --context geddes2 apply -f migration-toolbox.yaml
```

---

### 3. Enter the Destination Toolbox Pod

```bash
kubectl --context geddes2 -n my-namespace exec -it deployment/migration-toolbox -- /bin/bash
```

---

### 4. Run the Rsync Transfer

Replace `SOURCE_IP_HERE` with the external IP obtained earlier.

Verification and confirm that data exists before rsync.

```bash
ls -lah /mnt/data-01
du -sh /mnt/data-01
```

If you are satisfied with the `ls` and `du` output, you can run rsync:

```bash
rsync -avz -e 'ssh -p 2222' root@SOURCE_IP_HERE:/mnt/data-01/ /mnt/data-01/
```

!!! tip

    If migrating multiple PVCs, run a separate rsync command for each mounted directory.

---

## Step 7 — Cleanup and Restart Applications

---

### Delete the Migration Toolbox Resources

**IMPORTANT:** Use a strong temporary password and delete the migration toolbox immediately after migration is complete.

Run these commands on both Geddes and Geddes2:

* Geddes

    ```bash
    kubectl --context geddes -n my-namespace delete deployment migration-toolbox
    kubectl --context geddes -n my-namespace delete svc migration-toolbox-ssh
    kubectl --context geddes -n my-namespace delete secret ssh-root-password
    ```

* Geddes2

    ```bash
    kubectl --context geddes2 -n my-namespace delete deployment migration-toolbox
    kubectl --context geddes2 -n my-namespace delete svc migration-toolbox-ssh
    kubectl --context geddes2 -n my-namespace delete secret ssh-root-password
    ```

---

### PVC validation

- PVCs are Bound
- Application pods are Running
- Data exists on Geddes2

---

### Scale Applications Back Up on Geddes2

```bash
kubectl --context geddes2 -n my-namespace scale deployment <your-deployment-name> --replicas=1
```

Your application should now be running on Geddes2 with migrated data.

---

## Migrating Multiple PVCs

If your application uses multiple PVCs (for example: config, data, and logs), you can mount them all into the same migration toolbox deployment.

---

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

---

### Multi-PVC Rsync Commands

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

---

## Additional Notes

* Ensure workloads remain scaled down during the entire migration process
* Verify PVC capacity and storage class compatibility before deployment
* Test applications after migration before removing old resources
* Keep backups of important data before starting the migration process

---

## Migrating Ingress from Geddes to Geddes V2

### Exposing Applications Using Traefik and Gateway API

**Purpose:** This guide explains how to expose applications running in Kubernetes on Geddesv2 using Traefik and Kubernetes Gateway API.

It also provides instructions for users migrating applications from the original Geddes cluster, which uses NGINX Ingress.

---

### 1. Overview: Geddes vs. Geddesv2

The original Geddes cluster and Geddesv2 use different ingress technologies.

| Feature | Geddes (Old) | Geddesv2 (New) |
|---|---|---|
| Ingress controller | NGINX Ingress | Traefik |
| Routing resource | Ingress | HTTPRoute |
| Configuration | NGINX annotations | Gateway API |
| Advanced routing | NGINX annotations | Gateway API filters / Traefik Middleware |
| TLS termination | NGINX Ingress | Traefik Gateway |

#### Why are we moving away from NGINX Ingress?

The community Kubernetes Ingress NGINX project reached End of Life (EOL) in March 2026.

Following its retirement, the project no longer receives security updates, bug fixes, or maintenance releases.

For this reason, Geddesv2 uses Traefik with Kubernetes Gateway API as the replacement for the old NGINX Ingress infrastructure.

This also provides a more standardized approach to managing application routing.

---

### 2. Available Gateways on Geddesv2

Geddesv2 provides two Traefik Gateway endpoints for application access.

| Gateway | Namespace | Access |
|---|---|---|
| Private | `traefik-private` | Purdue campus network and VPN |
| Public | `traefik-public` | Public Internet |

Users must select the appropriate Gateway when creating an HTTPRoute.

**Private Gateway:**

```yaml
parentRefs:
  - name: private
    namespace: traefik-private
    sectionName: https
    kind: Gateway
```

**Public Gateway:**

```yaml
parentRefs:
  - name: public
    namespace: traefik-public
    sectionName: https
    kind: Gateway
```

The Gateway infrastructure is managed by cluster administrators. Users do not need to deploy their own Gateway or Traefik instance.

---

### 3. Creating an HTTPRoute on Geddesv2

The recommended way to expose an application is by creating an `HTTPRoute`.

#### Example: Exposing an application

Suppose you have an application running in the following namespace:

- Namespace: `my-app-namespace`
- Service name: `my-app`
- Service port: `8080`

Create a file named `my-app-httproute.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-app
  namespace: my-app-namespace
spec:
  parentRefs:
    - name: private
      namespace: traefik-private
      sectionName: https
      kind: Gateway

  hostnames:
    - my-app.geddes.rcac.purdue.edu

  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: my-app
          port: 8080
```

Apply the configuration:

```bash
kubectl apply -f my-app-httproute.yaml
```

Verify the HTTPRoute:

```bash
kubectl get httproute -n my-app-namespace
```

Check its status:

```bash
kubectl describe httproute my-app -n my-app-namespace
```

Look for these conditions:

- `Accepted: True`
- `ResolvedRefs: True`

Once the route is accepted and the backend is correctly configured, the application should be accessible at:

`https://my-app.geddes.rcac.purdue.edu`

#### Public application example

If the application needs to be accessible from the public Internet, change the parent reference to:

```yaml
parentRefs:
  - name: public
    namespace: traefik-public
    sectionName: https
    kind: Gateway
```

The rest of the HTTPRoute configuration remains the same.

---

### 4. Understanding the HTTPRoute Configuration

| Field | Description |
|---|---|
| `metadata.name` | Name of the HTTPRoute |
| `metadata.namespace` | Namespace containing the application |
| `parentRefs.name` | Name of the Gateway |
| `parentRefs.namespace` | Namespace containing the Gateway |
| `sectionName` | Gateway listener to use (`https`) |
| `hostnames` | DNS hostname assigned to the application |
| `matches.path.value` | URL path to match |
| `backendRefs.name` | Kubernetes Service name |
| `backendRefs.port` | Kubernetes Service port |

**Important:** The `parentRefs.namespace` field is required when the Gateway is in a different namespace from the HTTPRoute.

For example, an HTTPRoute in `my-app-namespace` references a Gateway in `traefik-private`. Therefore, the Gateway namespace must be specified.

If the Gateway were in the same namespace as the HTTPRoute, the namespace field could be omitted.

---

### 5. Migrating from NGINX Ingress to Traefik

Existing applications on the original Geddes cluster may use Kubernetes `Ingress` resources and NGINX-specific annotations.

When migrating applications to Geddesv2, there are two possible approaches.

#### Option A: Convert NGINX Ingress to HTTPRoute (Recommended)

This is the recommended approach for new and migrated applications.

Example of an existing NGINX Ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: my-app-namespace
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  rules:
    - host: my-app.geddes.rcac.purdue.edu
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 8080
```

The equivalent basic routing configuration on Geddesv2:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-app
  namespace: my-app-namespace
spec:
  parentRefs:
    - name: private
      namespace: traefik-private
      sectionName: https
      kind: Gateway

  hostnames:
    - my-app.geddes.rcac.purdue.edu

  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: my-app
          port: 8080
```

Notice that the NGINX-specific annotations are no longer present.

Some NGINX functionality has an equivalent in Gateway API, while other functionality requires Traefik Middleware resources or additional configuration.

#### Option B: Continue Using Kubernetes Ingress

Traefik can also support standard Kubernetes `Ingress` resources if its Kubernetes Ingress provider is enabled.

However, this is not the recommended approach for new deployments.

Considerations:

- The Ingress must use the appropriate Traefik IngressClass.
- NGINX-specific annotations will not work with Traefik.
- Traefik-specific annotations may be required for certain features.
- Existing NGINX configurations must be reviewed and tested.

For long-term compatibility and consistency, use HTTPRoute.

---

### 6. Common NGINX Annotation Replacements

Not every NGINX annotation has a direct equivalent in Gateway API.

| NGINX annotation | Geddesv2 alternative |
|---|---|
| `ssl-redirect` | Gateway API RequestRedirect filter or HTTPS Gateway configuration |
| `rewrite-target` | Gateway API URLRewrite filter |
| `proxy-body-size` | Traefik Middleware / buffering configuration |
| `proxy-read-timeout` | Gateway API timeouts or Traefik-specific configuration |
| `proxy-send-timeout` | Traefik-specific configuration |
| `whitelist-source-range` | Traefik IPAllowList Middleware |
| `proxy-buffering` | Traefik-specific configuration |
| `auth-url` | Traefik ForwardAuth Middleware |
| `configuration-snippet` | Traefik Middleware or another supported configuration mechanism |

Migration should be evaluated individually because some NGINX features do not have a direct Gateway API equivalent.

---

### 7. Using Traefik Middleware

For functionality that is not available through standard Gateway API filters, Traefik provides Middleware resources.

For example, to configure IP-based access restrictions, create a Middleware:

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: my-app-ip-allowlist
  namespace: my-app-namespace
spec:
  ipAllowList:
    sourceRange:
      - 128.211.0.0/16
      - 172.21.0.0/16
```

Then reference the Middleware from your HTTPRoute:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-app
  namespace: my-app-namespace
spec:
  parentRefs:
    - name: private
      namespace: traefik-private
      sectionName: https
      kind: Gateway

  hostnames:
    - my-app.geddes.rcac.purdue.edu

  rules:
    - filters:
        - type: ExtensionRef
          extensionRef:
            group: traefik.io
            kind: Middleware
            name: my-app-ip-allowlist
      backendRefs:
        - name: my-app
          port: 8080
```

This allows users to retain functionality such as IP restrictions while using Gateway API routing.

Note that the Middleware CRD must be installed, and the Traefik Gateway provider must support the referenced extension.

---

### 8. Troubleshooting

If your application is not accessible after creating an HTTPRoute, check the following.

#### Step 1: Verify the HTTPRoute

```bash
kubectl get httproute -n my-app-namespace
```

#### Step 2: Check HTTPRoute conditions

```bash
kubectl describe httproute my-app -n my-app-namespace
```

Look for:

- `Accepted: True`
- `ResolvedRefs: True`

#### Step 3: Verify the Gateway

Private:

```bash
kubectl get gateway -n traefik-private
```

Public:

```bash
kubectl get gateway -n traefik-public
```

#### Step 4: Verify the Kubernetes Service

```bash
kubectl get svc -n my-app-namespace
```

Make sure the backend Service name and port match your HTTPRoute configuration.

#### Step 5: Verify application endpoints

```bash
kubectl get endpointslice -n my-app-namespace
```

Make sure the application has healthy backend endpoints.

#### Step 6: Contact Geddes Cluster Administrators for Help

If the route is accepted but traffic is still not reaching the application, contact the cluster administrators for assistance with Traefik logs and Gateway configuration.

---

### 9. Migration Recommendations

When moving applications from Geddes to Geddesv2, we recommend the following process:

1. Identify existing NGINX Ingress resources.
2. Review all NGINX annotations currently being used.
3. Identify the application hostname, Service name, and Service port.
4. Create a new HTTPRoute using the appropriate Geddesv2 Gateway.
5. Translate any required NGINX functionality into Gateway API filters or Traefik Middleware.
6. Test the application using its assigned hostname.
7. Update DNS as part of the application migration process, where necessary.

**Do not assume that copying an existing NGINX Ingress YAML file to Geddesv2 will work without modification.**

---

### 10. Useful Documentation

- Kubernetes Gateway API: <https://gateway-api.sigs.k8s.io/>
- HTTPRoute reference: <https://gateway-api.sigs.k8s.io/reference/api-types/httproute/>
- Gateway API migration from Ingress: <https://gateway-api.sigs.k8s.io/guides/getting-started/migrating-from-ingress/>
- Traefik Kubernetes Gateway API: <https://doc.traefik.io/traefik/reference/routing-configuration/kubernetes/gateway-api/>
- Traefik Middleware documentation: <https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/overview/>

For assistance with application routing or migration, contact the RCAC support team at rcac-help@purdue.edu.