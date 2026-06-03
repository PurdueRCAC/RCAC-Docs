---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Submitting a Job

Once you have a [job submission file](creating_the_submission_script.md), you may submit this script to SLURM using the `sbatch` command. SLURM will find, or wait for, available resources matching your request and run your job there.


​On Bell, in order to submit jobs, you need to specify the partition, account and Quality of Service (QoS) name to which you want to submit your jobs. To familiarize yourself with the partitions and QoS available on Bell, visit [Bell Queues and Partitions](queues.md). To check the available partitions on Bell, you can use the `showpartitions` , and to check your available accounts you can use `slist` commands. Slurm uses the term "Account" with the option `-A` or `--account=` to specify different batch accounts, the option `-p` or `--partition=` to select a specific partition for job submission, and the option `-q` or `--qos=` .

```
Partition statistics for cluster bell at Wed Jul 30 13:07:27 EDT 2025
      Partition     #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
      Name State Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
bell-nodes   up$   488   476  62464  61376      0      0     1 infin   infinite   128     257+
       cpu    up   480   476  61440  60928      0      0     1 infin   infinite   128     257
   highmem   up$     8     0   1024    448      0      0     1 infin   infinite   128    1031
       gpu   up$     4     0    512    512      0      0     1 infin   infinite   128     257
  multigpu   up$     1     0     48     48      0      0     1 infin   infinite    48     353
```

## CPU Partition

The CPU partition on Bell has two Quality of Service (QoS) levels: **normal** and **standby**. To submit your job to one compute node on `cpu` partition and 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=normal myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q normal myjobsubmissionfile
```

 To submit your job to one compute node on `cpu` partition and 'standby' QoS which is has "low priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=standby myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q standby myjobsubmissionfile
```

## GPU Partition

On the GPU partition on **Bell** you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. To submit your job to one compute node requesting one GPU on the `gpu` partition under the 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --gpus-per-node=1 --ntasks=1 --cpus-per-task=64 --partition=gpu --account=accountname myjobsubmissionfile
$ sbatch -N1 --gpus-per-node=1 -n1 -c64 -p gpu -A accountname -q normal myjobsubmissionfile
```

## Highmem Partition

To submit your job to a compute node in the highmem partition, you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. However, the **highmem** partition is *only* suitable for jobs with memory requirements that exceed the capacity of a standard node, so the number of requested tasks should be appropriately high.

```
$ sbatch --nodes=1 --ntasks=1 --cpus-per-task=64 --partition=highmem --account=accountname myjobsubmissionfile
$ sbatch -N1 -n1 -c64 -p highmem -A accountname myjobsubmissionfile
```

## General Information

By default, each job receives 30 minutes of *wall time*, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request 1 hour and 30 minutes of wall time:

```
$ sbatch -t 01:30:00 -N=1 -n=1 -p=cpu -A=accountname -q=standby myjobsubmissionfile
```

The `--nodes=` or `-N` value indicates how many compute nodes you would like for your job, and `--ntasks=` or `-n` value indicates the number of tasks you want to run.

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

To request 2 compute nodes:

```
$ sbatch -t 01:30:00 -N=2 -n=16 -p=cpu -A=accountname -q=standby myjobsubmissionfile
```

By default, jobs on Bell will share nodes with other jobs.

If more convenient, you may also specify any command line options to `sbatch` from within your job submission file, using a special form of comment:

```
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH --account=accountname
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

# Print the hostname of the compute node on which this job is running.
/bin/hostname
```

If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with `SBATCH`, it may wait in queue for minutes, hours, or even weeks. How long it takes for a job to start depends on the specific queue, the resources and time requested, and other jobs already waiting in that queue requested as well. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

Once your job is submitted, you can [monitor the job status](monitoring_job.md), wait for the job to complete, and [check the job output](checking_output.md).

[**Back to the Running Jobs section**](../index.md)

​
