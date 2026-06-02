---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Web Server

## Nginx Deployment

1. Select your **Project** from the top right dropdown
    ![Geddes Web Server 1](/assets/images/userguides/geddes/Geddes-web-server-1.png)
2. Using the far left menu, select **Workload**
3. Click **Create** at the top right
    ![Geddes Web Server 2](/assets/images/userguides/geddes/Geddes-web-server-2.png)
4. Select the appropriate **Deployment Type** for your use case, here we will select and use **Deployment**
    ![Geddes Web Server 3](/assets/images/userguides/geddes/Geddes-web-server-3.png)
5. Fill out the form
    * Select **Namespace**
    * Give an arbitrary **Name**
    * Set **Container Image** to the nginx Docker image: `geddes-registry.rcac.purdue.edu/docker-hub-cache/library/nginx`
        ![Geddes Web Server 4](/assets/images/userguides/geddes/Geddes-web-server-4.png)
    * Create a **Cluster IP** service to point our external accessible ingress to later
        + Click **Add Port**
        + Click **Service Type** and with the dropdown select **Cluster IP**
        + In the **Private Container Port** box type **80**
            ![Geddes Web Server 5](/assets/images/userguides/geddes/Geddes-web-server-5.png)
    * Setup Pod Label
        + Select **Labels & Annotations** on the left side of the current form
        + Select **Add Label** under the **Pod Labels** section
        + Give an arbitrary unique key and value you can remember later when creating Services and other resources **e.g** **Key:** `my-web` **Value:** `nginx`
            ![Geddes Web Server 6](/assets/images/userguides/geddes/Geddes-web-server-6.png)
            ![Geddes Web Server 6b](/assets/images/userguides/geddes/Geddes-web-server-6b.png)
    * Click **Create**

Wait a couple minutes while your application is deployed. The "does not have minimum availability" message is expected. But, waiting more than 5 minutes for your workload to deploy typically indicates a problem. You can check for errors by clicking your workload name (i.e. "mywebserver"), then using the vertical ellipsis on the right hand side of your deployed pod and selecting **View Logs**.

If all goes well, you will see an Active status for your deployment.

## Expose the web server to external clients via an Ingress

1. Using the far left menu navigate to **Service Discovery** > **Ingresses** and select **Create** at the top right
    ![Geddes Web Server 7](/assets/images/userguides/geddes/Geddes-web-server-7.png)
2. Fill out the form
    * Ensure to select the **namespace** where you deployed the nginx
    * Give an arbitrary **Name**
    * Under **Request Host** give the url you want for your web application **e.g** `my-nginx.geddes.rcac.purdue.edu`
    * Fill in the value **Path** > **Prefix** as `/`
    * Use the **Target Service** and **Port** dropdowns to select the service you created during the **Nginx Deployment** section
        ![Geddes Web Server 8](/assets/images/userguides/geddes/Geddes-web-server-8.png)
    * The default Ingress is **private**, which is only accessible within the Purdue network. To make a **public** one, change the **Ingress Class** to `public`:
    ![Geddes Web Server 9](/assets/images/userguides/geddes/Geddes-web-server-9.png)