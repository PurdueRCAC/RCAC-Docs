---
title: HyperShell User Guide
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# HyperShell User Guide

HyperShell runs shell commands over a distributed, asynchronous queue. You give it a file of
commands, one task per line, and it runs them across whatever resources you give it: the cores of
one node, the nodes of one Slurm job, or clients that join from many jobs. A server holds the
queue, clients on compute nodes run the tasks, and a database records every task: its command,
where and when it ran, how long it took, and its exit status. RCAC builds HyperShell and recommends
it as the primary workflow tool on its clusters; [Workflow Automation](../index.md) explains why
and where other tools fit better.

This guide is written in tiers. Each tier adds what a bigger or longer-lived kind of work needs, and
each says who it is for and when to move on. Most readers need only the first: one job script that
runs a whole task list, picks up where it stopped when it is resubmitted, and tells you afterward
which tasks failed.

## HyperShell versions

!!! important "Purdue is HyperShell's home: check your version"

    Purdue is the primary site of HyperShell's development, and new versions with fixes and
    features reach RCAC's clusters often, through module updates. This guide documents
    HyperShell 2.9.0. Load the module and check which version you have:

    ```bash
    module load hypershell
    hs --version
    ```

    The default module version can differ from one cluster to another. Each page in this guide
    states the minimum version its features need; if your cluster's default is older, run
    `module spider hypershell` to see the versions installed there. If an older module, such as
    2.7.0, will read your HyperShell configuration file, leave `server.auth_eval` and
    `server.auth_env` out of it: 2.7.0 stops at start with `'auth' has more than one variant`
    when it finds either.

## The tiers

Start with tier 1. Move to a later tier only when your work has outgrown the one before it.

| Tier | Who it is for | What it adds | Move on when |
|---|---|---|---|
| [Tier 1: One Job Script](single_job.md) | Anyone with a list of independent commands, from hundreds to hundreds of thousands, that fits in one Slurm job or a few resubmissions of it. That is most readers. | `hsx` over a task file in one job, on one node or several; resubmitting picks up where the last job stopped; checking and re-running failures | Your work has phases that must run in order, needs different hardware per phase, is submitted over days, or has more tasks than one job can get through |
| [GPU Multiplexing](gpu_multiplexing.md) | Tier 1 readers whose tasks each use a fraction of a large GPU, such as small models, short inference runs or small renders | Several tasks at once on each GPU of a job | Each task fills a GPU on its own |
| [Tier 2: Extreme Scale](extreme_scale.md) | Readers with millions of tasks lasting seconds each, or anyone running HyperShell at a leadership-class facility. Purdue workloads rarely need it. | Bundling, staggered client starts, and running without the database | Throughput is fine with the defaults (go back to tier 1), or your problem is structure rather than scale (tier 3) |
| Tier 3: A Pipeline on One Cluster | Groups whose work has distinct phases and different hardware needs, and outlives any one job, all on one cluster | A persistent configuration and database, phases submitted from a login node, task groups and zones, and a helper script that schedules client jobs | The pipeline should run as a standing service, scale itself, or span clusters |
| Tier 4: A Persistent Service | Labs running a long campaign or a shared service | A server and database on Geddes, and clients that scale themselves on more than one cluster | This is the top tier |

## How HyperShell is put together

A few terms recur on every page of this guide:

- **Task file.** A plain text file with one shell command per line. Each line is one task.
- **Server.** The process that holds the queue. It reads tasks from the task file or the database
  and hands them to clients.
- **Client.** A process on a compute node that receives tasks from the server and runs them, as
  many at once as it has *executors* (set with `-N`).
- **Database.** Where the server records every task. HyperShell uses a SQLite file by default,
  and PostgreSQL for long-lived services.
- **Site directory.** The directory that holds HyperShell's database, logs and captured task
  output. Set it with the `HYPERSHELL_SITE` environment variable so that each campaign keeps its
  own; tier 1 shows how.

The `hsx` command (short for `hs cluster`) runs a server and its clients together, which is all a
single job needs. Later tiers run the server and the clients separately. The commands that read the
record, such as `hs list`, `hs info` and `hs update`, work on the database directly, so you can run
them on a login node after the job ends.

## The key that guards the queue

Clients prove themselves to the server with a shared key. In tier 1 you never see it: each `hsx`
run makes a fresh key and hands it to the clients it starts. When you run a server yourself, in
the later tiers, you supply the key in the `HYPERSHELL_SERVER_AUTH` environment variable or the
`server.auth` configuration setting. Never put it on a command line, where any user on the same
host can read it in the process list. From version 2.9.0, HyperShell refuses a key given there.

## Pages in this guide

<div class="grid cards" markdown>

-   :material-file-document-outline:{ .lg .middle } __Tier 1: One Job Script__

    ---

    One Slurm job script runs a whole task list on one node or several, resumes where it stopped,
    and re-runs exactly the failures. It covers most needs.

    [:octicons-arrow-right-24: Tier 1: One Job Script](single_job.md)

-   :material-expansion-card:{ .lg .middle } __GPU Multiplexing__

    ---

    Run several small tasks at once on each GPU of a job, and measure how many each GPU can take.

    [:octicons-arrow-right-24: GPU Multiplexing](gpu_multiplexing.md)

-   :material-speedometer:{ .lg .middle } __Tier 2: Extreme Scale__

    ---

    Options and practices for millions of short tasks, and for running HyperShell at
    leadership-class facilities. Rarely needed at Purdue.

    [:octicons-arrow-right-24: Tier 2: Extreme Scale](extreme_scale.md)

</div>

HyperShell's own documentation, with the full command and configuration reference, is at
[hypershell.readthedocs.io](https://hypershell.readthedocs.io).

[Back to Workflow Automation](../index.md){ .md-button }
