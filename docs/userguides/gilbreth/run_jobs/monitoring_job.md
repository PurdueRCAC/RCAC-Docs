---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Checking Job Status

Once a job is [submitted](/knowledge/${resource.dir}/run/slurm/submit) there are several commands you can use to monitor the progress of the job.

To see your jobs, use the `squeue -u` command and specify your username:

(Remember, in our SLURM environment a queue is referred to as an 'Account')

```

 
{::if resource.name == Gautschi}
squeue -u ${user.username}

JOBID      USER     ACCOUNT      PART QOS     NAME       NODES TRES_PER_NODE   CPUS  TIME_LIMIT ST TIME
182792     ${user.username} account_name     cpu  standby job1         1 N/A              192     4:00:00  R 35:54
185841     ${user.username} account_name     cpu  normal  job2         1 N/A              192     4:00:00  R 36:51
185844     ${user.username} account_name     smal normal  job3         1 gres/gpu:1        64     8:00:00  R 22:11

{::else}
squeue -u ${user.username}

    JOBID   ACCOUNT    NAME    USER   ST    TIME   NODES  NODELIST(REASON)
   182792   ${resource.queue}    job1    ${user.username}    R   20:19       1  {::if resource.nodashnames == true}a000{::else}${resource.hostname}-a000{::/}
   185841   ${resource.queue}    job2    ${user.username}    R   20:19       1  {::if resource.nodashnames == true}a001{::else}${resource.hostname}-a001{::/}
   185844   ${resource.queue}    job3    ${user.username}    R   20:18       1  {::if resource.nodashnames == true}a002{::else}${resource.hostname}-a002{::/}
   185847   ${resource.queue}    job4    ${user.username}    R   20:18       1  {::if resource.nodashnames == true}a003{::else}${resource.hostname}-a003{::/}

{::/}
```

To retrieve useful information about your queued or running job, use the `scontrol show job` command with your job's ID number. The output should look similar to the following:

```


{::if resource.name == Gautschi}
scontrol show job 3519

JobId=3519 JobName=job.sub
   UserId=${user.username} GroupId=mygroup MCS_label=N/A
   Priority=1000 Nice=0 Account=myaccount QOS=normal
   JobState=RUNNING Reason=None Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=0 Reboot=0 ExitCode=0:0
   RunTime=00:00:23 TimeLimit=04:00:00 TimeMin=N/A
   SubmitTime=2025-02-24T14:31:19 EligibleTime=2025-02-24T14:31:19
   AccrueTime=2025-02-24T14:31:19
   StartTime=2025-02-24T14:32:36 EndTime=2025-02-24T18:32:36 Deadline=N/A
   PreemptEligibleTime=2025-02-24T14:32:36 PreemptTime=None
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-02-24T14:32:36 Scheduler=Backfill
   Partition=cpu AllocNode:Sid=login02:4061246
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=a166
   BatchHost=a166
   NumNodes=1 NumCPUs=4 NumTasks=4 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
   ReqTRES=cpu=4,mem=7668M,node=1,gres/hp_cpu=4
   AllocTRES=cpu=4,mem=7668M,node=1,gres/hp_cpu=4
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=1 MinMemoryCPU=1917M MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/bin/sh
   WorkDir=/home/${user.username}
   TresPerJob=gres/hp_cpu=4

{::else}
scontrol show job 3519

JobId=3519 JobName=t.sub
   UserId=${user.username} GroupId=mygroup MCS_label=N/A
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
   Command=/home/${user.username}/jobdir/myjobfile.sub
   WorkDir=/home/${user.username}/jobdir
   StdErr=/home/${user.username}/jobdir/slurm-3519.out
   StdIn=/dev/null
   StdOut=/home/${user.username}/jobdir/slurm-3519.out
   Power=

{::/} 
```

There are several useful bits of information in this output.

* `JobState` lets you know if the job is Pending, Running, Completed, or Held.
* `RunTime and TimeLimit` will show how long the job has run and its maximum time.
* `SubmitTime` is when the job was submitted to the cluster.
* `NumNodes`, `NumCPUs`, `NumTasks` and `CPUs/Task` are the number of Nodes, CPUs, Tasks, and CPUs per Task are shown.
* `WorkDir` is the job's working directory.
{::if resource.name != Gautschi}* `StdOut` and `Stderr` are the locations of stdout and stderr of the job, respectively.
* `Reason` will show why a `PENDING` job isn't running. The above error says that it has been requested to start at a specific, later time.
{::/}