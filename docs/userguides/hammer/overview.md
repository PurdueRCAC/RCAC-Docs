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

Hammer is a Community Cluster optimized for Purdue's communities utilizing loosely-coupled, high-throughput computing. Hammer consists of multiple sub-clusters of Dell compute nodes with varying processor and memory configurations to support a wide range of research workloads.

## Hammer Specifications

Hammer Front-Ends

| Front-Ends | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
|  | 2 | Two Haswell @ 2.60GHz | 20 | 64 GB | 2020 |

Hammer Sub-Clusters

| Sub-Cluster | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires in |
| --- | --- | --- | --- | --- | --- |
| A | 198 | Two Haswell @ 2.60GHz | 20 | 64 GB | 2020 |
| B | 40 | Two Haswell @ 2.60GHz | 40 | 128 GB | 2021 |
| C | 27 | Two Sky Lake @ 2.60GHz | 48 | 192 GB | 2022 |
| D | 18 | Two Sky Lake @ 2.60GHz | 48 | 192 GB | 2023 |
| E | 15 | Two Xeon Gold @ 2.60GHz | 48 | 96 GB | 2024 |

Hammer nodes run Rocky Linux 8 and use Slurm (Simple Linux Utility for Resource Management) as the batch scheduler for resource and job management. The application of operating system patches occurs as security needs dictate. All nodes allow for unlimited stack usage, as well as unlimited core dump size (though disk space and server quotas may still be a limiting factor).

On Hammer, the following set of compiler and message-passing library for parallel code are recommended:

* GCC
* OpenMPI

[**Back to Hammer User Guide**](index.md)
