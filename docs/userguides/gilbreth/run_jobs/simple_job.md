---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Simple Job

Every SLURM job consists of a job submission file. A job submission file contains a list of commands that run your program and a set of resource requests, such as nodes, walltime, and queue/account requests.

The resource requests can appear in the [job submission file](submit_script.md), or they can be specified at submit time.

This simple example submits the job submission file `hello.sub` to the `standby` queue on Gilbreth and requests a single node.

## Example Job Submission File

Create a file named `hello.sub`:

```bash
#!/bin/bash
# FILENAME: hello.sub

# Show this ran on a compute node by running the hostname command.
hostname

echo "Hello World"
```

On Gilbreth, specifying the number of GPUs requested per node is required.

## Submit the Job

Submit the job with `sbatch`:

```bash
sbatch -A accountname --partition=a10 --nodes=1 --ntasks=1 --cpus-per-task=1 --gpus-per-node=1 --mem=2G --time=00:01:00 hello.sub
```

Example output:

```text
Submitted batch job 3521
```

For a real job, you would replace:

```bash
echo "Hello World"
```

with a command, or sequence of commands, that runs your program.

## Check the Output File

After your job finishes running, the `ls` command will show a new `.out` file in your directory:

```bash
ls -l
```

Example output:

```text
hello.sub
slurm-3521.out
```

The file `slurm-3521.out` contains the output and errors your program would have written to the screen if you had typed its commands at a command prompt.

View the output file with:

```bash
cat slurm-3521.out
```

Example output:

```text
gilbreth-a001.rcac.purdue.edu
Hello World
```

You should see the hostname of the compute node your job was executed on, followed by the `Hello World` statement.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)