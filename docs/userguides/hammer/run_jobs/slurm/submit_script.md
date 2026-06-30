---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Submitting a Job

Once you have a [job submission file](creating_the_submission_script.md), you may submit this script to SLURM using the `sbatch` command. SLURM will find, or wait for, available resources matching your request and run your job there.

On Hammer, you specify the queue (account) using the `-A` option. To check the queues available to you, use the `slist` command. For a description of Hammer's queues, visit [Hammer Queues](queues.md).

!!! note
    Each Hammer compute node has 20 processor cores. SLURM jobs on Hammer receive exclusive access to compute nodes by default.

To submit a job to one compute node:

```
$ sbatch --nodes=1 myjobsubmissionfile
```

To submit a job to the standby queue:

```
$ sbatch --nodes=1 -A standby myjobsubmissionfile
```

## General Information

By default, each job receives 30 minutes of *wall time*, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request 1 hour and 30 minutes of wall time:

```
$ sbatch -t 1:30:00 --nodes=1 -A standby myjobsubmissionfile
```

The `--nodes=` or `-N` value indicates how many compute nodes you would like for your job, and `--ntasks=` or `-n` value indicates the number of tasks you want to run.

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

To request 2 compute nodes:

```
$ sbatch --nodes=2 myjobsubmissionfile
```

To request GPU resources:

```
$ sbatch --nodes=1 --ntasks=4 --gpus-per-node=1 myjobsubmissionfile
```

If more convenient, you may also specify any command line options to `sbatch` from within your job submission file, using a special form of comment:

```
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH -A myqueuename
#SBATCH --nodes=1
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

/bin/hostname
```

If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with `sbatch`, it may wait in queue for minutes, hours, or even longer depending on the queue and current load. How long it takes for a job to start depends on the specific queue, the resources and time requested, and other jobs already waiting. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

Once your job is submitted, you can [monitor the job status](monitoring_job.md), wait for the job to complete, and [check the job output](checking_output.md).

[**Back to the Running Jobs section**](../index.md)
