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

# Interactive Jobs on Gilbreth

Interactive jobs are run on compute nodes, while giving you a shell to interact with. They give you the ability to type commands or use a graphical interface in the same way as if you were on a front-end login host.

To submit an interactive job, use `sinteractive` to run a login shell on allocated resources.

`sinteractive` accepts most of the same resource requests as `sbatch`, so to request a login shell on the cpu account while allocating 2 nodes and 16 total cores, you might do:

```bash
sinteractive -A accountname --partition=a10 -N2 -n32 --gpus-per-node=1 --mem=6G
```

To quit your interactive job:

`exit` or `Ctrl-D`

The above example will allocate the total of 32 CPU cores across 2 nodes. Note that if your multi-node job requests fewer than each node's full 16 cores per node, by default Slurm provides no guarantee with respect to how this total is distributed between assigned nodes (i.e. the cores may not necessarily be split evenly). If you need specific arrangements of your tasks and cores, you can use `--cpus-per-task=` and/or `--ntasks-per-node=` flags. See Slurm documentation or `man salloc` for more options.


[**Back to the Example Jobs section**](generic_slurm_jobs.md)
