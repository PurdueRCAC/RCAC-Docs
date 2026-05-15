<!-- Note: this is a shared snippet used across multiple cluster user guides without modification. -->
# Canceling a Job

To stop a job before it finishes or remove it from a queue, use the `scancel` command:

```bash
scancel myjobid
```

You find the job ID using the `squeue` command as explained in the [SLURM Job Status section](monitoring_job.md).
