---
date:
  created: 2026-10-12
  #Sometimes, bloggers need to update a post. This might happen when you make a mistake or when something changes that you need to reflect in the post. To indicate you have edited a post, you can include an updated date in the page header.
  #updated: 2025-09-03

categories:
  - Slurm

#Title will change how it's displayed on website
title: Tuning Gautschi's Slurm Limits

#Slug will change how it's shown in the domain url
slug: gautschi_slurm_limits

tags:
  - Software
  - Slurm
authors:
  - rderue
---


#### New Limits
- The maximum number of GPUs that can be allocated at once by each group will be reduced from 24 to 16
	- This will not reduce the maximum number of GPUs allocable under the preemptible QOS.
- The maximum walltime request of each job will be reduced from 14 days to 4 days.
	- This will not reduce the max walltime allocable under the preemptible QOS.

#### Why the New Limits?
As of October 1st, Gautschi has been in production for 19 months, and over that time, we have seen utilization continue to ramp up. Due to Gautschi's allocation method of allowing groups to purchase resources based on GPU hours rather than limiting them to the number of GPUs purchased, groups have been able to use many more GPUs in parallel than purchased. This is by design as we'd like for groups to be able to use the massively parallel capabilities of Gautschi, but while an overly generous limit of 24 H100s may have been suitable for a fledgling cluster with few users, it's become clear that it's too permissive for Gautschi's current user base.

#### Reducing Max GPUs per Group
Over the past nine months, we've watched the total utilization of the AI partition creep towards 100% while the percentage of jobs using the "preemptible" QOS falls. This indicates that we are at 100% utilization while there are always "normal" QOS jobs that are waiting to start.

![Utilization Graph of Allocated GPU Hours by QOS](/assets/images/blog/gautschi_usage_by_qos.png)

In order to address this, we'll be reducing the maximum number of GPUs that can be used by a group under the normal QOS from three full nodes (or 24 H100s) to two full nodes (or 16 H100s). This may be reduced further as more groups purchase into Gautschi. Currently, no groups have purchased a full node of H100s on Gautschi, and so this limit still allows all groups to parallelize across more GPUs than strictly purchased. Additionally, the "preemptible" QOS will still be available to allow groups to scale past this limit when idle GPUs are available.

#### Reducing Max Walltime per Job
Another limit that we are reducing in this tuning pass is the maximum wall time for each job under the normal QOS. There are a couple of reasons for this, but it essentially boils down to the fact that users are typically requesting many, many more hours/days than their jobs require, and this makes it harder for Slurm to give estimates on start time to users.

When looking at the statistics of all 508,234 jobs that have ran in the AI partition since March 1st, 2025 until Oct 12th, 2026, we see that less than <0.1% of jobs are using more than 3 days of walltime despite around 5% of jobs requesting >=3 days of walltime.

| Percentile | Requested Walltime | Used Walltime |
| ---------- | -----------------: | ------------: |
| 90%        |         1-02:00:00 |      01:54:00 |
| 99%        |        14-00:00:00 |      22:54:00 |
| 99.9%      |        14-00:00:00 |    3-00:00:00 |

Reducing the maximum walltime should allow Slurm to be more efficient in backfilling users jobs. For a more in-depth discussion as to why that is the case, see the discussion on backfill scheduling in [my other blog](https://docs.rcac.purdue.edu/blog/2025/08/08/job-priority-and-scheduling/#how-does-slurm-schedule). We recommend that users continue to implement and leverage checkpointing as a best practice to make efficient use of shorter step walltimes and preemptible jobs.




