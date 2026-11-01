# GOAL — uv on RCAC clusters, and current Python guidance

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** uv-module
- **kind:** feature
- **appetite:** big

## Problem

RCAC now provides a `uv` module on Anvil, Gautschi, Gilbreth, Negishi and Scholar. It loads
[uv-manager](https://github.com/PurdueRCAC/uv-manager) 0.7.0, a wrapper that runs the real `uv` and
`uvx` while keeping uv's binary, cache, tool environments and managed Pythons on scratch, separated
by CPU architecture and by user. The docs mention uv nowhere: not in the software catalog, not in
any cluster's Python chapter. A user who runs the standalone uv installer today fills their home
quota and gets binaries that may not match the compute node they land on.

The Python guidance around it has also aged. RCAC's preferred Python distribution is Miniforge (the
`conda` module), after Anaconda, Inc.'s licensing change, but some pages still load the `anaconda`
module, create environments with Python 3.8, or show paths from retired Anaconda installs.

## Outcome / vision

- A catalog entry for `uv` lists the clusters and versions, like every other module.
- Each supported cluster's Python material tells a reader when to reach for `conda` and when for
  `uv`, and shows the `uv` path: `module load uv`, then `uv` and `uvx` as usual.
- A blog post explains why RCAC built uv-manager, what it is, how it works, and what to keep in
  mind (the scratch purge, in-job repair, picking a Python version, storage and inodes).
- No page a reader lands on for Python advice still points them at the `anaconda` module for new
  work.

## Acceptance criteria (the contract)

- **R1** — The software catalog SHALL have a `uv` entry listing Anvil, Gautschi, Gilbreth, Negishi
  and Scholar with version `0.7.0` as the default, produced by the catalog generator (not hand-edited).
- **R2** — WHEN a reader opens the Python material for Anvil, Gautschi, Gilbreth, Negishi or
  Scholar, it SHALL include a uv section showing `module load uv`, a `uv run`, a `uv venv`/`uv pip`
  and a `uvx` example, and stating that uv's state lives under `$UVM_ROOT` (default
  `$SCRATCH/.uv`), not home.
- **R3** — The uv section SHALL say when to prefer `conda` (non-Python or compiled stacks from
  conda-forge, existing `conda-env-mod` workflows) and when `uv` (PyPI packages, projects with a
  `pyproject.toml`, single-file tools via `uvx`).
- **R4** — The uv section SHALL explain the scratch purge for uv state: what `UVM_REPAIR` does in a
  Slurm job, that the module turns it on, how to opt out (`export UVM_REPAIR=0`), and that
  `uv-manager doctor` checks for damage outside a job.
- **R5** — The uv section SHALL tell readers that uv picks the newest uv-managed Python by default,
  and SHALL show how to pin one (`--python 3.12`, or a `.python-version` file) when a package has
  no build for the newest version; and that `--python <path>` reaches another Python, such as the
  `conda` module's.
- **R6** — WHERE the cluster is Anvil, the uv section SHALL note the 30-day scratch purge and show
  how to put `UVM_ROOT` under the reader's own directory in `$PROJECT` instead.
- **R7** — The blog post SHALL cover: why (home quota, login/compute architecture mismatch, shared
  state, purge damage, in the context of the move from Anaconda to Miniforge), what uv-manager is,
  how to use it, and what to keep in mind; and SHALL link the catalog entry, the cluster guides and
  the 2025 "Conda vs Anaconda" post.
- **R8** — No user-guide page or shared snippet SHALL tell readers to `module load anaconda` for new
  work, or to create an environment with an end-of-life Python (3.8 or older).
- **R9** — `mkdocs build --strict` SHALL report no new warning, and every new page SHALL appear in
  nav (blog posts via the blog plugin).
- **R10** — The blog author entry `glentner` SHALL show the title "Principal AI Scientist".

## Non-goals (no-gos)

- Not documenting Bell or Hammer: uv is not deployed there.
- Not rewriting `conda-env-mod` documentation, beyond fixing what R8 names.
- Not removing or deprecating the `anaconda` module or its catalog page.
- Not documenting uv itself beyond RCAC specifics; link Astral's docs instead.
- Not changing the `docs/software/apps_md/` pages by hand; the generator owns them.

## Clarifications

- **Q:** Blog authors? — **A:** Geoffrey Lentner alone (resolved 2026-10-31).
- **Q:** Anvil's default state root? — **A:** `$SCRATCH/.uv`, like every cluster; `$PROJECT` is
  documented as the reader's choice (resolved 2026-10-31).
- **Q:** One job, or split the Python-guidance audit (R8) into its own `fix`? — **A:** One job;
  keep it all in, despite the size circuit-breaker (resolved 2026-10-31).
- **Q:** The blog author entry for Geoffrey Lentner says "Lead Research Data Scientist"; fix it
  here? — **A:** Yes, to "Principal AI Scientist"; added as R10 (resolved 2026-10-31).

## Related materials

- uv-manager 0.7.0: <https://github.com/PurdueRCAC/uv-manager/releases/tag/0.7.0> and its README
  ("Repairing inside a job", "Scratch purges and what uv does not notice").
- Existing blog post: `docs/blog/posts/conda_anaconda.md` (2025-09-24).
- Shared Python snippets: `docs/snippets/examples/apps/python/` (`conda.md`, `packages.md`, `pip.md`).
- Pages loading `anaconda`: Gilbreth `run_jobs/learning/customml.md`, `ml_batch.md`, and their
  snippets under `docs/snippets/examples/apps/learning/`.
- Astral uv docs: <https://docs.astral.sh/uv/>.
