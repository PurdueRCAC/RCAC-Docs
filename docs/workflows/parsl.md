---
title: Parsl
tags:
  - Workflows
  - Parsl
  - Python
authors:
  - glentner
search:
  boost: 2
---

# Parsl

Parsl is a Python library for parallel scripting, from the University of Chicago and Argonne
National Laboratory. You write an ordinary Python program and mark the functions that should run
in parallel as *apps*. Calling an app does not run it on the spot: it returns a *future*, a
placeholder for the result, and Parsl runs the app on whatever resources you configured. When you
pass one app's future to another app, Parsl waits for the first to finish before it runs the
second, so the program's own data flow becomes the dependency graph. Because the graph is built
as the program runs, its shape can depend on results computed along the way. Parsl's
documentation is at [parsl.readthedocs.io](https://parsl.readthedocs.io/).

## Installing Parsl

RCAC provides no Parsl module. Install it into your own Python environment, with the `uv` module
(see the [uv catalog page](../software/apps_md/uv.md)) or the `conda` module (see the
[conda catalog page](../software/apps_md/conda.md)). Parsl needs Python 3.10 or newer. With `uv`,
in your home directory so that the environment is not purged with scratch:

```bash
module load uv
uv venv ~/parsl-env --python 3.12
source ~/parsl-env/bin/activate
uv pip install parsl
python -c "import parsl; print(parsl.__version__)"
```

With `conda`, `conda install -c conda-forge parsl` in an environment of your own works as well.
Parsl's workers on the compute nodes need the same environment, which the example below arranges.

## How Parsl describes work

A Parsl program has two parts: what to run, and where to run it. This example does the same work
as the examples on the [job array](job_arrays.md), [GNU Make](gnu_make.md) and
[GNU Parallel](gnu_parallel.md) pages: it counts the words in every file under `data/`, one result
per file, then collects the counts in `summary.txt`. The program that says *what* to run:

```python title="count.py"
--8<-- "docs/snippets/workflows/parsl/count.py"
```

Each function marked `@bash_app` returns a shell command as a string, and Parsl runs that command
on a worker. A command that exits with a non-zero status makes its future fail. The `summarize`
app receives every `count_words` future in its special `inputs` argument, so Parsl runs it only
after all the counts succeed; if any count fails, the summary does not run, and `.result()`
raises an error that names the failed task. `parsl.load` starts Parsl with a configuration, and
leaving the `with` block shuts Parsl down, which is why the program waits on the summary's
`.result()` inside it. Parsl writes its logs to a `runinfo/` directory where you start the
program.

## Running apps in Slurm jobs

The configuration says *where* the apps run. With Parsl's high-throughput executor and its Slurm
provider, Parsl submits Slurm jobs, which it calls *blocks*, starts workers in them, and sends apps
to those workers:

```python title="config.py"
--8<-- "docs/snippets/workflows/parsl/config.py"
```

In this configuration:

- `account`, `partition` and `qos` become the blocks' `--account`, `--partition` and `--qos`.
  Replace `myallocation` with your own account. The values shown are for Gautschi; on Negishi
  they work as written, and on Anvil, use `partition="wholenode"` and leave out `qos`. See each
  cluster's queues page, linked from [Slurm Job Arrays](job_arrays.md#a-worked-example).
- `nodes_per_block` is the number of nodes in each block. By default the provider asks for whole
  nodes, and the executor starts one worker per core.
- Parsl starts `init_blocks` blocks at first, and adds or removes blocks as work arrives and
  drains, between `min_blocks` and `max_blocks`.
- `walltime` is each block's time limit.
- `worker_init` runs in each block before the workers start; here it activates the environment
  Parsl is installed in.

The provider's full list of options is in the
[SlurmProvider reference](https://parsl.readthedocs.io/en/stable/stubs/parsl.providers.SlurmProvider.html),
and Parsl's guide to
[providers](https://parsl.readthedocs.io/en/stable/userguide/configuration/providers/index.html)
explains providers, blocks and how Parsl scales them.

With both files in the directory that holds `data/`, run `python count.py` in the activated
environment. The program is the *driver*: it submits the blocks, hands out the apps, and stays
running until the workflow finishes. Workers in the blocks connect back to the driver over the
network, so the driver must keep running, on a host the compute nodes can reach, for as long as
the work lasts.

## Where Parsl wins

- **Workflows that are Python programs.** Loops, conditions and function calls describe the work,
  with no separate workflow language to learn.
- **Graphs decided at run time.** A step can look at earlier results and decide what to run next,
  which a rule file written in advance cannot express.
- **Python functions as tasks.** Besides shell commands, Parsl runs Python functions directly
  (`@python_app`) and passes their results between tasks in memory.
- **Portability.** Changing the configuration, not the program, moves the work to another
  scheduler, another cluster or a cloud.

## When to bring in HyperShell

Parsl earns its cost when the workflow is a Python program whose structure is only known as it
runs. When your work is a flat list of commands, Parsl asks you to wrap each command in a Python
function, keep a driver running for the whole campaign, and write and tune a configuration for each
cluster, all to run a list you could already type at a shell prompt. Unless you set up its
optional monitoring database, its record of what ran lives in its log files.

For that work, use HyperShell. Your task file is the list itself, the work runs inside your own
Slurm jobs, and every task, with its exit status, run time and host, is recorded in a database you
can query and re-run from. RCAC recommends HyperShell for flat many-task work; see
[RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for why. The
[HyperShell User Guide](hypershell/index.md) in this section starts with one job script that
runs a whole task list this way.

[Back to Workflow Automation](index.md){ .md-button }
