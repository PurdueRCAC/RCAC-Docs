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


# Object Storage Concepts
To effectively use Anvil Object Storage, it is essential to understand how it differs from the traditional "Project" or "Home" directories you use on the supercomputer. While traditional storage is hierarchical (folders inside folders), object storage is flat.

## Storage Comparison: When to Use S3

| Feature | Anvil Object Storage (S3) | $SCRATCH (GPFS) | Project Storage (GPFS) | $HOME (NFS) |
|--------|---------------------------|-------------------|-----------------|-------------|
| **Primary Protocol** | REST API (HTTP/HTTPS) | POSIX (File System) | POSIX (File System) | POSIX (File System) |
| **Best For** | Archival, ML datasets, large shared datasets | High-speed temporary computation | Shared project data and collaboration | Code, config files, small scripts |
| **Retention** | Persistent (no purge) | 30-day purge | Persistent (protected with snapshots) | Persistent (protected with snapshots) |
| **Access Method** | Tools (`rclone`, `boto3`, `s3cmd`) | Native OS commands (`cd`, `ls`) | Native OS commands | Native OS commands |
| **Metadata** | Customizable, searchable | Fixed (system attributes) | Fixed | Fixed |
| **Typical Use Case** | Data lakes, ML training datasets | Running jobs and temporary job outputs | Long-term shared data for a research group | Personal configs and scripts |

---

## The Object Model 
To use tools effectively, you must understand these core terminologies:

### Objects
An Object is the fundamental unit of storage. Unlike a simple file, an object is a "bundle" that consists of:

- **The Data:** The actual file (e.g., a .csv dataset or a .tar.gz backup).

- **Metadata:** Information describing the file (e.g., "created-by: researcher_a").

- **A Unique Key:** The unique identifier used to find the object.

### Buckets
A Bucket is a top-level container for objects. You can think of a bucket as a "directory," but with one key difference: buckets cannot be nested inside other buckets.

- **Unique Naming:** Bucket names must be globally unique across the entire Anvil object storage system.

- **Flat Structure:** In the background, every object in a bucket is stored at the same level.

### Object Keys (and "Prefixes")
The Key is the full name of the object. While object storage is flat, it "mimics" folders by using slashes in the key name.

- **Example:** If you upload a file as project1/data/results.txt, the Key is the entire string project1/data/results.txt.

- **Prefix:** The string project1/data/ is called a prefix. Tools like the s3cmd or rclone use these prefixes to show you a "folder-like" view, even though the storage is technically flat.

### Metadata
Metadata is "data about your data." In Anvil, every object has System Metadata (like file size and last modified date) and can have Custom Metadata. Custom metadata allows you to tag files with experimental parameters, making it possible to search through millions of objects without opening them.

