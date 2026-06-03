---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Concepts

## Containers & Images

**Image** - An image is a simple text file that defines the source code of an application you want to run as well as the libraries, dependencies, and tools required for the successful execution of the application. Images are immutable meaning they do not hold state or application data. Images represent a software environment at a specific point of time and provide an easy way to share applications across various environments. Images can be built from scratch or downloaded from various repositories on the internet, additionally many software vendors are now providing containers alongside traditional installation packages like Windows .exe and Linux rpm/deb.

**Container** - A container is the run-time environment constructed from an image when it is executed or run in a container runtime. Containers allow the user to attach various resources such as network and volumes in order to move and store data. Containers are similar to virtual machines in that they can be attached to when a process is running and have arbitrary commands executed that affect the running instance. However, unlike virtual machines, containers are more lightweight and portable allowing for easy sharing and collaboration as they run identically in all environments.

**Tags** - Tags are a way of organizing similar image files together for ease of use. You might see several versions of an image represented using various tags. For example, we might be building a new container to serve web pages using our favorite web server: nginx. If we search for the nginx container on Docker Hub image repository we see many options or tags are available for the official nginx container.

The most common you will see are typically `:latest` and `:number` where *number* refers to the most recent few versions of the software releases. In this example we can see several tags refer to the same image: `1.21.1, mainline, 1, 1.21,` and `latest` all reference the same image while the `1.20.1, stable, 1.20` tags all reference a common but different image. In this case we likely want the nginx image with either the `latest` or `1.21.1` tag represented as `nginx:latest` and `nginx:1.21.1` respectively.

**Container Security** - Containers enable fast developer velocity and ease compatibility through great portability, but the speed and ease of use come at some costs. In particular it is important that folks utilizing container driver development practices have a well established plan on how to approach container and environment security.

**Container Registries** - Container registries act as large repositories of images, containers, tools and surrounding software to enable easy use of pre-made containers software bundles. Container registries can be public or private and several can be used together for projects. Docker Hub is one of the largest public repositories available, and you will find many official software images present on it. You need a user account to avoid being rate limited by Docker Hub. A private container registry based on Harbor is available to use; see the [Container Registry](registry.md) page.

**Docker Hub** - Docker Hub is one of the largest container image registries that exists and is well known and widely used in the container community, it serves as an official location of many popular software container images. Container image repositories serve as a way to facilitate sharing of pre-made container images that are “ready for use.” Be careful to always pay attention to who is publishing particular images and verify that you are utilizing containers built only from reliable sources.

**Harbor** - Harbor is an open source registry for Kubernetes artifacts, it provides private image storage and enforces container security by vulnerability scanning as well as providing RBAC or role based access control to assist with user permissions. Harbor is a registry similar to Docker Hub, however it gives users the ability to create private repositories. You can use this to store your private images as well as keeping copies of common resources like base OS images from Docker Hub and ensure your containers are reasonably secure from common known vulnerabilities.

## Container Runtime Concepts

**Docker Desktop** - Docker Desktop is an application for your Mac / Windows machine that will allow you to build and run containers on your local computer. Docker desktop serves as a container environment and enables much of the functionality of containers on whatever machine you are currently using. This allows for great flexibility, you can develop and test containers directly on your laptop and deploy them directly with little to no modifications.

**Volumes** - Volumes provide us with a method to create persistent data that is generated and consumed by one or more containers. For docker this might be a folder on your laptop while on a large Kubernetes cluster this might be many SSD drives and spinning disk trays. Any data that is collected and manipulated by a container that we want to keep between container restarts needs to be written to a volume in order to remain around and be available for later use.

## Container Orchestration Concepts

**Container Orchestration** - Container orchestration broadly means the automation of much of the lifecycle management procedures surrounding the usage of containers. Specifically it refers to the software being used to manage those procedures. As containers have seen mass adoption and development in the last decade, they are now being used to power massive environments and several options have emerged to manage the lifecycle of containers. One of the industry leading options is Kubernetes, a software project that has descended from a container orchestrator at Google that was open sourced in 2015.

**Kubernetes (K8s)** - Kubernetes (often abbreviated as "K8s") is a platform providing container orchestration functionality. It was open sourced by Google around a decade ago and has seen widespread adoption and development in the ensuing years. K8s is the software that provides the core functionality of the Geddes Composable Platform by managing the complete lifecycle of containers. Additionally it provides the following functions: service discovery and load balancing, storage orchestration, secret and configuration management. The Kubernetes cluster can be accessed via the Rancher UI or the kubectl command line tool.

**Rancher** - Rancher is a “complete software stack for teams adopting containers” as described by its website. It can be thought of as a wrapper around Kubernetes, providing an additional set of tools to help operate the K8s cluster efficiently and additional functionality that does not exist in Kubernetes itself. Two examples of the added functionality is the Rancher UI that provides an easy to use GUI interface in a browser and Rancher projects, a concept that allows for multi-tenancy within the cluster. Users can interact directly with Rancher using either the Rancher UI or Rancher CLI to deploy and manage workloads on the Geddes Composable Platform.

**Rancher UI** - The Rancher UI is a web based graphical interface to use the Geddes Composable Platform from anywhere.

**Rancher CLI** - The Rancher CLI provides a convenient text based toolkit to interact with the cluster. The binary can be downloaded from the link on the right hand side of the footer in the Rancher UI. After you download the Rancher CLI, you need to make a few configurations Rancher CLI requires:

- Your Rancher Server URL, which is used to connect to Rancher Server.
- An API Bearer Token, which is used to authenticate with Rancher. See Creating an API Key.

After setting up the Rancher CLI you can issue `rancher --help` to view the full range of options available.

**Kubectl** - Kubectl is a text based tool for working with the underlying Geddes Kubernetes cluster. In order to take advantage of kubectl you will either need to set up a Kubeconfig File or use the built in kubectl shell in the Rancher UI. You can learn more about kubectl and how to download the kubectl file on the [Kubectl](access.md#kubectl) page.

**Storage** - Storage is utilized to provide persistent data storage between container deployments. The **Ceph** filesystem provides access to Block, Object and shared file systems. File storage provides an interface to access data in a file and folder hierarchy similar to NTFS or NFS. Block storage is a flexible type of storage that allows for snapshotting and is good for database workloads and generic container storage. Object storage is also provided by Ceph, this features a REST based bucket file system providing S3 and Swift compatibility.
