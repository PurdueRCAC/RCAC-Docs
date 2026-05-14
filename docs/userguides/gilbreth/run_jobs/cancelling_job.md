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

# Canceling a Job

To stop a job before it finishes or remove it from a queue, use the `scancel` command:

```bash
scancel myjobid
```

You find the job ID using the `squeue` command as explained in the [SLURM Job Status section](monitoring_job.md).

[**Back to the Running Jobs section**](index.md)