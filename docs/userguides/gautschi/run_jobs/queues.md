---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Slurm accounts, partitions, and QOS options

## Queues
On Gautschi, the required options for job submisison deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts:

- The number and type of resources you want 
- The account the resources should come out of
- The quality of service (QOS) this job expects from the resources
- The partition where the resources are located

If you have used other clusters, you will be familiar with first item. If you have not, you can read about how to format the request  on our job submission page. The rest of this page will focus on the last three items as they are specific to Gautschi.

## Accounts

On the Gautschi community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores, GPU hours or both. To see the list of accounts that you have access to on Gautschi as well as the resources they contain, you can use the command "slist".

On previous clusters, you may have had access to several other special accounts like "standby", "highmem", "gpu", etc. On Gautschi, these modes of access still exist, but they are no longer accounts. As well on Gautschi, you must explicitly define the account that you want to submit to using the "-A/--account=" option.

## Quality of Service (QOS)

On Gautschi, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs" that has been tagged with a QOS named "highpriority". There are two classes of QOSes and a job can have both:

- Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
- Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option "-q/--qos=". By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to submit to a particular partition. The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight or have tracking information for it or you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we may negotiate how they handle that package by choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS and you may be able to ask for your job to be handled a particular way by specifying the job QOS, but that option has to be offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The following job QOSes every user and every account of Gautschi has access to:

- "normal": The "normal" QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
- "standby": The "standby" QOS must be explicitly used if desired by using the option "-q standby" or "--qos=standby". The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous -A standby style of submission.

Some of these QOSes may not be available in every partition. Each of the partitions in the following section will enumerate which of these QOSes are allowed in the partition.

## Partitions

On Gautschi, the various types of nodes on the cluster are organized into distinct partitions. This allows CPU and GPU nodes to be charged separately and differently. **This also means that instead of only needing to specify the account name in the job script, the desired partition must also be specified.** Each of these partitions is subject to different limitations and has a specific use case that will be described below. 

### CPU Partition

This partition contains the resources a group purchases access to when they purchase CPU resources on Gautschi and is made up of 336 Gautschi-A nodes. Each of these nodes contains two Zen 4 AMD EPYC 9654 96-core processors for a total of 192 cores and 384 GB of memory for a total of more than 64,000 cores in the partition. Memory in this partition is allocated proportional to your core request such that each core is given about 2 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p cpu" or "--partition=cpu".

The purchasing model for this partition allows groups to purchase high priority access to some number of cores. When an account uses resources in this account by submitting a job tagged with the "normal" QOS, the cores used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the CPU partition, jobs are tagged by the "normal" QOS by default, but they can be tagged with the "standby" QOS if explicitly submitted using the "-q standby" or "--qos=standby" option.

**Jobs tagged with the "normal" QOS are subject to the following policies:**

- Jobs have a high priority and should not need to wait very long before starting.
- Any cores requested by these jobs are withdrawn from the account until the job terminates.
- These jobs can run for up to two weeks at a time.

**Jobs tagged with the "standby" QOS are subject to the following policies:**

- **Jobs have a low priority and there is no expectation of job start time.** If the partition is very busy with jobs using the "normal" QOS or if you are requesting a very large job, then jobs using the "standby" QOS may take hours or days to start.
- These jobs can use idle resources on the cluster and as such cores requested by these jobs are not withdrawn from the account to which they were submitted. 
- These jobs can run for up to four hours at a time.

Groups who purchased GPU resources on Gautschi will have the ability to run jobs in this partition tagged with the "standby" QOS described above, but will not be able to submit jobs tagged with the "normal" qos unless they have purchased CPU resources on the cluster.

Available QOSes: "normal", "standby"

### AI Partition

This partition contains the resources a group purchases access to when they purcahse GPU resources on Gautschi and is made up of 20 Gautschi-H nodes. Each of these nodes contains two Intel Xeon Platinum 8480+ 56-core processors and 8-way NVLinked H100s for a total of 160 H100s in the partition. CPU memory in this partition is allocated proportional to your core request such that each core is given about 9 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p ai" or "--partition=ai".

