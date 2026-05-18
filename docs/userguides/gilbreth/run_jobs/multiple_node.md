---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Multiple Node

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you need a program or code that is specifically written to use multiple nodes, such as an MPI program.

Simply requesting more nodes will not make your work go faster. Your code must support this ability.

This example shows a request for multiple compute nodes. The job submission file contains a single command to show the names of the compute nodes allocated.

## Example Job Submission File

Create a file named `myjobsubmissionfile.sub`:

```bash
# FILENAME: myjobsubmissionfile.sub
#!/bin/bash

echo "$SLURM_JOB_NODELIST"
```

On Gilbreth, specifying the number of GPUs requested per node is required.

## Submit the Job

Submit the job with `sbatch`:

```bash
sbatch --nodes=2 --ntasks=32 --gpus-per-node=1 --mem=8G --time=00:10:00 -A accountname --partition=a10 myjobsubmissionfile.sub
```

## Example Output

The allocated compute nodes may be shown as:

```text
gilbreth-a[014-015]
```

The above example allocates a total of 32 CPU cores across 2 nodes.

If your multi-node job requests fewer than each node's full 16 cores per node, Slurm does not guarantee how this total is distributed between the assigned nodes by default. The cores may not necessarily be split evenly.

If you need specific arrangements of tasks and cores, use options such as:

```bash
--cpus-per-task=
```

and/or:

```bash
--ntasks-per-node=
```

See the Slurm documentation or `man sbatch` for more options.



[**Back to the Example Jobs section**](generic_slurm_jobs.md)
