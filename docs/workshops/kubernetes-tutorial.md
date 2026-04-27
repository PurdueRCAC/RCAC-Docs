---
tags:
  - Anvil
  - Kubernetes
  - Anvil Composable
  - Anvil Cloud
  - Docker
authors:
  - dane
cluster: Anvil
draft: true
---

# Deploying a Full-Stack Application on Anvil Composable with Kubernetes

A complete, user-friendly guide to making your application live and accessible to anyone with internet access. We will walk through an example application with 3 separate components (Svelte frontend, FastAPI backend, and MongoDB database) on Anvil Composable using Kubernetes.

To follow along with code, please clone the corresponding [GitHub repository](https://github.com/wintermutant/anvil-composable-tutorial.git).

!!! note "Who this tutorial is for"
    This tutorial is meant for new users to veteran users. This tutorial will not explain every concept comprehensively, but it will hit on main concepts. For veteran users, you can jump to [Deploying to Anvil Composable](#deploying-to-anvil-composable)

---

## Goal of this tutorial

The goal is to showcase how to take a web-app you made on your computer and make it live and accessible to anyone in the world with internet. We call this process 'deployment', as we want to *deploy* our app onto Anvil Composable.

## Intuition

### Accessing our app

When people access our web-app (app being viewed in your browser), Anvil Composable takes care of all the minutiae. Imagine if you tried to use your personal computer to host your app: each time people access the app, your computer will receive network traffic and have to provide, or *serve*, the appropriate content to the user. 

Further, your computer would have to be powered on and connected to the internet at all times, otherwise people couldn't access our app. Anvil Composable, among many other things, provides a stable server to ensure users of our app can always access our app.

[Kubernetes](https://kubernetes.io/docs/home/) is the software layer Anvil Composable (AC) uses that automates deployment, scaling, and other aspects
of our app. For example, if millions of people start using our app, we most likely want to replicate more instances of our app so we can serve more people concurrently (at the same time). This would require adding compute resources (CPUs, perhaps) so we can replicate many copies of our app for people to use.

Further, Anvil Composable is a great place to host your app because it can easily connect to the compute power of the Anvil supercompute cluster.

### Architecture of an example app (Services)

A common format for an app is to have 3 separate components: 1 for the frontend, 1 for the backend, and 1 for the
database. This keeps logic separate and allows the developer to make incremental changes to each independent component separately. Let's dive into an example.

Say you create a python script that takes in an argument for your *full name* and then prints out a greeting to you.
```bash
$ python greet.py --full-name Annie Anvil
>>> Hello, Annie Anvil! It is nice to meet you
```

Great, you can run this on the command line and it works. But what if we want people to be able to interact with this script in the browser? We could create what we call a 'frontend', which defines what we see in our browser (in our example of a web-app). We will dive into the details later, but essentially the frontend is called a *service* because it needs to always monitor the url in our browser and *serve* the appropriate content.

For example, if we navigate to ```http://localhost:5173/home``` we want to show our home page. Let's imagine we have a frontend and we run it via some magic command (we will learn about this later); now we have a *frontend service* running.

This is what listens on a specific url and port (e.g., `http://localhost:5173`) and will provide the content for each route (e.g., `/home`).

Imagine our frontend has a home page with a button that says **enter name** and once you click **Submit**, the browser prints a nice text blob saying ```Hello, <name>! It is nice to meet you```. Instead of writing the logic in our frontend (Javascript, for example) app, we can use the logic from our ```greet.py``` to display this message.

Our frontend will be in charge o/rom our user, who writes in a box and clicks Submit. Then the frontend will **talk to our backend**, essentially inserting the *name* into the script:

```bash
$ python greet.py --full-name <value-collected-from-frontend>
$ python greet.py --full-name Annie Anvil # user wrote Annie Anvil in browser
```

So we outlined how a user goes to a browser page (frontend), writes their name in a text box, the frontend communicates this information to the backend, and then the backend runs the program and provides the greeting. 

Next, we need the backend to respond, or communicate back to the frontend with the *output* from running greet.py, which is ```Hello, Wintermute! It is nice to meet you```. Finally, the frontend receives this data and displays it for the user.

<hr style="border: 3px solid">

Just like our frontend, we call our backend a *service* (even if it just consists of 1 python script) because it needs a mechanism to listen and respond to *requests* for doing work. Our example of doing work means listening for a --full-name to be provided and then running the greet.py script with the --full-name <value provided> parameter. Later on, we will talk about how to turn our backend from 1 (or many) static scripts into a proper service.

Now let's add 1 more service to complete our 3-service app: a database service. Let's say we want to **store** the
--full-name every time people come to our app, where do we put it? This is where the database comes into play. Our
database service will simply be a database where we can store and retrieve data as requests come in (this is why we call it a service, as just like our frontend and backend, it must have a way to listen to requests).

Our workflow thus will be:

1. user goes to a browser page and our *frontend serves* them the home page
2. they type in their name
3. *frontend communicates name to the backend*
4. backend *listens and receives* the request to run ```greet.py``` with the name data
5. backend runs the code:
   1. *communicates output to database*, *database receives request*, and stores the output
   2. *communicates output to frontend*
6. *frontend receives output* and serves the content to the web browser, showing the user their greeting!

<hr style="border: 3px solid">

Imagine the frontend has another page, called ```/old-greetings```. Here, the frontend could bypass the backend and simply communicate with the database, asking for all previous greetings that are stored. Once it receives a response from the database, it can render all the previous greetings on the page. Although, oftentimes the database service is only accessible to the backend for security reasons.

In this case, the logic would flow as follows:

1. User navigates to ```/old-greetings``` on the browser (frontend serves content)
2. Frontend **requests** backend that it needs old greetings
3. Backend **requests** database to query old greetings
4. Database **responds** to the backend with all the old greetings
5. Backend **responds** to frontend with all the data from old greetings
6. Frontend **serves** the old greetings data to the web page for viewer to see

## Kubernetes to Host our Services

In the previous sections, we introduced the different services that make up our application. Now, we need to talk about where those services actually run. This is where you’ll start hearing a lot of Kubernetes-related terms, such as: containers, Docker, Pods, Services, Kubernetes, Ingress, and more. Don’t worry if these sound like buzzwords at first. We’ll introduce only what you need to understand to get up and running. Each part of our application - frontend, backend, and database - runs as its own container. This separation is intentional and powerful: it allows us to develop, update, and deploy each component independently without affecting the others.

!!! note "Kubernetes Pods"
    In Kubernetes, containers don’t run on their own. Instead, each container runs inside a Pod, which is the smallest deployable unit in Kubernetes. For our app, we’ll have:

    - A Pod for the frontend
    - A Pod for the backend
    - A Pod for the database

If you want a deeper dive into how Kubernetes works under the hood, The *Kubernetes Book by Nigel Poulton* is an excellent (and free) resource. This tutorial focuses on the concepts you need to build and deploy an app, not on covering every Kubernetes feature.

### How Pods Communicate: Kubernetes Services

Now that each service lives in its own Pod, the next question is: how do they talk to each other?

When the frontend needs data, it doesn’t communicate directly with the backend container - it communicates with the backend Pod. To make this communication reliable, Kubernetes provides an abstraction called a Service.

!!! warning "service vs Service"
    To avoid confusion:
    - We’ll use “service” (lowercase) to refer to parts of our application (frontend, backend, database)
    - We’ll use “Service” (capital S) to refer to the Kubernetes object

Think of it this way:

- Each Pod is a house
- A Kubernetes Service is a telephone
- The Service gives Pods a stable “phone number” they can use to reach each other

By defining Services, Kubernetes “wires up” our Pods so they can communicate without needing to know where the other Pods are physically running.

### Exposing the Application: Ingress

Finally, we need a way for users outside the cluster to access our app. This is where **Ingress** comes in.

An Ingress is a Kubernetes resource that defines:

- Which URLs your application is available at
- Which Services handle incoming requests

For example, we might configure an Ingress so that requests to: ```wintermutant.anvilcloud.rcac.purdue.edu``` are routed to our **frontend Service**, which then serves the homepage.

Using our analogy:
- Pods are houses
- Services are telephones
- Ingress is the public phone number that lets the outside world find your app

For security reasons, we typically expose only the frontend through the Ingress. The backend and database remain internal to the cluster, protected from direct access.

At a high level, our Kubernetes setup looks like this:

- Each app component runs in its own container
- Each container lives inside a Pod
- Pods communicate with each other through Kubernetes Services
- The outside world accesses the app through an Ingress

With these building blocks in place, we can now focus on deploying and managing our application inside Kubernetes.

## Local Kubernetes Development & Deployment

!!! note
    Before deploying to Anvil Composable, it's helpful to test your Kubernetes setup locally. This lets you iterate quickly and catch issues before deploying to production.

We'll deploy:

- **Frontend**: Svelte application (port 3000)
- **Backend**: FastAPI Python application (port 8080)
- **Database**: MongoDB (port 27017)
- **Ingress**: HTTP routing to frontend and backend

### Prerequisites

!!! warning "Required installations"
    Before you begin, ensure you have:

    - **Docker** installed: [Get Docker](https://docs.docker.com/get-docker/)
    - **kubectl** installed: [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
    - **minikube** installed: [Install minikube](https://minikube.sigs.k8s.io/docs/start/)
    - Basic understanding of Docker and command line

### Setting Up Local Kubernetes with Minikube

Minikube runs a single-node Kubernetes cluster on your local machine.

**1. Start minikube:**

```bash
minikube start
```

This may take a few minutes on first run as it downloads the Kubernetes components.

**2. Verify the cluster is running:**

```bash
# Check minikube status
minikube status

# Verify kubectl can connect
kubectl cluster-info

# You should see something like:
# Kubernetes control plane is running at https://127.0.0.1:xxxxx
# CoreDNS is running at https://127.0.0.1:60096/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

**3. Enable the Ingress addon:**

```bash
minikube addons enable ingress
```

This allows us to test Ingress routing locally.

**4. (Optional) Use minikube's Docker daemon:**

To avoid pushing images to a registry during local development, you can build images directly in minikube's Docker:

```bash
eval $(minikube docker-env)
# Run this command in each new terminal session, or add it to your shell profile.
```

Now any `docker build` commands will build images inside minikube, making them immediately available to your pods.

!!! note
    For this tutorial, I do not personally like to do this, as I prefer to point to Dockerhub. Later in the tutorial, I will reference pointing to Dockerhub. If you choose minikube's Docker, then you may have to slightly adjust your commands when pushing/pulling and pointing to your containers.


### Architecture Overview

Our application follows a three-tier architecture:

```
                    ┌─────────────┐
                    │   Ingress   │
                    └──────┬──────┘
                           │
           ┌───────────────┴───────────────┐
           │                               │
           ▼                               ▼
    ┌─────────────┐                ┌─────────────┐
    │  Frontend   │                │   Backend   │
    │   Service   │                │   Service   │
    │  (ClusterIP)│                │  (ClusterIP)│
    └──────┬──────┘                └──────┬──────┘
           │                               │
           ▼                               ▼
    ┌─────────────┐                ┌─────────────┐
    │  Frontend   │                │   FastAPI   │
    │    Pods     │◄───────────────┤    Pods     │
    │ (2 replicas)│                │ (2 replicas)│
    └─────────────┘                └──────┬──────┘
                                          │
                                          ▼
                                   ┌─────────────┐
                                   │   MongoDB   │
                                   │   Service   │
                                   │  (ClusterIP)│
                                   └──────┬──────┘
                                          │
                                          ▼
                                   ┌─────────────┐
                                   │   MongoDB   │
                                   │     Pod     │
                                   │ (1 replica) │
                                   └─────────────┘
```

**Key Components:**

- **Ingress**: Routes external traffic to frontend (/) and backend (/api)
- **Services**: Provide stable networking for pod communication
- **Deployments**: Manage pod lifecycle and scaling
- **Namespace**: All resources deployed in your chosen namespace (e.g., `<username>-tutorial`)

### Project Structure

```
.
├── README.md
├── docs/
│   └── tutorial.md              # This tutorial
├── docker/
│   └── backend/
│       ├── Dockerfile           # FastAPI container definition
│       ├── main.py              # FastAPI application code
│       └── requirements.txt     # Python dependencies
├── frontend/
│   ├── Dockerfile               # Frontend container definition
│   ├── package.json             # Node.js dependencies
│   ├── svelte.config.js         # SvelteKit configuration
│   └── src/
│       └── routes/
│           └── +page.svelte     # Main page component
└── k8s/
    ├── backend/
    │   ├── deployment.yaml      # FastAPI deployment (2 replicas)
    │   └── service.yaml         # FastAPI service (ClusterIP)
    ├── frontend/
    │   ├── deployment.yaml      # Frontend deployment (2 replicas)
    │   └── service.yaml         # Frontend service (ClusterIP)
    ├── database/
    │   ├── deployment.yaml      # MongoDB deployment (1 replica)
    │   ├── deployment-simple.yaml  # Alternative MongoDB config
    │   └── service.yaml         # MongoDB service (ClusterIP)
    ├── ingress-local.yaml       # HTTP routing for local minikube
    └── ingress-prod.yaml        # HTTP routing for Anvil Composable
```

**Directory Overview:**

- **docker/backend/**: FastAPI backend application and Dockerfile
- **frontend/**: Svelte frontend application and Dockerfile
- **k8s/**: Kubernetes manifests that we'll apply using `kubectl`

!!! note
    In this tutorial, we'll walk through deploying each component step-by-step using `kubectl` commands. This hands-on approach helps you understand how each piece works. Later, you could automate the full deployment with a single manifest or a script.

### Understanding the Kubernetes Manifests

#### Namespace

All resources are deployed in a namespace you create (e.g., `<username>-tutorial`). We will create it later. For now, let's walk through all the manifest (AKA config or YAML) files that specify the details of our kubernetes cluster.

<hr style="border: 3px solid">

#### Database Layer

**File: `k8s/database/deployment.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
spec:
  replicas: 1
  # ... containers, storage, etc.
```

**Key features:**

- Single replica (stateful workload)
- Resource limits: 500m CPU, 512Mi memory
- Uses `emptyDir` volume (data lost on pod restart)
- Environment variables for authentication

**File: `k8s/database/service.yaml`**

Exposes MongoDB on port 27017 within the cluster:
```yaml
type: ClusterIP
ports:
  - port: 27017
```

**Note:** For production, consider using a PersistentVolume instead of emptyDir.

<hr style="border: 3px solid">

#### Backend Layer

**File: `k8s/backend/deployment.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi
spec:
  replicas: 2
  # ... containers, env, etc.
```

**Key features:**

- 2 replicas for high availability
- Resource limits: 250m CPU, 256Mi memory
- Environment variable `MONGO_URI` connects to MongoDB service
- Container runs on port 80, exposed via service on port 8080

**File: `k8s/backend/service.yaml`**

Exposes the FastAPI backend as `fastapi-svc`:
```yaml
type: NodePort
ports:
  - port: 8080
    targetPort: 80
    nodePort: 30002
```

<hr style="border: 3px solid">

#### Frontend Layer

**File: `k8s/frontend/deployment.yaml`**

Similar structure to backend:

- 2 replicas
- Resource limits: 250m CPU, 256Mi memory
- Runs on port 3000

**File: `k8s/frontend/service.yaml`**

Exposes the frontend as `frontend-svc` on port 3000:
```yaml
type: ClusterIP
ports:
  - port: 3000
    targetPort: 3000
```

<hr style="border: 3px solid">

### Ingress

**Files: `k8s/ingress-local.yaml` and `k8s/ingress-prod.yaml`**

Routes external HTTP traffic:

- `/` → Frontend service
- `/api` → Backend service

```yaml
rules:
  - http:
      paths:
        - path: /api
          pathType: Prefix
          backend:
            service:
              name: fastapi-svc
              port:
                number: 8080
        - path: /
          pathType: Prefix
          backend:
            service:
              name: frontend-svc
              port:
                number: 3000
```

### Deploying to Local Minikube

Now let's deploy the application to your local minikube cluster.

**1. Make sure minikube is running:**

```bash
minikube status
# If not running: minikube start
```

**2. Build images in minikube's Docker (recommended for local dev):**

```bash
# Use minikube's Docker daemon
eval $(minikube docker-env)

# Build backend
cd docker/backend
docker build -t anvil-backend:local .

# Build frontend
cd ../../frontend
docker build -t anvil-frontend:local .
```

**3. Update the Kubernetes manifests to use local images:**

Edit `k8s/backend/deployment.yaml`:
```yaml
image: anvil-backend:local
imagePullPolicy: Never  # Use local image, don't pull from registry
```

Edit `k8s/frontend/deployment.yaml`:
```yaml
image: anvil-frontend:local
imagePullPolicy: Never
```

**4. Create namespace and deploy:**

```bash
# Create namespace (for local minikube, you can use kubectl directly)
kubectl create namespace my-local-tutorial

# Set it as your default namespace
kubectl config set-context --current --namespace=my-local-tutorial

# Deploy database
kubectl apply -f k8s/database/deployment.yaml
kubectl apply -f k8s/database/service.yaml

# Wait for MongoDB to be ready
kubectl get pods -w
# Press Ctrl+C once the mongodb pod shows "Running"

# Deploy backend
kubectl apply -f k8s/backend/deployment.yaml
kubectl apply -f k8s/backend/service.yaml

# Deploy frontend
kubectl apply -f k8s/frontend/deployment.yaml
kubectl apply -f k8s/frontend/service.yaml

# Deploy ingress
kubectl apply -f k8s/ingress-local.yaml
```

**5. Access the application:**

```bash
# Get the minikube IP
minikube ip

# Or use minikube's tunnel for ingress (run in separate terminal)
minikube tunnel
```

With `minikube tunnel` running, access the app at:
- Frontend: http://localhost/
- Backend API: http://localhost/api/names

At this point, you should see a little guest book app where the fronten displays the interface and the backend takes in the name and stores it in the database.

**6. Verify everything is working:**

```bash
# Check all pods are running
kubectl get pods

# Check services
kubectl get svc

# Check ingress
kubectl get ingress
```

<hr style="border: 3px solid">

#### Test the Backend

```bash
# Port-forward to test backend directly
kubectl port-forward svc/fastapi-svc 8080:8080

# In another terminal
curl http://localhost:8080
```

TODO: Ensure a stable return for this API endpoint.

#### Test the Frontend

```bash
# Port-forward to test frontend
kubectl port-forward svc/frontend-svc 3000:3000

# Visit http://localhost:3000 in your browser
```

#### Test via Ingress

```bash
# Get the ingress external IP/hostname
kubectl get ingress 
# Access your application
# http://<EXTERNAL-IP>/        (Frontend)
# http://<EXTERNAL-IP>/api     (Backend)
```

Once you've verified locally, you're ready to deploy to Anvil Composable.

---

## Deploying to Anvil Composable

### Building and Pushing Docker Images

Before deploying to Kubernetes, we need to containerize our backend and frontend applications and push them to a container registry. We'll use Docker Hub in this tutorial. Unlike our local deployment, we cannot push the our local minikube docker daemon, but rather must push to a repository accessible to Anvil Composable.

!!! warning "Prerequisites"

    1. **Create a Docker Hub account** at [hub.docker.com](https://hub.docker.com) if you don't have one
    2. **Log in to Docker Hub** from your terminal:

    ```bash
    docker login
    ```

    Enter your Docker Hub username and password when prompted. For the sake of this tutorial, I will be using the username `wintermutant`.

#### Backend Image

The backend Dockerfile (`docker/backend/Dockerfile`) creates a Python 3.11 container running FastAPI with Uvicorn. We need to build this image and push it to Docker Hub so that Kubernetes can pull it when creating Pods.

!!! warning "AMD64"
    Anvil Composable runs on **AMD64 (x86_64)** servers. If you're building on an Apple Silicon Mac (ARM64), you must build for the correct architecture or the image won't run.

**Build and push (multi-architecture):**

```bash
# Navigate to the backend directory
cd docker/backend

# Build for both AMD64 and ARM64, then push (replace YOUR_DOCKERHUB_USERNAME)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1 \
  --push .
```

!!! note
    If `docker buildx` isn't available, you can build for AMD64 only:
    ```bash
    docker build --platform linux/amd64 -t YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1 .
    docker push YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1
    ```

**Verify the push:**
Visit `https://hub.docker.com/r/YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend` to confirm your image is uploaded.

**Update the Kubernetes deployment:**
Edit `k8s/backend/deployment.yaml` and update the image field to reference your image:
```yaml
image: YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1
```

#### Frontend Image

The frontend is a SvelteKit application located in `frontend/`. It has its own Dockerfile that creates a Node.js container.

**Build and push (multi-architecture):**

```bash
# Navigate to the frontend directory
cd frontend

# Build for both AMD64 and ARM64, then push (replace YOUR_DOCKERHUB_USERNAME)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t YOUR_DOCKERHUB_USERNAME/anvil-tutorial-frontend:v1 \
  --push .
```

!!! note "docker buildx reminder..."
    If `docker buildx` isn't available, you can build for AMD64 only:
    ```bash
    docker build --platform linux/amd64 -t YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1 .
    docker push YOUR_DOCKERHUB_USERNAME/anvil-tutorial-backend:v1
    ```

**Update the Kubernetes deployment:**
Edit `k8s/frontend/deployment.yaml` and update the image field:
```yaml
image: YOUR_DOCKERHUB_USERNAME/anvil-tutorial-frontend:v1
```

#### Database Image

For MongoDB, we use the official public image from Docker Hub: `mongo:7.0`. No build step is required - Kubernetes will pull this image automatically when deploying the database Pod.


### Step 1: Configure kubectl

!!! warning
    You must complete this step before running any `kubectl` commands. Without proper configuration, you'll get authentication errors like `User "system:unauthenticated"`.

**1. Log in to Anvil Composable:**

Visit [composable.anvil.rcac.purdue.edu](https://composable.anvil.rcac.purdue.edu) and log in with your Purdue credentials.

**2. Download your kubeconfig:**

- Once logged in, click on Anvil (AVL) in the left navigation bar
- In the top right corner, you will see an icon that looks like a blacked-out piece of paper with a corner folded over. When you hover over it, it should say 'Download KubeConfig'
- Select **"Download kubeconfig"** (or navigate to the Kubernetes section)
- Save the file to `~/.kube/anvil.yaml` (create the `~/.kube` folder if it doesn't exist)

**3. Set the KUBECONFIG environment variable:**

In your terminal, run:
```bash
export KUBECONFIG=~/.kube/anvil.yaml

# Verify you're connected to Anvil (not minikube)
kubectl config current-context
```

!!! note
    This sets the config for your current terminal session only. If you open a new terminal, you'll need to run this command again. Alternatively, add it to your `~/.bashrc` or `~/.zshrc` to make it permanent.

!!! success
    If you see cluster information and namespaces listed, you're ready to deploy. If you get an "unauthenticated" error, double-check that:
    
    - The `KUBECONFIG` variable is set: `echo $KUBECONFIG`
    - The file exists at that path `~/.kube/anvil.yaml`
    - Your token hasn't expired (try downloading a fresh kubeconfig)

### Step 2: Create Namespace

For this part, due to permissions, we will need to create our namespace using the Anvil Composable Rancher interface. Rancher is a GUI for kubernetes and other functionality.

**1. Create the namespace in Rancher:**

Visit [Anvil Rancher](https://composable.anvil.rcac.purdue.edu) and click Cluster > Projects/Namespaces. Create a namespace with:

- **Project** = Select your project from the dropdown (**IMPORTANT:** Do not leave this blank! You need to assign the namespace to a project to have deployment permissions)
    - Your project should be the same as the one you use for research computing jobs with SLURM
- **Name** = `<your-username>-tutorial` (e.g., `wintermutant-tutorial`)
- CPU reservation = 1000 mCPUs
- CPU limit = 1000 mCPUs
- Memory reservation = 128 MiB
- Memory limit = 128 MiB

!!! warning "Selecting a Project"
    If you don't select a project, you will be able to create the namespace but you won't have permissions to deploy anything to it. If you get "Forbidden" errors when running `kubectl apply`, delete the namespace and recreate it with a project selected.

**2. Switch to your Anvil kubeconfig** (if you were using minikube for local development):

```bash
export KUBECONFIG=~/.kube/anvil.yaml

# Verify you're on the right cluster
kubectl config current-context
```

**3. Set your namespace as the default** so you don't need `-n <namespace>` on every command:

```bash
kubectl config set-context --current --namespace=<your-username>-tutorial
```

**4. Verify you have access:**

```bash
kubectl get pods
# Should show all pods
```

!!! warning "Default Namespace"
    The manifest files do not specify a namespace, so they will deploy to whatever namespace you have set as your current context. If you get an error while running this command, it means your kube config is not pointing to your namespace + project correctly and you have permission issues. Please try to go back and figure out the issue or contact [Anvil Support](https://support.access-ci.org/help-ticket).

### Step 3: Deploy the Database

!!! note
    Since you set your default namespace in Step 2, you don't need the `-n` flag.

The commands below will deploy to your current namespace context.

```bash
kubectl apply -f k8s/database/deployment.yaml
kubectl apply -f k8s/database/service.yaml

# Verify
kubectl get pods -l app=mongodb
kubectl get svc mongodb
```

Wait for the MongoDB pod to be Running before proceeding.

### Step 4: Deploy the Backend

```bash
kubectl apply -f k8s/backend/deployment.yaml
kubectl apply -f k8s/backend/service.yaml

# Verify
kubectl get pods -l app=fastapi
kubectl get svc fastapi-svc
```

### Step 5: Deploy the Frontend

```bash
kubectl apply -f k8s/frontend/deployment.yaml
kubectl apply -f k8s/frontend/service.yaml

# Verify
kubectl get pods -l app=frontend
kubectl get svc frontend-svc
```

### Step 6: Deploy the Ingress

**Change line 8**: `- host: wintermutant.anvilcloud.rcac.purdue.edu` and have it point to a domain of your choice that ends with `.anvilcloud.rcac.purdue.edu`.

!!! note
    If you are following along on a different cluster or service, you'll have to adjust the suffix as necessary.

```bash
kubectl apply -f k8s/ingress-prod.yaml

# Verify
kubectl get ingress
```

### Step 7: Verify All Resources

```bash
# View all pods
kubectl get pods

# View all services
kubectl get svc

# View deployments
kubectl get deployments

# View ingress
kubectl get ingress
```

Expected output:

- 1 MongoDB pod (Running)
- 2 FastAPI pods (Running)
- 2 Frontend pods (Running)
- 3 ClusterIP services
- 1 Ingress with an external address

### Verification and Testing

#### Check Pod Status

```bash
# All pods should be Running
kubectl get pods 
# If any pod is not running, check logs
kubectl logs <pod-name>

# Describe pod for more details
kubectl describe pod <pod-name>
```

!!! success
    Visit <YOUR_URL\>.anvilcloud.rcac.purdue.edu and see your app live in action! Congrats, you just deployed a multiservice cloud application on your own!

## Troubleshooting

### Pods Not Starting

**Check pod status:**
```bash
kubectl get pods kubectl describe pod <pod-name>
```

**Common issues:**

- Image pull errors: Verify image name and registry access
- Resource limits: Check cluster has available resources
- Configuration errors: Review environment variables

### Database Connection Errors

**Check MongoDB logs:**
```bash
kubectl logs <mongodb-pod-name>
```

**Verify service DNS:**
```bash
# From a backend pod
kubectl exec <fastapi-pod-name> -- nslookup mongodb
```

**Check MONGO_URI environment variable:**
```bash
kubectl exec <fastapi-pod-name> -- env | grep MONGO
```

### Ingress Not Working

**Check ingress controller:**
```bash
kubectl get pods -n kube-system | grep ingress
```

**Verify ingress configuration:**
```bash
kubectl describe ingress ```

### View Events

```bash
# See recent cluster events
kubectl get events --sort-by='.lastTimestamp'
```

### Useful Debug Commands

```bash
# View all resources in namespace
kubectl get all 
# Execute command in a pod
kubectl exec -it <pod-name> -- /bin/bash

# View pod logs with tail
kubectl logs <pod-name> --tail=50 -f

# Check resource usage
kubectl top pods ```

## Cleanup

To remove all deployed resources:

```bash
# Delete all resources
kubectl delete -f k8s/ingress-prod.yaml  # or ingress-local.yaml
kubectl delete -f k8s/frontend/
kubectl delete -f k8s/backend/
kubectl delete -f k8s/database/

# Delete namespace (removes everything) - use your namespace name
kubectl delete namespace <your-namespace>

# Verify cleanup
kubectl get all ```

## Next Steps

### Production Improvements

1. **Persistent Storage for MongoDB**
   - Replace `emptyDir` with a PersistentVolumeClaim
   - Ensures data survives pod restarts

2. **Secrets Management**
   - Move passwords to Kubernetes Secrets
   - Use environment variables from secrets

3. **Resource Optimization**
   - Monitor actual resource usage
   - Adjust CPU/memory requests and limits

4. **High Availability**
   - Consider MongoDB replica set
   - Add pod anti-affinity rules

5. **Monitoring and Logging**
   - Integrate with Prometheus/Grafana
   - Centralize logs with ELK or Loki

6. **TLS/HTTPS**
   - Add cert-manager for automatic TLS
   - Configure ingress for HTTPS

7. **Health Checks**
   - Add liveness and readiness probes
   - Improve pod lifecycle management

### Scaling

```bash
# Scale backend
kubectl scale deployment fastapi --replicas=4

# Scale frontend
kubectl scale deployment frontend --replicas=3
```

### Updates

```bash
# Update backend image
kubectl set image deployment/fastapi fastapi=YOUR_REGISTRY/YOUR_IMAGE:NEW_TAG 
# Check rollout status
kubectl rollout status deployment/fastapi 
# Rollback if needed
kubectl rollout undo deployment/fastapi
```

---

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [MongoDB on Kubernetes](https://www.mongodb.com/kubernetes)
- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

**Questions or Issues?**
Check the troubleshooting section or review the Kubernetes events for your namespace.
