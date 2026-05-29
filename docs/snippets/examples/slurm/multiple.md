# Multiple Node

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

This example shows a request for multiple compute nodes. The job submission file contains a single command to show the names of the compute nodes allocated:

```

# FILENAME:  myjobsubmissionfile.sub
#!/bin/bash
echo "$SLURM_JOB_NODELIST"
```


```

sbatch --nodes=2 --ntasks=256 --time=00:10:00 -A accountname myjobsubmissionfile.sub
```


Compute nodes allocated:

```

bell-a[014-015]
```

The above example will allocate the total of 256 CPU cores across 2 nodes. Note that if your multi-node job requests fewer than each node's full 128 cores per node, by default Slurm provides no guarantee with respect to how this total is distributed between assigned nodes (i.e. the cores may not necessarily be split evenly). If you need specific arrangements of your tasks and cores, you can use `--cpus-per-task=` and/or `--ntasks-per-node=` flags. See [Slurm documentation](https://slurm.schedmd.com/sbatch.html) or `man sbatch` for more options.
