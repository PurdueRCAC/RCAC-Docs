---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Registry

## Accessing the Geddes Harbor Registry

The Geddes Harbor registry is only accessible via campus networks and the Purdue VPN. Use a web browser to navigate to [geddes-registry.rcac.purdue.edu](https://geddes-registry.rcac.purdue.edu) and log in with your Purdue career account username and password.

## Using the Geddes Registry Docker Hub Cache

It's advised that you use the Docker Hub cache within Geddes to pull images for your deployments. There's a limit to how many images Docker Hub will allow to be pulled within a 24 hour period which Geddes does reach depending on user activity. This means if you're trying to deploy a workload without the cache, or have a currently deployed workload that needs migrated, restarted, or upgraded without the cache, there's a chance it will fail.

To bypass this, use the Geddes cache url `geddes-registry.rcac.purdue.edu/docker-hub-cache/` in your image names.

For example if you're wanting to pull a notebook from JupyterHub's Docker Hub repo e.g `jupyter/tensorflow-notebook:latest`, pulling it from the Geddes cache would look like this `geddes-registry.rcac.purdue.edu/docker-hub-cache/jupyter/tensorflow-notebook:latest`.

If the image you are using is an "Official" docker image (like httpd or mongo) the URL will use "library" in the path instead of the Docker repository name: `geddes-registry.rcac.purdue.edu/docker-hub-cache/library/mongo:latest`.

## Creating a registry

1. Using a browser, login to [geddes-registry.rcac.purdue.edu](https://geddes-registry.rcac.purdue.edu) with your Purdue account username and password
2. From the main page click **create project**, this will act as your registry
3. Fill in a name and select whether you want the project to be public or private
4. Click **ok** to create and finalize

## Tagging and Pushing Images to Your Harbor Registry

1. Tag your image

    ```
    $ docker tag my-image:tag geddes-registry.rcac.purdue.edu/project-registry/my-image:tag
    ```

2. Login to the Geddes registry via command line

    ```
    $ docker login geddes-registry.rcac.purdue.edu
    ```

3. Push your image to your project registry

    ```
    $ docker push geddes-registry.rcac.purdue.edu/project-registry/my-image:tag
    ```

## Creating a Robot Account for a Private Registry

A robot account and token can be used to authenticate to your registry in place of having to supply or store your private credentials on multi-tenant cloud environments like Rancher/Geddes.

1. Navigate to your project by logging into [geddes-registry.rcac.purdue.edu](https://geddes-registry.rcac.purdue.edu)
2. Navigate to the **Robot Accounts** tab and click **New Robot Account**
3. Fill out the form
    * Name your robot account
    * Select account expiration if any, select never to make permanent
    * Customize what permissions you wish the account to have
    * Click **Add**
4. Copy your information
    * Your robot's account name will be something longer than what you specified, since this is a multi-tenant registry, Harbor does this to avoid unrelated project owners creating a similarly named robot account
    * Export your token as JSON or copy it to a clipboard

    !!! note
        Harbor does not store account tokens, once you exit this page your token will be unrecoverable.

## Adding Your Private Registry to Rancher

1. Select your **Project** from the top right dropdown
2. Using the far left dropdown menu navigate to **Storage** > **Secrets**
3. Click **Create**
4. Click **Registry**
5. Fill out the form
    * Select **namespace** that will have access to the registry
    * Give a **name** to the Registry secret (this is an arbitrary name)
    * Under the **Data** tab ensure **custom** is selected
    * Enter "geddes-registry.rcac.purdue.edu" under **Registry Domain Name**
    * Enter your robot account's long name **eg. robot$my-registry+robot** as the **Username**
    * Enter your robot account's token as the **password**
    * Click **Create**

## External Harbor Documentation

* [Project Configurations](https://goharbor.io/docs/2.1.0/working-with-projects/project-configuration/)
* [Working With Images](https://goharbor.io/docs/2.1.0/working-with-projects/working-with-images/)