The purchasing model for this cluster allows groups to purchase access to GPUs. When a group purchases access to a GPU for a year, they are given 365*24 hours of GPU time on the partition. The advantage to tracking resources this way is that if a group needs access to more than one GPU for a project, they can use multiple GPUs at once since instead of having to purchase additional GPUs, they just consume those GPU hours faster. When an account uses resources in this partition, the balance of GPU hours in their account is charged at a rate of at least one GPU hour for each GPU their job uses per hour (this is tracked by the minute), however the usage of some QOSes described below will charge usage at a slower rate. 

When using the AI partition, jobs are tagged by the "normal" QOS by default, but they can be tagged with the "preemptible" QOS if explicitly submitted using the "-q preemptible" or "--qos=preemptible" option.

**Jobs tagged with the "normal" QOS are subject to the following policies:**

- Jobs have a high priority and should not need to wait very long before starting.
- The account the job is submitted to will be charged 1 GPU hour for each GPU this job uses per hour (this is tracked by the minute).
- These jobs can run for up to two weeks at a time.

**Jobs tagged with the "preemptible" QOS subject to the following policies:**

- **Jobs have a low priority and there is no expectation of job start time.** If the partition is very busy with jobs using the "normal" QOS or if you are requesting a very large job, then jobs using the "standby" QOS may take hours or days to start.
- The account the job is submitted to will be charged 0.25 GPU hour for each GPU this job uses per hour (this is tracked by the minute) which effectively allows jobs to use 4x as many resources as a job tagged with the "normal" qos for the same cost.
- These jobs can run for up to two weeks at a time.
- If there are not enough idle resources in this partition for a job tagged with the "normal" QOS to start, then this job may be cancelled to make room for that job. **This means it is imperative to use checkpointing if using this QOS.**

Available QOSes: "normal", "preemptible"

### Highmem Partition

This partition is made up of 6 Gautschi-B nodes which have four times as much memory as a standard Gautschi-A node, and access to this partition is given to all accounts on the cluster to enable work that has higher memory requirements. Each of these nodes contains two Zen 4 AMD EPYC 9654 96-core processors for a total of 192 cores and 1.5 TB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 8 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p highmem" or "--partition=highmem".

When using the Highmem partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. 

**Additionally, jobs are tagged by a highmem partition QOS that enforces the following policies:**

- **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gautschi
- You can have 2 jobs running in this partition at once
- You can have 8 jobs submitted to thie partition at once
- Your jobs must use more than 48 of the 192 cores on the node otherwise your memory footprint would fit on a standard Gautschi-A node
- These jobs can run for up to 24 hours at a time. 

Available QOSes: "normal"

### Profiling Partition

This partition is made up of 2 Gautschi-A nodes that have hardware performance counters enabled. By enabling hardware performance counters, profiling applications such as AMD MicroProf can track certain performance criteria for execution on the CPU such as L3 cache events, speculative execution misses, etc. Due to the fact that this allows greater visibility into the execution of each process, the nodes in this partition can only be used if your job uses the entire node.  Submission to this partition can be accomplished by using the option: "-p profiling" or "--partition=profiling".

When using the profiling partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. 

**Additionally, jobs are tagged by a profiling partition QOS that enforces the following policies:**

- **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gautschi
- You can have 1 job running in this partition at once
- If you have a single process running on one of the nodes, you must use that entire node when submitting to this partition
- These jobs can run for up to 24 hours at a time. 

This is a resource that is reserved for groups profiling their applications and we monitor to ensure that this partition is not being used simply for more compute.

Available QOSes: "normal"

### Smallgpu Partition

This partition is made up of 6 Gautschi-G nodes. Each of these nodes contains two NVIDIA L40s and two Zen 4 AMD EPYC 9554 64-core processors for a total of 128 cores and 384GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node) Submission to this partition can be accomplished by using the option: "-p smallgpu" or "--partition=smallgpu".

When using the smallgpu partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. 

**Additionally, jobs are tagged by a smallgpu partition QOS that enforces the following policies:**

- **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gautschi
- You can use up to 2 GPUs in this partition at once
- You can have 8 jobs submitted to thie partition at once
- These jobs can run for up to 24 hours at a time.

Available QOSes: "normal"

[**Back to the Running Jobs section**](index.md)
