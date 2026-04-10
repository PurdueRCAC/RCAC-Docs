---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Interactive jobs are run on compute nodes, while giving you a shell to interact with. They give you the ability to type commands or use a graphical interface in the same way as if you were on a front-end login host.

To submit an interactive job, use ```sinteractive``` to run a login shell on allocated resources.

```sinteractive``` accepts most of the same resource requests as ```sbatch```, so to request a login shell on the cpu account while allocating 2 nodes and 192 total cores, you might do:

```bash
sinteractive -A myallocation -p cpu -N2 -n384
```

To quit your interactive job:

```bash
exit or Ctrl-D
```

The above example will allocate the total of 384 CPU cores across 2 nodes. Note that if your multi-node job requests fewer than each node's full 192 cores per node, by default Slurm provides no guarantee with respect to how this total is distributed between assigned nodes (i.e. the cores may not necessarily be split evenly). If you need specific arrangements of your tasks and cores, you can use ```--cpus-per-task=``` and/or ```--ntasks-per-node=``` flags. See [Slurm documentation :octicons-link-external-16:](https://slurm.schedmd.com/salloc.html) or ```man salloc``` for more options.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
