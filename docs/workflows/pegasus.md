---
title: Pegasus
tags:
  - Workflows
  - Pegasus
authors:
  - glentner
search:
  boost: 2
---

# Pegasus

The Pegasus Workflow Management System, from the University of Southern California's Information
Sciences Institute, is a workflow *planner*. You describe an abstract workflow: the jobs, the
files each one reads and writes, and the order that follows from them, with no mention of where
anything runs. Pegasus then plans that workflow onto a particular site. It adds the jobs that
move input data in, move results out, register outputs and clean up intermediate files, and
hands the resulting plan to HTCondor's DAG manager (DAGMan) to run. Pegasus itself runs none of
your work. Its documentation is at
[pegasus.isi.edu/documentation](https://pegasus.isi.edu/documentation/).

## How Pegasus describes work

You write the workflow as a Python program that uses Pegasus's API to create jobs and files and
connect them. Three catalogs tell the planner the rest: where the input files live (the replica
catalog), where each program is installed (the transformation catalog), and what each execution
site offers (the site catalog). The `pegasus-plan` command combines the workflow with the
catalogs into an executable plan and can submit it in the same step. While the workflow runs,
Pegasus records every job's outcome in a database you can query for monitoring and provenance.

## Pegasus at RCAC

Pegasus is not installed as a module on any RCAC cluster, and no HTCondor module or
command is available on the clusters' login nodes. Pegasus reaches RCAC users through Anvil, by two
hosted routes, both reached with ACCESS credentials:

| Route | Operated by | What you need | How work reaches Anvil |
|---|---|---|---|
| Pegasus in the [Anvil Notebook Service](../userguides/anvil/notebook.md#pegasus-on-anvil) | RCAC | ACCESS credentials and an Anvil allocation; nothing to install | A ready Pegasus environment in Jupyter, with HTCondor and Anvil's Slurm already connected |
| [ACCESS Pegasus](https://pegasus.access-ci.org) | The Pegasus team, for ACCESS | ACCESS credentials; for real workflows, an Anvil allocation and Anvil username, and an SSH key set up for HTCondor Annex | HTCondor Annex sends pilot jobs to Anvil under your allocation, and your workflow's jobs run inside them |

**The Anvil Notebook Service.** RCAC announced Pegasus on Anvil on 2026-03-10
([Scientific workflow management system, Pegasus, available on Anvil](https://www.rcac.purdue.edu/news/7628)).
The Notebook Service is a browser-based Jupyter environment that runs on Anvil. Its Pegasus
environment bundles Pegasus, HTCondor and a preconfigured connection to Anvil's Slurm scheduler,
so you write and debug a workflow with the Pegasus Python API or command-line tools, submit it
under your Anvil allocation, and monitor it from the notebook. The
[Anvil Notebook Service page](../userguides/anvil/notebook.md) explains how to log in.

**ACCESS Pegasus.** [ACCESS Pegasus](https://pegasus.access-ci.org) is a hosted Jupyter
environment for all ACCESS users. Its tutorial notebooks run on a small bundled resource with no
allocation needed. For real workflows, you add compute with HTCondor Annex, which sends pilot jobs
to an ACCESS cluster where you hold an allocation, Anvil among them. The ACCESS documentation
covers the [ACCESS Pegasus environment](https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/1372291083/ACCESS+Pegasus)
and the [HTCondor Annex setup](https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/564887666),
and its [Pegasus Workflows page](https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/564887553/Pegasus+Workflows)
lists the hosted Pegasus environments, including Anvil's.

**Gautschi, Gilbreth, Negishi and Scholar.** There is no verified route to Pegasus from these
clusters. Neither hosted route sends work to them, and they have no Pegasus or HTCondor
module. If your work needs Pegasus, plan to run it on Anvil through ACCESS.

## Where Pegasus wins

- **Data-heavy graphs.** The planner adds the staging, transfer, registration and cleanup jobs
  for you, with integrity checks on the data it moves, so you describe what the workflow computes
  and Pegasus works out how the data gets there.
- **Workflows across sites.** The same abstract workflow can be planned onto different sites, or
  across several, by changing the catalogs rather than the workflow.
- **Recovery and reuse.** If a run fails, Pegasus can resume from where it stopped, and it skips
  jobs whose outputs already exist.
- **Provenance.** Every job's outcome, timing and inputs are recorded, which suits work that must
  account for exactly how each result was made.

Large collaborations with data spread over many sites, such as LIGO, have used Pegasus for this
reason.

## When to bring in HyperShell

Pegasus is built for graphs whose data must be moved, tracked and cleaned up across sites. Most
many-task work on one cluster has none of that. It is a flat list of commands over files already
on the cluster's shared filesystem, and a planner, its catalogs and an HTCondor pool are cost
with nothing to show for it. For that work, on any RCAC cluster, use HyperShell, which runs the
list inside your own Slurm jobs and records every task in a database. RCAC recommends HyperShell
for flat many-task work; see [RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for
why. The [HyperShell User Guide](hypershell/index.md) in this section starts with one job script
that runs a whole task list this way.

[Back to Workflow Automation](index.md){ .md-button }
