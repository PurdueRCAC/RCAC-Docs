---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# OpenMP

A shared-memory job is a single process that takes advantage of a multi-core processor and its shared memory to achieve parallelization.

This example shows how to submit an OpenMP program compiled in the section [Compiling OpenMP Programs](../compile/compile_openmp.md).

!!! note 
    When running OpenMP programs, all threads must be on the same compute node to take advantage of shared memory. The threads cannot communicate between nodes.

## Set `OMP_NUM_THREADS`

To run an OpenMP program, set the environment variable `OMP_NUM_THREADS` to the desired number of threads.

In `csh`:

```csh
setenv OMP_NUM_THREADS 128
```

In `bash`:

```bash
export OMP_NUM_THREADS=128
```

This should almost always be equal to the number of cores on a compute node. You may want to set it to another appropriate value if you are running several processes in parallel in a single job or node.

## Example Job Submission File

Create a job submission file named `omp_hello.sub`:

```bash
#!/bin/bash
# FILENAME:  omp_hello.sub
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --time=00:01:00

export OMP_NUM_THREADS=128
./omp_hello 
```

## Submit the Job

Submit the job:

```bash
sbatch omp_hello.sub
```

## View Results

View the results from one of the sample OpenMP programs about task parallelism:

```bash
cat omp_hello.sub.omyjobid
```

Example output:

```text
SERIAL REGION:     Runhost:negishi.a003.rcac.purdue.edu   Thread:0 of 1 thread    hello, world
PARALLEL REGION:   Runhost:negishi.a003.rcac.purdue.edu   Thread:0 of 128 threads   hello, world
PARALLEL REGION:   Runhost:negishi.a003.rcac.purdue.edu   Thread:1 of 128 threads   hello, world
   ...
```

If the job failed to run, view error messages in the file `slurm-myjobid.out`.

If an OpenMP program uses a lot of memory and 128 threads use all of the memory of the compute node, use fewer processor cores, or OpenMP threads, on that compute node.

[**Back to the Running Jobs section**](index.md)