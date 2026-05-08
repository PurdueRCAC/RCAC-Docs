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

# Slurm accounts, partitions, and QOS options

## Queues
On Gilbreth, the required options for job submission deviates from some of the other community clusters you might have experience using. In general every job submission will have four parts:

- The number and type of resources you want 
- The account the resources should come out of
- The quality of service (QOS) this job expects from the resources
- The partition where the resources are located

<!-- Table Summary of Changes

| Use Case | Old Syntax | New Syntax |
| --- | --- | --- |
| Submit a job to your group's account | `sbatch -A mygroup --gres=gpu:1` | `sbatch -A mygroup -p a100-40gb --mem=50G --gres=gpu:1` |
| Submit a standby job | `sbatch -A standby --gres=gpu:1` | `sbatch -A mygroup -p a100-40gb -q standby --mem=50G --gres=gpu:1` |
| Submit a training job | `sbatch -A training --gres=gpu:4` | `sbatch -A mygroup -p training -q training --mem=50G --gres=gpu:4` | -->

If you have used other clusters, you will be familiar with first item. If you have not, you can read about how to format the request  on our job submission page. The rest of this page will focus on the last three items as they are specific to Gilbreth.

## Partitions

On Gilbreth, the various types of nodes on the cluster are organized into distinct partitions. This allows jobs to different node types to be charged separately and differently. This also means that Instead of only needing to specify the account name in the job script, the desired partition must also be specified. Each of these partitions is subject to different limitations and has a specific use case that will be described below.  

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

Submission to this partition can be accomplished by using the option: `-p training`or `--partition=training`. When using the training partition, jobs *must* be tagged with the `training` QOS. Additionally jobs will be tagged with the training partition QOS which enforces the following policies:

1. Jobs have a low priority andthere is no expectation of job start time
2. These jobs can use idle resources on the cluster and as such GPUs requested by these jobs are not withdrawn from the account to which they were submitted.
3. These jobs can run for up to 24 hours at a time.

Available QOSes: `training`

## Accounts

On the Gilbreth community cluster, users will have access to one or more accounts, also known as queues. These accounts are dedicated to and named after each partner who has purchased access to the cluster, and they provide partners and their researchers with priority access to their portion of the cluster. These accounts can be thought of as bank accounts that contain the resources a group has purchased access to which may include some number of cores. To see the list of accounts that you have access to on Gilbreth as well as the resources they contain, you can use the command `slist`.

On Gilbreth, you must explicitly define the account that you want to submit to using the `-A`or`--account=` option.

## Quality of Service (QOS)

On Gilbreth, we use a Slurm concept called a Quality of Service or a QOS. A QOS can be thought of as a tag for a job that tells the scheduler how that job should be treated with respect to limits, priority, etc. The cluster administrators define the available QOSes as well as the policies for how each QOS should be treated on the cluster. A toy example of such a policy may be "no single user can have more than 200 jobs that has been tagged with a QOS named *highpriority*".

There are two classes of QOSes and a job can have both:

1. Partition QOSes: A partition QOS is a tag that is automatically added to your job when you submit to a partition that defines a partition QOS.
2. Job QOSes: A Job QOS is a tag that you explicitly give to a job using the option `-q`or`--qos=`. By explicitly tagging your jobs this way, you can choose the policy that each one of your jobs should abide by. We will describe the policies for the available job QOSes in the partition section below.

As an extended metaphor, if we think of a job as a package that we need to have shipped to some destination, then the partition can be thought of as the carrier we decide to ship our package with. That carrier is going to have some company policies that dictate how you need to label/pack that package, and that company policy is like the partition QOS. It is the policy that is enforced for simply deciding to use that carrier, or in this case, deciding to submit to a particular partition.

The Job QOS can then be thought of as the various different types of shipping options that carrier might offer. You might pay extra to have that package shipped overnight. On the other hand you may choose to pay less and have your package arrive as available. Once we decide to go with a particular carrier, we are subject to their company policy, but we also have some degree of control through choosing one of their available shipping options. In the same way, when you choose to submit to a partition, you are subject to the limits enforced by the partition QOS, but you may be able to ask for your job to be handled a particular way by specifying a job QOS offered by the partition.

In order for a job to use a Job QOS, the user submitting the job must have access to the QOS, the account the job is being submitted to must accept the QOS, and the partition the job is being submitted to must accept the QOS. The below list of job QOSes are QOSes that every user and every account of Gilbreth has access to:

1. `normal`: The `normal` QOS is the default job QOS on the cluster meaning if you do not explicitly list an alternative job QOS, your job will be tagged with this QOS. The policy for this QOS provides a high priority and does not add any additional limits.
2. `standby`: The `standby` QOS must be explicitly used if desired by using the option `-q standby` or `--qos=standby`. The policy for this QOS gives access to idle resources on the cluster. Jobs tagged with this QOS are "low priority" jobs and are only allowed to run for up to four hours at a time, however the resources used by these jobs do not count against the resources in your Account. For users of our previous clusters, usage of this QOS replaces the previous `-A standby` style of submission.

[**Back to the Running Jobs section**](index.md)