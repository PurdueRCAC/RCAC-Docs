---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Queues

{::if resource.name == Gautschi}

On Gilbreth, the required options for job submisison deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts:

1. The number and type of resources you want
2. The account the resources should come out of
3. The quality of service (QOS) this job expects from the resources
4. The partition where the resources are located

If you have used other clusters, you will be familiar with first item. If you have not, you can read about how to format the request  [on our job submission page.](https://www.rcac.purdue.edu/index.php/knowledge/gautschi/run/slurm/submit) The rest of this page will focus on the last three items as they are specific to Gilbreth.

Accounts
========

On the Gilbreth community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores, GPU hours or both. To see the list of accounts that you have access to on Gilbreth as well as the resources they contain, you can use the command "slist".

On previous clusters, you may have had access to several other special accounts like "standby", "highmem", "gpu", etc. On Gilbreth, these modes of access still exist, but they are no longer accounts. As well on Gilbreth, you must explicitly define the account that you want to submit to using the "-A/--account=" option.

Quality of Service (QOS)
========================

On Gilbreth, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs" that has been tagged with a QOS named "highpriority". There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that *you*explicitly give to a job using the option "-q/--qos=". By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to submit to a particular partition. The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight or have tracking information for it or you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we may negotiate how they handle that package by choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS and you may be able to ask for your job to be handled a particular way by specifying the job QOS, but that option has to be offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The following job QOSes every user and every account of Gilbreth has access to:

1. "normal": The "normal" QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. "standby": The "standby" QOS must be explicitly used if desired by using the option "-q standby" or "--qos=standby". The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. *For users of our previous clusters, usage of this QOS replaces the previous -A standby style of submission.*

Some of these QOSes may not be available in every partition. Each of the partitions in the following section will enumerate which of these QOSes are allowed in the partition.

Partitions
==========

On Gilbreth, the various types of nodes on the cluster are organized into distinct partitions. This allows CPU and GPU nodes to be charged separately and differently. *This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified*. Each of these partitions is subject to different limitations and has a specific use case that will be described below.

### CPU Partition

This partition contains the resources a group purchases access to when they purchase CPU resources on Gilbreth and is made up of 336 Gautschi-A nodes. Each of these nodes contains two Zen 4 AMD EPYC 9654 96-core processors for a total of 192 cores and 384 GB of memory for a total of more than 64,000 cores in the partition. Memory in this partition is allocated proportional to your core request such that each core is given about 2 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p cpu" or "--partition=cpu".

The purchasing model for this partition allows groups to purchase high priority access to some number of cores. When an account uses resources in this account by submitting a job tagged with the "normal" QOS, the cores used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the CPU partition, jobs are tagged by the "normal" QOS by default, but they can be tagged with the "standby" QOS if explicitly submitted using the "-q standby" or "--qos=standby" option.

1. Jobs tagged with the "normal" QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any cores requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the "standby" QOS are subject to the following policies:
   1. Jobs have a low priority and **t****here is no expectation of job start time.** If the partition is very busy with jobs using the "normal" QOS or if you are requesting a very large job, then jobs using the "standby" QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such cores requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

**Groups who purchased GPU resources on Gilbreth will have the ability to run jobs in this partition tagged with the "standby" QOS described above, but will not be able to submit jobs tagged with the "normal" qos unless they have purchased CPU resources on the cluster.**

Available QOSes: "normal", "standby"

### AI Partition

This partition contains the resources a group purchases access to when they purcahse GPU resources on Gilbreth and is made up of 20 Gautschi-H nodes. Each of these nodes contains two Intel Xeon Platinum 8480+ 56-core processors and 8-way NVLinked H100s for a total of 160 H100s in the partition. CPU memory in this partition is allocated proportional to your core request such that each core is given about 9 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p ai" or "--partition=ai".

The purchasing model for this cluster allows groups to purchase access to GPUs. When a group purchases access to a GPU for a year, they are given 365\*24 hours of GPU time on the partition. The advantage to tracking resources this way is that if a group needs access to more than one GPU for a project, they can use multiple GPUs at once since instead of having to purchase additional GPUs, they just consume those GPU hours faster. When an account uses resources in this partition, the balance of GPU hours in their account is charged at a rate of at least one GPU hour for each GPU their job uses per hour (this is tracked by the minute), however the usage of some QOSes described below will charge usage at a slower rate.

When using the AI partition, jobs are tagged by the "normal" QOS by default, but they can be tagged with the "preemptible" QOS if explicitly submitted using the "-q preemptible" or "--qos=preemptible" option.

1. Jobs tagged with the "normal" QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. The account the job is submitted to will be charged 1 GPU hour for each GPU this job uses per hour (this is tracked by the minute).
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the "preemptible" QOS subject to the following policies:
   1. Jobs have a low priority and **t****here is no expectation of job start time.** If the partition is very busy with jobs using the "normal" QOS or if you are requesting a very large job, then jobs using the "standby" QOS may take hours or days to start.
   2. The account the job is submitted to will be charged 0.25 GPU hour for each GPU this job uses per hour (this is tracked by the minute) which effectively allows jobs to use 4x as many resources as a job tagged with the "normal" qos for the same cost.
   3. These jobs can run for up to two weeks at a time.
   4. If there are not enough idle resources in this partition for a job tagged with the "normal" QOS to start, then this job may be cancelled to make room for that job. **This means it is imperative to use checkpointing if using this QOS.**

Available QOSes: "normal", "preemptible"

### Highmem Partition

This partition is made up of 6 Gautschi-B nodes which have four times as much memory as a standard Gautschi-A node, and access to this partition is given to all accounts on the cluster to enable work that has higher memory requirements. Each of these nodes contains two Zen 4 AMD EPYC 9654 96-core processors for a total of 192 cores and 1.5 TB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 8 GB of memory per core requested. Submission to this partition can be accomplished by using the option: "-p highmem" or "--partition=highmem".

When using the Highmem partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a highmem partition QOS that enforces the following policies

1. **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can have 2 jobs running in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. Your jobs must use more than 48 of the 192 cores on the node otherwise your memory footprint would fit on a standard Gautschi-A node
5. These jobs can run for up to 24 hours at a time.

Available QOSes: "normal"

### Profiling Partition

This partition is made up of 2 Gautschi-A nodes that have hardware performance counters enabled. By enabling hardware performance counters, profiling applications such as AMD MicroProf can track certain performance criteria for execution on the CPU such as L3 cache events, speculative execution misses, etc. Due to the fact that this allows greater visibility into the execution of each process, the nodes in this partition can only be used if your job uses the entire node.  Submission to this partition can be accomplished by using the option: "-p profiling" or "--partition=profiling".

When using the profiling partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a profiling partition QOS that enforces the following policies

1. **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can have 1 job running in this partition at once
3. If you have a single process running on one of the nodes, you must use that entire node when submitting to this partition
4. These jobs can run for up to 24 hours at a time.

This is a resource that is reserved for groups profiling their applications and we monitor to ensure that this partition is not being used simply for more compute.

Available QOSes: "normal"

### Smallgpu Partiton

This partition is made up of 6 Gautschi-G nodes. Each of these nodes contains two NVIDIA L40s and two Zen 4 AMD EPYC 9554 64-core processors for a total of 128 cores and 384GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node) Submission to this partition can be accomplished by using the option: "-p smallgpu" or "--partition=smallgpu".

