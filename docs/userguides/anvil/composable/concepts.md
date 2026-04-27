## Containers & Images

**Image** - An image is a simple text file that defines the source code of an application you want to run as well as the libraries, dependencies, and tools required for the successful execution of the application. Images are immutable meaning they do not hold state or application data. Images represent a software environment at a specific point of time and provide an easy way to share applications across various environments. Images can be built from scratch or downloaded from various repositories on the internet, additionally many software vendors are now providing containers alongside traditional installation packages like Windows .exe and Linux rpm/deb.

**Container** - A container is the run-time environment constructed from an image when it is executed or run in a container runtime. Containers allow the user to attach various resources such as network and volumes in order to move and store data. Containers are similar to virtual machines in that they can be attached to when a process is running and have arbitrary commands executed that affect the running instance. However, unlike virtual machines, containers are more lightweight and portable allowing for easy sharing and collaboration as they run identically in all environments.

**Tags** - Tags are a way of organizing similar image files together for ease of use. You might see several versions of an image represented using various tags. For example, we might be building a new container to serve web pages using our favorite web server: nginx. If we search for the nginx container on Docker Hub image repository we see many options or tags are available for the official nginx container.

The most common you will see are typically `:latest` and `:number` where number refers to the most recent few versions of the software releases. In this example we can see several tags refer to the same `image: 1.21.1`, `mainline`, `1`, `1.21`, and `latest` all reference the same image while the `1.20.1`, `stable`, `1.20` tags all reference a common but different image. In this case we likely want the nginx image with either the `latest` or `1.21.1` tag represented as `nginx:latest` and `nginx:1.21.1` respectively.

**Container Security** - Containers enable fast developer velocity and ease compatibility through great portability, but the speed and ease of use come at some costs. In particular it is important that folks utilizing container driver development practices have a well established plan on how to approach container and environment security. Best Practices

**Container Registries** - Container registries act as large repositories of images, containers, tools and surrounding software to enable easy use of pre-made containers software bundles. Container registries can be public or private and several can be used together for projects. Docker Hub is one of the largest public repositories available, and you will find many official software images present on it. You need a user account to avoid being rate limited by Docker Hub. A private container registry based on Harbor that is available to use. TODO: link to harbor instructions

**Docker Hub** - Docker Hub is one of the largest container image registries that exists and is well known and widely used in the container community, it serves as an official location of many popular software container images. Container image repositories serve as a way to facilitate sharing of pre-made container images that are “ready for use.” Be careful to always pay attention to who is publishing particular images and verify that you are utilizing containers built only from reliable sources.

**Harbor** - Harbor is an open source registry for Kubernetes artifacts, it provides private image storage and enforces container security by vulnerability scanning as well as providing RBAC or role based access control to assist with user permissions. Harbor is a registry similar to Docker Hub, however it gives users the ability to create private repositories. You can use this to store your private images as well as keeping copies of common resources like base OS images from Docker Hub and ensure your containers are reasonably secure from common known vulnerabilities.

## Container Runtime Concepts

**Docker Desktop** - Docker Desktop is an application for your Mac / Windows machine that will allow you to build and run containers on your local computer. Docker desktop serves as a container environment and enables much of the functionality of containers on whatever machine you are currently using. This allows for great flexibility, you can develop and test containers directly on your laptop and deploy them directly with little to no modifications.

**Volumes** - Volumes provide us with a method to create persistent data that is generated and consumed by one or more containers. For docker this might be a folder on your laptop while on a large Kubernetes cluster this might be many SSD drives and spinning disk trays. Any data that is collected and manipulated by a container that we want to keep between container restarts needs to be written to a volume in order to remain around and be available for later use.

## Container Orchestration Concepts

**Container Orchestration** - Container orchestration broadly means the automation of much of the lifecycle management procedures surrounding the usage of containers. Specifically it refers to the software being used to manage those procedures. As containers have seen mass adoption and development in the last decade, they are now being used to power massive environments and several options have emerged to manage the lifecycle of containers. One of the industry leading options is Kubernetes, a software project that has descended from a container orchestrator at Google that was open sourced in 2015.

**Kubernetes (K8s)** - Kubernetes (often abbreviated as "K8s") is a platform providing container orchestration functionality. It was open sourced by Google around a decade ago and has seen widespread adoption and development in the ensuing years. K8s is the software that provides the core functionality of the Anvil Composable Subsystem by managing the complete lifecycle of containers. Additionally it provides the following functions: service discovery and load balancing, storage orchestration, secret and configuration management. The Kubernetes cluster can be accessed via the Rancher UI or the kubectl command line tool.

