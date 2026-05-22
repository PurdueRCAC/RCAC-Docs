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

# Holding a job

Sometimes you may want to submit a job but not have it run just yet. You may be wanting to allow lab mates to cut in front of you in the queue - so hold the job until their jobs have started, and then release yours.

To place a hold on a job before it starts running, use the ```scontrol hold job``` command:

```bash
$ scontrol hold job  myjobid
```

Once a job has started running it can not be placed on hold.

To release a hold on a job, use the ```scontrol release job``` command:

```bash
$ scontrol release job  myjobid
```

You find the job ID using the ```squeue``` command as explained in the [Monitoring a job](monitoring_job.md) section.

[**Back to the Running Jobs section**](index.md)
