---
date:
  created: 2026-07-30
  #Sometimes, bloggers need to update a post. This might happen when you make a mistake or when something changes that you need to reflect in the post. To indicate you have edited a post, you can include an updated date in the page header.
  #updated: 2025-09-03

categories:
  - Software

#Title will change how it's displayed on website
title: Why is My Job Waiting? Decoding the Cluster Queue

#Slug will change how it's shown in the domain url
slug: cluster_queue

tags:
  - Software
  - Slurm
authors:
  - carls113
---

Have you ever submitted a job just to wait for it to start, without knowing why it’s sitting in the queue? In this blog post, I’ll talk about how the queue works on a supercomputer, how to determine why your job is waiting, and some tips to wait less time for your jobs to start.

<!-- more -->

## What is a Scheduler?

Supercomputers are big. They have a plethora of compute nodes working simultaneously to solve a varied host of research problems. However, there needs to be order in the madness. There needs to be some kind of structured way to get access to the compute nodes instead of it being a free-for-all.

This is where a scheduler comes in. It takes everyone’s resource allocation requests (jobs) and determines the best time and node(s) to run those jobs. It does its best to be fair to everyone, something I’ll dive into in a later section.

Here at Purdue, we use the Slurm workload manager. There are other schedulers out there that you may encounter (such as Kubernetes, or PBS), and many of the same tenets apply, but we’ll focus on Slurm, as that’s the one you’ll interface with working on Purdue’s supercomputers.

So, what does Slurm do? It uses a variety of algorithms to manage a queue of resource requests from a myriad of users. It helps users to get the resources they need as fast and as fairly as it is able.

## Deciphering the cluster queue

We know that Slurm uses a queue system to mete out resources to requestors, but how would we see that queue? We can use the `squeue` command. If you run that on one of Purdue’s supercomputers, it will spit out a list of every single running and pending job on that cluster. It’s a long list. There are some optional flags that can be helpful to use:

| Flag | Meaning |
| ---- | ------- |
| `--me` | Just your own jobs |
| `-A $ACCOUNT_NAME` | Just the jobs using the `$ACCOUNT_NAME` account |
| `-p $PARTITION` | Just the jobs submitted to the specified `$PARTITION` |

For example, if you wanted to see jobs that were pending and running under your group’s account in the gpu partition, you could run: `squeue -A $GROUP_NAME -p gpu`.

`squeue` gives a lot of great information about your job, such as how many resources it has requested, what time limit it has, how long it’s been running for, and the state your job is in. There are three states that should normally show up here in the `squeue` list:

| State | Long State | Meaning |
| ----- | ---------- | ------- |
| PD | Pending | waiting to run |
| R | Running | hooray your job is running |
| CG | Completing | your job is finishing up |

!!! tip "Completing State"
     If your job stays in a completing state for a long time, contact RCAC support, who can help nudge it out of that state.

Another thing that `squeue` tells you is the job ID of the jobs, something we can use to query more information about the job. At Purdue, we’ve implemented a program named `jobinfo` that can tell you more information about your job. To use it, run `jobinfo $JOB_ID`, using the job ID from the output of `squeue`. You can run `jobinfo` on pending, running, or finished jobs. There are some lines of information that come from running `jobinfo` but the two lines important to this job post are `State` and `Waited`. `Waited` tells you how long the job has waited to start. `State` tells you what state the job is in, and if the job is Pending, it will tell you why it’s pending. In the next section, I’ll talk about what are some of the common reasons why jobs wait in the queue.

## What are common job reason codes?

