## Loading uv

[uv](https://docs.astral.sh/uv/) is a fast Python package and project manager. It installs packages
from PyPI, creates virtual environments, runs scripts and command-line tools, and installs Python
itself. Load it with:

```bash
$ module load uv
```

After that, `uv` and `uvx` work as described in uv's own documentation. The module runs them
through a small wrapper, [uv-manager](https://github.com/PurdueRCAC/uv-manager), which gives you
your own copy of uv and keeps what uv stores on scratch, not in your home directory.

The first time you run `uv` on a node of a given CPU architecture, the wrapper downloads uv for
you. This takes a few seconds:

```bash
$ uv --version
uv-manager: installing uv (latest) for x86_64
...
uv 0.13.6 (x86_64-unknown-linux-gnu)
```

To see where the wrapper keeps uv and its files:

```bash
$ uv-manager status
```

`uvm` is a short name for `uv-manager`, and `uv-manager help` lists all of its commands.

## Running scripts and tools

Run a script with its dependencies installed on the fly, without setting up an environment first:

```bash
$ uv run --with numpy --with matplotlib sine.py
```

A script can also list its own dependencies at the top of the file
([inline script metadata](https://docs.astral.sh/uv/guides/scripts/)). Then `uv run sine.py` is
enough, and `uv add --script sine.py numpy` adds a dependency to that list.

Run a command-line tool once, in a temporary environment, without installing it:

```bash
$ uvx ruff check .
$ uvx --from jupyterlab jupyter-lab --version
```

Install a tool you use often, then run it by name:

```bash
$ uv tool install ruff
$ ruff check .
```

The tool's environment lives on scratch with the rest of uv's files. uv-manager also keeps a small
record of how you installed it in your home directory, so a tool the scratch purge removes can be
restored (see *Scratch purges and repair in batch jobs* below).

## Projects and virtual environments

For a project you will come back to, let uv manage a `pyproject.toml` and a lock file:

```bash
$ uv init myproject
$ cd myproject
$ uv add numpy pandas
$ uv run python analysis.py
```

`uv add` records the dependency, resolves it and installs it into the project's `.venv`.
`uv sync` brings the `.venv` back in line with the lock file, for instance on a colleague's
checkout of the same project.

To work the familiar `pip` way instead:

```bash
$ uv venv myenv --python 3.12
$ source myenv/bin/activate
$ uv pip install -r requirements.txt
```

!!! tip "Where to keep a virtual environment"
    Scratch is purged, so keep the virtual environment of a long-lived project in your home
    directory if it is small, or in your group's Data Depot space if it is large. The module sets
    `UV_LINK_MODE=copy`, so uv copies packages from its cache into an environment on another
    filesystem without warning about it.

## Choosing a Python version

The module sets `UV_PYTHON_PREFERENCE=only-managed`: uv uses only the Python interpreters it
installs itself, never an old operating-system Python by accident. If you don't ask for a
version, uv uses the newest Python it has installed, and downloads the latest release if it has
none.

The newest Python release is sometimes too new: a package you need may not publish a build for it
yet, and the install fails or falls back to building from source. When that happens, pick a
version:

```bash
$ uv run --python 3.12 script.py      # for one command
$ uv python pin 3.12                  # writes .python-version in this directory
```

In a project, `requires-python` in `pyproject.toml` has the same effect. `uv python list` shows
what is installed and what is available.

To use a Python uv did not install, such as the one from the `conda` module, pass its path:

```bash
$ module load conda
$ uv venv --python "$(command -v python3)" myenv
```

If you export your own `UV_PYTHON_PREFERENCE` before loading the module, your value is kept.

## Where uv keeps its files

Everything uv stores goes under `$UVM_ROOT`, which the module sets to `$SCRATCH/.uv`: the uv
program itself, its download cache, tool environments and the Python interpreters it installs.
These are kept separately for each CPU architecture, so a login node and a compute node of a
different architecture never share binaries. Nothing goes in `~/.cache/uv` or `~/.local/bin`, and
none of it counts against your home quota.

To put it somewhere else, export `UVM_ROOT` before loading the module:

```bash
$ export UVM_ROOT=/path/of/your/choice/.uv
$ module load uv
```

One small thing does go in your home directory: a record of each tool you install with
`uv tool install`, a few KB apiece, and the commands that run those tools by name. They live under
`$UVM_DATA`, which the module sets to `~/.local/share/uvm`, off scratch, so a purge cannot take a
tool's record along with the tool. To keep them elsewhere, export `UVM_DATA` before loading the
module, and pick storage that is not purged.

A populated uv tree holds many files, and scratch has a limit on the number of files as well as
on space. Check yours with `myquota`, and clear out cached packages you no longer use with:

```bash
$ uv cache prune
```

## Scratch purges and repair in batch jobs

Files on scratch that go unused for long enough are purged. uv does not notice when only some
files of a tool environment, of a Python it installed, or of an environment in its cache are gone:
it runs them anyway, and the job fails with an `ImportError` or
`ModuleNotFoundError` that doesn't point at the cause.

The module sets `UVM_REPAIR=1` to handle this in batch jobs. The first `uv` or `uvx` call in a
Slurm job, or the first call of a tool you installed with `uv tool install` by its own name, checks
the tree and repairs any damage before your command runs:

- a Python uv installed is reinstalled at the same version;
- an installed tool is restored from its record, at the versions it had;
- an environment in uv's cache that `uv run <script>` or `uvx` runs from has its damaged packages
  reinstalled, or is rebuilt by the next call that needs it.

Every later call in the same job skips the check, at almost no cost. In a multi-node job, one task
does the repair while the others wait for it, then all of them run:

```bash
#!/bin/bash
#SBATCH -A myallocation
#SBATCH -p partition-name
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=64
#SBATCH --time=01:00:00

module load uv
srun uv run --no-project analysis.py
```

An installed tool run by its own name gets the same repair, for example `srun ruff check .`.

In a job array, a successful repair by one task covers the others. A failed repair only stops the
task that tried it, and the next task tries again.

To turn the repair off, export `UVM_REPAIR=0` before loading the module or in your job script.

When the repair cannot show where a damaged package came from, such as a package from an index
only your script names, a local build, or a `--find-links` directory, it does not guess: the job
fails with a message naming the package. `uv-manager clean cache --yes` empties uv's cache, and the
next call rebuilds what it needs.

Outside a batch job, run `uv-manager doctor` when something that used to work stops importing.
It reports the damage it can find and what to remove. If a job was killed while repairing, later
jobs wait on its lock and then fail with a message naming it; `uv-manager doctor` shows the lock,
and `uv-manager clean lock --yes` removes it.

The repair covers what uv itself manages: its Pythons, its tools and its cache. A virtual
environment you create yourself, such as a project's `.venv`, is yours to manage, so keep
long-lived ones off scratch.

## conda or uv?

Both modules can be loaded at the same time, and each is the better fit for different work:

| Use `conda` (Miniforge) when… | Use `uv` when… |
|---|---|
| you need non-Python software or compiled libraries from conda-forge, such as GDAL, CUDA libraries or R | your dependencies are Python packages on PyPI |
| you want `conda-env-mod` to generate a module file or a Jupyter kernel for an environment | you work on a project with a `pyproject.toml`, or want a lock file for reproducible installs |
| you already have conda environments that work | you want to run a tool or a script without setting up an environment first (`uvx`, `uv run`) |

## Coming from uv/0.7.0

If you used `uv/0.7.0`, run this once after the module moves you to 0.8.0:

```bash
$ module load uv
$ uv-manager doctor
```

It writes a record for each tool you installed under 0.7.0, so the repair can restore those tools
too.

The first time 0.8.0 runs, it updates the small commands that start your installed tools. If you
then go back with `module load uv/0.7.0`, an installed tool can fail to start with
`uv-manager: unknown command: _trampoline`. Run this once under 0.7.0 to fix it:

```bash
$ module load uv/0.7.0
$ uvm trampolines
```

Loading 0.8.0 again afterwards needs no extra step.

## More information

- [uv documentation](https://docs.astral.sh/uv/)
- [uv-manager on GitHub](https://github.com/PurdueRCAC/uv-manager): how the wrapper works, and every
  setting it reads
