---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Negishi Overview

Negishi is a Community Cluster optimized for communities running traditional, tightly-coupled science and engineering applications. Negishi was built through a partnership with Dell and AMD over the summer of 2022. Negishi consists of Dell compute nodes with two 64-core AMD Epyc "Milan" processors (128 cores per node) and 256 GB of memory. All nodes have 100 Gbps HDR Infiniband interconnect and a 6-year warranty.

New with Negishi is that access is being offered on the basis of each 64-core Milan processor, or a half-node share. To purchase access to Negishi today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or contact us via email at [rcac-cluster-purchase@lists.purdue.edu](mailto:rcac-cluster-purchase@lists.purdue.edu) if you have any questions.

## Negishi Interactive 

The interactive tier on our Negishi cluster provides entry-level access to high performance computing. This includes login to the system, data storage on our high-performance *scratch* filesystem, and a small allocation that allows jobs submitted to an "interactive" account limited to a few cores. This subscription is useful for getting workloads off your personal machine, integrated with more robust research computing and data systems, and a platform for smaller workloads. Transitioning to a larger allocation with priority scheduling is easy and simple.

## Negishi Namesake

Negishi is named in honor of Dr. Ei-ichi Negishi, the Herbert C. Brown Distinguished Professor in the Department of Chemistry at Purdue. More information about his life and impact on Purdue is available in a [Biography of Negishi](./biography.md).

## Negishi Specifications

All Negishi compute nodes have 128 processor cores, 256 GB memory and 100 Gbps HDR100 Infiniband interconnects.

### Negishi Front-Ends

| Front-Ends | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
|  | 8 | Two AMD EPYC 7763 64-Core Processors @ 2.2GHz | 128 | 512 GB | 2028 |

### Negishi Sub-Clusters

| Sub-Cluster | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
| A | 450 | Two AMD Epyc 7763 “Milan” CPUs @ 2.2GHz | 128 | 256 GB | 2028 |
| B | 6 | Two AMD Epyc 7763 “Milan” CPUs @ 2.2GHz | 128 | 1 TB | 2028 |
| C | 16 | Two AMD Epyc 7763 “Milan” CPUs @ 2.2GHz | 128 | 512 GB | 2028 |
| G | 5 | Two AMD Epyc 7313 “Milan” CPUs @ 3.0GHz,  Three AMD MI210 GPUs (64GB) | 32 | 512 GB | 2028 |

Negishi nodes run Rocky Linux 8 and use Slurm (Simple Linux Utility for Resource Management) as the batch scheduler for resource and job management. The application of operating system patches occurs as security needs dictate. All nodes allow for unlimited stack usage, as well as unlimited core dump size (though disk space and server quotas may still be a limiting factor).

On Negishi, the following set of compiler and message-passing libraries for parallel code are recommended:

* GCC 12.2.0
* OpenMPI or MVAPICH2


[**Back to Negishi User Guide**](index.md)
