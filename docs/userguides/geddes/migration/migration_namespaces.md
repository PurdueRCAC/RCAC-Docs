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

# Migrating Namespaces from Geddes (RKE1) to Geddes2 (RKE2)

This guide explains how to migrate namespaces between the Geddes (RKE1) cluster and the Geddes2 (RKE2) cluster using Rancher and `kubectl`.



## Configure kubectl Contexts

To migrate namespaces between Geddes and Geddes2, first add both cluster kubeconfigs as contexts in your local `kubectl` configuration.



### Step 1 — Download kubeconfig from Rancher

For each cluster:

1. Open Rancher
2. Navigate to the cluster
3. Click **Kubeconfig**
4. Copy or download the kubeconfig

You should end up with files similar to:

```bash
geddes-v1.yaml
geddes-v2.yaml
```



### Step 2 — Test Each kubeconfig Separately

Verify that each kubeconfig can successfully connect to its cluster.

#### Test Geddes (RKE1)

```bash
kubectl --kubeconfig geddes-v1.yaml get nodes
```

#### Test Geddes2 (RKE2)

```bash
kubectl --kubeconfig geddes-v2.yaml get nodes
```

If both commands work successfully, continue to the next step.



## Step 3 — Merge kubeconfigs

Temporarily merge both kubeconfig files:

```bash
export KUBECONFIG=geddes-v1.yaml:geddes-v2.yaml
```

Then merge them into your default kubeconfig:

```bash
kubectl config view --flatten > ~/.kube/config
```



### Step 4 — Verify Contexts

Verify that both cluster contexts are available:

```bash
kubectl config get-contexts
```

Example output:

```text 
CURRENT   NAME
*         geddes
          geddes2
```



### Step 5 — Test Switching Contexts

#### Switch to Geddes

```bash
kubectl config use-context geddes
```

Verify access:

```bash
kubectl get pods -n <namespace>
```

If this command works, your context and permissions are configured correctly.



#### Switch to Geddes2

```bash
kubectl config use-context geddes2
```



### Step 6 — Use Contexts Directly

You can now run commands against either cluster directly.

#### Geddes

```bash
kubectl --context geddes get ns
```

#### Geddes2

```bash
kubectl --context geddes2 get ns
```



## Exporting Namespace from Geddes (RKE1) to Geddes2 (RKE2)

### Using Rancher UI (Recommended)



### On Geddes (GDS)

1. Log in to the Geddes Rancher UI
2. Navigate to the Geddes cluster (`GDS`)
3. Open **Projects / Namespaces**
4. Locate your assigned namespace
5. Record the exact namespace name



### On Geddes2 (GS2)

1. Navigate to the Geddes2 cluster (`GS2`)
2. Open **Projects / Namespaces**
3. Click **Create Namespace**
4. Enter the same namespace name used on Geddes
5. Click **Create**



## Exporting Namespace Resource Quotas from Rancher

This section explains how to review and document namespace Resource Quotas before migrating workloads to Geddes2.



### Important Notes

If your Project already has default namespace Resource Quotas configured, Rancher will automatically apply those default quotas when the namespace is recreated on Geddes2.

In most cases, you do **not** need to manually recreate Resource Quotas.

You only need to perform this step if:

* the namespace quotas were manually modified
* additional resources were added
* limits were reduced or customized for the namespace

Examples include:

* custom CPU limits
* increased memory quotas
* modified storage limits



## Steps to Export / View Namespace Resource Quotas

### 1. Log in to Rancher

Open the Rancher web interface and log in using your credentials.



### 2. Select Your Project

Navigate to:

* the target cluster
* your Project
* the namespace you plan to migrate



### 3. Open Namespace Configuration

Locate your namespace in the namespace list.

On the far-right side of the namespace row:

1. Click the **three dots** (`⋮`)
2. Select **Edit Config** from the drop-down menu



### 4. Review Resource Quotas

Inside the namespace configuration page, review the configured Resource Quotas.

Examples may include:

* CPU limits
* memory limits
* storage quotas
* pod limits

Document these values carefully.



### 5. Recreate Resource Quotas on Geddes2

When recreating the namespace on Geddes2:

* apply the same custom Resource Quota values
* ensure any modified limits match the original namespace configuration

If no custom quotas were configured, Rancher will automatically apply the Project default quotas.