**Rancher** - Rancher is a “is a complete software stack for teams adopting containers.” as described by its website. It can be thought of as a wrapper around Kubernetes, providing an additional set of tools to help operate the K8 cluster efficiently and additional functionality that does not exist in Kubernetes itself. Two examples of the added functionality is the Rancher UI that provides an easy to use GUI interface in a browser and Rancher projects, a concept that allows for multi-tenancy within the cluster. Users can interact directly with Rancher using either the Rancher UI or Rancher CLI to deploy and manage workloads on the Anvil Composable Subsystem.

**Rancher UI** - The Rancher UI is a web based graphical interface to use the Anvil Composable Subsystem from anywhere.

**Rancher CLI** - The Rancher CLI provides a convenient text based toolkit to interact with the cluster. The binary can be downloaded from the link on the right hand side of the footer in the Rancher UI. After you download the Rancher CLI, you need to make a few configurations Rancher CLI requires:

- Your Rancher Server URL, which is used to connect to Rancher Server.
- An API Bearer Token, which is used to authenticate with Rancher. see Creating an API Key.

After setting up the Rancher CLI you can issue rancher --help to view the full range of options available.

**Kubectl** - Kubectl is a text based tool for working with the underlying Anvil Kubernetes cluster. In order to take advantage of kubectl you will either need to set up a Kubeconfig File or use the built in kubectl shell in the Rancher UI. You can learn more about kubectl and how to download the kubectl file here.

**Storage** - Storage is utilized to provide persistent data storage between container deployments. The Ceph filesystem provides access to Block, Object and shared file systems. File storage provides an interface to access data in a file and folder hierarchy similar to NTFS or NFS. Block storage is a flexible type of storage that allows for snapshotting and is good for database workloads and generic container storage. Object storage is also provided by Ceph, this features a REST based bucket file system providing S3 and Swift compatibility.

## Workloads

**Deploy a Workload**

1. Using the top right dropdown select the Project or Namespace you wish to deploy to.
2. Using the far left menu navigate to Workload
3. Click Create at the top right
4. Select the appropriate Deployment Type for your use case
   1. Select Namespace if not already done from step 1
   2. Set a unique Name for your deployment, i.e. “myapp"
   3. Set Container Image. Ensure you're using the Anvil registry for personal images or the Anvil registry docker-hub cache when pulling public docker-hub specific images. e.g: registry.anvil.rcac.purdue.edu/my-registry/myimage:tag or registry.anvil.rcac.purdue.edu/docker-hub-cache/library/image:tag
   4. Click Create

Wait a couple minutes while your application is deployed. The “does not have minimum availability” message is expected. But, waiting more than 5 minutes for your workload to deploy typically indicates a problem. You can check for errors by clicking your workload name (i.e. "myapp"), then the lower button on the right side of your deployed pod and selecting **View Logs**.

If all goes well, you will see an **Active** status for your deployment

You can then interact with your deployed container on the command line by clicking the button with three dots on the right side of the screen and choosing "Execute Shell"

## Services

A **Service** is an abstract way to expose an application running on Pods as a network service. This allows the networking and application to be logically decoupled so state changes in either the application itself or the network connecting application components do not need to be tracked individually by all portions of an application.

**Service resources**

In Kubernetes, a Service is an abstraction which defines a logical set of Pods and a policy by which to access them (sometimes this pattern is called a micro-service). The set of Pods targeted by a Service is usually determined by a Pod selector, but can also be defined other ways.

**Publishing Services (ServiceTypes)**

For some parts of your application you may want to expose a Service onto an external IP address, that’s outside of your cluster.

Kubernetes **ServiceTypes** allow you to specify what kind of Service you want. The default is ClusterIP.

- **ClusterIP**: Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default ServiceType.
- **NodePort**: Exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You’ll be able to contact the NodePort Service, from outside the cluster, by requesting <NodeIP>:<NodePort>.
- **LoadBalancer**: Exposes the Service externally using Anvil's load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created. Users can create LoadBalancer resources using a private IP pool on Purdue's network with the annotation `metallb.universe.tf/address-pool: anvil-private-pool`. Public LoadBalancer IPs are avaiable via request only.

