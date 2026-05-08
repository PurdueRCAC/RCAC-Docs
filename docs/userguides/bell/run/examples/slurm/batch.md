---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Simple Job

Every SLURM job consists of a job submission file. A job submission file contains a list of commands that run your program and a set of resource (nodes, walltime, queue) requests. The resource requests can appear in the [job submission file](/knowledge/${resource.hostname}/run/examples/slurm/directives) or can be specified at submit-time as shown below.

This simple example submits the job submission file `hello.sub` to the `${resource.queue}` queue on ${resource.name} and requests a single node:

```

#!/bin/bash
# FILENAME: hello.sub

# Show this ran on a compute node by running the hostname command.
hostname

echo "Hello World"
```

{::if resource.qsub\_needs\_gpu == 1}

On ${resource.name}, **specifying the number of GPUs requested per node is required.**

{::if resource.name == Gautschi}

```

sbatch -A myallocation -p queue-name --nodes=1 --ntasks=1 --cpus-per-task=1 --gpus-per-node=1 --time=00:01:00 hello.sub 
Submitted batch job 3521
```

{::else}

```

sbatch -A ${resource.queue} --nodes=1 --ntasks=1 --cpus-per-task=1 --gpus-per-node=1 --time=00:01:00 hello.sub 
Submitted batch job 3521
```

{::/}

{::else}

{::if resource.name == Gautschi}

```

sbatch -A myallocation -p queue-name --nodes=1 --ntasks=1 --cpus-per-task=1 --time=00:01:00 hello.sub 
Submitted batch job 3521
```

{::else}

```

sbatch -A ${resource.queue} --nodes=1 --ntasks=1 --cpus-per-task=1 --time=00:01:00 hello.sub 
Submitted batch job 3521
```

{::/}

{::/}

For a real job you would replace `echo "Hello World"` with a command, or sequence of commands, that run your program.

After your job finishes running, the `ls` command will show a new file in your directory, the `.out` file:

```

ls -l
hello.sub
slurm-3521.out
```

The file `slurm-3521.out` contains the output and errors your program would have written to the screen if you had typed its commands at a command prompt:

```

cat slurm-3521.out 
{::if resource.name != Weber}
{::if resource.nodashnames == true}
a001.${resource.hostname}{::else}
${resource.hostname}-a001{::/}.rcac.purdue.edu
{::else}
${resource.hostname}.rcac.purdue.edu
{::/}
Hello World
```

You should see the hostname of the compute node your job was executed on. Following should be the "Hello World" statement.