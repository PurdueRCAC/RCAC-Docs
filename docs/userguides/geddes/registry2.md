---
tags:
  - Geddes2
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Accessing the Geddes2 Harbor Container Registry

## Overview

The Geddes2 Harbor container registry uses Purdue OIDC (Single Sign-On) for web interface access.

Because container tools like Docker cannot authenticate directly via browser-based OIDC logins, you must use a Harbor CLI Secret as your password when authenticating over the command line.


## 1. Log In to the Harbor Web UI

1. Go to the registry interface: [https://geddes2-registry.rcac.purdue.edu](https://geddes2-registry.rcac.purdue.edu)
2. Click **LOGIN WITH Purdue Account**.
3. Log in with your standard Purdue credentials:
   * **Username:** `<username>@purdue.edu`
   * **Password:** Your Purdue account password (MFA App or Duo authentication if prompted).


## 2. Retrieve Your Harbor CLI Secret

1. Once logged in, click your account profile in the top-right corner.
2. Select **User Profile**.
3. Locate the **CLI Secret** field.
4. Click the copy icon to copy your secret (or generate a new one if it is blank).

> **Important:** Your CLI Secret functions as your password for CLI access. Never share it or commit it to public repositories.


## 3. Log In via Docker CLI

Open your terminal and initiate login:

```bash
docker login geddes2-registry.rcac.purdue.edu

```

Provide your Purdue email address and Harbor CLI Secret when prompted:

```text
Username: <username>@purdue.edu
Password: <YOUR_HARBOR_CLI_SECRET>

```

Upon successful authentication, you will see:

```text
Login Succeeded

```

## 4. Quick Authentication Summary

| Interface | URL / Command | Username | Password |
|  |  |  |  |
| **Harbor Web UI** | [https://geddes2-registry.rcac.purdue.edu](https://geddes2-registry.rcac.purdue.edu) | `<username>@purdue.edu` | Purdue Account Password |
| **Docker / CLI** | `docker login geddes2-registry.rcac.purdue.edu` | `<username>@purdue.edu` | Harbor CLI Secret |

> **Note:** Do not use your standard Purdue account password for `docker login`.


## 5. Pulling and Pushing Images

### Pull an Image

```bash
docker pull geddes2-registry.rcac.purdue.edu/<project>/<image>:<tag>

```

**Example:**

```bash
docker pull geddes2-registry.rcac.purdue.edu/myproject/analysis-tools:latest

```

### Push an Image

```bash
docker push geddes2-registry.rcac.purdue.edu/<project>/<image>:<tag>

```

## 6. Logging Out

To remove stored registry credentials from your local machine:

```bash
docker logout geddes2-registry.rcac.purdue.edu

```



## 7. Troubleshooting

**`unauthorized: authentication required`**

* Verify that you are entering your full Purdue email (`<username>@purdue.edu`) as the username.
* Ensure you entered your Harbor CLI Secret and not your Purdue login password.
* Try logging out (`docker logout geddes2-registry.rcac.purdue.edu`) and running `docker login` again.

**`denied: requested access to the resource is denied`**

* Your login succeeded, but your account lacks permissions for the specified project or repository.
* Contact the project administrator or RCAC support to request access to the project namespace.