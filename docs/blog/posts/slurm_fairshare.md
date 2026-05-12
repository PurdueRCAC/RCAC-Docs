---
date:
  created: 2025-08-08
  #Sometimes, bloggers need to update a post. This might happen when you make a mistake or when something changes that you need to reflect in the post. To indicate you have edited a post, you can include an updated date in the page header.
  updated: 2026-05-06

categories:
  - Slurm

slug: job-priority-and-scheduling

tags:
  - Slurm
  - Fairuse
authors:
  - rderue
draft: false
---

# About Slurm Fairshare on RCAC clusters

The purpose of this article is to provide a deep-dive into how Slurm assigns priority to the jobs it is scheduling. The design space for such a scheduler is very large and so there are many options that Slurm provides to accommodate a variety of different clusters/policies. 

<!-- more -->

I will explain the majority of the settings that are available and all of them which we use. Our goal in designing the scheduler is to create something which is fair and reliable, and as in cryptography, the best way to create a secure and robust system is not to keep its machinations a secret, but to open it up to scrutiny from the community. I will provide you the tools needed to understand what is going on, and give you the commands you can use to inspect the system yourself. 

## How Does Slurm Schedule?

There are two primary passes Slurm makes when it schedules.

1. The primary scheduler - This is the scheduler that affects the majority of the jobs on the cluster based on the configurations we will talk about below. When it determines that a job will get to start next, it identifies the nodes that will become available next and says that this job will land on those resources once they become available.
2. The backfill scheduler - This scheduler attempts to opportunistically schedule jobs into "holes" left by the the primary scheduler. The constraint the backfill scheduler follows it that it must not delay the start of jobs scheduled by the "primary scheduler." Backfill scheduling is best explained through an example.
   
Assume that there is a large job that wants 8 nodes. By virtue of having the largest priority on the cluster, Slurm has figured out which 8 nodes will run that job next. 6 of those 8 nodes are currently idle, but the remaining 2 nodes won't be done with their current jobs for another 3 hours. Slurm will attempt to "backfill" jobs onto those 6 idle nodes as long as those "backfilled" jobs will be finished in under 3 hours such that it doesn't delay the start time of the large job.

Each of these schedulers is subject to a large number of configuration parameters that are defined in the Slurm configuration file named `slurm.conf`. You can dump the current configuration by using the command `scontrol show conf` and grep for the variables we will discuss. These parameters determine things like:
1. How frequently the scheduler evaluates jobs
	a. For the main scheduler this is set by `sched_interval`. In practice however, the scheduler also does a pass to test all pending jobs every time a job is submitted, is terminated, etc. So on a production cluster like ours, the `sched_interval` is almost never reached just based on the sheer number of jobs we serve. Instead, we limit how frequently jobs can be evaluated in order to protect the scheduler from getting overloaded by these checks through setting a `sched_min_interval`.
	b. For the backfill scheduler, this is set by `bf_interval`.
2. How many jobs are evaluated in a given evaluation cycle
	a. The main scheduler is set with `sched_max_job_start`
	b. The backfill scheduler is set with `bf_max_job_test` as well as a limit on the number of jobs that can be backfilled by any one association with `bf_max_job_assoc`. 
3. How far to look ahead into the future when determining if jobs can be backfilled
	a. These are set by `bf_window` and `bf_resolution`

### The Main Scheduler Loop
The main scheduler looks at jobs in the following order on each of its evaluation passes:

1. Jobs that can preempt 
2. Jobs with an advanced reservation
3. Partition PriorityTier 
4. Job priority 
5. Job submit time
6. Job ID

On RCAC clusters, the overwhelming majority of all scheduling considerations is determined at the 4th step--job priority. So the majority of this article will comprise exactly what determines job priority.

## What Determines Job Priority?
### The Multifactor Plugin

