## Loading uv

[uv](https://docs.astral.sh/uv/) is a fast Python package and project manager. It installs packages
from PyPI, creates virtual environments, runs scripts and command-line tools, and installs Python
itself. Load it with:

```bash
$ module load uv
```

After that, `uv` and `uvx` work as described in uv's own documentation. The module runs them
through a small wrapper, [uv-manager](https://github.com/PurdueRCAC/uv-manager), which gives you
your own copy of uv and keeps everything uv stores out of your home directory.

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
different architecture never share binaries. Nothing goes in `~/.cache/uv` or `~/.local`, and
none of it counts against your home quota.

To put it somewhere else, export `UVM_ROOT` before loading the module:

```bash
$ export UVM_ROOT=/path/of/your/choice/.uv
$ module load uv
```

A populated uv tree holds many files, and scratch has a limit on the number of files as well as
on space. Check yours with `myquota`, and clear out cached packages you no longer use with:

```bash
$ uv cache prune
```

## Scratch purges and repair in batch jobs

Files on scratch that go unused for long enough are purged. The download cache recovers on its
own, but uv does not notice when only some files of a tool environment or of a Python it installed
are gone: it runs them anyway, and the job fails with an `ImportError` or
`ModuleNotFoundError` that doesn't point at the cause.

The module sets `UVM_REPAIR=1` to handle this in batch jobs. The first `uv` or `uvx` call in a
Slurm job checks the tree and repairs any damage before your command runs. Every later call in the
same job skips the check, at almost no cost. In a multi-node job, one task does the repair while
the others wait for it, then all of them run:

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

In a job array, a successful repair by one task covers the others. A failed repair only stops the
task that tried it, and the next task tries again.

To turn the repair off, export `UVM_REPAIR=0` before loading the module or in your job script.

Outside a batch job, run `uv-manager doctor` when something that used to work stops importing.
It reports the damage it can find and what to remove. If a job was killed while repairing, later
jobs wait on its lock and then fail with a message naming it; `uv-manager doctor` shows the lock,
and `uv-manager clean lock --yes` removes it.

Two habits reduce the damage in the first place: prefer `uvx tool` over `uv tool install tool`,
since a temporary environment is rebuilt from the cache when needed, and keep long-lived virtual
environments off scratch.

## conda or uv?

Both modules can be loaded at the same time, and each is the better fit for different work:

| Use `conda` (Miniforge) when… | Use `uv` when… |
|---|---|
| you need non-Python software or compiled libraries from conda-forge, such as GDAL, CUDA libraries or R | your dependencies are Python packages on PyPI |
| you want `conda-env-mod` to generate a module file or a Jupyter kernel for an environment | you work on a project with a `pyproject.toml`, or want a lock file for reproducible installs |
| you already have conda environments that work | you want to run a tool or a script without setting up an environment first (`uvx`, `uv run`) |

## More information

- [uv documentation](https://docs.astral.sh/uv/)
- [uv-manager on GitHub](https://github.com/PurdueRCAC/uv-manager): how the wrapper works, and every
  setting it reads
