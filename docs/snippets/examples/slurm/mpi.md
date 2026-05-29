# MPI

An MPI job is a set of processes that take advantage of multiple compute nodes by communicating with each other. OpenMPI and Intel MPI (IMPI) are implementations of the MPI standard.

This section shows how to submit one of the MPI programs compiled in the section [Compiling MPI Programs](../../../compile/mpi.md).

Use `module load` to set up the paths to access these libraries. Use `module avail` to see all MPI packages installed on Bell.

Create a job submission file:


```
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH  --nodes=2
#SBATCH  --ntasks-per-node=128
#SBATCH  --time=00:01:00
#SBATCH  -A accountname

srun -n 256 ./mpi_hello
```


SLURM can run an MPI program with the `srun` command. The number of processes is requested with the `-n` option. If you do not specify the `-n` option, it will default to the total number of processor cores you request from SLURM.

If the code is built with OpenMPI, it can be run with a simple `srun -n`  command. If it is built with Intel IMPI, then you also need to add the `--mpi=pmi2` option:  `srun --mpi=pmi2 -n 256 ./mpi_hello` in this example.

Submit the MPI job:

```
sbatch ./mpi_hello.sub
```

View results in the output file:

```
cat slurm-myjobid.out
Runhost:bell-a010.rcac.purdue.edu   Rank:0 of 256 ranks   hello, world
Runhost:bell-a010.rcac.purdue.edu   Rank:1 of 256 ranks   hello, world
...
Runhost:bell-a011.rcac.purdue.edu   Rank:128 of 256 ranks   hello, world
Runhost:bell-a011.rcac.purdue.edu   Rank:129 of 256 ranks   hello, world
...
```

If the job failed to run, then view error messages in the output file.

If an MPI job uses a lot of memory and 128 MPI ranks per compute node use all of the memory of the compute nodes, request more compute nodes, while keeping the total number of MPI ranks unchanged.

Submit the job with double the number of compute nodes and modify the resource request to halve the number of MPI ranks per compute node.

```
#!/bin/bash
# FILENAME:  mpi_hello.sub

#SBATCH --nodes=4                                                                                                                                        
#SBATCH --ntasks-per-node=64                                                                                                        
#SBATCH -t 00:01:00                                                                                                                                      

#SBATCH -A accountname

srun -n 256 ./mpi_hello
```

```
sbatch ./mpi_hello.sub
```

View results in the output file:

```
cat slurm-myjobid.out
Runhost:bell-a10.rcac.purdue.edu   Rank:0 of 256 ranks   hello, world
Runhost:bell-a010.rcac.purdue.edu   Rank:1 of 256 ranks   hello, world
...
Runhost:bell-a011.rcac.purdue.edu   Rank:64 of 256 ranks   hello, world
...
Runhost:bell-a012.rcac.purdue.edu   Rank:128 of 256 ranks   hello, world
...
Runhost:bell-a013.rcac.purdue.edu   Rank:192 of 256 ranks   hello, world
...
```

**Notes**

* Use `slist` to determine which queues (`--account` or `-A` option) are available to you. The name of the queue you should use depends on the Bell allocation you are charging.
* Invoking an MPI program on Bell with `./program` is typically wrong, since this will use only one MPI process and defeat the purpose of using MPI. Unless that is what you want (rarely the case), you should use `srun` or `mpiexec` to invoke an MPI program.
* In general, the exact order in which MPI ranks output similar write requests to an output file is random.
