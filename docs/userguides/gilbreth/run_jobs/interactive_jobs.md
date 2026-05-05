---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Interactive Jobs

Interactive jobs are run on compute nodes, while giving you a shell to interact with. They give you the ability to type commands or use a graphical interface in the same way as if you were on a front-end login host.

To submit an interactive job, use `sinteractive` to run a login shell on allocated resources.

`sinteractive` accepts most of the same resource requests as `sbatch`, so to request a login shell on the `${resource.queue}` account while allocating 2 nodes and ${resource.nodecores} total cores, you might do:

{::if resource.name == Gautschi} {::if resource.qsub\_needs\_gpu == 1}

```

sinteractive -A myallocation -p ${resource.gpuqueue} -N2 -n${resource.nodecores*2} --gpus-per-node=1
```

{::else}

```

sinteractive -A myallocation -p ${resource.queue} -N2 -n${resource.nodecores*2}
```

{::/} {::else} {::if resource.qsub\_needs\_gpu == 1}

```

sinteractive -A ${resource.queue} -N2 -n${resource.nodecores*2} --gpus-per-node=1
```

{::else}

```

sinteractive -A ${resource.queue} -N2 -n${resource.nodecores*2}
```

{::/} {::/}

To quit your interactive job:

`exit` or `Ctrl-D`

The above example will allocate the total of ${resource.nodecores\*2} CPU cores across 2 nodes. Note that if your multi-node job requests fewer than each node's full ${resource.nodecores} cores per node, by default Slurm provides no guarantee with respect to how this total is distributed between assigned nodes (i.e. the cores may not necessarily be split evenly). If you need specific arrangements of your tasks and cores, you can use `--cpus-per-task=` and/or `--ntasks-per-node=` flags. See [Slurm documentation](https://slurm.schedmd.com/salloc.html) or `man salloc` for more options.