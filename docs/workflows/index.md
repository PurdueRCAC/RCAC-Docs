---
title: Workflow Automation
tags:
  - Workflows
authors:
  - glentner
search:
  boost: 2
---

# Workflow Automation

Much research computing is not one large calculation but many small ones. Think of a parameter
sweep, a conversion run over every file in a dataset, an ensemble of simulations, or the same
pipeline run on each of a thousand samples. Each task is small and mostly independent of the
others, and there are thousands or millions of them. Workflow automation tools exist to run this
kind of work well on a shared cluster.

This page explains why you need such a tool, what separates one tool from another, and where each
tool you are likely to meet fits. It ends with a recommendation. For most many-task work at
Purdue, the right tool is HyperShell, which RCAC builds and supports. This page also says plainly
where another tool is the better choice.

## Why you need a workflow tool

The obvious way to run a thousand tasks on a Slurm cluster is to submit a thousand jobs, one per
task. This **job-per-task** pattern works for a handful of tasks. At scale it fails in three ways:

- **It floods the scheduler.** Every job is an entry the scheduler must track, prioritize and
  account for. Thousands of short jobs load the scheduler that every other user depends on.
  RCAC's [HPC Exchange material on many-task workloads](../workshops/hpc_exchange/week4/workload-management.md)
  asks you to prefer the pilot-job pattern for this reason: request one job, and run many tasks
  inside it.
- **It runs into limits.** Clusters cap how many jobs one user may have running and queued. A
  campaign of many thousands of tasks hits those caps long before it finishes, and you end up
  writing loops that wait and resubmit.
- **It leaves no usable record.** When the campaign ends, what you have is scheduler accounting
  and a directory of output files. Which tasks failed? Which never ran because a job hit its
  walltime? Answering that means parsing logs by hand, and re-running only the failures means
  building that list yourself.

Each job also waits in the queue on its own. When a task runs for seconds and the queue wait is
minutes, most of the campaign's elapsed time is spent waiting.

Slurm job arrays soften the first problem, because one submission creates many array tasks. But
each array task is still a scheduler job. It counts toward your limits, it waits in the queue,
and it leaves the same record behind. A workflow tool replaces "one job per task" with "a few jobs,
many tasks each". It also keeps track of what ran and how it ended.

## What separates one tool from another

"Workflow tool" covers software built for very different jobs. Before asking which tool is best,
sort them by kind. Four questions do most of the sorting.

### Does the tool define the work, or execute it?

Some tools **define** work and hand it to something else to run. A planner such as Pegasus
compiles a workflow into a plan and runs none of it itself. Snakemake and Nextflow work out a
graph of steps, then submit each step through an executor, which on a cluster is usually Slurm.
Other tools **execute** a list of work that you give them: they take commands and run them on
the resources they have. Some tools do both. The distinction matters because the two kinds
compose: a tool that defines a graph can hand its wide steps to a tool that executes lists well.

### How do you describe the work?

- **A shell command.** You already know how to run one task from the command line, so you write
  that line once per task, or once as a template. Nothing new to learn: the description of the
  work is the work.
- **A rule-file DSL.** You write the workflow in the tool's own language, a Makefile, a Snakefile
  or a Nextflow script. You gain a precise description of inputs, outputs and dependencies. In
  exchange you restate your work inside the tool's model, and you maintain that description.
- **A programming API.** You write a program, usually in Python, that calls the tool's library to
  create tasks and pass results between them. This is the most flexible choice. It also ties the
  workflow to that language and to the tool's execution model.

### What coordinates the work, and what does it remember?

- **A single process** that runs on one node, launches the work and exits when it is done. Its
  memory is whatever it leaves on disk: file timestamps or a log file.
- **A server with workers and persisted state.** A server holds the queue, workers connect to it
  and run tasks, and the state of every task lives in a database you can query after the fact.
  Workers can come and go, on one node or across many jobs.
- **A DAG engine**, a driver process that holds a dependency graph, decides what is ready to run
  and submits it. Its state is the graph plus its own records on disk.
- **A pool manager**, a standing set of daemons that match work to machines. The pool exists
  before your work arrives and remains after it leaves.

### Is the work a flat list or a dependency graph?

In **flat** work, the tasks do not depend on each other and can run in any order. A **dependency
graph**, a directed acyclic graph (DAG), says that some tasks consume what others produce, so
order matters. Between the two sits work in **ordered phases**: every task of the first phase must
finish before any task of the second starts, with no order inside a phase.

## Where each tool sits

The table places each tool you are likely to meet on those four questions.

