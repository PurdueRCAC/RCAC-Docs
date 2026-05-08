---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# Checking Job Status

Once a job is [submitted](submit_script.md) there are several commands you can use to monitor the progress of the job.

To see your jobs, use the `squeue -u` command and specify your username:

> Remember, in the RCAC SLURM environment a queue is referred to as an **Account**.


```bash
squeue -u myusername
```

Example output:

```text
    JOBID   ACCOUNT    NAME    USER        ST    TIME   NODES  NODELIST(REASON)
   182792   standby    job1    myusername  R     20:19      1   gilbreth-a000
   185841   standby    job2    myusername  R     20:19      1   gilbreth-a001
   185844   standby    job3    myusername  R     20:18      1   gilbreth-a002
   185847   standby    job4    myusername  R     20:18      1   gilbreth-a003
```

## Retrieving Detailed Job Information

To retrieve useful information about your queued or running job, use the `scontrol show job` command with your job's ID number.

```bash
scontrol show job 3519
```

Example output:

```text
JobId=3519 JobName=t.sub
   UserId=myusername GroupId=mygroup MCS_label=N/A
   Priority=3 Nice=0 Account=(null) QOS=(null)
   JobState=PENDING Reason=BeginTime Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
   RunTime=00:00:00 TimeLimit=7-00:00:00 TimeMin=N/A
   SubmitTime=2019-08-29T16:56:52 EligibleTime=2019-08-29T23:30:00
   AccrueTime=Unknown
   StartTime=2019-08-29T23:30:00 EndTime=2019-09-05T23:30:00 Deadline=N/A
   PreemptTime=None SuspendTime=None SecsPreSuspend=0
   LastSchedEval=2019-08-29T16:56:52
   Partition=workq AllocNode:Sid=mack-fe00:54476
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=(null)
   NumNodes=1 NumCPUs=2 NumTasks=2 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   TRES=cpu=2,node=1,billing=2
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryNode=0 MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/home/myusername/jobdir/myjobfile.sub
   WorkDir=/home/myusername/jobdir
   StdErr=/home/myusername/jobdir/slurm-3519.out
   StdIn=/dev/null
   StdOut=/home/myusername/jobdir/slurm-3519.out
   Power=
```

## Useful Fields in `scontrol show job`

There are several useful pieces of information in the `scontrol show job` output:

- `JobState` shows whether the job is pending, running, completed, or held.
- `RunTime` and `TimeLimit` show how long the job has run and the maximum amount of time it is allowed to run.
- `SubmitTime` shows when the job was submitted to the cluster.
- `NumNodes`, `NumCPUs`, `NumTasks`, and `CPUs/Task` show the number of nodes, CPUs, tasks, and CPUs per task requested by the job.
- `WorkDir` shows the job's working directory.
- `StdOut` and `StdErr` show the locations of the job's standard output and standard error files.
- `Reason` shows why a `PENDING` job is not running. In the example above, the job has been requested to start at a specific later time.

[**Back to the Running Jobs section**](index.md)