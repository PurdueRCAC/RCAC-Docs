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

# MPI

An MPI job is a set of processes that take advantage of multiple compute nodes by communicating with each other. OpenMPI and Intel MPI (IMPI) are implementations of the MPI standard.

This section shows how to submit one of the MPI programs compiled in the section [Compiling MPI Programs](../compile/compile_mpi.md).

Use `module load` to set up the paths to access these libraries. Use `module avail` to see all MPI packages installed on Gilbreth.

## Example MPI Job Submission File

Create a job submission file named `mpi_hello.sub`:

```bash
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH  --nodes=2
#SBATCH  --ntasks-per-node=16
#SBATCH  --gpus-per-node=1
#SBATCH  --time=00:01:00
#SBATCH  -A standby

srun -n 32 ./mpi_hello
```

SLURM can run an MPI program with the `srun` command. The number of processes is requested with the `-n` option.

If you do not specify the `-n` option, it will default to the total number of processor cores you request from SLURM.

If the code is built with OpenMPI, it can be run with a simple `srun -n` command.

If it is built with Intel IMPI, then you also need to add the `--mpi=pmi2` option:

```bash
srun --mpi=pmi2 -n 32 ./mpi_hello
```

## Submit the MPI Job

Submit the MPI job:

```bash
sbatch ./mpi_hello.sub
```

## View Results

View results in the output file:

```bash
cat slurm-myjobid.out
```

Example output:

```text
Runhost:gilbreth-a010.rcac.purdue.edu   Rank:0 of 32 ranks   hello, world
Runhost:gilbreth-a010.rcac.purdue.edu   Rank:1 of 32 ranks   hello, world
...
Runhost:gilbreth-a011.rcac.purdue.edu   Rank:16 of 32 ranks   hello, world
Runhost:gilbreth-a011.rcac.purdue.edu   Rank:17 of 32 ranks   hello, world
...
```

If the job failed to run, view error messages in the output file.

## Reducing MPI Ranks Per Node for Memory-Heavy Jobs

If an MPI job uses a lot of memory and 16 MPI ranks per compute node use all of the memory of the compute nodes, request more compute nodes while keeping the total number of MPI ranks unchanged.

Submit the job with double the number of compute nodes and modify the resource request to halve the number of MPI ranks per compute node.

Create or modify `mpi_hello.sub`:

```bash
#!/bin/bash
# FILENAME:  mpi_hello.sub
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=1
#SBATCH -t 00:01:00
#SBATCH -A standby

srun -n 32 ./mpi_hello
```

Submit the job:

```bash
sbatch ./mpi_hello.sub
```

View results in the output file:

```bash
cat slurm-myjobid.out
```

Example output:

```text
Runhost:gilbreth-a10.rcac.purdue.edu   Rank:0 of 32 ranks   hello, world
Runhost:gilbreth-a010.rcac.purdue.edu   Rank:1 of 32 ranks   hello, world
...
Runhost:gilbreth-a011.rcac.purdue.edu   Rank:8 of 32 ranks   hello, world
...
Runhost:gilbreth-a012.rcac.purdue.edu   Rank:16 of 32 ranks   hello, world
...
Runhost:gilbreth-a013.rcac.purdue.edu   Rank:24 of 32 ranks   hello, world
...
```

## Notes

- Use `slist` to determine which queues, specified by the `--account` or `-A` option, are available to you.
- The queue available to everyone on Gilbreth is `standby`.
- Invoking an MPI program on Gilbreth with `./program` is typically wrong, since this will use only one MPI process and defeat the purpose of using MPI.
- Unless using only one MPI process is what you want, which is rarely the case, use `srun` or `mpiexec` to invoke an MPI program.
- In general, the exact order in which MPI ranks write similar output to an output file is random.


[**Back to the Running Jobs section**](index.md)