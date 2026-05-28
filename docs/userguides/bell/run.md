---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Running Jobs

Jobs are submitted on {{ resource }} via the SLURM (Simple Linux Utility for Resource Management) scheduler, which is responsible for allocating resources and scheduling the start time of a job. You may use either the batch or interactive mode to run your jobs. The batch mode is ideal for finished programs, and the interactive mode is useful for debugging your job.

!!! important
    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end login host. All users share the front-end hosts, and running anything but the smallest test job will negatively impact everyone's ability to use Bell. Always use SLURM to submit your work as a job.

Before creating your submission script, learn more about how to use Slurm accounts, partitions, and QOS options:

- [**Basics of using Slurm accounts, partitions, and QOS options**](run/slurm/queues.md)

Batch jobs submitted via SLURM have four main steps:

* [Create job submission script](run/slurm/creating_the_submission_script.md)
* [Submit job script](run/slurm/submit_script.md)
* [Monitor job status](run/slurm/monitoring_job.md)
* [Check output](run/slurm/checking_output.md)

## Other useful topics

- [Canceling a Job](run/slurm/cancelling_job.md)
- [Job Dependencies](run/slurm/job_dependencies.md)
- [Holding a Job](run/slurm/holding_job.md)


## Example Jobs

A number of example jobs are available for you to look over and adapt to your own needs. The first few are generic examples, and latter ones go into specifics for particular software packages.

- [Specific Applications](run/examples/apps.md)
- [Hadoop](run/examples/hadoop.md)
- [Generic SLURM Jobs](run/examples/slurm.md)

[**Back to Bell User Guide**](index.md)