You can see an example of [exposing a workload using the LoadBalancer type](https://www.rcac.purdue.edu/knowledge/anvil/composable/examples/database#_expose_the_database_to_external_clients) on Anvil in the examples section.

- **ExternalName**: Maps the Service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record with its value. No proxying of any kind is set up.

## Ingress

An **Ingress** is an API object that manages external access to the services in a cluster, typically HTTP/HTTPS. An Ingress is not a ServiceType, but rather brings external traffic into the cluster and then passes it to an Ingress Controller to be routed to the correct location. Ingress may provide load balancing, SSL termination and name-based virtual hosting. Traffic routing is controlled by rules defined on the Ingress resource.

You can see an example of [a service being exposed with an Ingress](https://www.rcac.purdue.edu/knowledge/anvil/composable/examples/webserver#_expose_the_web_server_to_external_clients_via_an_ingress) on Anvil in the examples section.

### Ingress Controller
Anvil provides the [nginx](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme) ingress controller configured to facilitate SSL termination and automatic DNS name generation under the `anvilcloud.rcac.purdue.edu` subdomain.

Kubernetes provides additional information about [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) in the official documentation.

## Storage

Storage on Anvil Composable utilizes Ceph software to provide three types of persistent data storage between container deployments: block, filesystem, and object storage.

**Key storage types:**

- **File storage**: Hierarchical file/folder access similar to NTFS or NFS
- **Block storage**: Flexible with snapshotting capabilities, suitable for databases and containers
- **Object storage**: REST-based S3-compatible API for large unstructured data

!!! warning
    RCAC currently provides no backup of Anvil Composable storage, either via snapshots or transfer of data to other storage.

### Storage Classes

Two storage classes are available based on workload access requirements:

| Storage Class | Type | Access Mode |
|---------------|------|-------------|
| `anvil-block` | SSD-based block storage | Single-node read/write access |
| `anvil-filesystem` | SSD-based file storage | Multiple-node read/write or read-only access |

### Provisioning Storage

To add persistent storage during workload deployment:

1. Select Volumes dropdown and click **Add Volume**
2. Choose "Add a new persistent volume (claim)"
3. Assign a unique volume name
4. Select storage class (Ceph default)
5. Specify storage amount in gigabytes
6. Click **Define**
7. Set mount point (e.g., `/data`)

### Backup Methods

**kubectl cp**

For copying files/directories to and from pods:

```bash
# Copy file to pod
kubectl cp /tmp/myfile <namespace>/<pod>:/tmp/myfile

# Copy from pod to local storage
kubectl cp <namespace>/<pod>:/pvcdirectory /localstorage
```

### Database Dumps

```bash
kubectl -n <namespace> exec <pod> -- mysqldump --user=<username> --password=<password> my_database > backup.sql
```

### Remote Transfers

Requires SSH/rsync in container:

```bash
kubectl -n <namespace> exec <pod> -- scp -r /data username@anvil.rcac.purdue.edu:~/backup
```

### Automated Backups

Kubernetes CronJob resources enable scheduled backup automation.

### External Object Storage Access

Access S3-compatible storage via **Cyberduck**:

1. Download and install [Cyberduck](https://cyberduck.io/)
2. Click **+ Open Connection**
3. Select **S3** from dropdown
4. Enter server details, access key, and secret key
5. Connect and manage storage via right-click menu

## Registry

The Anvil registry utilizes Harbor, an open-source container and artifact management system, accessible at [https://registry.anvil.rcac.purdue.edu](https://registry.anvil.rcac.purdue.edu).

### Docker Hub Cache

To avoid Docker Hub rate limits, users should employ the cache URL when pulling images:

```
registry.anvil.rcac.purdue.edu/docker-hub-cache/
```

**Example:** Instead of `jupyter/tensorflow-notebook:latest`, use:

```
registry.anvil.rcac.purdue.edu/docker-hub-cache/jupyter/tensorflow-notebook:latest
```

### OIDC Authentication for CLI Tools

After initial Harbor login via OIDC, Docker and Helm CLIs can authenticate using a CLI secret:

1. Log into Harbor with OIDC credentials
2. Access User Profile via username menu
3. Copy the CLI secret (one per account)
4. Login command:

```bash
docker login -u <username> -p <cli secret> registry.anvil.rcac.purdue.edu
```

!!! note
    CLI secrets remain valid even after ID token expiration due to automatic refresh, but require re-authentication if refresh fails.

### Creating a Project Registry

1. Navigate to [https://registry.anvil.rcac.purdue.edu](https://registry.anvil.rcac.purdue.edu)
2. Select "Create Project"
3. Configure name and visibility (public/private)
4. Confirm creation

### Tagging and Pushing Images

```bash
docker tag my-image:tag registry.anvil.rcac.purdue.edu/project-registry/my-image:tag
docker login registry.anvil.rcac.purdue.edu
docker push registry.anvil.rcac.purdue.edu/project-registry/my-image:tag
```

### Robot Accounts

Robot accounts provide credential-free authentication for multi-tenant environments:

1. Navigate to Robot Accounts tab within project
2. Create new account with optional expiration
3. Configure permissions
4. Export token as JSON (non-recoverable after page exit)

### Adding Private Registry to Rancher

1. Access `Resources > Secrets`
2. Select Registry Credentials tab
3. Configure with robot account credentials
4. Address: `registry.anvil.rcac.purdue.edu`

### External Resources

- [Harbor Documentation](https://goharbor.io/)
- [Working with images](https://goharbor.io/docs/2.1.0/working-with-projects/working-with-images/)
- You can learn more about the Harbor project on the official website: https://goharbor.io/