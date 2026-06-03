---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# R Shiny

This guide provides instructions on how to build a Docker image for an R Shiny application, push it to the Geddes Registry and deploy it on Geddes.

## Create an R Shiny Docker Image

Create a local Dockerfile by saving the following Dockerfile to your computer and editing the contents for your R Shiny App.

```
FROM rocker/shiny

# install R package dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    git \
    ## clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install any R packages you need
RUN install2.r --error \
        <package 1> \
        <package 2> \
        <package 3> \
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## copy shiny app to shiny server location
COPY ./<app directory> /srv/shiny-server/
```

## Docker Build and Testing Process

Build the Docker image locally based on the Dockerfile above. The Dockerfile must be in your current working directory. This command tags the image with the name "myshinyapp" and version 1.0.

```bash
docker build -t myshinyapp:1.0 .
```

Test your application locally. This command will run your container locally and expose the R Shiny port (3838) so it can be accessed via `http://localhost:3838` in your web browser.

On Linux or Mac: `docker run --network=host myshinyapp:1.0`

On Windows: `docker run -p 3838:3838 myshinyapp:1.0`

Iterate on code changes locally until you want to deploy on Geddes.

## Tag and Upload to the Geddes Registry

Tag the image for upload to the Geddes Registry.

```bash
docker tag myshinyapp:1.0 geddes-registry.rcac.purdue.edu/<repo>/myshinyapp:1.0
```

Push the image to the Geddes Registry. Run the login command using your Purdue career account username and password if you currently are not authenticated to the registry.

```bash
docker login geddes-registry.rcac.purdue.edu
```

```bash
docker push geddes-registry.rcac.purdue.edu/<repo>/myshinyapp:1.0
```

## Deploy the Application on Geddes

To deploy the application, one can follow the [instructions for deploying a web server](webserver.md) and replace the image name with the Geddes registry image tag from above: `geddes-registry.rcac.purdue.edu/<repo>/myshinyapp:1.0`
