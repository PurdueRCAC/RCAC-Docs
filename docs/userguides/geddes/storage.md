---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Storage

Geddes has a software defined storage system that provides user-provisioned persistent data storage for container deployments.

Ceph is used to provide block, filesystem and object storage on the Geddes Composable Platform. **File storage** provides an interface to access data in a file and folder hierarchy similar to Data Depot. **Block storage** is a flexible type of storage that is good for database workloads and generic container storage. **Object storage** is ideal for large unstructured data and features a REST based API providing an S3 compatible endpoint that can be utilized by the preexisting ecosystem of S3 client tools.

!!! note
    The integrity of the Ceph storage components is accomplished via a redundant disk system (3x replication). RCAC currently provides no backup of Geddes storage, either via snapshots or transfer of data to other storage. No disaster recovery other than the redundant disk systems is currently provided.

## Storage Classes

Geddes provides four different storage classes based on access characteristics and the performance needs of a workload. Performance classes should be used for workloads with high I/O requirements (databases, AI/ML).

* `geddes-standard-singlenode` - Block storage based on SSDs that can be accessed by a single node (Single-Node Read/Write).
* `geddes-standard-multinode` - File storage based on SSDs that can be accessed by multiple nodes (Many-Node Read/Write or Many-Node Read-Only)
* `geddes-performance-singlenode` - Block storage based on NVMe drives that can be accessed by a single node (Single-Node Read/Write).
* `geddes-performance-multinode` - File storage based on NVMe drives that can be accessed by multiple nodes (Many-Node Read/Write or Many-Node Read-Only)

### Block and Filesystem Storage Provisioning in Deployments

Block and Filesystem storage can both be provisioned in a similar way.

1. While deploying a Workload, click the Storage tab and click **Add Volume**…
2. Select "**Create Persistent Volume Claim**"
3. Set a unique Persistent Volume Claim Name, i.e. "`<username>-volume`"
4. Select a Storage Class. The default storage class is "geddes-standard-singlenode".
5. Select an Access Mode. The "geddes-standard-singlenode" class only supports Single-Node Read/Write.
6. Request an amount of storage in Gigabytes
7. Provide a Mount Point for the persistent volume: i.e */data*

## Backup Strategies

Developers using the Geddes platform should have a backup strategy in place to ensure that your data is safe and can be recovered in case of a disaster. Below is a list of methods that can be used to backup data on Persistent Volume Claims.

### Copying Files to and from a Container

The `kubectl cp` command can be used to copy files into or out of a running container.

```
# get pod id you want to copy to/from
kubectl -n <namespace> get pods

# copy a file from local filesystem to remote pod
kubectl cp /tmp/myfile <namespace>/<pod>:/tmp/myfile

# copy a file from remote pod to local filesystem
kubectl cp <namespace>/<pod>:/tmp/myfile /tmp/myfile
```

