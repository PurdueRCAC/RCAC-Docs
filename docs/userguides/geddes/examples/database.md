---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Deploy a Database

## Deploy a postgis Database

1. Select your **Project** from the top right dropdown
2. Using the far left menu, select **Workload**
3. Click **Create** at the top right
4. Select the appropriate **Deployment Type** for your use case, here we will select and use **Deployment**
5. Fill out the form
   * Select **Namespace**
   * Give an arbitrary **Name**
   * Set **Container Image** to the postgis Docker image: `geddes-registry.rcac.purdue.edu/docker-hub-cache/postgis/postgis:latest`
   * Set the postgres user password
     + Select the **Add Variable** button under the **Environment Variables** section
     + Fill in the fields **Variable Name** and **Value** so that we have a variable `POSTGRES_PASSWORD = <some password>`
   * Create a persistent volume for your database
     + Select the **Storage** tab from within the current form on the left hand side
     + Select **Add Volume** and choose **Create Persistent Volume Claim**
     + Give an arbitrary **Name**
     + Select **Single-Node Read/Write**
     + Select an appropriate **Storage Class** from the dropdown and give **Capacity** in GiB **e.g** 5
     + Provide the default postgres data directory as a **Mount Point** for the persistent volume `/var/lib/postgresql/data`
     + Set **Sub Path** to `data`
   * Set resource CPU limitations
     + Select **Resources** tab on the left within the current form
     + Under the **CPU Reservation** box fill in `2000`. This ensures that Kubernetes will only schedule your workload to nodes that have that resource amount available, guaranteeing your application has 2 CPU cores to utilize
     + Under the **CPU Limit** box also fill in `2000`. This ensures that your workload cannot exceed or utilize more than 2 CPU cores. This helps resource quota management on the project level.
   * Setup Pod Label
     + Select **Labels & Annotations** on the left side of the current form
     + Select **Add Label** under the **Pod Labels** section
     + Give an arbitrary unique key and value you can remember later when creating Services and other resources **e.g** **Key:** `my-db` **Value:** `postgis`
   * Select **Create** to launch the postgis database

Wait a couple minutes while your persistent volume is created and the postgis container is deployed. The "does not have minimum availability" message is expected. But, waiting more than 5 minutes for your workload to deploy typically indicates a problem. You can check for errors by clicking your workload name (i.e. "mydb"), then the lower button on the right side of your deployed pod and selecting **View Logs**. If all goes well, you will see an Active status for your deployment.

## Expose the Database to external clients

Use a **LoadBalancer** service to automatically assign an IP address on a private Purdue network and open the postgres port (5432). A DNS name will automatically be configured for your service as `<servicename>.<namespace>.geddes.rcac.purdue.edu`.

1. Using the far left menu navigate to **Service Discovery** > **Services**
2. Select **Create** at the top right
3. Select **Load Balancer**
4. Fill out the form
   * Ensure to select the **namespace** where you deployed the postgis database
   * Give a **Name** to your **Service**. Remember that your final DNS name when the service creates will be in the format of `<servicename>.<namespace>.geddes.rcac.purdue.edu`
   * Fill in **Listening Port** and **Target Port** with the postgis default port **5432**
   * Select the **Selectors** tab within the current form
     + Fill in **Key** and **Value** with the label values you created during the **Setup Pod Label** step from earlier **e.g** **Key:** `my-db` **Value:** `postgis`
     + IMPORTANT: The yellow bar will turn green if your key-value pair matches the pod label you set during the "Setup Pod Label" deployment step above. If you don't see a green bar with a matching Pod, your LoadBalancer will not work.
   * Select the **Labels & Annotations** tab within the current form
     + Select **Add Annotation**
     + To deploy to a **Purdue Private Address Range** fill in **Key:** `metallb.universe.tf/address-pool` **Value:** `geddes-private-pool`
     + To deploy to a **Public Address Range** fill in **Key:** `metallb.universe.tf/address-pool` **Value:** `geddes-public-pool`

Kubernetes will now automatically assign you an IP address from the Geddes private IP pool. You can check the IP address by hovering over the "5432/tcp" link on the Service Discovery page or by viewing your service via kubectl on a terminal.

```
$ kubectl -n <namespace> get services
```

Verify your DNS record was created:

```
$ host <servicename>.<namespace>.geddes.rcac.purdue.edu
```
