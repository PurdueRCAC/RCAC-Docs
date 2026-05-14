---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Submitting a Job

Once you have a job submission script, you may submit the script to SLURM using the sbatch command. SLURM will find, or wait for, available resources matching your request and run your job there. If you have included your sbatch options as special comments in your submission script, submitting the job is as simple as:

```bash
sbatch --nodes=1 --gpus-per-node=1 myjobsubmissionfile
```

On Gilbreth, GPU jobs must specify the number of GPUs using the `--gpus-per-node` option.

## Submitting to a Specific Queue or Account

SLURM uses the term **Account** for some queue-like resource allocations. The account can be specified with `-A`.

For example, to submit to the `standby` account:

```bash
sbatch --nodes=1 --gpus-per-node=1 -A standby myjobsubmissionfile
```

## Requesting Wall Time

By default, jobs receive 30 minutes of wall time. If your job needs more time, request it explicitly.

For example, to request 1 hour and 30 minutes:

```bash
sbatch -t 1:30:00 --nodes=1 --gpus-per-node=1 -p standby myjobsubmissionfile
```

Requesting only the time your job actually needs may help it start sooner.

## Requesting Multiple Nodes

The `--nodes` option controls how many compute nodes your job requests.

For example, to request two compute nodes:

```bash
sbatch --nodes=2 --gpus-per-node=1 myjobsubmissionfile
```

Requesting multiple nodes only helps if your application is written to use multiple nodes, such as an MPI program. Simply requesting additional nodes will not automatically make a single-node program run faster.

## Requesting Multiple Tasks

By default, Gilbreth jobs may share nodes with other jobs.

To submit a job using one node with four tasks and one GPU per node:

```bash
sbatch --nodes=1 --ntasks=4 --gpus-per-node=1 myjobsubmissionfile
```

## Putting SLURM Options in the Job Script

Instead of passing all options on the command line, you can include `#SBATCH` directives inside the job submission file.

Example job submission script:

```bash
#!/bin/sh -l
# FILENAME: myjobsubmissionfile

#SBATCH -A myqueuename
#SBATCH --nodes=1 --gpus-per-node=1
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

# Print the hostname of the compute node this job runs on.
/bin/hostname
```

!!! note
    Any sbatch options that you specify in the command-line submission will override what is specified in your job submission script.

## After Submitting

After submission, a job may wait in the queue for minutes, hours, or longer. The wait time depends on the queue, requested resources, requested wall time, and other jobs already waiting.

For best results, request only the resources and time your job actually needs.

After submitting a job, you can [monitor its status](monitoring_job.md), wait for it to finish, and then [check its output](checking_output.md).



    
[**Back to the Running Jobs section**](index.md)
