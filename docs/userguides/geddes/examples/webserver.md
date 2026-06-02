---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Deploy a Web Server

## Nginx Deployment

1. Select your **Project** from the top right dropdown
2. Using the far left menu, select **Workload**
3. Click **Create** at the top right
4. Select the appropriate **Deployment Type** for your use case, here we will select and use **Deployment**
5. Fill out the form
   * Select **Namespace**
   * Give an arbitrary **Name**
   * Set **Container Image** to the nginx Docker image: `geddes-registry.rcac.purdue.edu/docker-hub-cache/library/nginx`
   * Create a **Cluster IP** service to point our external accessible ingress to later
     + Click **Add Port**
     + Click **Service Type** and with the dropdown select **Cluster IP**
     + In the **Private Container Port** box type **80**
   * Setup Pod Label
     + Select **Labels & Annotations** on the left side of the current form
     + Select **Add Label** under the **Pod Labels** section
     + Give an arbitrary unique key and value you can remember later when creating Services and other resources **e.g** **Key:** `my-web` **Value:** `nginx`
   * Click **Create**

<!-- TODO: add screenshots Geddes-web-server-4 through Geddes-web-server-10 (Nginx deployment form steps) -->

Wait a couple minutes while your application is deployed. The "does not have minimum availability" message is expected. But, waiting more than 5 minutes for your workload to deploy typically indicates a problem. You can check for errors by clicking your workload name (i.e. "mywebserver"), then using the vertical ellipsis on the right hand side of your deployed pod and selecting **View Logs**.

If all goes well, you will see an Active status for your deployment.

## Expose the web server to external clients via an Ingress

1. Using the far left menu navigate to **Service Discovery** > **Ingresses** and select **Create** at the top right
2. Fill out the form
   * Ensure to select the **namespace** where you deployed the nginx
   * Give an arbitrary **Name**
   * Under **Request Host** give the url you want for your web application **e.g** `my-nginx.geddes.rcac.purdue.edu`
   * Fill in the value **Path** > **Prefix** as `/`
   * Use the **Target Service** and **Port** dropdowns to select the service you created during the **Nginx Deployment** section
   * The default Ingress is **private**, which is only accessible within the Purdue network. To make a **public** one, change the **Ingress Class** to `public`:

<!-- TODO: add screenshots Geddes-web-server-1 through Geddes-web-server-3 (Ingress creation form) -->

![Changing the Ingress Class to public](https://www.rcac.purdue.edu/files/image-20231212162400-1.png)
