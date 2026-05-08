---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# MPI

An MPI job is a set of processes that take advantage of multiple compute nodes by communicating with each other. OpenMPI and Intel MPI (IMPI) are implementations of the MPI standard.

This section shows how to submit one of the MPI programs compiled in the section [Compiling MPI Programs](/knowledge/${resource.hostname}/compile/mpi).

Use `module load` to set up the paths to access these libraries. Use `module avail` to see all MPI packages installed on ${resource.name}.

Create a job submission file:

{::if resource.qsub\_needs\_gpu == 1}

```
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH  --nodes=2
#SBATCH  --ntasks-per-node=${resource.nodecores}
#SBATCH  --gpus-per-node=1
#SBATCH  --time=00:01:00
#SBATCH  -A ${resource.queue}

srun -n ${resource.nodecores*2} ./mpi_hello
```

{::else}

```
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH  --nodes=2
#SBATCH  --ntasks-per-node=${resource.nodecores}
#SBATCH  --time=00:01:00
#SBATCH  -A ${resource.queue}

srun -n ${resource.nodecores*2} ./mpi_hello
```

{::/}

SLURM can run an MPI program with the `srun` command. The number of processes is requested with the `-n` option. If you do not specify the `-n` option, it will default to the total number of processor cores you request from SLURM.

If the code is built with OpenMPI, it can be run with a simple `srun -n`  command. If it is built with Intel IMPI, then you also need to add the `--mpi=pmi2` option:  `srun --mpi=pmi2 -n ${resource.nodecores*2} ./mpi_hello` in this example.

Submit the MPI job:

```
sbatch ./mpi_hello.sub
```

View results in the output file:

```
cat slurm-myjobid.out
Runhost:{::if resource.nodashnames == true}a010.${resource.hostname}.rcac.purdue.edu{::else}${resource.hostname}-a010.rcac.purdue.edu{::/}   Rank:0 of ${resource.nodecores*2} ranks   hello, world
Runhost:{::if resource.nodashnames == true}a010.${resource.hostname}.rcac.purdue.edu{::else}${resource.hostname}-a010.rcac.purdue.edu{::/}   Rank:1 of ${resource.nodecores*2} ranks   hello, world
...
Runhost:{::if resource.nodashnames == true}a011.${resource.hostname}.rcac.purdue.edu{::else}${resource.hostname}-a011.rcac.purdue.edu{::/}   Rank:${resource.nodecores} of ${resource.nodecores*2} ranks   hello, world
Runhost:{::if resource.nodashnames == true}a011.${resource.hostname}.rcac.purdue.edu{::else}${resource.hostname}-a011.rcac.purdue.edu{::/}   Rank:${resource.nodecores+1} of ${resource.nodecores*2} ranks   hello, world
...
```

If the job failed to run, then view error messages in the output file.

If an MPI job uses a lot of memory and ${resource.nodecores} MPI ranks per compute node use all of the memory of the compute nodes, request more compute nodes, while keeping the total number of MPI ranks unchanged.

Submit the job with double the number of compute nodes and modify the resource request to halve the number of MPI ranks per compute node.

```
#!/bin/bash
# FILENAME:  mpi_hello.sub
{::if resource.qsub_needs_gpu == 1}
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=${resource.nodecores/2}
#SBATCH --gpus-per-node=1
#SBATCH -t 00:01:00
{::else}
#SBATCH --nodes=4                                                                                                                                        
#SBATCH --ntasks-per-node=${resource.nodecores/2}                                                                                                        
#SBATCH -t 00:01:00                                                                                                                                      
{::/}
#SBATCH -A ${resource.queue}

srun -n ${resource.nodecores*2} ./mpi_hello
```

```
sbatch ./mpi_hello.sub
```

View results in the output file:

```
cat slurm-myjobid.out
Runhost:{::if resource.nodashnames == true}a010.${resource.hostname}{::else}${resource.hostname}-a10{::/}.rcac.purdue.edu   Rank:0 of ${resource.nodecores*2} ranks   hello, world
Runhost:{::if resource.nodashnames == true}a010.${resource.hostname}{::else}${resource.hostname}-a010{::/}.rcac.purdue.edu   Rank:1 of ${resource.nodecores*2} ranks   hello, world
...
Runhost:{::if resource.nodashnames == true}a011.${resource.hostname}{::else}${resource.hostname}-a011{::/}.rcac.purdue.edu   Rank:${resource.nodecores/2} of ${resource.nodecores*2} ranks   hello, world
...
Runhost:{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu   Rank:${resource.nodecores} of ${resource.nodecores*2} ranks   hello, world
...
Runhost:{::if resource.nodashnames == true}a013.${resource.hostname}{::else}${resource.hostname}-a013{::/}.rcac.purdue.edu   Rank:${resource.nodecores*1.5} of ${resource.nodecores*2} ranks   hello, world
...
```

**Notes**

* Use `slist` to determine which queues (`--account` or `-A` option) are available to you. The name of the queue which is available to everyone on ${resource.name} is "${resource.queue}".
* Invoking an MPI program on ${resource.name} with `./program` is typically wrong, since this will use only one MPI process and defeat the purpose of using MPI. Unless that is what you want (rarely the case), you should use `srun` or `mpiexec` to invoke an MPI program.
* In general, the exact order in which MPI ranks output similar write requests to an output file is random.