Slurm has 2 primary ways that it can be configured to assign priority to jobs through the value of the setting `PriorityType` in your `slurm.conf`: 1) `priority/basic` and 2) `priority/multifactor`. You can check which plugin your cluster is using by using the command `scontrol show conf | grep  PriorityType`

The basic mode of priority works exactly like a First-In/First-Out queue. All the jobs that are submitted to the scheduler wait in a line in the order they arrive and those that have been in line longest are allocated resources first. This is a very simple mechanism, and is not often used.

The multifactor mode of priority is quite a bit more sophisticated and computes a priority for each job based on multiple factors, hence the name. Those factors are:

1. **Age** - How long has the job been waiting to start?
2. **Association** - How much priority does this account have vs. other accounts or other users within the same account?
3. **Fairshare** - How much of the cluster has this association used recently relative to how many resources this association owns?
4. **JobSize** - How much priority should a job have based on how large it is? This is a really simple calculation based on the number of cores requested vs how many cores are in the cluster?
5. **Partition** - How much priority should a job have based on the partition it was submitted to?
6. **QOS** - Does the quality of service that this job was tagged with give it any higher priority?
7. **TRES** - This allows for more granular control of "job size" on the basis of **T**rackable **RES** type, so you can affect priority of jobs based on the basis of GPUs or memory rather than just CPUs.

The Slurm administrators of the cluster can configure each of these factors to be weighted differently based on how important they determine each contributing factor to be. If you're interested in seeing their weights, you can use the command: `scontrol show conf | grep  PriorityWeight`. The PriorityWeight for each factor determines its maximum contribution to a job's priority

### Breaking down the Factors

**Age:**

The age of a job is how long the job has been waiting *from the time that Slurm deems it eligible to run*. Jobs that have been waiting longer have a higher priority from this factor. The exact value of this factor is a relatively simple calculation. It's the `AgePriorityWeight` * `% of PriorityMaxAge`. The `PriorityMaxAge` is another configuration parameter that can be viewed by using the command `scontrol show conf | grep PriorityMaxAge`. This parameter defines the time it takes for a job to reach its maximum age priority. 

The tricky part of a job's age is that italicized portion of the preceding paragraph. We are somewhat restricted to the definition of what Slurm determines an eligible job to be. In my experience, this definition has been somewhat dubious. For example, on one of our clusters, we may have a limit on the number of resources any one user can run under a particular quality of service at any given time. Let's say it's 24 GPUs. If a user submits 100 jobs each requesting a single GPU, one might assume that only the first 24 jobs would be considered eligible, but this is not the case. At the time of submission all 100 jobs begin accruing age priority despite the 25th-48th job needing to wait for the first 24 jobs to complete. Without some mechanism to block this, a user could submit a large battery of jobs, the majority of which are initially ineligible to start, and starve out the rest of the users by accruing age priority over newly submitted jobs.

In order to get solve this, we use some of the available Quality of Service options that take the form of `MaxJobsAccruePerXXX`. That `XXX` could be per user, per account, etc. but it is always some entity. These options restrict the number of jobs that a given entity is able to have accruing age priority at once. You can inspect the value of these settings by using the command `sacctmgr show qos <qos_name> format=MaxJobsAccruePA,MaxJobsAccruePU`. For example on one of our clusters, the `normal` qos does not allow any account to have more than 4 jobs accruing age priority at once:

```bash
rderue@login05.gautschi:[~] $ sacctmgr show qos normal format=maxjobsaccruepa    MaxJobsAccruePA                                                                  
---------------                                                                  
              4
```

We use these options anywhere that the `PriorityWeightAge` is the dominant discriminating factor which you will learn more about in the Fairshare section below.

**Association:**

An association refers to a specific combination of an account and user. Optionally, this could also include a partition, but on our clusters this is frequently not the case. The account can have a predefined amount of priority and the user's association can also have a predefined amount of priority. This factor is the contribution of both of those terms. On RCAC clusters, we do not use this factor and all accounts have equal association priority.

