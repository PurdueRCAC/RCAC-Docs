---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Services

A **Service** is an abstract way to expose an application running on Pods as a network service. This allows the networking and application to be logically decoupled so state changes in either the application itself or the network connecting application components do not need to be tracked individually by all portions of an application.

## Service resources

In Kubernetes, a Service is an abstraction which defines a logical set of Pods and a policy by which to access them (sometimes this pattern is called a micro-service). The set of Pods targeted by a Service is usually determined by a Pod selector, but can also be defined other ways.

## Publishing Services (ServiceTypes)

For some parts of your deployment you may need to expose an application externally from the cluster using **Services**.

Kubernetes **ServiceTypes** allow you to specify what kind of Service you want. The default is ClusterIP.

* **ClusterIP:** Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default ServiceType.
* **NodePort:** Exposes the Service on each Node's IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You'll be able to contact the NodePort Service, from outside the cluster, by requesting `<NodeIP>:<NodePort>`.
* **LoadBalancer:** Exposes the Service externally using a cloud provider's load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created.

You can see an example of [exposing a workload using the **LoadBalancer** type](examples/database.md#expose-the-database-to-external-clients) in the examples section.

### Ingress

An **Ingress** is an API object that manages external access to the services in a cluster, typically HTTP/HTTPS. An Ingress is not a ServiceType, but rather brings external traffic into the cluster and then passes it to an Ingress Controller to be routed to the correct location. Ingress may provide load balancing, SSL termination and name-based virtual hosting. Traffic routing is controlled by rules defined on the Ingress resource.

## Ingress Controller

Geddes provides the [nginx](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme) ingress controller configured to facilitate SSL termination and automatic DNS name generation under the `geddes.rcac.purdue.edu` subdomain.

In the Examples section, there are detailed instructions about **[how to expose a service with an Ingress](examples/webserver.md)**. Here are the outline of major steps:

1. Create a new **Deployment** under Workload
2. Set **Container Image** to the Docker image you want to use
3. Create a **Cluster IP** service to point our external accessible ingress for later
4. Setup Pod Label
5. Create a new **Ingress** page
6. Give the URL you would like to use for your web application under **Request Host**
7. Put the **Cluster IP** you created in *Step 1* to **Target Service** and **Port**
8. The default Ingress is **private**, which is only accessible within the Purdue network. To make a **public** one, add an **Annotation**: `kubernetes.io/ingress.class: "public"`

Kubernetes provides additional information about [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) in the official documentation.
