---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Every SLURM job consists of a job submission file. A job submission file contains a list of commands that run your program and a set of resource (nodes, walltime, queue) requests. The resource requests can appear in the job submission file or can be specified at submit-time as shown below.

This simple example submits the job submission file ```hello.sub``` to the cpu queue on Gautschi and requests a single node:

```bash
#!/bin/bash
# FILENAME: hello.sub

# Show this ran on a compute node by running the hostname command.
hostname

echo "Hello World"

sbatch -A myallocation -p queue-name --nodes=1 --ntasks=1 --cpus-per-task=1 --time=00:01:00 hello.sub 
Submitted batch job 3521
```

For a real job you would replace ```echo "Hello World"``` with a command, or sequence of commands, that run your program.

After your job finishes running, the ```ls``` command will show a new file in your directory, the ```.out``` file:

```bash
ls -l
hello.sub
slurm-3521.out
```

The file ```slurm-3521.out``` contains the output and errors your program would have written to the screen if you had typed its commands at a command prompt:

```bash
cat slurm-3521.out 

gautschi-a001.rcac.purdue.edu 
Hello World
```

You should see the hostname of the compute node your job was executed on. Following should be the "Hello World" statement.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
