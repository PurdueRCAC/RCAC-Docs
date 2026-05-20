---
tags:
  - Scholar
authors:
  - jin456
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Submitting the script as a job

Once you have a [job submission file](creating_the_submission_script.md), you may submit this script to SLURM using the ```sbatch``` command. SLURM will find, or wait for, available resources matching your request and run your job there.

To submit your job to one compute node:

```bash
$ sbatch --nodes=1 myjobsubmissionfile 
```

Slurm uses the word 'Account' and the option '-A' to specify different batch queues. To submit your job to a specific queue:

```bash
$ sbatch --nodes=1 -A scholar myjobsubmissionfile 
```

By default, each job receives 30 minutes of wall time, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request the 1 hour and 30 minutes of wall time:

```bash
$ sbatch -t 1:30:00 --nodes=1 -A scholar myjobsubmissionfile 
```

The ```--nodes``` value indicates how many compute nodes you would like for your job.

Each compute node in Scholar has 20 processor cores.

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

To request 2 compute nodes:

```bash
$ sbatch --nodes=2 myjobsubmissionfile 
```

By default, jobs on Scholar will share nodes with other jobs.

To submit a job using 1 compute node with 4 tasks, each using the default 1 core and 1 GPU per node:

```bash
$ sbatch --nodes=1 --ntasks=4 --gpus-per-node=1 myjobsubmissionfile
```

If more convenient, you may also specify any command line options to ```sbatch``` from within your job submission file, using a special form of comment:

```bash
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH -A myqueuename
#SBATCH --nodes=1 
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

# Print the hostname of the compute node on which this job is running.
/bin/hostname
```

If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with ```SBATCH```, it may wait in queue for minutes, hours, or even weeks. How long it takes for a job to start depends on the specific queue, the resources and time requested, and other jobs already waiting in that queue requested as well. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

[**Back to the Running Jobs section**](index.md)
