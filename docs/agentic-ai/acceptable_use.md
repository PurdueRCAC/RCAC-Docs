---
tags:
  - Agentic AI
authors:
  - glentner
---

# Acceptable Use & Etiquette

{% set resource = "gautschi" %}

Running an agentic coding tool on RCAC's systems does not change the rules — it
raises the stakes. An agent can issue commands faster than you can read them, so
the same acceptable-use and good-citizen expectations that apply to *you* apply
to any agent acting on your behalf. **You are accountable for everything your
agent does under your account**, exactly as if you had typed it yourself. The
rules below are the etiquette for using these tools responsibly on shared HPC
resources; they are consistent with RCAC's existing Acceptable Use policy, quoted
at the bottom of this page.

## No heavy compute on the login nodes

Login (front-end) nodes are shared by every user for editing, compiling, and
submitting work — not for running it. An agent that compiles a large project,
launches a parallel run, or spins up a long-lived process on a login node
degrades the system for everyone. Keep agent activity on the front ends light,
and push real work to the scheduler. This mirrors the Gautschi Running Jobs
guidance:

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a
    front-end login host. All users share the front-end hosts, and running
    anything but the smallest test job will negatively impact everyone's ability
    to use the cluster. Always use SLURM to submit your work as a job.

## Run real work through Slurm, with time limits

Any nontrivial computation an agent performs SHALL go through the Slurm
scheduler, not run interactively on a login node. Instruct your agent to submit
batch or interactive jobs (`sbatch`, `sinteractive`) with an explicit
`--time` limit and a correct account, partition, and QOS. A bounded time limit
protects both your allocation and the shared queue from a runaway job an agent
started and then lost track of.

## Keep sensitive data out of world-readable locations

Do not let an agent place sensitive or restricted data in world-readable paths
(for example, a group- or world-readable scratch directory). Agents readily
create scratch files, logs, and intermediate outputs; make sure those land in
appropriately-permissioned locations. If your work involves regulated or
export-controlled data, confirm it is handled on an approved system before an
agent ever touches it.

## Never expose secrets or credentials

Do not paste passwords, SSH private keys, API tokens, or other credentials into
an agent's prompt or context, and do not point an agent at files that contain
them. Whatever an agent can read, it may echo back, log, or transmit to a
model provider. Treat the agent's context window as potentially observable, and
keep secrets out of it.

## Confirm destructive and irreversible actions

Require your agent to pause for your confirmation before any destructive or
hard-to-undo operation — deleting files (`rm`), overwriting data, cancelling
other users' jobs, or changing permissions on shared paths. Configure your
harness so these actions prompt rather than run automatically; the per-harness
settings we publish in this section deny the most dangerous operations outright
as a starting point.

## Be a good citizen

You share these systems with thousands of other researchers. The same courtesy
you extend as a human user extends to your agent: do not stress the filesystem
with runaway metadata operations, do not leave orphaned processes on login
nodes, and do not consume shared resources you are not actually using. If an
agent's behavior is affecting the system or other users, RCAC staff may stop it
without prior notice, exactly as they would any other disruptive workload.

## Acceptable Purdue IT Research Resource Use

{{ resource_use(resource) }}

---

Back to [Agentic AI](index.md).