When using the smallgpu partition, jobs are tagged by the "normal" QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a smallgpu partition QOS that enforces the following policies

1. **There is no expectation of job start time** as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can use up to 2 GPUs in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: "normal"

{::elseif resource.name == Negishi}

On Gilbreth, the required options for job submission deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts: “`sbatch --ntasks=1 --cpus-per-task=4 --partition=cpu --account=rcac --qos=standby`”

1. The number and type of resources you want (`--ntasks=1 --cpus-per-task=4`)
2. The partition where the resources are located (`--partition=cpu`)
3. The account the resources should come out of ( `--account=rcac`)
4. The quality of service (QOS) this job expects from the resources (`--qos=standby`)

Table Summary of Changes

| Use Case | Old Syntax | New Syntax |
| --- | --- | --- |
| Submit a job to your group's account | `sbatch -A mygroup` | `sbatch -A mygroup -p cpu` |
| Submit a standby job | `sbatch -A standby` | `sbatch -A mygroup -p cpu -q standby` |
| Submit a highmem job | `sbatch -A highmem` | `sbatch -A mygroup -p highmem` |
| Submit a gpu job | `sbatch -A gpu` | `sbatch -A mygroup -p gpu` |
| Submit a job to your group's interactive account | `sbatch -A interactive` | `sbatch -A mygroup -p negishi -q interactive` |

