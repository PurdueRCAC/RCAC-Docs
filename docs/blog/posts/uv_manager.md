---
date:
  created: 2026-11-01

categories:
  - Software
  - Announcements

title: "uv on RCAC Clusters: Why We Built uv-manager"

slug: uv-manager

tags:
  - uv
  - Python
  - Conda

authors:
  - glentner
---

# uv on RCAC Clusters: Why We Built uv-manager

`module load uv` now works on Anvil, Gautschi, Gilbreth, Negishi and Scholar. After loading it, you
run `uv` and `uvx` exactly as [Astral's documentation](https://docs.astral.sh/uv/) describes. This
post explains why RCAC provides uv through a small wrapper called uv-manager, what that wrapper
does, and what to keep in mind when you use it on a cluster.

<!-- more -->

## Why a module for uv?

Last year Anaconda, Inc. changed the terms under which its distribution and its `defaults` channel
may be used, and RCAC made the `conda` module (Miniforge, with the open conda-forge channel) the
recommended way to build Python environments. Our earlier post,
[Conda vs Anaconda](conda_anaconda.md), covers that change.

Many Python users need nothing from conda-forge, though. Their dependencies are packages on PyPI,
and [uv](https://docs.astral.sh/uv/) installs those quickly, resolves them into a lock file, and
manages Python versions as well. Plenty of you already run uv's standalone installer on our
clusters, and on a cluster that installer causes four problems:

- **Home quota.** The installer puts uv in `~/.local/bin`, its cache in `~/.cache/uv`, and its tool
  environments and Python interpreters under `~/.local/share/uv`. A working setup easily reaches
  tens of gigabytes, far more than a home directory holds.
- **CPU architecture.** A binary downloaded on a login node is built for that node's architecture.
  Where the compute nodes a job lands on differ (now or in a future partition), the same files fail
  with an `Exec format error` deep inside the job.
- **Shared state.** The obvious fix, one site-wide uv install, means one user's `uv tool install`
  or `uv python install` changes what every other user gets. Each user needs their own.
- **Purges.** Moving uv's files to scratch solves the quota, but scratch is purged file by file.
  When some files of a tool environment or of a uv-managed Python are purged and others survive,
  uv does not notice. It runs them anyway, and you get an `ImportError` that says nothing about
  the purge.

## What uv-manager is

[uv-manager](https://github.com/PurdueRCAC/uv-manager) is a single, open-source shell script
installed under the names `uv`, `uvx` and `uv-manager`. When you run `uv`, it:

1. finds your state root, `$UVM_ROOT` (the module sets it to `$SCRATCH/.uv`);
2. on the first call on a given CPU architecture, downloads the real uv into
   `$UVM_ROOT/<architecture>`, which is yours alone;
3. points uv's cache, tool and Python directories at that same per-architecture tree, on the node
   that is actually running the command;
4. runs the real uv with your arguments.

Nothing it stores goes in your home directory, a login node and a compute node of different
architectures never share binaries, and no two users share anything. `uv-manager status` shows
every path it is using, and `uv-manager install` fetches a newer uv when you want one.

## Using it

```bash
$ module load uv
$ uv --version
$ uvx ruff check .
$ uv run --with numpy analysis.py
```

Each cluster's user guide has a page with the details: projects and virtual environments, choosing
a Python version, batch jobs, and when to use `conda` instead.

- [Anvil](../../userguides/anvil/python_uv.md)
- [Gautschi](../../userguides/gautschi/run_jobs/examples/python_uv.md)
- [Gilbreth](../../userguides/gilbreth/run_jobs/examples/python_uv.md)
- [Negishi](../../userguides/negishi/run_jobs/python/uv.md)
- [Scholar](../../userguides/scholar/run_jobs/python_uv.md)

The [software catalog entry](../../software/apps_md/uv.md) lists the versions on each cluster.

## What to keep in mind

- **Repair runs in your batch jobs.** The module sets `UVM_REPAIR=1`. In a Slurm job, the first
  `uv` or `uvx` call checks for purged files and repairs them before your command runs, once per
  job. In a multi-node job one task repairs while the others wait. Export `UVM_REPAIR=0` to turn it
  off. Outside a job, `uv-manager doctor` reports what it finds.
- **Pick a Python when the newest is too new.** The module has uv use only the Python interpreters
  it installs itself (an old operating-system Python can quietly pull in ancient package
  releases), and by default that is the newest release. When a package has no build for it yet,
  pin one: `uv python pin 3.12`, or `--python 3.12` on a single command. To use the `conda`
  module's Python, pass `--python "$(command -v python3)"`.
- **Anvil purges scratch after 30 days.** To keep your uv state longer, set
  `UVM_ROOT=$PROJECT/$USER/.uv` before loading the module (a directory of your own, never the
  shared top of `$PROJECT`).
- **Keep long-lived environments off scratch.** A project's `.venv` belongs in your home directory
  if it is small, or in your group's Data Depot space if it is large.
- **Watch your file count.** Scratch limits the number of files as well as space, and a busy uv
  cache holds many. `myquota` shows where you stand, and `uv cache prune` clears what you no longer
  use.
- **conda is still the right tool for some work.** Compiled stacks from conda-forge, R, GDAL,
  `conda-env-mod` modules and Jupyter kernels stay with the `conda` module. Both modules load side
  by side.

If uv-manager itself misbehaves, please open an issue on
[GitHub](https://github.com/PurdueRCAC/uv-manager/issues); for anything about your jobs, the
[RCAC support team](../../contact.md) can help.
