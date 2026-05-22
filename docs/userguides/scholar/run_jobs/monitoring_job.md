---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Monitoring the Job

Once a job is submitted there are several commands you can use to monitor the progress of the job.

To see your jobs, use the squeue -u command and specify your username:

!!!note
    Remember, in Scholar's SLURM environment a queue is referred to as an 'Account'

```bash
squeue -u myusername

    JOBID   ACCOUNT    NAME    USER   ST    TIME   NODES  NODELIST(REASON)
   182792   scholar    job1    myusername    R   20:19       1  scholar-a000
   185841   scholar    job2    myusername    R   20:19       1  scholar-a001
   185844   scholar    job3    myusername    R   20:18       1  scholar-a002
   185847   scholar    job4    myusername    R   20:18       1  scholar-a003
```

To retrieve useful information about your queued or running job, use the ```scontrol show job``` command with your job's ID number. The output should look similar to the following:

```bash
scontrol show job 3519

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

There are several useful bits of information in this output.

- ```JobState``` lets you know if the job is Pending, Running, Completed, or Held.
- ```RunTime``` and ```TimeLimit``` will show how long the job has run and its maximum time.
- ```SubmitTime``` is when the job was submitted to the cluster.
- ```NumNodes```, ```NumCPUs```, ```NumTasks``` and ```CPUs/Task``` are the number of Nodes, CPUs, Tasks, and CPUs per Task are shown.
- ```WorkDir``` is the job's working directory.
- ```StdOut``` and ```Stderr``` are the locations of stdout and stderr of the job, respectively.
- ```Reason``` will show why a ```PENDING``` job isn't running. The above error says that it has been requested to start at a specific, later time.

[**Back to the Running Jobs section**](index.md)
