---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Overview of Geddes

Geddes is a Community Composable Platform optimized for composable, cloud-like workflows that are complementary to the batch applications run on Community Clusters. Funded by the National Science Foundation under grant OAC-2018926, Geddes consists of Dell Compute nodes with two 64-core AMD Epyc 'Rome' processors (128 cores per node).

To purchase access to Geddes today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or [contact us](mailto:rcac-cluster-purchase@lists.purdue.edu) if you have any questions.

## Geddes Namesake

Geddes is named in honor of Lanelle Geddes, a Purdue professor and Head of the School of Nursing. More information about her life and impact on Purdue is available in a [Biography of Lanelle Geddes](biography.md).

## Geddes Specifications

All Geddes compute nodes have 128 processor cores and 100 Gbps Infiniband interconnects.

### Geddes Hyperconverged Worker Nodes

| Worker Type | Number of Nodes | Processors per Node | Cores per Node | Storage per Node | Memory per Node |
| --- | --- | --- | --- | --- | --- |
| A | 8 | Two AMD Epyc CPUs @ 2.0GHz | 128 | 24 TB SATA SSD | 1 TB |
| B | 16 | Two AMD Epyc CPUs @ 2.0GHz | 128 | 24 TB SATA SSD | 512 GB |

### Geddes Hyperconverged GPU Nodes

| Number of Nodes | Processors per Node | Cores per Node | GPUs per Node | Storage per Node | Memory per Node |
| --- | --- | --- | --- | --- | --- |
| 4 | Two AMD Epyc CPUs @ 2.0GHz | 128 | 2 Nvidia A100 | 24 TB SATA SSD | 512 GB |

### Geddes Storage Nodes

| Number of Nodes | Processors per Node | Cores per Node | Storage per Node | Memory per Node |
| --- | --- | --- | --- | --- |
| 8 | Two Intel Xeon Gold 6126 | 24 | 24 TB NVMe | 192 GB |

Geddes nodes run Rocky 8 and use Rancher and Kubernetes as the resource manager for resource and workload orchestration.
