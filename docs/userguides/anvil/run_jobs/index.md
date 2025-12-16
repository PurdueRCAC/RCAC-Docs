---
tags:
  - Anvil
authors:
  - jin456
cluster: Anvil
search:
  boost: 2
---

There is one method for submitting jobs to {{ cluster }}. You may use Slurm to submit jobs to a partition on {{ cluster }}. Slurm performs job scheduling. Jobs may be any type of program. You may use either the batch or interactive mode to run your jobs. Use the batch mode for finished programs; use the interactive mode only for debugging.

Users familiar with the Linux command line may use standard job submission utilities to manage and run jobs on the Anvil compute nodes.

!!! note
    For GPU jobs, make sure to use `--gpus-per-node` argument, otherwise, your job may not run properly.

- [**Python on {{ cluster }} cluster**](running_jobs_python.md)
- [**R on {{ cluster }} cluster**](running_jobs_r.md)