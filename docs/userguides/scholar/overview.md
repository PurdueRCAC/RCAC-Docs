---
tags:
  - Scholar
authors:
  - jin456
  - remender
search:
  boost: 2
---

# Scholar Overview

Scholar is a small computer cluster, suitable for classroom learning about high performance computing (HPC). It consists of 6 interactive login servers and 16 batch worker nodes.

It can be accessed as a typical cluster, with a job scheduler distributing batch jobs onto its worker nodes, or as an interactive resource, with software packages available through a desktop-like environment on its login servers.

If you have a class that you think will benefit from the use of Scholar, you can schedule it for your class through our [Class Account Request](https://www.rcac.purdue.edu/account/class) page. You only need to register your class itself. All students who register for the class will automatically get login privileges to the Scholar cluster.

As a batch resource, the cluster has access to typical HPC software packages and tool chains; as an interactive resource, Scholar provides a Linux remote desktop, or a Jupyter notebook server, or an R Studio server. Jupyter and R Studio can be used by students without any reliance on Linux knowledge or experience.

## Scholar Specifications

### Scholar Front-Ends

| Front-Ends | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires In |
| ---- | ---- | -------- | ---- | ---- | ---- |
| No GPU | 3 | Two AMD EPYC 9634 ("Genoa") 84-Core Processors | 168 | 384 GB | 2029 |
| GPU | 3 | Two Intel Xeon Gold 6126 ("Skylake") 12-Core Processors with one NVIDIA Tesla V100 32GB GPU | 24 | 768 GB | 2027 |

### Scholar Sub-Clusters

| Sub-Cluster | Number of Nodes | Processors per Node | Cores per Node | Memory per Node | Retires In |
| ---- | ---- | -------- | ---- | ---- | ---- |
| A | 4 | Two AMD EPYC 7713 ("Milan") 64-Core Processors | 128 | 256 GB | 2027 |
| B | 3 | One AMD EPYC 7702P ("Rome") 64-Core Processor | 64 | 256 GB | 2026 |
| G | 4 | Two Intel Xeon Silver 4110 ("Skylake") 8-Core Processors with one NVIDIA Tesla V100 16GB GPU | 16 | 192 GB | 2027 |
| H | 2 | Two AMD EPYC 7543 3rd generation ("Milan") 32-Core Processors with two NVIDIA A30 24GB GPUs | 64 | 512 GB | 2027 |
| H-MIG | 2 | Two AMD EPYC 7543 3rd generation ("Milan") 32-Core Processors with eight 6GB Multi-Instance GPUs (MIGs) configured from two NVIDIA A30 24GB GPUs | 64 | 512 GB | 2027 |
| I-MIG | 1 | 	Two AMD EPYC 9554 ("Genoa") 64-Core Processors with four 6GB Multi-Instance GPUs (MIGs) configured from one NVIDIA A30 24GB GPU | 128 | 384 GB | 2029 |
| J | 4 | Two Intel Xeon Gold 6126 ("Skylake") 12-Core Processors with two NVIDIA A40 48GB GPUs | 24 | 192 GB | 2029 |

Faculty who would like to know more about Scholar, please read the [Faculty Guide](https://www.rcac.purdue.edu/policies/faculty)

## Scholar Software Catalog

A list of available applications on Scholar can be found [here](../../software/app_catalog.md).
