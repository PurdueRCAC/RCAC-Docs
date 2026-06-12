---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---


# Specific Types of Nodes

SLURM allows running a job on [specific types of compute nodes](../overview.md) to accommodate special hardware requirements (e.g. a certain CPU or GPU type, etc.)

Cluster nodes have a set of descriptive features assigned to them, and users can specify which of these features are required by their job by using the constraint option at submission time. Only nodes having features matching the job constraints will be used to satisfy the request.

**Example:** a job requires a compute node in an "A" sub-cluster:


```
sbatch --nodes=1 --ntasks=128 --constraint=A myjobsubmissionfile.sub
```

Compute node allocated:

```
a003.negishi
```

Feature constraints can be used for both batch and interactive jobs, as well as for individual job steps inside a job. Multiple constraints can be specified with a predefined syntax to achieve complex request logic (see detailed description of the '--constraint' option in `man sbatch` or online Slurm documentation).

Refer to [Detailed Hardware Specification](../overview.md) section for list of available sub-cluster labels, their respective per-node memory sizes and other hardware details. You could also use `sfeatures` command to list available constraint feature names for different node types.


[**Back to the Example Jobs section**](generic_slurm_jobs.md)
