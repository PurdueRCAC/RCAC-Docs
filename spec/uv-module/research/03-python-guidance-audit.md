# 03 — Python guidance audit (R8)

Scope: the five clusters' guides plus the shared snippets they include. Bell and Hammer pages are
out of scope (GOAL non-goals).

| Where | What it says | Fix |
|---|---|---|
| `snippets/apps/python.md`, `snippets/examples/apps/python.md`, Gautschi/Gilbreth `run_jobs/python_example.md`, Negishi `run_jobs/python.md` | "We suggest using Anaconda … the default Anaconda distribution" over `module load conda` | Say Miniforge (the `conda` module), and point to the uv page |
| `snippets/examples/apps/python/conda.md`, Gilbreth `examples/python_conda.md`, Negishi `python/conda.md` | `conda create … python=3.8` (end of life Oct 2024) | `python=3.12` |
| Gilbreth `run_jobs/learning/customml.md` (lines 26–29, 144–149), `ml_batch.md` (36–40) | `module load anaconda`; env names `…-py3.8.5` | `module load conda`; example names `…-py3.12` |
| Anvil `anvil-software.md` line 34 | "binaries distributed through Anaconda" | Name the `conda` module (Miniforge) and the `uv` module |

Checked on a Gilbreth login node, 2026-10-31: after `module load conda` (Miniforge, conda 25.3.1,
Python 3.12.11), `conda-env-mod` is on `PATH` and its base module name is `conda`, so the ML
pages' `conda-env-mod` steps work unchanged under `conda`.

Left alone, as sample output rather than advice: retired Anaconda paths inside error messages in
`pip.md`/`python_pip.md` copies and `conda list` output in `source.md` copies; the captured
`module avail` listings on each `software.md`; Anvil `policies.md` (policy text).

Also found: `snippets/examples/apps/learning/{customml,ml_batch}.md` load `anaconda`, but only the
Hammer guide includes them. Whether R8 covers them is a question for the human.
