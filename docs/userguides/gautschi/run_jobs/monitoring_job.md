---
tags:
  - Gautschi
authors:
  - jin456
cluster: Gautschi
search:
  boost: 2
---

Once a job is submitted there are several commands you can use to monitor the progress of the job.

To see your jobs, use the ```squeue -u``` command and specify your username:

(Remember, in our SLURM environment a queue is referred to as an 'Account')

```bash
squeue -u myusername

JOBID      USER     ACCOUNT      PART QOS     NAME       NODES TRES_PER_NODE   CPUS  TIME_LIMIT ST TIME
182792     myusername account_name     cpu  standby job1         1 N/A              192     4:00:00  R 35:54
185841     myusername account_name     cpu  normal  job2         1 N/A              192     4:00:00  R 36:51
185844     myusername account_name     smal normal  job3         1 gres/gpu:1        64     8:00:00  R 22:11
```

To retrieve useful information about your queued or running job, use the ```scontrol show job``` command with your job's ID number. The output should look similar to the following:

```bash
scontrol show job 3519

JobId=3519 JobName=job.sub
   UserId=myusername GroupId=mygroup MCS_label=N/A
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
   WorkDir=/home/myusername
   TresPerJob=gres/hp_cpu=4
```

There are several useful bits of information in this output.

- ```JobState``` lets you know if the job is Pending, Running, Completed, or Held.

- ```RunTime``` and ```TimeLimit``` will show how long the job has run and its maximum time.

- ```SubmitTime``` is when the job was submitted to the cluster.

- ```NumNodes```, ```NumCPUs```, ```NumTasks``` and ```CPUs/Task``` are the number of 
Nodes, CPUs, Tasks, and - CPUs per Task are shown.

- ```WorkDir``` is the job's working directory.

[**Back to the Running Jobs section**](index.md)
