---
tags:
  - Gautschi
authors:
  - jin456
  - remender
resource: Gautschi
search:
  boost: 2
---

Jobs are submitted on {{ resource }} via the SLURM (Simple Linux Utility for Resource Management) scheduler, which is responsible for allocating resources and scheduling the start time of a job. You may use either the batch or interactive mode to run your jobs. The batch mode is ideal for finished programs, and the interactive mode is useful for debugging your job.

!!! important
    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end login host. All users share the front-end hosts, and running anything but the smallest test job will negatively impact everyone's ability to use Gautschi. Always use SLURM to submit your work as a job.

Batch jobs submitted via SLURM have four main steps:

- [**Creating the submission script**](creating_the_submission_script.md)
- [**Submitting the script as a job**](submit_script.md)
- [**Monitoring the job**](monitoring_job.md)
- [**Checking the job output**](checking_output.md)
