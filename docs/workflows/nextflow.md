---
title: Nextflow
tags:
  - Workflows
  - Nextflow
authors:
  - glentner
search:
  boost: 2
---

# Nextflow

Nextflow is a workflow manager for portable, reproducible data pipelines. You write a pipeline in
Nextflow's own language, which is based on Groovy: *processes* are the steps, each running a script
on its inputs, and *channels* carry data from one process to the next. Nextflow starts a process
as soon as its inputs arrive, so independent steps run side by side and the pipeline's graph
follows from how the channels connect. Each process can run in its own container, which is what
makes a Nextflow pipeline portable from a laptop to a cluster to a cloud.

Nextflow is best known for [nf-core](https://nf-co.re/), a community catalog of more than a
hundred production pipelines for genomics, transcriptomics, proteomics and more, each with test
data, documentation and containers. Nextflow's documentation is at
[docs.seqera.io/nextflow](https://docs.seqera.io/nextflow/).

## Nextflow at RCAC

RCAC's Life Sciences guides cover Nextflow in depth, and this page does not repeat them:

- [Reproducible Bioinformatics Using Nextflow](../lifesciences/guides/nextflow-gautschi.md) runs
  nf-core pipelines on Gautschi with the `nextflow` module and the `purdue_gautschi` institutional
  profile, which already holds Gautschi's Slurm and container settings. Its section on
  [reading a Nextflow pipeline](../lifesciences/guides/nextflow-gautschi.md#reading-a-nextflow-pipeline)
  walks through the structure of a pipeline.
- [Nextflow and nf-core on Negishi](../lifesciences/guides/nextflow.md) installs Nextflow and the
  nf-core tools yourself and writes a Slurm configuration for Negishi from scratch.

Nextflow is a module on Anvil, Gautschi and Negishi, and on Scholar through the BioContainers
collection. Name the version you want when you load it, for example
`module load nextflow/25.10.04`, so that a pipeline always runs on the version you tested it with.
A version listed as "through BioContainers" loads only after `module load biocontainers`:

| Cluster | `nextflow` module versions |
|---|---|
| Anvil | 22.10.1; 21.10.0 through BioContainers |
| Gautschi | 25.10.04, 26.04.2 |
| Negishi | 22.10.1, 23.04.1, 25.10.04, 26.04.2 |
| Scholar | 21.10.0 through BioContainers |

Gilbreth has no Nextflow module. There, or wherever the module versions are older than your
pipeline needs, install Nextflow yourself as the
[Negishi guide shows](../lifesciences/guides/nextflow.md#installing-nextflow); it needs Java 17 or
newer. Each nf-core pipeline states the oldest Nextflow version it supports, and Anvil's modules
are older than most current pipelines need. See
the [Nextflow catalog page](../software/apps_md/nextflow.md), or run `module spider nextflow`, for
the current list.

## How Nextflow runs on a cluster

A Nextflow run has a *head* process, which reads the pipeline and decides what is ready to run,
and the tasks it launches. Where the tasks run is set by the pipeline's configuration, not by the
pipeline itself: the `local` executor runs them on the machine the head process runs on, and the
`slurm` executor submits each task to Slurm as its own batch job and watches it. Nextflow keeps
every task's files in a `work/` directory, and `-resume` reuses the results of tasks that already
finished, so a rerun after a failure picks up where it stopped. The Life Sciences guides run the
head process in a small job of its own and explain why.

Because the `slurm` executor makes one scheduler job per task, a pipeline with thousands of short
tasks brings back the job-per-task pattern that the
[Workflow Automation landing page](index.md#why-you-need-a-workflow-tool) warns about. Nextflow's
`executor.queueSize` and `executor.submitRateLimit` settings cap how many jobs it keeps queued and
how fast it submits them; the
[Negishi guide's configuration](../lifesciences/guides/nextflow.md#a-minimal-working-config-for-negishi)
sets them. The [executor documentation](https://docs.seqera.io/nextflow/executor) lists every
executor and its settings.

## Where Nextflow wins

- **Ready-made pipelines.** If an nf-core pipeline already does your analysis, use it. Someone
  else has written, tested and documented the pipeline, and the `purdue_gautschi` profile has
  already configured it for Gautschi.
- **Portability.** The same pipeline runs on a laptop, on any cluster Nextflow has an executor for,
  or in a cloud, by changing configuration, not code.
- **Containers per step.** Each process names its own container, so the software of every step is
  pinned and reproducible.
- **Dataflow graphs.** Steps that depend on each other's outputs run in the right order, and
  independent steps run at the same time, without your writing that logic.

## When to bring in HyperShell

Nextflow is the right choice for a multi-step pipeline, above all one the nf-core community
already maintains. The Gautschi guide makes the same point from the other side: for a one-off
command, Nextflow is more than you need. When your work is a flat list of commands, with nothing
feeding anything else, a dataflow language and its containers add cost and buy nothing. Use
HyperShell for that work.

The two also compose. When a pipeline has one very wide, flat step, such as the same command over
tens of thousands of inputs, let Nextflow own the pipeline, its containers and its resume cache,
and let that step be a single process that writes the list of commands and hands it to HyperShell
inside one allocation. The step then runs as one job instead of thousands, with a record of every
task. RCAC recommends HyperShell for flat many-task work; see
[RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for why. The
[HyperShell User Guide](hypershell/index.md) in this section starts with one job script that
runs a whole task list this way.

[Back to Workflow Automation](index.md){ .md-button }
