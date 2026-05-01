---
tags:
  - Anvil
  - Object Storage
authors:
  - hkashgar
search:
  boost: 2
draft: false
---
[Back to Anvil Object Storage](index.md)

# Getting Access and Connecting to Object Storage
## Eligibility
Access is provisioned separately from Anvil login credentials. It is available to Anvil allocations. 

## Request Process

To request access to Anvil Object Storage, follow the steps below:

### 1. Submit a Support Ticket

Choose one of the following portals:

- **ACCESS:** <https://support.access-ci.org/open-a-ticket>  
- **NAIRR:** <https://nairrpilot.org/open-support-request>  

---

### 2. Use the Correct Subject Line

> **Request for Anvil Object Storage Access**

---

### 3. Include Required Information

Make sure your request contains:

- **Project name or allocation ID**  
- **Brief description of your use case**  
- **Dataset(s) you intend to store or access**
- **Size of your data and number of files**
  
You will be provided access to object storage and your credentials after you submit the request.

---

### 4. Security & Credentials
Object storage uses HMAC credentials, not your ACCESS/NAIRR account password.

- **Access Key ID:** 20-character alphanumeric string (Public identifier).
- **Secret Access Key:** 40-character string (Private signature key).

---

### 5. Connecting to Storage
Connection Parameters: 

- **Endpoint URL:** https://s3.anvil.rcac.purdue.edu
- **Addressing Style:** Path-style is preferred (e.g., endpoint/bucket/object).

  - **Path-Style**

    In path-style addressing, the bucket name is part of the URL path:

    ```
    https://s3.anvil.rcac.purdue.edu/bucket-name/object-key
    ```

    **Example:** `https://s3.anvil.rcac.purdue.edu/ai-datasets/COCO/file`

  - **DNS-Style (Virtual Hosted Style)**

    In DNS-style addressing, the bucket name is part of the hostname:

    ```
    https://bucket-name.s3.anvil.rcac.purdue.edu/object-key
    ```

    **Example:** `https://ai-datasets.s3.anvil.rcac.purdue.edu/COCO/file`


!!! note
    Check the user tool documentation for instructions on how to connect using tools such as `rclone`, `s3cmd`, and others.
---
