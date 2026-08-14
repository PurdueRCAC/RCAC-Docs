---
tags:
  - Scholar
authors:
  - jin456
  - remender
  - verburgt
resource: Scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Slurm Queues and Partitions

## Scholar Queue

`--account=scholar` or `-A scholar`

All jobs submitted to Scholar should utilize the `scholar` queue. Specific resource types and quality of service of jobs can be specified via the partition and QoS, which are described below.

To check the current status of the `scholar`, queue, you can use the ```slist``` command.

This lists the number of nodes allocated to the queue, how many are available to run jobs, and the maximum walltime you may request. Options to the command will give more detailed information. This command can be used to get a general idea of how busy an individual queue is and how long you may have to wait for your job to start.



## Scholar Partitions

In addition to the account, Scholar necessitates that you specify a partition to submit jobs to. Partitions are used to describe the type of resources you wish to use for your job. The available partitions are described below:

### CPU Partition

`--partition=cpu` or `-p cpu`

The CPU partition provides access to nodes that only contain CPUs. Node types in this partition include `scholar-a` and `scholar-b`

Example:
```bash linenums="0"
 sinteractive -A scholar \
  --partition=cpu \ 
  --time=1:00:00 \ 
  --qos=normal \ 
  --ntasks=1 \ 
  --cpus-per-task=24
```

### GPU Partition

`--partition=gpu` or `-p gpu`

If your job requires access to an Nvidia GPU accelerator, then use the ```gpu``` partition. Node types this partition include `scholar-g`, `scholar-h`, `scholar-i`, and `scholar-j`. Remember to request GPUs when submitting to a GPU partition!

Example:

```bash linenums="0"
 sinteractive -A scholar \
  --partition=gpu \ 
  --time=1:00:00 \ 
  --qos=normal \ 
  --ntasks=1 \ 
  --cpus-per-task=24 \
  --gres=gpu:1
```

### Spark Interactive and Spark Batch Partitions

`--partition=spark-batch` or `--partition=spark-interactive`

The `spark-batch` and `spark-interactive` partitions provide access to Nvidia DGX Spark systems with unified CPU/GPU memory. Node types in this partition include `scholar-k` and `scholar-l`.

Information regarding the Spark partitions can be found on the [Scholar Spark Nodes](../scholar-spark.md#partitions) page. 


## Quality of Service (QoS)

The Quality of Service (QoS) is used to describe how your job should be prioritized. The available QoS'es on Scholar are described below.

### Normal (default)

`--qos=normal`

The `normal` QoS allows users to submit jobs up to 4 hours in length, and is the default on Scholar.

Example:
```bash linenums="0"
 sinteractive -A scholar \
  --partition=cpu \ 
  --time=4:00:00 \ 
  --qos=normal \ 
  --ntasks=1 \ 
  --cpus-per-task=24
```

### Long

`--qos=long`

If your job requires more than 4 hours to complete, you can submit it to the ```long``` QoS. The maximum walltime is 3 days. `long` QoS jobs are lower priority, so you may need to wait for some time to get access to a node.

### Debug

`--qos=debug`

The `debug` QoS allows users to submit high-priority jobs in order to debug code, test programs, or test configurations. You are limited to one running job at a time in the queue, and you may run up to two compute nodes for 30 minutes. The expectation is that debug jobs should start within a couple of minutes, assuming all of its dedicated nodes are not taken by others.

[**Back to the Running Jobs section**](index.md)
