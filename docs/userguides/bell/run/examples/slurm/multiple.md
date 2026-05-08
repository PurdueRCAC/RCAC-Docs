---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Multiple Node

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

This example shows a request for multiple compute nodes. The job submission file contains a single command to show the names of the compute nodes allocated:

```

# FILENAME:  myjobsubmissionfile.sub
#!/bin/bash
echo "$SLURM_JOB_NODELIST"
```

{::if resource.name == Gautschi}

{::if resource.qsub\_needs\_gpu == 1}

On ${resource.name}, **specifying the number of GPUs requested per node is required.**

```

sbatch --nodes=2 --ntasks=${resource.nodecores*2} --gpus-per-node=1 --time=00:10:00 -A myallocation -p queue-name myjobsubmissionfile.sub
```

{::else}

```

sbatch --nodes=2 --ntasks=${resource.nodecores*2} --time=00:10:00 -A myallocation -p queue-name myjobsubmissionfile.sub
```

{::/}

{::else}

{::if resource.qsub\_needs\_gpu == 1}

On ${resource.name}, **specifying the number of GPUs requested per node is required.**

```

sbatch --nodes=2 --ntasks=${resource.nodecores*2} --gpus-per-node=1 --time=00:10:00 -A ${resource.queue} myjobsubmissionfile.sub
```

{::else}

```

sbatch --nodes=2 --ntasks=${resource.nodecores*2} --time=00:10:00 -A ${resource.queue} myjobsubmissionfile.sub
```

{::/}

{::/}

Compute nodes allocated:

```

{::if resource.nodashnames == true}a[014-015].${resource.hostname}{::else}${resource.hostname}-a[014-015]{::/}
```

The above example will allocate the total of ${resource.nodecores\*2} CPU cores across 2 nodes. Note that if your multi-node job requests fewer than each node's full ${resource.nodecores} cores per node, by default Slurm provides no guarantee with respect to how this total is distributed between assigned nodes (i.e. the cores may not necessarily be split evenly). If you need specific arrangements of your tasks and cores, you can use `--cpus-per-task=` and/or `--ntasks-per-node=` flags. See [Slurm documentation](https://slurm.schedmd.com/sbatch.html) or `man sbatch` for more options.