If you have used other clusters, you will be familiar with the first item. If you have not, you can read about how to format the request [on our job submission page.](https://www.rcac.purdue.edu/index.php/knowledge/negishi/run/slurm/submit) The rest of this page will focus on the last three items.

Partitions
==========

On Gilbreth, the various types of nodes on the cluster are organized into distinct partitions. This allows jobs to different node types to be charged separately and differently. This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified. Each of these partitions is subject to different limitations and has a specific use case that will be described below. 

### CPU Partition

This partition contains the resources a group purchases access to when they purchase CPU resources on Gilbreth and is made up of 446 Bell-A nodes. Each of these nodes contains two Zen 3 AMD EPYC 7763 64-core processors for a total of 128 cores and 256 GB of memory for a total of more than 57,000 cores in the partition. Memory in this partition is allocated proportional to your core request such that each core is given about 2 GB of memory per core requested. Submission to this partition can be accomplished by using the option: `-p cpu` or `--partition=cpu`.

The purchasing model for this partition allows groups to purchase high priority access to some number of cores. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, the cores used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the CPU partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any cores requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a very large job, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such cores requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### Highmem Partition

This partition is made up of 6 Bell-B nodes which have four times as much memory as a standard Bell-A node, and access to this partition is given to all accounts on the cluster to enable work that has higher memory requirements. Each of these nodes contains two Zen 2 AMD EPYC 7763 64-core processors for a total of 128 cores and 1 TB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 8 GB of memory per core requested. Submission to this partition can be accomplished by using the option: `-p highmem` or `--partition=highmem`.

When using the Highmem partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a highmem partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can have 2 jobs running in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. Your jobs must use more than 64 of the 128 cores on the node otherwise your memory footprint would fit on a standard Negishi-A node
5. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

### GPU Partition

This partition is made up of 5 Negishi-G nodes. Each of these nodes contains two AMD MI210s and two Zen 2 AMD EPYC 7313 16-core processors for a total of 32 cores and 512GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 8 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node) Submission to this partition can be accomplished by using the option: `-p gpu` or `--partition=gpu`.

When using the gpu partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a gpu partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can use up to 2 GPUs in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

### Login Partition

This partition contains the resources a group purchases access to when they purchase "interactive access" on Gilbreth. Interactive access allows submission of jobs directly to the front ends for immediate job start times. These jobs can only request up to 4 CPUs and 8 GB of memory each and interactive users can only have one job at a time. Submission to this partition can be accomplished by using the option: `-p login` or `--partition=login`. In order to use this partition, you must submit using the interactive QOS which enforces the following policies:

1. You can have one job running at a time.
2. You can use up to 4 cores and 8 GB of memory at a time.
3. Jobs can run for up to 24 hours.

Available QOSes: `interactive`

Accounts
========

On the Gilbreth community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores. To see the list of accounts that you have access to on Gilbreth as well as the resources they contain, you can use the command `slist`.

On Gilbreth, you must explicitly define the account that you want to submit to using the `-A`or`--account=` option.

Quality of Service (QOS)
========================

On Gilbreth, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs that has been tagged with a QOS named *highpriority*".

There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option `-q`or`--qos=`. By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to use that carrier, or in this case, deciding to submit to a particular partition.

The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight. On the other hand you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we also have some degree of control through choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS, but you may be able to ask for your job to be handled a particular way by specifying a job QOS offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The below list of job QOSes are QOSes that every user and every account of Gilbreth has access to:

1. `normal`: The `normal` QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. `standby`: The `standby` QOS must be explicitly used if desired by using the option `-q standby` or `--qos=standby`. The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous `-A standby` style of submission.

Some of these QOSes may not be available in every partition. Each of the partitions in the following section will enumerate which of these QOSes are allowed in the partition.

{::elseif resource.name == Bell}

On Gilbreth, the required options for job submission deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts: “`sbatch --ntasks=1 --cpus-per-task=4 --partition=cpu --account=rcac --qos=standby`”

1. The number and type of resources you want (`--ntasks=1 --cores-per-task=4`)
2. The partition where the resources are located (`--partition=cpu`)
3. The account the resources should come out of ( `--account=rcac`)
4. The quality of service (QOS) this job expects from the resources (`--qos=standby`)

Table Summary of Changes

| Use Case | Old Syntax | New Syntax |
| --- | --- | --- |
| Submit a job to your group's account | `sbatch -A mygroup` | `sbatch -A mygroup -p cpu` |
| Submit a standby job | `sbatch -A standby` | `sbatch -A mygroup -p cpu -q standby` |
| Submit a highmem job | `sbatch -A highmem` | `sbatch -A mygroup -p highmem` |
| Submit a gpu job | `sbatch -A gpu` | `sbatch -A mygroup -p gpu` |
| Submit a multigpu job | `sbatch -A multigpu` | `sbatch -A mygroup -p multigpu` |

If you have used other clusters, you will be familiar with the first item. If you have not, you can read about how to format the request [on our job submission page.](https://www.rcac.purdue.edu/index.php/knowledge/bell/run/slurm/submit) The rest of this page will focus on the last three items.

Partitions
==========

On Gilbreth, the various types of nodes on the cluster are organized into distinct partitions. This allows jobs to different node types to be charged separately and differently. This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified. Each of these partitions is subject to different limitations and has a specific use case that will be described below. 

### CPU Partition

This partition contains the resources a group purchases access to when they purchase CPU resources on Gilbreth and is made up of 488 Bell-A nodes. Each of these nodes contains two Zen 2 AMD EPYC 7662 64-core processors for a total of 128 cores and 256 GB of memory for a total of more than 62,000 cores in the partition. Memory in this partition is allocated proportional to your core request such that each core is given about 2 GB of memory per core requested. Submission to this partition can be accomplished by using the option: `-p cpu` or `--partition=cpu`.

The purchasing model for this partition allows groups to purchase high priority access to some number of cores. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, the cores used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the CPU partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any cores requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a very large job, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such cores requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### Highmem Partition

This partition is made up of 8 Bell-B nodes which have four times as much memory as a standard Bell-A node, and access to this partition is given to all accounts on the cluster to enable work that has higher memory requirements. Each of these nodes contains two Zen 2 AMD EPYC 7662 64-core processors for a total of 128 cores and 1 TB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 8 GB of memory per core requested. Submission to this partition can be accomplished by using the option: `-p highmem` or `--partition=highmem`.

When using the Highmem partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a highmem partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can have 2 jobs running in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. Your jobs must use more than 64 of the 128 cores on the node otherwise your memory footprint would fit on a standard Bell-A node
5. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

### GPU Partition

This partition is made up of 4 Bell-G nodes. Each of these nodes contains two AMD MI50s and two Zen 2 AMD EPYC 7662 64-core processors for a total of 128 cores and 256GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node) Submission to this partition can be accomplished by using the option: `-p gpu` or `--partition=gpu`.

When using the gpu partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a gpu partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can use up to 2 GPUs in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

Multi-GPU Partition
===================

This partition is made up of a single Bell-X node. Each of these nodes contains six AMD MI60s and two Intel Xeon 8268 48-core processors for a total of 96 cores and 354GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3.5 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the six GPUs, you should request 16 of the cores on the node) Submission to this partition can be accomplished by using the option: `-p multigpu` or `--partition=multigpu`.

When using the gpu partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a multigpu partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Gilbreth
2. You can use up to 6 GPUs in this partition at once
3. You can have 1 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

Accounts
========

On the Gilbreth community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores. To see the list of accounts that you have access to on Gilbreth as well as the resources they contain, you can use the command `slist`.

On Gilbreth, you must explicitly define the account that you want to submit to using the `-A`or`--account=` option.

Quality of Service (QOS)
========================

On Gilbreth, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs that has been tagged with a QOS named *highpriority*".

There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option `-q`or`--qos=`. By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to use that carrier, or in this case, deciding to submit to a particular partition.

The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight. On the other hand you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we also have some degree of control through choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS, but you may be able to ask for your job to be handled a particular way by specifying a job QOS offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The below list of job QOSes are QOSes that every user and every account of Gilbreth has access to:

1. `normal`: The `normal` QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. `standby`: The `standby` QOS must be explicitly used if desired by using the option `-q standby` or `--qos=standby`. The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous `-A standby` style of submission.

Some of these QOSes may not be available in every partition. Each of the partitions in the following section will enumerate which of these QOSes are allowed in the partition.

{::elseif resource.name == Gilbreth}

On Gilbreth, the required options for job submission deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts: “`sbatch --ntasks=1 --gpus-per-task=1 --cores-per-task=4 --mem=50G --partition=a100-40gb --account=rcac --qos=standby`”

1. The number and type of resources you want (`--ntasks=1 --cores-per-task=4 --gpus-per-task=1 --mem=50G`)
2. The partition where the resources are located (`--partition=a100-40gb`)
3. The account the resources should come out of ( `--account=rcac`)
4. The quality of service (QOS) this job expects from the resources (`--qos=standby`)

Table Summary of Changes

| Use Case | Old Syntax | New Syntax |
| --- | --- | --- |
| Submit a job to your group's account | `sbatch -A mygroup --gres=gpu:1` | `sbatch -A mygroup -p a100-40gb --mem=50G --gres=gpu:1` |
| Submit a standby job | `sbatch -A standby --gres=gpu:1` | `sbatch -A mygroup -p a100-40gb -q standby --mem=50G --gres=gpu:1` |
| Submit a training job | `sbatch -A training --gres=gpu:4` | `sbatch -A mygroup -p training -q training --mem=50G --gres=gpu:4` |