**Fairshare:**

Fairshare is probably one of the most commonly misunderstood topics in Slurm's scheduling algorithm. On a shared cluster, everyone "owns" some portion of the cluster known as their "share". On RCAC clusters, Accounts are the only entity which have a "share", but on other clusters users within an account may also have their own shares within the account. The idea of "FairShare" is simple. Slurm calculates the percentage of the cluster you own by taking your number of shares (referred to as "Raw Shares") and dividing it by the total number of Raw Shares on the cluster. This calculated percentage is referred to as Normalized Shares or "NormShares".

Your normalized shares represent the percentage of cycles that you should get on the cluster, and so Slurm also calculates an "effective usage" by dividing your utilization by the sum of the total utilization of the cluster and prioritizes or de-prioritizes your jobs based on whether your effective usage is lower or higher than your normalized shares respectively.

Utilization is also dynamic. Someone who ran a large number of jobs should not be permanently penalized in their fairshare for that, and so Slurm has a mechanism to weight your utilization around jobs that have been ran more recently. This mechanism is a half-life decay. Through a configurable parameter, `PriorityDecayHalfLife`, a period is set wherein Slurm slowly decays the utilization of a job such that by the time that period has elapsed, the job is only contributing half of its initial utilization. After another period, that job will have decayed to quarter of its utilization and so forth. You can view the value of that period by using the command: `scontrol show conf | grep PriorityDecayHalfLife`.

You can also view the current values of everyone's utilization by using the `sshare` command.

```bash
rderue@login00.negishi:[~] $ sshare -o account%12,rawshares,normshares,rawusage,effectvusage 
                           
     Account  RawShares  NormShares    RawUsage  EffectvUsage                    
------------ ---------- ----------- ----------- -------------                    
     root                0.000000 41981818458      1.000000                    
	     xxx        256    0.001923     5217291      0.000124                    
	     xxx        128    0.000961           0      0.000000                    
	     xxx        448    0.003365    39970339      0.000952
       xxx        576    0.004326           0      0.000000                    
	     yyy       1024    0.007691   914898553      0.021793
```

!!! note
    I did specify output options to exclude some of the default fields for brevity.

In the above example, you can see that users in the account `yyy` have effectively accounted for 2.18% of all the clusters recent cycles despite only owning 0.8% of the cluster and so you can expect the fairshare component of priority to be de-prioritizing jobs until that effective usage is decayed. The Fairshare is calculated as `Fairshare=2^(-EffectvUsage/NormShares)`. A higher value here means the job is more likely to be prioritized.

At RCAC, we have clusters that use Fairshare and we have other clusters that do not. The rule of thumb is that if the cluster works on a "credit", "Service Unit (SU)", or "GPU Hours" model, it does not use Fairshare. At the time of writing this, those cluster are Gautschi and Anvil. On both of these clusters, the `PriorityWeightFairshare` is set to zero.

The reason for this is that the variable that limits credits on a cluster (`GrpTRESMins`) uses the same internal variable as utilization under the hood. Clever readers will realize that because of the way that the aforementioned `PriorityDecayHalfLife` works, this would cause those utilized credits to slowly be regenerated at the same rate that the utilization is decayed. For that reason, you will also find that on these clusters `PriorityDecayHalfLife` is also set to zero meaning no utilization is ever decayed. For this reason, Fairshare does not make sense on these clusters and instead the `Age` factor is the most important distinguishing factor between similar jobs.

**JobSize:**

This term can be set to either prioritize large jobs (the default behavior) or small jobs. It may seem counter intuitive to prioritize larger jobs, however in the absence of giving those jobs elevated priority, smaller jobs will starve out the resources the larger jobs need because it's easier to find smaller chunks of resources. As well, its advantageous to all users that large jobs are scheduled greedily due to backfill scheduling. 

