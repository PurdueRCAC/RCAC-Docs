---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Workloads

## Deploy a Workload

1. Using the top right dropdown select the **Project** or **Namespace** you wish to deploy to.
2. Using the far left menu navigate to **Workload**
3. Click **Create** at the top right
4. Select the appropriate **Deployment Type** for your use case
   * Select **Namespace** if not already done from step 1
   * Set a unique **Name** for your deployment, **i.e.** "myapp"
   * Set **Container Image**. Ensure you're using the Geddes registry for personal images or the Geddes registry docker-hub cache when pulling public docker-hub specific images. **e.g**: `geddes-registry.rcac.purdue.edu/my-registry/myimage:tag` or `geddes-registry.rcac.purdue.edu/docker-hub-cache/library/image:tag`
   * Click **Create**

See the [Examples](examples/index.md) section for complete walkthroughs of deploying a database, a web server, an R Shiny app, and JupyterHub.