This method requires the `tar` executable to be present in your container, which is usually the case with Linux images. More info can be found in the kubectl [docs](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#cp).

### Copying Directories from a Container

The `kubectl cp` command can also be used to recursively copy entire directories to local storage or places like Data Depot.

```
# get pod id you want to copy to/from
kubectl -n <namespace> get pods

# copy a directory from remote pod to local filesystem
kubectl cp <namespace>/<pod>:/pvcdirectory /localstorage
```

### Backing up a Database from a Container

The `kubectl exec` command can be used to create a backup or dump of a database and save it to a local directory. For instance, to backup a MySQL database with kubectl, run the following commands from a local workstation or cluster frontend.

```
# get pod id of your database pod
kubectl -n <namespace> get pods

# run mysqldump in the remote pod and redirect the output to local storage
kubectl -n <namespace> exec <pod> -- mysqldump --user=<username> --password=<password> my_database > my_database_dump.sql
```

### Backups using common Linux tools

If your container has the OpenSSH client or rsync packages installed, one can use the `kubectl exec` command to copy or synchronize to another storage location.

```
# get pod id of your pod
kubectl -n <namespace> get pods

# run scp to transfer data from the pod to a remote storage location
kubectl -n <namespace> exec <pod> -- scp -r /data username@negishi.rcac.purdue.edu:~/backup
```

### Automating Backups

Kubernetes CronJob resources can be used with the commands above to create an automated backup solution. For more information, refer to the Kubernetes [documentation](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/).

## Object Storage

Geddes provides S3 compatible object storage from the endpoint [s3-prod.geddes.rcac.purdue.edu](https://s3-prod.geddes.rcac.purdue.edu).

S3 access can be requested by [contacting support](https://www.rcac.purdue.edu/help). Access keys will be provided via Filelocker.

### Accessing Object Storage

The S3 endpoint provided by Geddes can be accessed in multiple ways. Two popular options for interacting with S3 storage via the command line and GUI are listed below.

**S3cmd** is a free command line tool for managing data in S3 compatible storage resources that works on Linux and Mac.

* Download: [s3tools.org/download](https://s3tools.org/download)
* How-To Documentation: [s3tools.org/s3cmd-howto](https://s3tools.org/s3cmd-howto)

**Cyberduck** is a free server and cloud storage browser that can be used on Windows and Mac.

1. [Download and install Cyberduck](https://cyberduck.io/download/)
2. Launch Cyberduck
3. Click **+ Open Connection** at the top of the UI.
4. Select **S3** from the dropdown menu
5. Fill in **Server**, **Access Key ID** and **Secret Access Key** fields
6. Click **Connect**
7. You can now right click to bring up a menu of actions that can be performed against the storage endpoint

Further information about using Cyberduck can be found on the [Cyberduck documentation site](https://docs.cyberduck.io/).

## Accessing and Mounting Depot

[Contact support](https://www.rcac.purdue.edu/help) to request access. Make sure to provide the Geddes namespace that will be accessing depot and the `$PATH` to your user/lab depot space. Once access has been approved and an admin has created the needed Persistent Volumes for depot you can move on to the steps below.

The overall process is:

1. Submit request.
    1. An admin will create the needed Persistent Volume needed to access your depot space and will provide you with the name `pv-depot-<your-pv-name>`
2. Create Kubernetes secrets for Depot username/password authentication.
3. Create a Persistent Volume Claim via Rancher UI or kubectl.
4. Use that claim for your workloads/pods to mount depot.

**Create k8s username/password secret for depot auth**

1. From the Rancher UI, use the left navigation bar to select **Storage > Secrets**
2. Click **Create** at the top right
3. Select **Opaque** and fill out the form.
    1. Make sure to select the namespace that will be accessing depot
    2. Name should be `depot-credentials-<myusername>`
    3. Under the data tab click **add** to create a second secret key field
    4. Provide key/values
        1. Key: **username** value: `<yourUsername>`
        2. Key: **password** value: `<yourPassword>`
    5. Click **Create** at the bottom right

**Create a PersistentVolumeClaim for Depot (Rancher UI)**

1. From the Rancher UI, use the left navigation bar to select **Storage > PersistentVolumeClaims**
2. Click **Create** at the top right and fill out the form
    1. Make sure to select the namespace that will be accessing depot
    2. Name should be `pvc-depot-<yourUsername>`
    3. Select **Use an existing Persistent Volume**
    4. Use the dropdown to the immediate right to select `pv-depot-<your pv name>`
    5. Click **Customize** in the form tab on the left
    6. Select **Many Nodes Read-Write**
    7. Click **Create** at the bottom right.

**Create a PersistentVolumeClaim for Depot (kubectl)**

1. Create a yaml file i.e **depot-pvc.yaml** with the code below

    ```
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc-depot-<yourUsername>
      namespace: <namespace>
    spec:
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 1Mi
      volumeName: pv-depot-<your pv name>
      storageClassName: ""
    ```

2. Replace all the `<yourUsername>` and `<namespace>` with the appropriate values.
    1. Do not include the example angle brackets `< >` in your code
3. Apply the yaml with the command `kubectl apply -f depot-pvc.yaml`
