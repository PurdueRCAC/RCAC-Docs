---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: Scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# MPI Jobs

An MPI job is a set of processes that take advantage of multiple compute nodes by communicating with each other. OpenMPI and Intel MPI (IMPI) are implementations of the MPI standard.

This section shows how to submit one of the MPI programs compiled in the section [Compiling MPI Programs](../compile/compile_mpi.md).

Use ```module load``` to set up the paths to access these libraries. Use ```module avail``` to see all MPI packages installed on Scholar.

Create a job submission file:

```bash
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH  --nodes=2
#SBATCH  --ntasks-per-node=20
#SBATCH  --time=00:01:00
#SBATCH  -A scholar

srun -n 40 ./mpi_hello
```

SLURM can run an MPI program with the ```srun``` command. The number of processes is requested with the -n option. If you do not specify the ```-n``` option, it will default to the total number of processor cores you request from SLURM.

If the code is built with OpenMPI, it can be run with a simple ```srun -n``` command. If it is built with Intel IMPI, then you also need to add the ```--mpi=pmi2``` option: ```srun --mpi=pmi2 -n 40 ./mpi_hello``` in this example.

Submit the MPI job:

```bash
sbatch ./mpi_hello.sub
```

View results in the output file:

```bash
cat slurm-myjobid.out
Runhost:scholar-a010.rcac.purdue.edu   Rank:0 of 40 ranks   hello, world
Runhost:scholar-a010.rcac.purdue.edu   Rank:1 of 40 ranks   hello, world
...
Runhost:scholar-a011.rcac.purdue.edu   Rank:20 of 40 ranks   hello, world
Runhost:scholar-a011.rcac.purdue.edu   Rank:21 of 40 ranks   hello, world
...
```

If the job failed to run, then view error messages in the output file.

If an MPI job uses a lot of memory and 20 MPI ranks per compute node use all of the memory of the compute nodes, request more compute nodes, while keeping the total number of MPI ranks unchanged.

Submit the job with double the number of compute nodes and modify the resource request to halve the number of MPI ranks per compute node.

```bash
#!/bin/bash
# FILENAME:  mpi_hello.sub

#SBATCH --nodes=4                                                                                                                                        
#SBATCH --ntasks-per-node=10                                                                                                        
#SBATCH -t 00:01:00 
#SBATCH -A scholar

srun -n 40 ./mpi_hello

sbatch ./mpi_hello.sub
```

View results in the output file:

```bash
cat slurm-myjobid.out
Runhost:scholar-a10.rcac.purdue.edu   Rank:0 of 40 ranks   hello, world
Runhost:scholar-a010.rcac.purdue.edu   Rank:1 of 40 ranks   hello, world
...
Runhost:scholar-a011.rcac.purdue.edu   Rank:10 of 40 ranks   hello, world
...
Runhost:scholar-a012.rcac.purdue.edu   Rank:20 of 40 ranks   hello, world
...
Runhost:scholar-a013.rcac.purdue.edu   Rank:30 of 40 ranks   hello, world
...
```

!!!note
    - Use ```slist``` to determine which queues (```--account``` or ```-A``` option) are available to you. The name of the queue which is available to everyone on Scholar is "scholar".
    - Invoking an MPI program on Scholar with ```./program``` is typically wrong, since this will use only one MPI process and defeat the purpose of using MPI. Unless that is what you want (rarely the case), you should use ```srun``` or ```mpiexec``` to invoke an MPI program.
    - In general, the exact order in which MPI ranks output similar write requests to an output file is random.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