The shortcoming of this JobSize factor is that Slurm's concept of JobSize is very dated in the era of accelerators. This value is calculated by taking the number of CPUs requested by the job and dividing it by the total number of CPUs in the system, however in today's era of HPC, the resources that make a large job "large" are often non-cpu resources like memory, GPUs, or fast interconnects.

**Partition:**

Partitions can also be configured to provide some priority to the jobs running in them. This is really only useful on clusters where nodes belong to multiple partitions. If all jobs competing for a node in a partition belong to the same partition, then this priority contribution is not distinguishing any job from another. On RCAC clusters, nodes typically only belong to one partition and so we don't use this factor.

**QOS:**

A Quality of Service (QOS) can also contribute priority to a job. If there exists a class of jobs that should always run before another, then we can use this factor to prioritize the jobs that are tagged with one QOS from the ones that are tagged with the other. On RCAC clusters, this is exactly what we do with our "standby" jobs vs. non-standby jobs.

When you don't specify a QOS, you are automatically assigned your default QOS. Oftentimes, this is the QOS Slurm creates by default named "normal". We assign a high QOS priority to "normal" jobs, and we assign zero QOS priority to "standby" jobs. We set these values to be a magnitude such that no other factor matters when determining whether a "normal" or "standby" job will start next. If a "normal" job is eligible to start, it will start over the "standby" job. However, the other factors do determine *which* of the "normal" jobs will start next.

**TRES:**

This factor is slowly starting to replace the JobSize factor described above. This allows us to weight each of the different TRESes a job is requesting to allow Slurm to calculate a "job size" that isn't solely based on the number of CPUs requested.

## Inspecting Job Priorities

Slurm provides tooling to actually inspect the contributing factors to priority for all jobs running on the cluster through its tool `sprio`. `sprio` takes the same filtering options that you are probably familiar with through your use of `squeue`. We'll look at two examples of using this tool. One will be on Gautschi where job priority is primarily determined by age/qos, and another on Negishi where job priority is primarily determined by fairshare/qos. Here is an example output on one of our cluster's below.

### Age/QOS Example

```bash
rderue@login05.gautschi:[~] $ sprio -p ai -o "%7i %7o %4Y %3A %9F %10n %3Q %P" | sort -k3 -n -r
JOBID   ACCOUNT PRIO AGE FAIRSHARE QOSNAME    QOS PARTITION
9676722 xxx     1142 141 0         normal     500 500
9688135 xxx     1045 44  0         normal     500 500
9690774 xxx     1010 10  0         normal     500 500
9766996 yyy     1008 8   0         normal     500 500
9691471 xxx     1006 6   0         normal     500 500
9769820 zzz     1005 5   0         normal     500 500
9769672 bbb     1005 5   0         normal     500 500
9769671 bbb     1005 5   0         normal     500 500
9769622 zzz     1005 5   0         normal     500 500
9770186 ccc     1004 4   0         normal     500 500
9770033 ccc     1004 4   0         normal     500 500
9771091 aaa     1003 3   0         normal     500 500
9771085 aaa     1003 3   0         normal     500 500
9771079 aaa     1003 3   0         normal     500 500
9770698 aaa     1003 3   0         normal     500 500
9770641 rrr     1003 3   0         normal     500 500
9770565 sss     1003 3   0         normal     500 500
9771493 eee     1002 1   0         normal     500 500
9771406 eee     1002 2   0         normal     500 500
9769674 bbb     1002 2   0         normal     500 500
9769673 bbb     1002 2   0         normal     500 500
9771703 ccc     1001 1   0         normal     500 500
9771758 ddd     1000 0   0         normal     500 500
9771757 ddd     1000 0   0         normal     500 500
9771756 ddd     1000 0   0         normal     500 500
9745674 xxx     1000 0   0         normal     500 500
9745445 xxx     1000 0   0         normal     500 500
9745444 xxx     1000 0   0         normal     500 500
9730623 xxx     1000 0   0         normal     500 500
9699179 xxx     1000 0   0         normal     500 500
9678360 xxx     511  11  0         preemptibl 0   500
9692295 xxx     505  5   0         preemptibl 0   500

```