Slurm has a published list of job reason codes [Job Reason Codes](https://slurm.schedmd.com/job_reason_codes.html), of which I took some of the most seen on Purdue clusters and put them here.

| Code | Meaning |
| ---- | ------- |
| `AssocGrp*` | The job's account has reached an aggregate limit. |
| `AssocMax*` | A portion of the job request exceeds a maximum limit (e.g., PerJob, PerNode) for the requested account. |
| `Max*PerAccount` | A portion of the job request exceeds the per-Account limit on the job's QOS. |
| `None` | Your job is still being evaluated by the scheduler. |
| `Priority` | One or more higher priority jobs exist for the partition associated with the job. |
| `QOSMax*` | A portion of the job request exceeds a maximum limit (e.g., PerJob, PerNode) for the requested QOS. |
| `ReqNodeNotAvail` | Likely there is a maintenance, or your job has requested a node configuration that does not exist. |
| `Reservation` | The job is waiting its reservation to become available, or the resource request extends past the end of the reservation time. |
| `Resources` | Your resources have been chosen, but are still being used by other jobs, your job should start soon. |

## How does Slurm prioritize jobs?

If Slurm handles a queue with a bunch of requests in it, how does it figure out what order to grant those requests in? It could simply be First-In-First-Out, but then you may have resources idle if a big request comes by and takes up a lot of resources and needs to wait for all those resources to be available to it. Instead, Slurm uses a priority system that takes in a couple different factors to determine the best way to allocate resources.

You can use the `sprio` command to see the priority of jobs on the cluster. By default, it shows the priority of every single pending job when you run it. This is a lot of information. To pare it down, you can use `sprio -j $JOB_ID` where `$JOB_ID` is replaced with the Slurm Job ID of the pending job you want to investigate. There are a couple different columns by default when you run the `sprio` command:

| Field | Meaning |
| ----- | ------- |
| Job ID | The Slurm identifying number |
| Partition | What part of the supercomputer the job was submitted to |
| Total priority | After all factors, the total priority of the job |
| Site priority | The admin factor of priority |
| Age priority | The age component of priority |
| Fairshare priority | The fairshare component of priority |
| Job size priority | The size component of priority |
| Partition priority | The partition component of priority |
| QoS priority | The Quality-of-Service component of priority |

On Purdue clusters, we only use some of these priority factors. The three most important ones at Purdue are `AGE`, `FAIRSHARE`, and `QOS`. And on different clusters, these weights are treated differently. For example, on Gautschi, Fairshare isn’t factored in due to technical limitations.

Slurm will go down the priority list and schedule the jobs with the highest priority first.

### Age

Age is a very important factor as it is what changes over time, giving more priority to your job the longer it is in the queue.

### Fairshare

We have a blog post that goes in depth about these factors as well as focusing on Fairshare [Fairshare blog post](https://docs.rcac.purdue.edu/blog/2025/08/08/job-priority-and-scheduling/), so for the purposes of this blog post, it suffices to say that Fairshare is a weight that deprioritizes people and groups who submit lots of jobs and gives more priority to people who don’t submit as many jobs.

### Quality of Service

On our clusters, the normal QoS gives a job a higher priority than a job using the standby or preemptible QoS would have.

## Tips to get to the top of the queue faster

While it’s difficult to maximize the priority score of your job without simply waiting, there are a couple things you can do to help your job start sooner:

### Request a realistic walltime

The shorter the job request, the easier it is for Slurm to slot your job in while waiting for a different, larger job’s resources to become available. Sometimes, you may know how long you will need the job to run, however other times it may be necessary to request a longer walltime to ensure that your job finishes.

Something else to consider is to break up your job using checkpointing. By saving the state of your job periodically, you can resume the work in a different job without losing so much time. We have another blog post specifically about checkpointing: [Checkpointing](https://docs.rcac.purdue.edu/blog/2025/10/16/preemption-checkpointing/) if you’re interested in that option.

### Request only resources that you need

The bigger your job request, the harder it is for Slurm to find resources to allocate to your job. In addition, on Purdue clusters, certain specialized hardware, such as the high-memory nodes are in higher demand than the normal CPU partition, which can make your job wait longer if you don’t need that specialized hardware. Do your best to request just over what you need, to ensure your job doesn’t fail, but also doesn’t wait for a long time for a bunch of resources to become available.
