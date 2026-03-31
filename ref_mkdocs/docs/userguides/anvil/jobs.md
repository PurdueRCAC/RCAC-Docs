---
tags:
  - Anvil
authors:
  - dane
  - elian
draft: true
---

## Overview / Slurm Basics

Anvil uses the [Slurm Workload Manager](https://slurm.schedmd.com/) for job scheduling and management. With Slurm, a user requests resources and submits a job to a queue. The system takes jobs from queues, allocates the necessary compute nodes, and executes them. While users will typically SSH to an Anvil login node to access the Slurm job scheduler, they should note that Slurm should always be used to submit their work as a job rather than run computationally intensive jobs directly on a login node. All users share the login nodes, and running anything but the smallest test job will negatively impact everyone's ability to use Anvil.

Anvil is designed to serve the moderate-scale computation and data needs of the majority of ACCESS users. Users with allocations can submit to a variety of queues with varying job size and walltime limits. Separate sets of queues are utilized for the CPU, GPU, and large memory nodes. Typically, queues with shorter walltime and smaller job size limits will feature faster turnarounds. Some additional points to be aware of regarding the Anvil queues are:

- Anvil provides a debug queue for testing and debugging codes.
- Anvil supports shared-node jobs (more than one job on a single node). Many applications are serial or can only scale to a few cores. Allowing shared nodes improves job throughput, provides higher overall system utilization and allows more users to run on Anvil.
- Anvil supports long-running jobs - run times can be extended to four days for jobs using up to 16 full nodes.
- The maximum allowable job size on Anvil is 7,168 cores. To run larger jobs, submit a consulting ticket to discuss with Anvil support.
- Shared-node queues will be utilized for managing jobs on the GPU and large memory nodes.

## Job Scheduling Essentials

- What each job needs to request resources

### Partitions (Queues)

### Anvil Production Queues

| Queue Name | Node Type | Max Nodes per Job | Max Cores per Job | Max Duration | Max Running Jobs per User | Max Running + Submitted Jobs | Charging Factor |
|----------|-----------|-------------------|-------------------|--------------|---------------------------|------------------------------|-----------------|
| debug | regular | 2 nodes | 256 cores | 2 hrs | 1 | 2 | 1 |
| gpu-debug | gpu | 1 node | 2 GPUs | 0.5 hrs | 1 | 2 | 1 |
| wholenode | regular | 16 nodes | 2,048 cores | 96 hrs | 64 | 2500 | 1 (node-exclusive) |
| wide | regular | 56 nodes | 7,168 cores | 12 hrs | 5 | 10 | 1 (node-exclusive) |
| shared | regular | 1 node | 128 cores | 96 hrs | 1280 cores | – | 1 |
| highmem | large-memory | 1 node | 128 cores | 48 hrs | 2 | 4 | 4 |
| gpu | gpu | – | – | 48 hrs | – | – | 1 |
| ai | ai | – | – | 48 hrs | – | – | 1 |


!!! warning "GPU and AI Queues"
    - Maximum of **12 GPUs in use per user**
    - Maximum of **32 GPUs in use per allocation**

!!! note "Default Partition"
    Make sure to specify the desired partition when submitting your jobs (for example, `-p wholenode`). If no partition is specified, the job will be directed into the default partition (`shared`).

!!! warning "Charges for Whole-Node Partitions"
    If the partition is **node-exclusive** (e.g., `wholenode` and `wide`), even if you request only one core, the job will be allocated an entire node. The job will be charged for **128 cores**, and `squeue` will reflect this allocation. See SU accounting for more details.

### Useful Tools

To display all Slurm partitions and their current usage, run:

```bash
showpartitions
```
Example output:
```bash
Partition statistics for cluster anvil at CURRENTTIME
        Partition     #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
        Name State Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
   wholenode    up   750     0  96000    512      0  92280     1 infin   infinite   128     257 
    standard    up   750     0  96000    512      0   6753     1 infin   infinite   128     257 
    shared:*    up   250    97  32000  16395      0   4997     1 infin   infinite   128     257 
        wide    up   746     0  95488    512      0  24576     1 infin   infinite   128     257 
     highmem    up    32    19   4096   2504      0      0     1 infin   infinite   128    1031 
       debug    up    17     0   2176    113      0    128     1 infin   infinite   128     257 
         gpu    up    16     0   2048   1371      0    228     1 infin   infinite   128     515 
          ai    up    21    18   2016   1814      0      0     1 infin   infinite    96    1031 
   gpu-debug    up    16     0   2048   1371      0      0     1 infin   infinite   128     515 
benchmarking    up  1048   116 134144  20782      0      0     1 infin   infinite   128     257+
   profiling    up     4     0    512      0      0      0     1 infin   infinite   128     257 
       azure    up     8     0     16      0      0      0     1 infin   infinite     2       7
```
To list available constraint feature names for different node types, run:
```bash
sfeatures
```
```bash
NODELIST       CPUS   MEMORY    AVAIL_FEATURES    GRES
a[000-999]     128    257400    A,a               (null)
b[000-031]     128    1031400   B,b,testing       (null)
g[000-015]     128    515400    G,g,A100          gpu:4
h[000-020]     96     1031000   H,h,H100          gpu:4
login[00-07]   32     500000    login             (null)
ondemand       32     90000     (null)            (null)
z[000-007]     2      7684      Z,z,power_azure   (null)
```

## Running Jobs

### Job Submission Script

To submit work to a Slurm queue, you must first create a job submission file. This job submission file is essentially a simple shell script. It will set any required environment variables, load any necessary modules, create or modify files and directories, and run any applications that you need:

```bash
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

# Loads Matlab and sets the application up
module load matlab

# Change to the directory from which you originally submitted this job.
cd $SLURM_SUBMIT_DIR

# Runs a Matlab script named 'myscript'
matlab -nodisplay -singleCompThread -r myscript
```

The standard Slurm environment variables that can be used in the job submission file are listed in the table below:

**Job Script Environment Variables**

| Name | Description |
| --- | --- |
| SLURM\_SUBMIT\_DIR | Absolute path of the current working directory when you submitted this job |
| SLURM\_JOBID | Job ID number assigned to this job by the batch system |
| SLURM\_JOB\_NAME | Job name supplied by the user |
| SLURM\_JOB\_NODELIST | Names of nodes assigned to this job |
| SLURM\_SUBMIT\_HOST | Hostname of the system where you submitted this job |
| SLURM\_JOB\_PARTITION | Name of the original queue to which you submitted this job |

Once your script is prepared, you are ready to submit your job.

### Submitting a Job

Once you have a job submission file, you may submit this script to SLURM using the sbatch command. Slurm will find, or wait for, available resources matching your request and run your job there.

To submit your job to one compute node with one task:

```shell-session

$ sbatch --nodes=1 --ntasks=1 myjobsubmissionfile
```

By default, each job receives 30 minutes of wall time, or clock time. If you know that your job will not need more than a certain amount of time to run, request less than the maximum wall time, as this may allow your job to run sooner. To request the 1 hour and 30 minutes of wall time:

```shell-session

$ sbatch -t 1:30:00 --nodes=1  --ntasks=1 myjobsubmissionfile
```

Each compute node in Anvil has 128 processor cores. In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must utilize all the cores to support this ability. To request 2 compute nodes with 256 tasks:

```shell-session

$ sbatch --nodes=2 --ntasks=256 myjobsubmissionfile
```

If more convenient, you may also specify any command line options to sbatch from within your job submission file, using a special form of comment:

```bash
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH -A myallocation
#SBATCH -p queue-name # the default queue is "shared" queue
#SBATCH --nodes=1
#SBATCH --ntasks=1 
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

module purge # Unload all loaded modules and reset everything to original state.
module load ...
...
module list # List currently loaded modules.
# Print the hostname of the compute node on which this job is running.
hostname
```

If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with `sbatch`, it may wait in the queue for minutes, hours, or even days. How long it takes for a job to start depends on the specific queue, the available resources, and time requested, and other jobs that are already waiting in that queue. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

Once your job is submitted, you can monitor the job status, wait for the job to complete, and check the job output.

### Checking Job Status

Once a job is submitted there are several commands you can use to monitor the progress of the job. To see your jobs, use the `squeue -u` command and specify your username.

```shell-session

$ squeue -u myusername
   JOBID   PARTITION   NAME     USER       ST    TIME   NODES   NODELIST(REASON)
   188     wholenode job1   myusername   R     0:14      2    a[010-011]
   189     wholenode job2   myusername   R     0:15      1    a012
```

To retrieve useful information about your queued or running job, use the `scontrol show job` command with your job's ID number.

```shell-session

$ scontrol show job 189
JobId=189 JobName=myjobname
   UserId=myusername GroupId=mygroup MCS_label=N/A
   Priority=103076 Nice=0 Account=myacct QOS=normal
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=0 Reboot=0 ExitCode=0:0
   RunTime=00:01:28 TimeLimit=00:30:00 TimeMin=N/A
   SubmitTime=2021-10-04T14:59:52 EligibleTime=2021-10-04T14:59:52
   AccrueTime=Unknown
   StartTime=2021-10-04T14:59:52 EndTime=2021-10-04T15:29:52 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2021-10-04T14:59:52 Scheduler=Main
   Partition=wholenode AllocNode:Sid=login05:1202865
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=a010
   BatchHost=a010
   NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   TRES=cpu=1,mem=257526M,node=1,billing=1
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryNode=257526M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=(null)
   WorkDir=/home/myusername/jobdir
   Power=
```

*   `JobState` lets you know if the job is Pending, Running, Completed, or Held.
*   `RunTime and TimeLimit` will show how long the job has run and its maximum time.
*   `SubmitTime` is when the job was submitted to the cluster.
*   The job's number of Nodes, Tasks, Cores (CPUs) and CPUs per Task are shown.
*   `WorkDir` is the job's working directory.
*   `StdOut` and `Stderr` are the locations of stdout and stderr of the job, respectively.
*   `Reason` will show why a `PENDING` job isn't running.

You can check the predicted wait time for a queued job by running `wait_time -j {your_job_id}`

For historic (completed) jobs, you can use the `jobinfo` command. While not as detailed as scontrol output, it can also report information on jobs that are no longer active.

### Checking Job Output

Once a job is submitted, and has started, it will write its standard output and standard error to files that you can read.

SLURM catches output written to standard output and standard error - what would be printed to your screen if you ran your program interactively. Unless you specified otherwise, SLURM will put the output in the directory where you submitted the job in a file named slurm- followed by the job id, with the extension out. For example `slurm-3509.out`. Note that both stdout and stderr will be written into the same file, unless you specify otherwise.

If your program writes its own output files, those files will be created as defined by the program. This may be in the directory where the program was run, or may be defined in a configuration or input file. You will need to check the documentation for your program for more details.

### Redirecting Job Output

It is possible to redirect job output to somewhere other than the default location with the `--error` and `--output` directives:

```bash
#! /bin/sh -l
#SBATCH --output=/path/myjob.out
#SBATCH --error=/path/myjob.out

# This job prints "Hello World" to output and exits
echo "Hello World"
```

### Holding a Job

Sometimes you may want to submit a job but not have it run just yet. You may be wanting to allow lab mates to cut in front of you in the queue - so hold the job until their jobs have started, and then release yours.

To place a hold on a job before it starts running, use the scontrol hold job command:

```shell-session
$ scontrol hold job  myjobid
```

Once a job has started running it can not be placed on hold.

To release a hold on a job, use the scontrol release job command:

```shell-session
$ scontrol release job  myjobid
```

### Job Dependencies

Dependencies are an automated way of holding and releasing jobs. Jobs with a dependency are held until the condition is satisfied. Once the condition is satisfied jobs only then become eligible to run and must still queue as normal.

Job dependencies may be configured to ensure jobs start in a specified order. Jobs can be configured to run after other job state changes, such as when the job starts or the job ends.

These examples illustrate setting dependencies in several ways. Typically dependencies are set by capturing and using the job ID from the last job submitted.

To run a job after job myjobid has started:

```shell-session
$ sbatch --dependency=after:myjobid myjobsubmissionfile
```

To run a job after job myjobid ends without error:

```shell-session
$ sbatch --dependency=afterok:myjobid myjobsubmissionfile
```

To run a job after job myjobid ends with errors:

```shell-session
$ sbatch --dependency=afternotok:myjobid myjobsubmissionfile
```

To run a job after job myjobid ends with or without errors:

```shell-session
$ sbatch --dependency=afterany:myjobid myjobsubmissionfile
```

To set more complex dependencies on multiple jobs and conditions:

```shell-session
$ sbatch --dependency=after:myjobid1:myjobid2:myjobid3,afterok:myjobid4 myjobsubmissionfile
```

### Canceling a Job

To stop a job before it finishes or remove it from a queue, use the scancel command:

```shell-session
$ scancel myjobid
```

### Interactive jobs

In addition to the ThinLinc and OnDemand interfaces, users can also choose to run interactive jobs on compute nodes to obtain a shell that they can interact with. This gives users the ability to type commands or use a graphical interface as if they were on a login node.

To submit an interactive job, use `sinteractive` to run a login shell on allocated resources.

`sinteractive` accepts most of the same resource requests as sbatch, so to request a login shell in the compute queue while allocating 2 nodes and 256 total cores, you might do:

```
$ sinteractive -p wholenode -N 2 -n 256 -A oneofyourallocations
```

You can check the predicted wait time for a queued job by running `wait_time -j {your_job_id}`

To quit your interactive job:

`exit` or `Ctrl-D`

## Job Accounting

On Anvil, the CPU nodes and GPU nodes are charged separately.
Link to section 'For CPU nodes' of 'Job Accounting'For CPU nodes
The charge unit for Anvil is the Service Unit (SU). This corresponds to the equivalent use of one compute core utilizing less than approximately 2G of data in memory for one hour.

Keep in mind that your charges are based on the resources that are tied up by your job and do not necessarily reflect how the resources are used.

If you explicitly request --mem-per-cpu=2G, SLURM may allocate more resources than expected, since the default memory per core on Anvil is slightly less than 2GB (approximately 1896 MB). By requesting exactly 2GB per core, SLURM may allocate additional cores to meet the memory requirement, which can lead to higher SU charges.

Charges on jobs submitted to the shared queues are based on the number of cores and the fraction of the memory requested, whichever is larger. Jobs submitted as node-exclusive will be charged for all 128 cores, whether the resources are used or not.

Jobs submitted to the large memory nodes will be charged 4 SU per compute core (4x wholenode node charge).

Link to section 'For GPU nodes' of 'Job Accounting'For GPU nodes
1 SU corresponds to the equivalent use of one GPU utilizing less than or equal to approximately 120G of data in memory for one hour.

Each GPU nodes on Anvil have 4 GPUs and all GPU nodes are shared.

Link to section 'For file system' of 'Job Accounting'For file system
Filesystem storage is not charged.

You can use mybalance command to check your current allocation usage.

## Extended Examples

### Python Jobs

TODO: Snippet

### R Jobs

TODO: Snippet