!!! note
    I have anonymized this data and specified format specifiers for readability. You will probably want to use `sprio -l`.

There are a few points glean from the above example:

1. First, we can see that the only two columns differentiating priority between jobs are Age and QOS. All jobs share the same partition and so the priority conferred there is not doing anything to affect the decision of which job gets to go next.
2. We can see that account "xxx" has several jobs on the cluster. Most are making use of the `normal` QOS, and as a result only four such jobs have a non-zero age-priority. This ensures that while throughput remains high (This cluster is currently at 100% utilization), all accounts are getting a turn. When their next job starts, the oldest of their jobs will begin accruing age priority.
3. We can see that the lower-priority preemptible QOS drastically decreases job priority by virtue of conferring no priority to the job. This ensures that preemptible jobs will only start if there are idle jobs on the cluster and no normal jobs that aren't already assigned resources.


### Fairshare/QOS Example

```bash
rderue@login00.negishi:[~] $ sprio -p cpu -o "%7i %7o %8Y %3A %9F %10n %5Q %P" | sort -k3 -n -r
JOBID   ACCOUNT PRIORITY AGE FAIRSHARE  QOSNAME     QOS   PARTITION
3698751 aaa     93522      0   38023     normal     55000 500
3698751 aaa     93522      0   38023     normal     55000 500
3698761 bbb     77954      0   22454     normal     55000 500
3698760 bbb     77954      0   22454     normal     55000 500
3698760 bbb     77954      0   22454     normal     55000 500
3697866 ccc     77561      4   22057     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698348 ddd     77289      2   21788     normal     55000 500
3698275 eee     12082      3   11580     standby    0     500
3698275 eee     12082      3   11580     standby    0     500
3696815 eee     11709      14  11195     standby    0     500
```

!!! note
    I have anonymized this data and specified format specifiers for readability. You will probably want to use `sprio -l`

There are also a few things to note here:
1. The first things that you will notice is that the magnitude of the priority values here is larger than before. That's because when using Fairshare, we need to make sure that the weighted values are large enough that we can achieve reasonable resolution between differences in Fairshare. The size of the number here doesn't really matter--only the differences between jobs.
2. Take a look at the account "ddd". They have 6 jobs here, and all of them have non-zero age priority. On this cluster, Fairshare and QOS are the primary contributing factors, so we don't limit the number of jobs that are able to accrue priority.
3. You'll notice again that the "standby" QOS, which is the low priority QOS on this cluster, confers no priority to the job. You'll also notice that the "normal" QOS gives a much larger value than in our previous example. This is again to ensure that the magnitude in difference is large enough that a "standby" job will never be scheduled before a "normal" job.

## Takeaways

There are a few lessons to be learned here for the reader, particularly if you are a reader who uses one of our clusters.

1. **Make your resource request as modest as possible**. Users often forget that there are two separate scheduler passes and schedule jobs that are impossible to backfill. This is a mistake we see over and over again on our clusters. People request days or even two-week long jobs and their job terminates after a matter of hours. If they had requested hours initially, the backfill scheduler likely would have found an opportunity to start their job much earlier.
2. **Know whether you're on a Fairshare scheduled cluster or an Age scheduled cluster.** Check the value of `PriorityDecayHalfLife`. If it's zero, then your cluster does not have Fairshare. Knowing the type of cluster you're on will let you know how to share your resources with your labmates. If someone has a deadline coming up, consider how your usage will affect them.
3. **Use sshare/sprio if you think that something is wrong**. These are very useful tools to debug why your jobs aren't scheduling as fast as you think they should. Often times, this will help you to debug what is de-prioritizing your job, and if you can't you can always email us at [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu).
