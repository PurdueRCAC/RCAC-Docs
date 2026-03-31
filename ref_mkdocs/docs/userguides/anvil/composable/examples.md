This page provides step-by-step examples for deploying common workloads on Anvil's Composable Subsystem.

---

## Interactive Tutorials:

- Deploying a [Kubernetes cluster on Anvil Composable](/workshops/kubernetes-tutorial)

## Database Deployment (PostGIS)

This example demonstrates how to deploy a PostGIS database and expose it to external clients.

### Deploy a PostGIS Database

1. **Project Selection**: Choose your project from the top-right dropdown menu

2. **Workload Creation**: Navigate to the Workload section via the left menu and click Create

3. **Deployment Configuration**: Select "Deployment" as your deployment type

4. **Form Setup**:
    - Select your namespace
    - Assign an arbitrary name to the deployment
    - Set the container image to: `registry.anvil.rcac.purdue.edu/docker-hub-cache/postgis/postgis:latest`

5. **Environment Configuration**:
    - Add environment variable via the "Add Variable" button
    - Set `POSTGRES_PASSWORD` with your chosen password

6. **Storage Setup**:
    - Access the Storage tab
    - Create a persistent volume claim with single-node read/write access
    - Select appropriate storage class and capacity (example: 5 GiB)
    - Mount point: `/var/lib/postgresql/data`
    - Set sub-path to `data`

7. **Resource Allocation**:
    - CPU Reservation: 2000 (ensures 2 CPU cores available)
    - CPU Limit: 2000 (prevents exceeding 2 CPU cores)

8. **Pod Labeling**:
    - Add labels under "Labels & Annotations"
    - Example: Key `my-db`, Value `postgis`

9. **Deployment Launch**: Click Create to initiate the deployment

!!! note
    Deployment typically completes within 5 minutes.

### Expose the Database Externally

Create a LoadBalancer service for external client access:

1. **Service Creation**: Navigate to Service Discovery > Services and select Create

2. **LoadBalancer Selection**: Choose Load Balancer service type

3. **Configuration**:
    - Select correct namespace
    - Provide service name (results in DNS: `<servicename>.<namespace>.anvilcloud.rcac.purdue.edu`)
    - Listening Port and Target Port: 5432 (PostgreSQL default)

4. **Selector Configuration**:
    - Match the pod label from deployment step
    - The interface shows green confirmation when labels match correctly

5. **Network Configuration**:
    - Private network: Add annotation with Key `metallb.universe.tf/address-pool` and Value `anvil-private-pool`
    - Public network: Use Value `anvil-public-pool`

### Verification

Confirm service deployment:

```bash
kubectl -n <namespace> get services
```

Verify DNS record creation:

```bash
host <servicename>.<namespace>.anvilcloud.rcac.purdue.edu
```

The system automatically assigns an IP address and configures DNS naming.

---

## Web Server Deployment (Nginx)

This example covers deploying an Nginx web server and exposing it via an Ingress for external access.

### Deploy Nginx

1. **Select Project**: Choose your project from the top-right dropdown

2. **Navigate to Workloads**: Use the left menu to access the Workload section

3. **Create New Workload**: Click Create in the top right

4. **Choose Deployment Type**: Select "Deployment"

5. **Configure the Deployment**:
    - Select your namespace
    - Assign an arbitrary name for the deployment
    - Set container image to: `registry.anvil.rcac.purdue.edu/docker-hub-cache/library/nginx`

6. **Service Configuration**:
    - Click "Add Port"
    - Select "Cluster IP" as the Service Type
    - Set Private Container Port to **80**

7. **Pod Labels Setup**:
    - Navigate to "Labels & Annotations" in the form
    - Select "Add Label" under Pod Labels section
    - Assign a memorable key-value pair (example: Key: `my-web`, Value: `nginx`)
    - Click Create

!!! note
    Deployment typically completes within 5 minutes. Initial "does not have minimum availability" messages are normal during deployment startup.

### Expose via Ingress

1. **Navigate to Service Discovery**: Access "Service Discovery" > "Ingresses"

2. **Create Ingress**: Click Create in the top right

3. **Configure Ingress Settings**:
    - Select the namespace containing your nginx deployment
    - Provide an arbitrary name
    - Set Request Host (example: `my-nginx.anvilcloud.rcac.purdue.edu`)
    - Set Path Prefix to `/`
    - Select the target service and port from dropdowns
    - Click Create

### Troubleshooting

Access deployment logs by clicking the workload name, then selecting "View Logs" via the ellipsis menu on the deployed pod.