| Tool | Defines or executes | How work is described | What coordinates and remembers it | Flat or graph |
|---|---|---|---|---|
| [Slurm job arrays](job_arrays.md) | Executes (the scheduler runs each task as a job) | A job script and an index range | The Slurm scheduler; accounting records and your output files | Flat; whole arrays can depend on each other |
| [GNU Make](gnu_make.md) | Both, on one node | Rule-file DSL (a Makefile) | Single process; file timestamps | Graph of files |
| [GNU Parallel](gnu_parallel.md) | Executes | Shell command, with input templating | Single process; an optional job log file | Flat |
| HyperShell | Executes | Shell command, with input templating | Server with workers; a SQL database of every task | Flat, with ordered task groups |
| Snakemake | Defines; submits through executors | Rule-file DSL (a Python-based Snakefile) | DAG engine (one driver process); files plus its own state directory | Graph of files |
| Nextflow | Defines; submits through executors | Pipeline DSL (Groovy-based) | DAG engine (a dataflow driver on the JVM); a work directory and resume cache | Dataflow graph |
| Pegasus | Defines (it plans; HTCondor executes) | Programming API (Python) plus catalogs | Planner over HTCondor's DAG manager; a provenance database | Graph with data movement |
| Parsl | Both | Programming API (Python) | Driver process with pilot workers; in memory, with an optional monitoring database | Graph built at run time |
| HTCondor | Executes | Submit description file, plus a DAG file for workflows | Pool manager (standing daemons) | Flat, or a graph through its DAG manager |
| Dask | Both | Programming API (Python) | Scheduler with workers; in memory | Graph built at run time |
| Ray | Both | Programming API (Python) | Head node with workers; an in-memory object store | Graph built at run time |

Read down the last column and a pattern appears. Most of these tools are built around a
dependency graph. Now think about the work you actually have.

## The case for intentional simplicity

Most many-task work is flat. A parameter sweep runs the same model at a thousand points. A
conversion runs the same command on every file. An ensemble runs the same simulation with
different seeds. Nothing in that work depends on anything else. There is no graph to manage,
only a long list of commands, each of which you could already type at a shell prompt.

For that work, a DAG engine solves a problem you do not have. A rule-file DSL asks you to
translate a list you already have into the tool's language, and to keep that translation correct
as the work changes. A programming API wraps each command in code and ties your workflow to one
language and one library. Each choice is a cost: something new to learn, something new to debug,
and something that stands between you and the commands you want to run. None of it buys anything
when the work is a list.

What flat work does need is narrower and more practical:

- running many tasks inside a few jobs instead of one job per task;
- spreading those tasks over one node or many, as the size of the work demands;
- a durable record of every task: when it ran, where, how long it took, and how it ended;
- after an interruption, resuming without redoing finished work, and re-running exactly the tasks
  that failed.

Choosing the simplest tool that meets those needs is not a lack of sophistication. It is an
engineering judgement: you match the tool to the shape of the work, not to the most general case
you can imagine. A sophisticated workflow is often a plain list of commands, run by a tool that
does those few things very well. When the work really is a graph, the judgement changes, and the
tools built for graphs earn their cost.

## RCAC recommends HyperShell

RCAC recommends **HyperShell** as the primary supported workflow tool at Purdue. HyperShell runs
shell commands over a distributed, asynchronous queue. You give it a file of commands, one task
per line, or one command template and a list of inputs. It runs those tasks across whatever
resources it has, from one node in one job to many nodes across many jobs. A server holds the
queue, clients connect to it from compute nodes, and a database records every task: its command,
where and when it ran, how long it took, and its exit status. A single command, `hsx`, runs the
server and its clients together inside one batch job, which covers most needs.

On the four questions, HyperShell executes rather than defines; you describe work as shell
commands; a server with clients coordinates it, with state persisted in a SQL database (SQLite by
default, PostgreSQL for long-lived services); and the work is flat, with task groups for work in
ordered phases. That combination fits the needs above. Your task file is the same list you would
have written anyway. Clients join and leave, so the work spreads over as many nodes as you give
it. The database lets you ask which tasks failed and re-run exactly those, and pick up after a job
reaches its walltime without redoing finished work.

