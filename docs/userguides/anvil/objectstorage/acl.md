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

[Placeholder for mykeys tool]

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