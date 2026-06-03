---
date:
  created: 2026-06-01

categories:
  - Announcements

#Title will change how it's displayed on website
title: Good Practices Guide on RCAC Resources

#Slug will change how it's shown in the domain url
slug: good_practice_guide

tags:
  - Slurm
  - Fairuse
  - HPC

authors:
  - jin456
---

# Good Practices on RCAC Clusters

You share RCAC systems with thousands of other researchers. The following guidelines protect everyone's ability to work effectively — including yours.

<!-- more -->

## Do Not Run Jobs on Login Nodes

Login nodes are shared among all connected users. Running computationally intensive work on them slows or crashes the experience for everyone.

**Login nodes are for:** editing files, writing and submitting job scripts, monitoring jobs, small file transfers, and quick tests under ~1 minute.

**Login nodes are NOT for:** compiling large codebases, processing data files, running Python/R scripts against datasets, ML training, or anything that pegs a CPU for more than a moment.

### How to tell you are on a login node

Your shell prompt will show a hostname started in `login` (e.g., `login00.anvil`) or ended with `fexx` (e.g., `gilbreth-fe00`). You can run `hostname` to check your current landed node.

### What to do instead

| Need | Solution |
|---|---|
| Short interactive work | `sinteractive` |
| Long-running batch work | `sbatch myjob.sh` |
| Jupyter notebook | Use the Open OnDemand gateway, not a login node terminal |

## Do Not Stress the Shared Filesystem

The filesystems (`$HOME`, `$SCRATCH`, `$DEPOT` or `$PROJECT`) are shared infrastructure. Certain access patterns can degrade performance for the entire cluster.

### Patterns that harm the filesystem

- Opening and closing millions of small files in rapid succession (common with large conda environments installed in `$HOME`)
- Many parallel MPI ranks simultaneously writing to the same output file without   collective I/O
- Tight loops checking for the existence of a file (polling with `ls` or `stat`)

### Recommended filesystem usage

| Filesystem | Best used for | Avoid |
|---|---|---|
| `$HOME` | Scripts, source code, small configs | Large datasets, job outputs |
| `$SCRATCH` | Active job input/output during a run | Long-term storage, important results |
| `$DEPOT` or `$PROJECT` | Group shared data, results to keep | Temporary working files |

### Conda environment tip

Large conda environments (>20,000 files) in `$HOME` can cause slow logins and filesystem load. Move heavy environments to `$PROJECT` or `$SCRATCH`, or use Apptainer/Singularity containers for portability.


## Scratch Is Not Permanent Storage

!!! warning
    Files on `$SCRATCH` of all RCAC systems that have not been **accessed** in a certain time are purged automatically. There are no warning emails. Back up results immediately
    after your jobs complete.

Check sections user guides for how to TODO....

## Request Only What Your Job Actually Uses

Over-requesting resources wastes your SU allocation, makes the scheduler's job
harder, and delays your own jobs by making them harder to backfill.

### Why it matters

- **SU charging:** On Anvil, SUs are charged based on what you *request*, not
  what you use. Requesting 128 cores for a serial job burns your allocation 128×
  faster than necessary.
- **Scheduling delay:** A job requesting 64 nodes must wait for 64 nodes to be
  simultaneously free. A job requesting 4 nodes starts far sooner.

### How to right-size your jobs

After any completed job, run:

    seff <jobid>

This reports CPU efficiency and peak memory (MaxRSS). Use this to tune future
submissions:

- **CPU efficiency under 50%?** Your code may not be parallelizing well.
  Consider reducing `--ntasks-per-node` or profiling your code.
- **Memory used was 12 GB, you requested 256 GB?** Set `--mem=16G` next time.


## Tips for More Efficient Work

**Use the `debug` partition for testing.**
The `debug` partition has a 2-node, 2-hour limit but typically starts within
minutes. Always test your job script there before submitting a full production run.

**Set email notifications.**
Add these lines to your job scripts so you know immediately when a job ends or fails:

    #SBATCH --mail-type=END,FAIL
    #SBATCH --mail-user=your@email.com

**Use `module purge` at the top of job scripts.**
This ensures your job uses exactly the modules you load in the script, regardless
of what you have loaded interactively at submission time.

**Use `tmux` or `screen` for persistent sessions.**
These tools keep your terminal session alive through SSH disconnections.
See [Productivity Tips](../lifesciences/guides/productivity-tips/) for setup instructions.

**Check allocation balance before large runs.**

    mybalance

Don't discover you're out of SUs after submitting 500 jobs.


## Writing Good Help Desk Tickets

A well-written ticket gets resolved faster. Before submitting:

1. **Check the documentation and FAQs first.** Search this site and the
   [ACCESS knowledge base](https://support.access-ci.org/).
2. **Include the job ID** for any scheduler-related issues.
3. **Include the full path** to your job script and working directory.
4. **Paste the exact error message** — don't paraphrase.
5. **Note what changed** since the last time your workflow succeeded.
6. **Have realistic expectations.** Staff can address system issues and answer
   questions about RCAC resources, but cannot debug domain-specific application
   code or teach parallel programming in a ticket.

Submit tickets via the [ACCESS Help Desk](https://support.access-ci.org/open-a-ticket)
for Anvil issues, or [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) for
Gautschi and community cluster issues.