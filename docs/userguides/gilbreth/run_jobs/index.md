---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Running jobs

Jobs are submitted on {{ resource }} via the SLURM (Simple Linux Utility for Resource Management) scheduler, which is responsible for allocating resources and scheduling the start time of a job. You may use either the batch or interactive mode to run your jobs. The batch mode is ideal for finished programs, and the interactive mode is useful for debugging your job.

!!! important
    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end login host. All users share the front-end hosts, and running anything but the smallest test job will negatively impact everyone's ability to use Gautschi. Always use SLURM to submit your work as a job.

Before creating your submission script, learn more about how to use Slurm accounts, partitions, and QOS options:

- [**Basics of using Slurm accounts, partitions, and QOS options**](queues.md)

Batch jobs submitted via SLURM have four main steps: