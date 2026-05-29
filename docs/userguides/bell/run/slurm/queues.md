---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Queues

On Bell, the required options for job submission deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts: “`sbatch --ntasks=1 --cpus-per-task=4 --partition=cpu --account=rcac --qos=standby`”

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

If you have used other clusters, you will be familiar with the first item. If you have not, you can read about how to format the request [on our job submission page.](submit_script.md) The rest of this page will focus on the last three items.

## Partitions

On Bell, the various types of nodes on the cluster are organized into distinct partitions. This allows jobs to different node types to be charged separately and differently. This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified. Each of these partitions is subject to different limitations and has a specific use case that will be described below. 

### CPU Partition

This partition contains the resources a group purchases access to when they purchase CPU resources on Bell and is made up of 488 Bell-A nodes. Each of these nodes contains two Zen 2 AMD EPYC 7662 64-core processors for a total of 128 cores and 256 GB of memory for a total of more than 62,000 cores in the partition. Memory in this partition is allocated proportional to your core request such that each core is given about 2 GB of memory per core requested. Submission to this partition can be accomplished by using the option: `-p cpu` or `--partition=cpu`.

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

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Bell
2. You can have 2 jobs running in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. Your jobs must use more than 64 of the 128 cores on the node otherwise your memory footprint would fit on a standard Bell-A node
5. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

### GPU Partition

This partition is made up of 4 Bell-G nodes. Each of these nodes contains two AMD MI50s and two Zen 2 AMD EPYC 7662 64-core processors for a total of 128 cores and 256GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the two GPUs, you should request half of the cores on the node) Submission to this partition can be accomplished by using the option: `-p gpu` or `--partition=gpu`.

When using the gpu partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a gpu partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Bell
2. You can use up to 2 GPUs in this partition at once
3. You can have 8 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

### Multi-GPU Partition

This partition is made up of a single Bell-X node. Each of these nodes contains six AMD MI60s and two Intel Xeon 8268 48-core processors for a total of 96 cores and 354GB of memory. Memory in this partition is allocated proportional to your core request such that each core is given about 3.5 GB of memory per core requested. You should request cores proportional to the number of GPUs you are using in this partition (i.e. if you only need one of the six GPUs, you should request 16 of the cores on the node) Submission to this partition can be accomplished by using the option: `-p multigpu` or `--partition=multigpu`.

When using the gpu partition, jobs are tagged by the `normal` QOS by default, and this is the only QOS that is available for this partition, so there is no need to specify a QOS when using this partition. Additionally jobs are tagged by a multigpu partition QOS that enforces the following policies

1. There is no expectation of job start time as these nodes are a shared resources that are given as a bonus for purchasing access to high priority access to resources on Bell
2. You can use up to 6 GPUs in this partition at once
3. You can have 1 jobs submitted to thie partition at once
4. These jobs can run for up to 24 hours at a time.

Available QOSes: `normal`

## Accounts

On the Bell community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores. To see the list of accounts that you have access to on Bell as well as the resources they contain, you can use the command `slist`.

On Bell, you must explicitly define the account that you want to submit to using the `-A`or`--account=` option.

## Quality of Service (QOS)

On Bell, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs that has been tagged with a QOS named *highpriority*".

There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option `-q`or`--qos=`. By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to use that carrier, or in this case, deciding to submit to a particular partition.

The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight. On the other hand you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we also have some degree of control through choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS, but you may be able to ask for your job to be handled a particular way by specifying a job QOS offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The below list of job QOSes are QOSes that every user and every account of Bell has access to:

1. `normal`: The `normal` QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. `standby`: The `standby` QOS must be explicitly used if desired by using the option `-q standby` or `--qos=standby`. The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous `-A standby` style of submission.

Some of these QOSes may not be available in every partition. Each of the partitions in the following section will enumerate which of these QOSes are allowed in the partition.

## Job Submission Matrix

| Job Type | Partition | QoS | Job Submission Options | Number of Cores Per Account | Number of Jobs Per Account | Priority Accrual | Max Walltime |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PI Queue | cpu | normal | `-A "mygroup" -p cpu` | Limited to purchased cores | No limit | No Limit | 2 weeks |
| Standby Job | cpu | standby | `-A "mygroup" -p cpu -q standby` | 15360 Cores | 5000 | No Limit | 4 hours |
| Highmem Job | highmem | normal | `-A "mygroup" -p highmem` | 128 Cores | 2 | 1 | 24 hours |
| GPU Job | gpu | normal | `-A "mygroup" -p gpu` | 128 cores | 1 | 1 | 24 hours |
| Multi GPU Job | multigpu | normal | `-A "mygroup" -p multigpu` | 48 cores | 1 | 1 | 24 hours |

!!! Note
    The normal QOS is the default and does not need to be specified.

[**Back to the Running Jobs section**](../../run.md)
