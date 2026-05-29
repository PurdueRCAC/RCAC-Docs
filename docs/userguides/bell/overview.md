---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Bell Overview

Bell is a Community Cluster optimized for communities running traditional, tightly-coupled science and engineering applications. Bell was built through a partnership with Dell and AMD over the summer of 2020. Bell consists of Dell compute nodes with two 64-core AMD Epyc 7662 "Rome" processors (128 cores per node) and 256 GB of memory. All nodes have 100 Gbps HDR Infiniband interconnect and a 6-year warranty.

Bell access is offered on the basis of each 64-core Rome processor, or a half-node share. To purchase access to Bell today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or contact us via email at [rcac-cluster-purchase@lists.purdue.edu](mailto:rcac-cluster-purchase@lists.purdue.edu) if you have any questions.

## Bell Namesake

Bell is named in honor of Clara Bell Sessions, minority advocate and Professor and Director of Continuing Education of Nursing. More information about her life and impact on Purdue is available in a [Biography of Bell](biography.md).

## Bell Specifications

All Bell compute nodes have 128 processor cores and 100 Gbps Infiniband interconnects.

Bell Front-Ends

| Front-Ends | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
|  | 8 | One Rome CPU @ 2.0GHz | 32 | 512 GB | 2026 |

Bell Sub-Clusters

| Sub-Cluster | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
| A | 448 | Two Rome CPUs @ 2.0GHz | 128 | 256 GB | 2026 |
| B | 8 | Two Rome CPUs @ 2.0GHz | 128 | 1 TB | 2026 |
| G | 4 | Two Rome CPUs @ 2.0GHz,  two MI50 AMD GPUs (32GB) | 128 | 256 GB | 2026 |
| G | 1 | Two Cascade Lake CPUs @ 2.90 GHz,  six MI50 AMD GPUs (32GB) | 48 | 384 GB | 2026 |

Bell nodes run Rocky Linux 8 and use Slurm (Simple Linux Utility for Resource Management) as the batch scheduler for resource and job management. The application of operating system patches occurs as security needs dictate. All nodes allow for unlimited stack usage, as well as unlimited core dump size (though disk space and server quotas may still be a limiting factor).

On Bell, the following set of compiler and message-passing library for parallel code are recommended:

* GCC 14.2.0
* OpenMPI 5.0.5

[**Back to Bell User Guide**](index.md)
