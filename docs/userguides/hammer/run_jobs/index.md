---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Running Jobs

Jobs are submitted on Hammer via the SLURM (Simple Linux Utility for Resource Management) scheduler, which is responsible for allocating resources and scheduling the start time of a job. You may use either the batch or interactive mode to run your jobs. The batch mode is ideal for finished programs, and the interactive mode is useful for debugging your job.

!!! important
    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end login host. All users share the front-end hosts, and running anything but the smallest test job will negatively impact everyone's ability to use Hammer. Always use SLURM to submit your work as a job.

Before creating your submission script, learn more about how to use Slurm accounts and queues on Hammer:

- [**Basics of using Slurm accounts and queues**](slurm/queues.md)

Batch jobs submitted via SLURM have four main steps:

* [Create job submission script](slurm/creating_the_submission_script.md)
* [Submit job script](slurm/submit_script.md)
* [Monitor job status](slurm/monitoring_job.md)
* [Check output](slurm/checking_output.md)

## Other useful topics

- [Canceling a Job](slurm/cancelling_job.md)
- [Job Dependencies](slurm/job_dependencies.md)
- [Holding a Job](slurm/holding_job.md)


## Example Jobs

A number of example jobs are available for you to look over and adapt to your own needs. The first few are generic examples, and latter ones go into specifics for particular software packages.

- [Specific Applications](examples/apps.md)
- [Hadoop](examples/hadoop.md)
- [Generic SLURM Jobs](examples/slurm.md)

[**Back to Hammer User Guide**](../index.md)