If you have used other clusters, you will be familiar with the first item. If you have not, you can read about how to format the request [on our job submission page.](https://www.rcac.purdue.edu/index.php/knowledge/gilbreth/run/slurm/submit) The rest of this page will focus on the last three items.

Partitions
==========

On Gilbreth, the various types of nodes on the cluster are organized into distinct partitions. This allows jobs to different node types to be charged separately and differently. This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified. Each of these partitions is subject to different limitations and has a specific use case that will be described below. 

### 

### V100 Partition

This partition contains the resources a group purchases access to when they purchase V100 GPUs on Gilbreth and is made up of 14 Gilbreth-E nodes and 5 Gilbreth-F nodes. Each of these nodes contains NVIDIA V100 GPUs each with 16GB and 32GB of memory respectively, and they both have 190GB of CPU memory. Submission to this partition can be accomplished by using the option: `-p v100`or `--partition=v100`. If you know that your job requires more than 16 GB of GPU memory, make sure that you specify the `--constraint=v100-32gb` to ensure your job lands on the Gilbreth-F nodes.

The purchasing model for this partition allows groups to purchase high priority access to these GPUs. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, which is the default QOS, the GPUs used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the A100 partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any GPUs requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a job requesting many GPUs, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### A10 Partition

This partition contains the resources a group purchases access to when they purchase A10 GPUs on Gilbreth and is made up of 16 Gilbreth-H nodes. Each of these nodes contains three NVIDIA A10 GPUs each with 24GB of memory. In this partition, nodes have 512GB of CPU memory, and you should request memory proportional the number of GPUs you request. Submission to this partition can be accomplished by using the option: `-p a10`or `--partition=a10`.

The purchasing model for this partition allows groups to purchase high priority access to these GPUs. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, which is the default QOS, the GPUs used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the A10 partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any GPUs requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a job requesting many GPUs, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### A30 Partition

This partition contains the resources a group purchases access to when they purchase A30 GPUs on Gilbreth and is made up of 16 Gilbreth-B nodes and 8 Gilbreth-D nodes. Each of these nodes contains three NVIDIA A30 GPUs each with 24GB of memory. In this partition, nodes have 190GB of CPU memory, and you should request memory proportional the number of GPUs you request. Submission to this partition can be accomplished by using the option: `-p a30`or `--partition=a30`.

The purchasing model for this partition allows groups to purchase high priority access to these GPUs. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, which is the default QOS, the GPUs used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the A30 partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any GPUs requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a job requesting many GPUs, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### A100-40GB Partition

This partition contains the resources a group purchases access to when they purchase A100-40GB GPUs on Gilbreth and is made up of 12 Gilbreth-G nodes and 20 Gilbreth-N nodes. Each of these nodes contains NVIDIA A100 GPUs each with 40GB of memory. The Gilbreth-G nodes contain 2 GPUs and 510GB of CPU memory and the Gilbreth-N nodes contain 4 GPUs and 1 TB of CPU memory. Additionally, the GPUs in the Gilbreth-N partition have an NVLink connection, and when using multiple GPUs for a single task the `--constraint='nvlink'` option should be used to ensure your job lands on the NVLinked nodes. Submission to this partition can be accomplished by using the option: `-p a100-40gb`or `--partition=a100-40gb`.

The purchasing model for this partition allows groups to purchase high priority access to these GPUs. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, which is the default QOS, the GPUs used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the A100 partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any GPUs requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a job requesting many GPUs, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### A100-80GB Partition

This partition contains the resources a group purchases access to when they purchase A100-40GB GPUs on Gilbreth and is made up of 5 Gilbreth-I nodes and 52 Gilbreth-K nodes. Each of these nodes contains NVIDIA A100 GPUs each with 80GB of memory. Each node contains 2 GPUs and 512GB of CPU memory. Submission to this partition can be accomplished by using the option: `-p a100-80gb`or `--partition=a100-80gb`.

The purchasing model for this partition allows groups to purchase high priority access to these GPUs. When an account uses resources in this account by submitting a job tagged with the `normal` QOS, which is the default QOS, the GPUs used by that job are withdrawn from the account and deposited back into the account when the job terminates.

When using the A100 partition, jobs are tagged by the `normal` QOS by default, but they can be tagged with the `standby` QOS if explicitly submitted using the `-q standby` or `--qos=standby` option.

1. Jobs tagged with the `normal` QOS are subject to the following policies:
   1. Jobs have a high priority and should not need to wait very long before starting.
   2. Any GPUs requested by these jobs are withdrawn from the account until the job terminates.
   3. These jobs can run for up to two weeks at a time.
2. Jobs tagged with the `standby` QOS are subject to the following policies:
   1. Jobs have a low priority and there is no expectation of job start time. If the partition is very busy with jobs using the `normal` QOS or if you are requesting a job requesting many GPUs, then jobs using the `standby` QOS may take hours or days to start.
   2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
   3. These jobs can run for up to four hours at a time.

Available QOSes: `normal`, `standby`

### Training Partition

This partition contains the a pool of shared resources available to groups who have demonstrated that their workflows contain processes requiring more than 2 GPUs at once. This partition is made up of nodes containing 4 GPUs each. There are 3 types of nodes in this partition:  
1. Three Gilbreth-C nodes containing 4 NVIDIA V100s

2. Three Gilbreth-J nodes containing 4 NVIDIA A100s

3. Two Gilbreth-l nodes containing 4 NVIDIA H100s

Submission to this partition can be accomplished by using the option: `-p training`or `--partition=training`. In order to request a particular node type,

When using the training partition, jobs *must* be tagged with the `training` QOS. Additionally jobs will be tagged with the training partition QOS which enforces the following policies:

1. Jobs have a low priority andthere is no expectation of job start time
2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
3. These jobs can run for up to 24 hours at a time.

Available QOSes: `training`

Accounts
========

On the Gilbreth community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores. To see the list of accounts that you have access to on Gilbreth as well as the resources they contain, you can use the command `slist`.

On Gilbreth, you must explicitly define the account that you want to submit to using the `-A`or`--account=` option.

Quality of Service (QOS)
========================

On Gilbreth, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs that has been tagged with a QOS named *highpriority*".

There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option `-q`or`--qos=`. By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to use that carrier, or in this case, deciding to submit to a particular partition.

The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight. On the other hand you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we also have some degree of control through choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS, but you may be able to ask for your job to be handled a particular way by specifying a job QOS offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The below list of job QOSes are QOSes that every user and every account of Gilbreth has access to:

1. `normal`: The `normal` QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. `standby`: The `standby` QOS must be explicitly used if desired by using the option `-q standby` or `--qos=standby`. The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous `-A standby` style of submission.

{::else} {::if resource.queuemodel == dedicated}

### "mylab" Queues

Gilbreth, as a community cluster, has one or more queues dedicated to and named after each partner who has purchased access to the cluster. These queues provide partners and their researchers with priority access to their portion of the cluster. Jobs in these queues are typically limited to 336 hours. **The expectation is that any jobs submitted to your research lab queues will start within 4 hours, assuming the queue currently has enough capacity for the job** (that is, your lab mates aren't using all of the cores currently).

{::elseif resource.queuemodel == partner}

### Partner Queue

Gilbreth provides partners and their researchers shared access to the cluster through a shared `partner` queue. This is the default queue for submitting short to moderately long jobs. It allows jobs up to 24 hours and lets researchers run up to 3 jobs simultaneously. **The expectation is that any jobs submitted to the `partner` queue will start within 4 hours, assuming the queue currently has enough capacity for the job**.

### Dedicated Queues

If a research group has purchased dedicated access to Gilbreth there will be a queue named after the faculty or research group. These queues provide faculty and their researchers with priority access to their portion of the cluster. Jobs in these queues are typically limited to 336 hours. **The expectation is that any jobs submitted to dedicated queues will start within 4 hours, assuming the queue currently has enough capacity for the job** (that is, your lab mates aren't using all of the cores currently).

{::/} {::if resource.name == Scholar}

### Scholar Queue

This is the default queue for submitting jobs on Scholar. The maximum walltime on `scholar` queue is 4 hours.

### Long Queue

If your job requires more than 4 hours to complete, you can submit it to the `long` queue. The maximum walltime is 3 days. There are only 5 nodes in this queue, so you may have to wait for some time to get access to a node.

### GPU Queue

If your job needs access to an Nvidia GPU accelerator, then use the `gpu` queue. The maximum walltime is 4 hours.

{::/} {::if resource.name == Gilbreth}

### Training Queue

If your job can scale well to multiple GPUs and it requires longer than 24 hours, then use the `training` queue. Since the `training` nodes have specialty hardware and are few in number, these are restricted to users whose workloads can scale well with the number of GPUs. Please note that staff may ask you to provide evidence that your jobs can fully utilize the GPUs, before granting access to this queue. The Max wall time is 3 days, the number of jobs a user could concurrently run is 2, and the total number of consumed GPUs is 8. There are only 5 nodes in this queue, so you may have to wait a considerable amount of time before your job is scheduled.

{::/} {::if resource.standby == true}

### Standby Queue

Additionally, community clusters provide a "${resource.queue}" queue which is available to all cluster users. This "${resource.queue}" queue allows users to utilize portions of the cluster that would otherwise be idle, but at a lower priority than partner-queue jobs, and with a relatively short time limit, to ensure "${resource.queue}" jobs will not be able to tie up resources and prevent partner-queue jobs from running quickly. Jobs in standby are limited to 4 hours. **There is no expectation of job start time.** If the cluster is very busy with partner queue jobs, or you are requesting a very large job, jobs in standby may take hours or days to start.

{::/} {::if resource.name == Gilbreth}

### Debug Queue

The debug queue allows you to quickly start small, short, interactive jobs in order to debug code, test programs, or test configurations. You are limited to one running job at a time in the queue, and you may run up to two GPUs for 30 minutes. The expectation is that debug jobs should start within a couple of minutes, assuming all of its dedicated nodes are not taken by others.

{::else} {::if resource.debug == true}

### Debug Queue

The debug queue allows you to quickly start small, short, interactive jobs in order to debug code, test programs, or test configurations. You are limited to one running job at a time in the queue, and you may run up to two compute nodes for 30 minutes. The expectation is that debug jobs should start within a couple of minutes, assuming all of its dedicated nodes are not taken by others.

{::/} {::/}

### List of Queues

{::if resource.batchsystem == slurm}

To see a list of all queues on Gilbreth that you may submit to, use the `slist` command

This lists each queue you can submit to, the number of nodes allocated to the queue, how many are available to run jobs, and the maximum walltime you may request. Options to the command will give more detailed information. This command can be used to get a general idea of how busy an individual queue is and how long you may have to wait for your job to start.

{::/} {::if resource.name == Gilbreth} The default output mode of `slist` command shows the available **GPU** counts in queues:

```
$ slist

                      Current Number of GPUs                        Node
Account           Total    Queue     Run    Free    Max Walltime    Type
==============  =================================  ==============  ======
debug               183        0       0     183      00:30:00     B,D,E,F,G,H,I
standby             183       77      55      98      04:00:00     B,D,E,F,G,H,I
training             20        0       8      12     3-00:00:00    C,J
mylab                80        0       0      80    14-00:00:00    F
```

To check the number of **CPUs** mounted on each queue, please use `slist -c` command.

### Summary of Queues

Gilbreth contains several queues and heterogeneous hardware consisting of different number of cores and different GPU models. Some queues are backed by only one node type, but some queues may land on multiple node types. On queues that land on multiple node types, you will need to be mindful of your resource request. Below are the current combinations of queues, GPU types, and resources you may request.

Gilbreth queues

| Queue | GPU Type | Number of GPUs per node | Intended use-case | Max walltime | Max GPUs pre user concurrently | Max Jobs running per user |
| --- | --- | --- | --- | --- | --- | --- |
| Standby | V100 (16 GB), V100 (32 GB), A100 (40 GB), A100 (80 GB), A10 (24 GB), A30 (24 GB) | 16 (2), 40 (2), 128 (2), 128 (2), 32 (3), 24/16 (3) | Short to moderately long jobs | 4 hours | 16 | 16 |
| training | V100 (32 GB, NVLink), A100 (80GB, NVLink) | 20 (4), 128 (4) | Long jobs that can scale well to multiple GPUs, such as Deep Learning model training | 3 days | 8 | 2 |
| debug | V100 (16 GB), V100 (32 GB), A100 (40 GB), A100 (80 GB), A10 (24 GB), A30 (24 GB) | 16 (2), 40 (2), 128 (2), 128 (2), 32 (3), 24/16 (3) | Quick testing | 30 mins | 2 | 1 |
| "mylab" | Based on Purchase | Based on Purchase | There will be a separate queue for each type of GPU the partners have purchased. | 2 Weeks | Amount Purchased | Based on Purchase |

{::/} {::if resource.name == Gautschi} The default output mode of `slist` command shows the available **GPU** counts in queues:

```
$ slist

                      Current Number of GPUs                        Node
Account           Total    Queue     Run    Free    Max Walltime    Type
==============  =================================  ==============  ======
debug               183        0       0     183      00:30:00     B,D,E,F,G,H,I
standby             183       77      55      98      04:00:00     B,D,E,F,G,H,I
training             20        0       8      12     3-00:00:00    C,J
mylab                80        0       0      80    14-00:00:00    F
```

To check the number of **CPUs** mounted on each queue, please use `slist -c` command.

### Summary of Queues

Gilbreth contains several queues and heterogeneous hardware consisting of different number of cores and different GPU models. Some queues are backed by only one node type, but some queues may land on multiple node types. On queues that land on multiple node types, you will need to be mindful of your resource request. Below are the current combinations of queues, GPU types, and resources you may request.

Gilbreth queues

| Queue | GPU Type | Number of GPUs per node | Intended use-case | Max walltime | Max GPUs pre user concurrently | Max Jobs running per user |
| --- | --- | --- | --- | --- | --- | --- |
| Standby | V100 (16 GB), V100 (32 GB), A100 (40 GB), A100 (80 GB), A10 (24 GB), A30 (24 GB) | 16 (2), 40 (2), 128 (2), 128 (2), 32 (3), 24/16 (3) | Short to moderately long jobs | 4 hours | 16 | 16 |
| training | V100 (32 GB, NVLink), A100 (80GB, NVLink) | 20 (4), 128 (4) | Long jobs that can scale well to multiple GPUs, such as Deep Learning model training | 3 days | 8 | 2 |
| debug | V100 (16 GB), V100 (32 GB), A100 (40 GB), A100 (80 GB), A10 (24 GB), A30 (24 GB) | 16 (2), 40 (2), 128 (2), 128 (2), 32 (3), 24/16 (3) | Quick testing | 30 mins | 2 | 1 |
| "mylab" | Based on Purchase | Based on Purchase | There will be a separate queue for each type of GPU the partners have purchased. | 2 Weeks | Amount Purchased | Based on Purchase |

{::/} {::/}