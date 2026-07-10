---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Hammer Overview

Hammer is optimized for Purdue's communities utilizing loosely-coupled, high-throughput computing. Hammer was established in April 2015 through a partnership with HP and Intel and has been expanded annually, with each year's nodes kept in production for five years. Hammer was expanded again in late 2016. Hammer will be expanded annually, with each year's purchase of nodes to remain in production for 5 years from their initial purchase.

To purchase access to Hammer today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or contact us via email at [rcac-cluster-purchase@lists.purdue.edu](mailto:rcac-cluster-purchase@lists.purdue.edu) if you have any questions.

## Hammer Specifications

Currently, all Hammer nodes consist of identical hardware with the exception for some of them hosting an Nvidia T4 GPU.  All Hammer nodes have 128 HT-enabled processor cores, 512 GB of RAM, and 10 Gbps Ethernet interconnects.

Hammer Front-Ends

| Front-Ends | Number of Nodes | Processors per Node | Cores per Node | Memory per Node |
| --- | --- | --- | --- | --- |
|  | 2 | Two Sky Lake CPUs @ 2.60GHz | 48 (Logical) | 192 GB |

Hammer Sub-Clusters

| Sub-Cluster | Number of Nodes | Processors per Node | Cores per Node | Memory per Node |
| --- | --- | --- | --- | --- |
| F [000-012] | 13 | Two AMD EPYC 7702 @ 2GHz, one Nvidia Tesla T4 GPU | 256 | 512GB |
| F [013-015] | 3 | Two AMD EPYC 7702 @ 2GHz | 256 | 512GB |
| G | 40 | Two AMD EPYC 7702 @ 2GHz | 256 | 512GB |

Hammer nodes run Rocky Linux 8 and use Slurm (Simple Linux Utility for Resource Management) as the batch scheduler for resource and job management. The application of operating system patches occurs as security needs dictate. All nodes allow for unlimited stack usage, as well as unlimited core dump size (though disk space and server quotas may still be a limiting factor).

By default, the `rcac` module is loaded on login, which provides a standard set of compilers and message-passing libraries. Use `module list` to see currently loaded modules.

[**Back to Hammer User Guide**](index.md)
