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

Once you have a [job submission file](/knowledge/${resource.dir}/run/slurm/script), you may submit this script to SLURM using the `sbatch` command. SLURM will find, or wait for, available resources matching your request and run your job there.

{::if resource.name == Gautschi}

On Gautschi, in order to submit jobs, you need to specify the partition, account and Quality of Service (QoS) name to which you want to submit your jobs. To familiarize yourself with the partitions and QoS available on Gautschi, visit [Gautschi Queues and Partitons](https://www.rcac.purdue.edu/knowledge/gautschi/run/slurm/queues). To check the available partitions on Gautschi, you can use the `showpartitions` , and to check your available accounts you can use `slist` commands. Slurm uses the term "Account" with the option `-A` or `--account=` to specify different batch accounts, the option `-p` or `--partition=` to select a specific partition for job submission, and the option `-q` or `--qos=` .

```
showpartitions

Partition statistics for cluster gautschi at Fri Dec  6 05:26:30 PM EST 2024
     Partition     #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
     Name State Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
       ai    up    20    20   2240   2240      0      0     1 infin   infinite   112    1031 
      cpu    up   336   300  64512  57600      0      0     1 infin   infinite   192     386 
  highmem    up     6     6   1152   1152      0      0     1 infin   infinite   192    1547   
 smallgpu    up     6     6    768    768      0      0     1 infin   infinite   128     386 
profiling    up     2     2    384    384      0      0     1 infin   infinite   192     386
```

##### CPU Partition

The CPU partition on **Gautschi** has two Quality of Service (QoS) levels: **normal** and **standby**. To submit your job to one compute node on `cpu` partition and 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=normal myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q normal myjobsubmissionfile
```

 To submit your job to one compute node on `cpu` partition and 'standby' QoS which is has "low priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=standby myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q standby myjobsubmissionfile
```

##### AI Partition

The CPU partition on **Gautschi** has two Quality of Service (QoS) levels: **normal** and **preemptible**. To submit your job to one compute node requesting one GPU on `ai` partition and 'normal' QoS which is has "high priority":

```
$ sbatch --nodes=1 --gpus-per-node=1 --ntasks=14 --partition=ai --account=accountname --qos=normal myjobsubmissionfile
$ sbatch -N1 --gpus-per-node=1 -n14 -p ai -A accountname -q normal myjobsubmissionfile
```

 To submit your job to one compute node requesting one GPU on `ai` partition and 'preemptible' QoS which  has "high priority":

```
$ sbatch --nodes=1 --gpus-per-node=1 --ntasks=14 --partition=ai --account=accountname --qos=preemptible myjobsubmissionfile
$ sbatch -N1 --gpus-per-node=1 -n14 -p ai -A accountname -q preemptible myjobsubmissionfile
```

##### Highmem Partition

To submit your job to a compute node on the highmem partition, you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. However, the **highmem** partition is suitable for jobs with memory requirements that exceed the capacity of a standard node, so the number of requested tasks should be appropriately high.

##### Profiling Partition

To submit your job to a compute node on the profiling partition, you also don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**.

```
$ sbatch --nodes=1 --ntasks=1 --partition=profiling --account=accountname myjobsubmissionfile
$ sbatch -N1 -n1 -p profiling -A accountname myjobsubmissionfile
```

##### Smallgpu Partition

To submit your job to a compute node on the smallgpu partition, you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node).

```
$ sbatch --nodes=1 --ntasks=64 --gpus-per-node=1 --partition=smallgpu --account=accountname myjobsubmissionfile
$ sbatch -N1 -n64 --gpus-per-node=1 -p smallgpu -A accountname myjobsubmissionfile
```

##### General Information

By default, each job receives 30 minutes of *wall time*, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request the 1 hour and 30 minutes of wall time:

```
$ sbatch -t 01:30:00 -N=1 -n=1 -p=cpu -A=accountname -q=standby myjobsubmissionfile
```

The `--nodes=` or `-N` value indicates how many compute nodes you would like for your job, and `--ntasks=` or `-n` value indicates the number of tasks you want to run.

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

To request 2 compute nodes:

```
$ sbatch -t 01:30:00 -N=2 -n=16 -p=cpu -A=accountname -q=standby myjobsubmissionfile
```

By default, jobs on Gilbreth will share nodes with other jobs.

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

Once your job is submitted, you can [monitor the job status](/knowledge/${resource.dir}/run/slurm/status), wait for the job to complete, and [check the job output](/knowledge/${resource.dir}/run/slurm/output).

{::elseif resource.name == Negishi}

