# OpenMP

A shared-memory job is a single process that takes advantage of a multi-core processor and its shared memory to achieve parallelization.

This example shows how to submit an OpenMP program compiled in the section [Compiling OpenMP Programs](../../../compile/openmp.md).

!!! Note
      When running OpenMP programs, all threads must be on the same compute node to take advantage of shared memory. The threads cannot communicate between nodes.

To run an OpenMP program, set the environment variable OMP\_NUM\_THREADS to the desired number of threads:

In csh:

```
setenv OMP_NUM_THREADS 128
```

In bash:

```
export OMP_NUM_THREADS=128
```

This should almost always be equal to the number of cores on a compute node. You may want to set to another appropriate value if you are running several processes in parallel in a single job or node.

Create a job submissionfile:


```
#!/bin/bash
# FILENAME:  omp_hello.sub
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --time=00:01:00

export OMP_NUM_THREADS=128
./omp_hello 
```


Submit the job:

```
sbatch omp_hello.sub
```

View the results from one of the sample OpenMP programs about task parallelism:


```
cat omp_hello.sub.omyjobid
SERIAL REGION:     Runhost:bell-a003.rcac.purdue.edu   Thread:0 of 1 thread    hello, world
PARALLEL REGION:   Runhost:bell-a003.rcac.purdue.edu   Thread:0 of 128 threads   hello, world
PARALLEL REGION:   Runhost:bell-a003.rcac.purdue.edu   Thread:1 of 128 threads   hello, world
   ...
```


If the job failed to run, then view error messages in the file `slurm-myjobid.out`.

If an OpenMP program uses a lot of memory and 128 threads use all of the memory of the compute node, use fewer processor cores (OpenMP threads) on that compute node.