RCAC builds HyperShell, Purdue is the primary site of its development, and RCAC's community
clusters provide it as a module (`module load hypershell`). Its documentation is at
[hypershell.readthedocs.io](https://hypershell.readthedocs.io).

### What HyperShell does not do

HyperShell is a deliberate choice of scope, and its limits follow from that choice:

- **It is not a general DAG engine.** Task groups run work in ordered phases, which covers most
  staged pipelines, but HyperShell does not track which output feeds which input.
- **It does not manage data.** It relies on the cluster's shared filesystem; it does not stage
  files in or out, or schedule tasks near their data.
- **Its server is the coordination point.** One server hands out tasks. The state of every task
  is persisted in the database, so if the server stops, the record survives and a rerun continues
  from it.

### Where other tools win

Some work fits another tool better. Choose the other tool when your work matches its strength:

- **Slurm job arrays:** nothing to install, and the right fit for tens to a few hundred uniform
  tasks that each deserve their own scheduler entry, with per-task resources and accounting.
- **GNU Make:** incremental, file-driven rebuilds of a small pipeline on one node, where only
  outputs that are out of date are rebuilt.
- **GNU Parallel:** instant, zero-setup parallelism inside one job on one node, with the richest
  input templating of any tool here.
- **Snakemake:** true dependency graphs over files, with a software environment per rule and
  reruns of only what changed.
- **Nextflow:** containerized, portable pipelines, and the nf-core catalog of ready-made community
  pipelines. If an nf-core pipeline already does your analysis, use it.
- **Pegasus:** data-heavy graphs where a planner takes care of staging, cleanup, provenance and
  placement across sites for you.
- **Parsl:** workflows written as ordinary Python, whose structure is decided while they run.

These tools are not only rivals. When your work is a real graph with some very wide steps,
consider composing tools: let a workflow manager own the graph, its environments and its caching.
Let one wide, flat step run as a single task that hands a long list of commands to HyperShell
inside one allocation, instead of fanning out into thousands of scheduler jobs. A workflow manager
whose Slurm executor submits each task as its own job, as Nextflow's does, brings back the
job-per-task pattern at scale, so this composition matters most for the widest steps.

## Which tool?

A short guide to the first choice. Start at the top and stop at the first line that describes
your work.

- **Tens to a few hundred uniform tasks, each worth its own job:** a Slurm job array.
- **A small pipeline of files on one node that you rebuild as inputs change:** GNU Make.
- **A few thousand quick commands inside one single-node job, with no need for a record
  afterward:** GNU Parallel.
- **An nf-core or other community pipeline that already does your analysis:** Nextflow.
- **A genuine dependency graph over files:** Snakemake or Nextflow, possibly handing their widest
  steps to HyperShell.
- **A workflow written in Python whose structure is only known at run time:** Parsl.
- **A data-heavy, multi-site graph that needs provenance:** Pegasus.
- **Anything else made of many tasks:** a flat list of commands of any size, on one node or many,
  where you want a record of what ran and how it ended, the ability to resume, and re-runs of
  exactly the failures. Use HyperShell, with task groups if the work runs in ordered phases.

Because most many-task work is flat, that last line is where most readers land.

## Tool pages in this section

Each page says what the tool is, the work it fits, where it wins, and where HyperShell takes over.

<div class="grid cards" markdown>

-   :material-format-list-numbered:{ .lg .middle } __Slurm Job Arrays__

    ---

    The baseline: many copies of one job script from a single `sbatch`, each with its own index.

    [:octicons-arrow-right-24: Slurm Job Arrays](job_arrays.md)

-   :material-hammer-wrench:{ .lg .middle } __GNU Make__

    ---

    File-driven, incremental rebuilds of a small pipeline on one node.

    [:octicons-arrow-right-24: GNU Make](gnu_make.md)

-   :material-call-split:{ .lg .middle } __GNU Parallel__

    ---

    Zero-setup parallelism for a list of shell commands inside one single-node job.

    [:octicons-arrow-right-24: GNU Parallel](gnu_parallel.md)

</div>

## Other tools you may meet

Three more tools come up often in conversations about many-task computing. Each solves a different
problem from the tools above, and none is covered further in this section.

**HTCondor** is a distributed high-throughput computing system: a standing pool of daemons that
matches jobs to machines, with a DAG manager for workflows. It is not provided as a module on
RCAC's clusters. You would choose it when you work within a pool that runs it, such as the OSPool
or a campus pool, or through a service built on it, such as Pegasus. See the
[HTCondor documentation](https://htcondor.readthedocs.io/).

**Dask** is a Python library for parallel and distributed computing. It builds task graphs lazily,
passes data between tasks in memory, and offers parallel versions of NumPy arrays and pandas
dataframes. Choose it when you want to scale array or dataframe analysis in Python past one node;
the Dask-Jobqueue project starts Dask workers through Slurm. Install it in your own `conda` or
`uv` environment. See the [Dask documentation](https://docs.dask.org/).

**Ray** is a framework for building and scaling distributed Python and machine-learning
applications, with remote tasks, stateful actors, a shared object store, and libraries for
hyperparameter search, distributed training, serving and reinforcement learning. Choose it for
tightly coupled, stateful distributed Python. Running Ray on Slurm follows a community-supported
guide in Ray's documentation. Install it in your own `conda` or `uv` environment. See the
[Ray documentation](https://docs.ray.io/).

---

For the workflow software installed as modules on RCAC clusters, see the
[Workflow software catalog](../software/workflow_catalog.md).
