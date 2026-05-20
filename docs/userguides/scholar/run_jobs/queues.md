---
tags:
  - Scholar
authors:
  - jin456
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Queues

## Scholar Queue

This is the default queue for submitting jobs on Scholar. The maximum walltime on the ```scholar``` queue is 4 hours.

## Long Queue

If your job requires more than 4 hours to complete, you can submit it to the ```long``` queue. The maximum walltime is 3 days. There are only 5 nodes in this queue, so you may have to wait for some time to get access to a node.

## GPU Queue

If your job needs access to an Nvidia GPU accelerator, then use the ```gpu``` queue. The maximum walltime is 4 hours.

## Debug Queue

The debug queue allows you to quickly start small, short, interactive jobs in order to debug code, test programs, or test configurations. You are limited to one running job at a time in the queue, and you may run up to two compute nodes for 30 minutes. The expectation is that debug jobs should start within a couple of minutes, assuming all of its dedicated nodes are not taken by others.

## List of Queues

To see a list of all queues on Scholar that you may submit to, use the ```slist``` command.

This lists each queue you can submit to, the number of nodes allocated to the queue, how many are available to run jobs, and the maximum walltime you may request. Options to the command will give more detailed information. This command can be used to get a general idea of how busy an individual queue is and how long you may have to wait for your job to start.

[**Back to the Running Jobs section**](index.md)
