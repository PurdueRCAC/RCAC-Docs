---
tags:
  - Gautschi
authors:
  - jin456
cluster: Gautschi
search:
  boost: 2
---

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

[**Back to the Running Jobs section**](index.md)