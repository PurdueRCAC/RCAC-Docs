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

# Jobs

There are four apps under the Jobs apps: Active Jobs and Job Composer. These are detailed below.

## Active Jobs

This shows you active SLURM jobs currently on the cluster. The default view will show you your current jobs, similar to `squeue --me`. Using the button labeled "Your Jobs" in the upper right allows you to select different filters by queue (account). All accounts output by `slist` will appear for you here. Using the arrow on the left hand side will expand the full job details.

![A table of active jobs](../../../assets/images/userguides/gilbreth/Gilbreth-ood-active-jobs.png)

The table of active jobs shows useful information such as queue, status, cluster, and ID. It can be sorted by clicking the headers of each column or searched with the "Filter" box above it.

## Job Composer

The Job Composer app allows you to create and submit jobs to the cluster. You can select from pre-defined templates (most of these are taken from the User Guide examples) or you can create your own templates for frequently used workflows.

![An image of job composer](../../../assets/images/userguides/gilbreth/Gilbreth-ood-job-composer.png)

## Job Performance Metrics

The job performance metrics dropdown provides an overview of your jobs within a specific time range. It reports the total jobs, wait time, average job duration, and total wall time of your jobs within the specified range. Memory, time, and CPU efficiency are also reported. 

![An image of job performance metrics](../../../assets/images/userguides/gilbreth/Gilbreth-ood-perf_metrics.png)

## My Jobs

My Jobs provides you with an overview of the state of your jobs. You can filter, by date, account, partition, QoS, and state. For any job, you can click the expand button to see job details. 

![A summary of a users jobs](../../../assets/images/userguides/gilbreth/Gilbreth-ood-my-jobs.png)

[Back to Gateway](../gateway.md)