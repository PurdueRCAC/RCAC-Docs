---
tags:
  - Anvil
authors:
  - jin456
search:
  boost: 2
---

# System Architecture

## Compute Nodes
|Attribute|	Anvil CPUs|	Anvil GPUs|	Anvil AI|
|--|--|--|--|
|**Model**|	AMD EPYC™ 7763 CPUs|	AMD EPYC™ 7763 CPUs with 4 NVIDIA A100 GPUs|	Intel Xeon Platinum 8468 CPUs with 4 NVIDIA H100 GPUs|
|**CPU speed**|	2.45GHz|	2.45GHz|	2.1Ghz|
|**Number of nodes**|	1000	|16|	21|
|**Cores per node**|	128|	128|	96|
|**RAM per node**|	256GB|	512GB|	1TB|
|**Cache**|	L1d(32K), L1i(32K), L2(512K), L3(32768K)|	L1d(32K), L1i(32K), L2(512K), L3(32768K)|	L1d(48K), L1i(32K), L2(2048K), L3(107520K)|
|**GPU memeory**|-|	40GB|	80GB|
|**Network Interconnect**|	100 Gbps Infiniband|	100 Gbps Infiniband	|Dual 400Gbps Infiniband|
|**Operating System**|	Rocky Linux 8.10|	Rocky Linux 8.10|	Rocky Linux 8.10|
|**Batch system**|	Slurm|	Slurm|	Slurm|

## Login Nodes
|Number of Nodes|Processors per Node       |Cores per Node|Memory per Node|
|---------------|--------------------------|--------------|---------------|
|8              |3rd Gen AMD EPYC™ 7543 CPU|32            |512 GB         |

## Specialized Nodes
|Sub-Cluster	|Number of Nodes|	Processors per Node	|Cores per Node|	Memory per Node|
|--|--|--|--|--|
|B|	32|	Two 3rd Gen AMD EPYC™ 7763 CPUs|	128|	1 TB|
|G|	16|	Two 3rd Gen AMD EPYC™ 7763 CPUs + Four NVIDIA A100 GPUs|	128	|512 GB|
|H|	21|	Dual Intel Xeon Platinum 8468 CPUs + Four NVIDIA H100 GPUs	|96	|1 TB|

## Network

All nodes, as well as the scratch storage system are interconnected by an oversubscribed (3:1 fat tree) HDR InfiniBand interconnect. The nominal per-node bandwidth is 100 Gbps, with message latency as low as 0.90 microseconds. The fabric is implemented as a two-stage fat tree. Nodes are directly connected to Mellanox QM8790 switches with 60 HDR100 links down to nodes and 10 links to spine switches.

## Storage

The Anvil local storage infrastructure provides users with their Home, Scratch, and Project areas. These file systems are mounted across all Anvil nodes and are accessible on the Anvil Globus Endpoints. In addition, Anvil Ceph offers a distributed, software-defined storage system that supports large-scale, durable, and high-throughput data access for research workflows.

The three tiers of storage are intended for different use cases and are optimized for that use. Use of data tiers for their unintended purposes is discouraged as poor performance or file system access problems may occur. These tiers have quotas in both capacity and numbers of files, so care should be taken to not exceed those. Use the 'myquota' command to see what your usage is on the various tiers.

Anvil File Systems

|  | HOME | SCRATCH | PROJECT |
| --- | --- | --- | --- |
| Filesystem | ZFS | GPFS | GPFS |
| Capacity | 25 GB | 100 TB | 5 TB |
| File number limit | none | 1 millions | 1 millions |
| Backups | daily snapshots | none | daily snapshots |
| Hardware | <ul><li>Dell PowerEdge R7515 Server</li><li>12 x 7.1TB NVME SSDs</li></ul> | <ul><li><p><strong>Flash Tier</strong></p><ul><li>11 Dell PowerEdge R7515 Servers</li><li>20 15.3 NVME SSDS</li></ul><p>&nbsp;</p></li><li><p><strong>SAS Tier</strong></p><ul><li>4 Dell PowerEdge R6516 Servers connected by InfiniBand to 2 DDN SFA 18K, each unit contains 5 SS9012 expansion enclosures</li><li>367 18TB NL SAS Drives</li></ul></li></ul> | |

### Home

Home is intended to hold configuration files for setting up the user's environment and some small files that are often needed to run jobs. Saving job output permanently is not really supported on this tier as the space is limited.

### Scratch

Scratch is intended to hold input and output data for running jobs. This tier of storage is very high performance and is very large to be able to handle a large number of jobs and large quantities of data. It is not intended for long-term storage of data, either input or output as files may only reside on Scratch for 30 days. Files older than 30 days will be eligible for an automated process which purges those files. This automated process can not be cancelled or overridden. So make provisions for moving your data to your home institution or other storage before then. New files on Scratch are written to a fast tier of NVME disk where they will reside for 7 days or if that tier is more than 90% full, at which time they are moved to a slower SAS tier for the remaining 30 days or until deleted.

!!! warning 
    CAUTION: Be aware that data on this tier is not backed up or snapshotted, so files that are accidentally erased or lost due to mechanical problems is NOT recoverable. Movement of data to a more secure tier is recommended.

### Project

Projects is intended for groups to store data that is relevant for entire groups such a common datasets used for computation or for collaboration. Allocations for this tier is by request and it is not designed to be used in actively writing job output to, but are usual for those files that are constantly in use for reading.

### Anvil Ceph

Anvil Ceph is intended to provide scalable, fault-tolerant, and high-throughput storage for large or persistent research data. It supports both object and block storage, making it suitable for hosting shared datasets, storing long-term research outputs, and enabling data access for containerized or cloud-integrated workflows. Ceph complements the Lustre-based storage tiers by offering durable and easily expandable storage for diverse data management needs.

Anvil Ceph Tech Detail

| Attribute | Anvil CEPH |
| --- | --- |
| **CPU Model** | 2x Intel® Xeon® Gold 5416S Processors |
| **CPU speed + cache** | 2.00 GHz, 30M Cache |
| **CPU Cores per node** | 32 |
| **Number of nodes** | 12 |
| **RAM per node** | 256 GB |
| **Network Interconnect** | 100 Gbps Infiniband |
| **Operating System** | Rocky Linux 8.10 |
| **Disks** | 16 x Dell NVMe 15.36TB |