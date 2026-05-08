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

# Security and Access Control

### Getting Your Keys

The `mykeys` tool is available on Anvil login nodes to retrieve your S3 credentials for Anvil Object Storage. This tool fetches your unique access key and secret key from the RCAC S3 Key service.

!!! note "Prerequisites"
    You must [request access to Anvil Object Storage](access.md) before you can retrieve your S3 credentials.

#### Usage

To retrieve your S3 credentials, run the following command on any Anvil login node:

```bash
mykeys
```

#### Example Output

```
=====================================
  S3 Credentials for: username
=====================================
Access Key : YOUR_ACCESS_KEY_HERE
Secret Key : YOUR_SECRET_KEY_HERE
=====================================
```

Use these credentials with S3-compatible tools (such as `rclone`, `s3cmd`, or Python `boto3`) to access your buckets on Anvil Object Storage. Keep your secret key confidential and do not share it.

---

### Manage Bucket CLI Tool

The `manage-bucket` tool is a command-line interface for managing access policies on Anvil Object Storage (Ceph S3). It lets you easily grant or revoke user permissions at the bucket level using common access patterns like read-only or read-write.

#### Usage
```
manage-bucket [-h] COMMAND ...
```
##### Grant Access
```
manage-bucket grant-readonly-access --bucket <bucket-name> --user <username>
manage-bucket grant-readwrite-access --bucket <bucket-name> --user <username>
```

##### Remove Access
```
manage-bucket remove-readonly-access --bucket <bucket-name> --user <username>
manage-bucket remove-readwrite-access --bucket <bucket-name> --user <username>
manage-bucket remove-all-access --bucket <bucket-name> --user <username>
```

##### Restrict Access
```
manage-bucket make-private --bucket <bucket-name> --user <username>
```