​On Gilbreth, in order to submit jobs, you need to specify the partition, account and Quality of Service (QoS) name to which you want to submit your jobs. To familiarize yourself with the partitions and QoS available on Gilbreth, visit [Negishi Queues and Partitions](https://www.rcac.purdue.edu/knowledge/negishi/run/slurm/queues). To check the available partitions on Gilbreth, you can use the `showpartitions` , and to check your available accounts you can use `slist` commands. Slurm uses the term "Account" with the option `-A` or `--account=` to specify different batch accounts, the option `-p` or `--partition=` to select a specific partition for job submission, and the option `-q` or `--qos=` .

```
Partition statistics for cluster negishi at Wed Jul 30 13:07:17 EDT 2025
             Partition     #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
             Name State Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
    negishi-nodes   up$     6     0    768    768      0      0     1 infin   infinite   128     257
              cpu   up$   446     0  57088  57067      0    163     1 infin   infinite   128     257
          highmem   up$     6     0    768    768      0      0     1 infin   infinite   128    1031
              cms   up$    16     0   4096   3840      0   9036     1 infin   infinite   256     515
              gpu    up     5     0    160      0      0     30     1 infin   infinite    32     515
    negishi-login   up$     8     0   2048   2048      0      0     1 infin   infinite   256     515
negishi-profiling    up     4     3    512    512      0      0     1 infin   infinite   128     257
```

##### CPU Partition

The CPU partition on Gilbreth has two Quality of Service (QoS) levels: **normal** and **standby**. To submit your job to one compute node on `cpu` partition and 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=normal myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q normal myjobsubmissionfile
```

 To submit your job to one compute node on `cpu` partition and 'standby' QoS which is has "low priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=standby myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q standby myjobsubmissionfile
```

##### GPU Partition

On the GPU partition on **Gilbreth** you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. To submit your job to one compute node requesting one GPU on the `gpu` partition under the 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --gpus-per-node=1 --ntasks=1 --cpus-per-task=64 --partition=gpu --account=accountname myjobsubmissionfile
$ sbatch -N1 --gpus-per-node=1 -n1 -c64 -p gpu -A accountname -q normal myjobsubmissionfile
```

##### Highmem Partition

To submit your job to a compute node in the highmem partition, you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. However, the **highmem** partition is *only* suitable for jobs with memory requirements that exceed the capacity of a standard node, so the number of requested tasks should be appropriately high.

```
$ sbatch --nodes=1 --ntasks=1 --cpus-per-task=64 --partition=highmem --account=accountname myjobsubmissionfile
$ sbatch -N1  -n1 -c64 -p gpu -A accountname myjobsubmissionfile
```

##### Login Partition

The login partition is reserved for Negishi users who have purchased "interactive" access to Negishi. As an access control, in order to submit to this partition, you must supply the **interactive**QoS as a job option as this is the only QoS accepted by the partition. This partition is meant to give near-immediate start times to computationally modest jobs.

```
$ sbatch --nodes=1 --ntasks=1 --cpus-per-task=4 --partition=login --qos=interactive --account=accountname myjobsubmissionfile
$ sbatch -N1  -n1 -c4 -p gpu -q interactive -A accountname myjobsubmissionfile
```

##### General Information

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

By default, jobs on Gilbreth will share nodes with other jobs.

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

Once your job is submitted, you can [monitor the job status](/knowledge/${resource.dir}/run/slurm/status), wait for the job to complete, and [check the job output](/knowledge/${resource.dir}/run/slurm/output).

​

{::elseif resource.name == Bell}

​On Gilbreth, in order to submit jobs, you need to specify the partition, account and Quality of Service (QoS) name to which you want to submit your jobs. To familiarize yourself with the partitions and QoS available on Gilbreth, visit [Bell Queues and Partitions](https://www.rcac.purdue.edu/knowledge/bell/run/slurm/queues). To check the available partitions on Gilbreth, you can use the `showpartitions` , and to check your available accounts you can use `slist` commands. Slurm uses the term "Account" with the option `-A` or `--account=` to specify different batch accounts, the option `-p` or `--partition=` to select a specific partition for job submission, and the option `-q` or `--qos=` .

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

##### CPU Partition

The CPU partition on Gilbreth has two Quality of Service (QoS) levels: **normal** and **standby**. To submit your job to one compute node on `cpu` partition and 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=normal myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q normal myjobsubmissionfile
```

 To submit your job to one compute node on `cpu` partition and 'standby' QoS which is has "low priority":

```
$ sbatch --nodes=1 --ntasks=1 --partition=cpu --account=accountname --qos=standby myjobsubmissionfile
$ sbatch -N1 -n1 -p cpu -A accountname -q standby myjobsubmissionfile
```

##### GPU Partition

On the GPU partition on **Gilbreth** you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. To submit your job to one compute node requesting one GPU on the `gpu` partition under the 'normal' QoS which has "high priority":

```
$ sbatch --nodes=1 --gpus-per-node=1 --ntasks=1 --cpus-per-task=64 --partition=gpu --account=accountname myjobsubmissionfile
$ sbatch -N1 --gpus-per-node=1 -n1 -c64 -p gpu -A accountname -q normal myjobsubmissionfile
```

##### Highmem Partition

To submit your job to a compute node in the highmem partition, you don’t need to specify the QoS name because only one QoS exists for this partition, and the default is **normal**. However, the **highmem** partition is *only* suitable for jobs with memory requirements that exceed the capacity of a standard node, so the number of requested tasks should be appropriately high.

```
$ sbatch --nodes=1 --ntasks=1 --cpus-per-task=64 --partition=highmem --account=accountname myjobsubmissionfile
$ sbatch -N1  -n1 -c64 -p gpu -A accountname myjobsubmissionfile
```

##### General Information

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

By default, jobs on Gilbreth will share nodes with other jobs.

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

Once your job is submitted, you can [monitor the job status](/knowledge/${resource.dir}/run/slurm/status), wait for the job to complete, and [check the job output](/knowledge/${resource.dir}/run/slurm/output).

​

{::else}

To submit your job to one compute node:

```
{::if resource.qsub_needs_gpu == 1}$ sbatch --nodes=1 --gpus-per-node=1 myjobsubmissionfile {::else} $ sbatch --nodes=1 myjobsubmissionfile {::/}
```

Slurm uses the word 'Account' and the option '-A' to specify different batch queues. To submit your job to a specific queue:

```
{::if resource.qsub_needs_gpu == 1}$ sbatch --nodes=1 --gpus-per-node=1 -A ${resource.queue} myjobsubmissionfile {::else} $ sbatch --nodes=1 -A ${resource.queue} myjobsubmissionfile {::/}
```

{::if resource.qsub\_needs\_gpu == 1}

On Gilbreth, you must specify the number of GPUs with the `--gpus-per-node` option.

{::/}

By default, each job receives 30 minutes of *wall time*, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request the 1 hour and 30 minutes of wall time:

```
{::if resource.qsub_needs_gpu == 1} $ sbatch -t 1:30:00 --nodes=1 --gpus-per-node=1 -p ${resource.queue} myjobsubmissionfile {::else} $ sbatch -t 1:30:00 --nodes=1 -A ${resource.queue} myjobsubmissionfile {::/}
```

The `--nodes` value indicates how many compute nodes you would like for your job.

{::if resource.name == Gilbreth}Each compute node in Gilbreth has various cores per node. Refer to the [Hardware Overview](/knowledge/${resource.dir}/overview) and [Queue Overview](/knowledge/${resource.dir}/run/slurm/queues) for details.{::else}Each compute node in Gilbreth has ${resource.nodecores} processor cores.{::/}

In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must support this ability.

To request 2 compute nodes:

```
{::if resource.qsub_needs_gpu == 1} $ sbatch --nodes=2 --gpus-per-node=1 myjobsubmissionfile {::else} $ sbatch --nodes=2 myjobsubmissionfile {::/}
```

{::if resource.naccesspolicy == singlejob}

SLURM jobs will have exclusive access to compute nodes and other jobs will not use the same nodes. SLURM will allow a single job to run multiple `tasks`, and those tasks can be allocated resources with the `--ntasks` option.

{::else}

By default, jobs on Gilbreth will share nodes with other jobs.

{::/}

To submit a job using 1 compute node with 4 tasks, each using the default 1 core and 1 GPU per node:

```
$ sbatch --nodes=1 --ntasks=4 --gpus-per-node=1 myjobsubmissionfile
```

If more convenient, you may also specify any command line options to `sbatch` from within your job submission file, using a special form of comment:

```
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH -A myqueuename
{::if resource.qsub_needs_gpu == 1}
#SBATCH --nodes=1 --gpus-per-node=1
{::else}
#SBATCH --nodes=1
{::/}
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

# Print the hostname of the compute node on which this job is running.
/bin/hostname
```

If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with `SBATCH`, it may wait in queue for minutes, hours, or even weeks. How long it takes for a job to start depends on the specific queue, the resources and time requested, and other jobs already waiting in that queue requested as well. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

Once your job is submitted, you can [monitor the job status](/knowledge/${resource.dir}/run/slurm/status), wait for the job to complete, and [check the job output](/knowledge/${resource.dir}/run/slurm/output).

{::/}