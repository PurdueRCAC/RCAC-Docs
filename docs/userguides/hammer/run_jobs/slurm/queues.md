---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Queues

On Hammer, jobs are submitted to named queues (also called accounts). Each research partner who has purchased access to Hammer receives a dedicated queue named after their research group. In addition, all users have access to the `standby` and `debug` queues.

## Named (mylab) Queues

Each research partner on Hammer has a dedicated queue named after their research group (e.g., `mylab`). These queues provide priority access to the resources purchased by that group.

* Jobs submitted to a named queue have high priority and are expected to start within 4 hours.
* The maximum walltime for jobs in a named queue is **336 hours** (14 days).
* Named queue jobs withdraw resources from the group's purchased allocation while running.

To submit a job to your named queue:

```bash
$ sbatch --account=myqueuename myjobsubmissionfile
```

To check what queues you have access to, use the `slist` command.

## Standby Queue

The `standby` queue is available to all Hammer users and allows jobs to run on otherwise idle resources across the cluster.

* Jobs in the standby queue have lower priority; there is no guaranteed start time.
* The maximum walltime for standby jobs is **4 hours**.
* Standby jobs use idle resources and do not count against your group's purchased allocation.

To submit a job to the standby queue:

```bash
$ sbatch --account=standby myjobsubmissionfile
```

## Debug Queue

The `debug` queue is intended for short, interactive debugging sessions to help you test and troubleshoot your job scripts before submitting longer runs.

* Each user may have **1 running job** in the debug queue at a time.
* Jobs may use up to **2 compute nodes**.
* The maximum walltime is **30 minutes**.
* Debug jobs are expected to start within minutes.

To submit a job to the debug queue:

```bash
$ sbatch --account=debug --nodes=1 myjobsubmissionfile
```

## Queue Summary

| Queue | Who Can Use | Max Walltime | Expected Start | Notes |
| --- | --- | --- | --- | --- |
| Named (mylab) | Research group members | 336 hours | Within 4 hours | Dedicated, high priority |
| standby | All users | 4 hours | No guarantee | Uses idle resources |
| debug | All users | 30 minutes | Within minutes | 1 running job/user, max 2 nodes |

[**Back to the Running Jobs section**](../index.md)
