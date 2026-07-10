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

## "mylab" Queues

Hammer, as a community cluster, has one or more queues dedicated to and named after each partner who has purchased access to the cluster. These queues provide partners and their researchers with priority access to their portion of the cluster. Jobs in these queues are typically limited to 336 hours. **The expectation is that any jobs submitted to your research lab queues will start within 4 hours, assuming the queue currently has enough capacity for the job** (that is, your lab mates aren't using all of the cores currently).

## Standby Queue

Additionally, community clusters provide a "standby" queue which is available to all cluster users. This "standby" queue allows users to utilize portions of the cluster that would otherwise be idle, but at a lower priority than partner-queue jobs, and with a relatively short time limit, to ensure "standby" jobs will not be able to tie up resources and prevent partner-queue jobs from running quickly. Jobs in standby are limited to 12 hours. **There is no expectation of job start time.** If the cluster is very busy with partner queue jobs, or you are requesting a very large job, jobs in standby may take hours or days to start.

## Debug Queue

The debug queue allows you to quickly start small, short, interactive jobs in order to debug code, test programs, or test configurations. You are limited to one running job at a time in the queue, and you may run up to two compute nodes for 30 minutes. The expectation is that debug jobs should start within a couple of minutes, assuming all of its dedicated nodes are not taken by others.

## List of Queues

To see a list of all queues on Hammer that you may submit to, use the `slist` command

This lists each queue you can submit to, the number of nodes allocated to the queue, how many are available to run jobs, and the maximum walltime you may request. Options to the command will give more detailed information. This command can be used to get a general idea of how busy an individual queue is and how long you may have to wait for your job to start.

