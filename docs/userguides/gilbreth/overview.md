---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# Overview of Gilbreth

Gilbreth is a Community Cluster optimized for communities running GPU intensive applications such as machine learning. Gilbreth consists of Dell compute nodes with Intel Xeon processors and Nvidia Ampere and Hopper GPUs.

To purchase access to Gilbreth today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or contact us via email at [rcac-cluster-purchase@lists.purdue.edu](mailto:rcac-cluster-purchase@lists.purdue.edu) if you have any questions.


## Gilbreth Namesake

Gilbreth is named in honor of Lillian Moller Gilbreth, Purdue's first female engineering professor. More information about her life and impact on Purdue is available in a [Biography of Lillian Moller Gilbreth](./biography.md).

## Gilbreth Detailed Hardware Specification

Gilbreth has heterogeneous hardware comprising of Nvidia A100, A10, and A30 GPUs in separate sub-clusters. All the nodes are connected by 100 Gbps Infiniband interconnects. Please see the hardware specifications below for details about various node types.

Gilbreth Front-Ends

| Front-Ends | Number of Nodes | Cores per Node | Memory per Node | GPUs per node (GPU memory per card) | Retires in |
| --- | --- | --- | --- | --- | --- |
| With GPU | 4 | 64 | 512 GB | 1 A30 (24 GB) | 2027 |

Gilbreth Sub-Clusters

| Sub-Cluster | Number of Nodes | Cores per Node | Memory per Node | GPUs per node (GPU memory per card) | Retires in |
| --- | --- | --- | --- | --- | --- |
| B | 16 | 24 | 192 GB | 3 A30 (24 GB) | 2027 |
| D | 8 | 16 | 192 GB | 3 A30 (24 GB) | 2027 |
| G | 12 | 128 | 512 GB | 2 A100 (40 GB) | 2026 |
| H | 16 | 32 | 512 GB | 3 A10 (24 GB) | 2027 |
| I | 5 | 32 | 512 GB | 2 A100 (80 GB) | 2027 |
| J | 2 | 128 | 1024 GB | 4 A100 (80 GB) with NVLink | 2027 |
| K | 52 | 64 | 512 GB | 2 A100 (80 GB) | 2028 |
| L | 2 | 64 | 512 GB | 2 H100 | 2029 |
| M-Not for Sale | 2 | 96 | 2 TB | 4 H100 | 2029 |
| N | 20 | 48 | 1024 GB | 4 A100 (40 GB) with NVLink | 2029 |

Gilbreth nodes run Rocky 9 and use Slurm (Simple Linux Utility for Resource Management) as the batch scheduler for resource and job management. The application of operating system patches occurs as security needs dictate. All nodes allow for unlimited stack usage, as well as unlimited core dump size (though disk space and server quotas may still be a limiting factor).

On Gilbreth, the following set of compiler, math library, and message-passing library for parallel code are recommended:

* Intel/17.0.1.132
* MKL
* Intel MPI

This compiler and these libraries are loaded by default. To load the recommended set again:

```bash
$ module load rcac
```

To verify what you loaded:

```bash
$ module list
```