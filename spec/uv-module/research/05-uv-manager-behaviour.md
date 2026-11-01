# 05 — What the `uv/0.7.0` module does (HPC accuracy source)

Sources: the uv-manager 0.7.0 README and modulefile reference
(<https://github.com/PurdueRCAC/uv-manager/tree/0.7.0>), and load tests of the deployed module on
the login nodes of all five clusters, 2026-10-31.

- `module load uv` puts the wrapper first on `PATH`; `uv`, `uvx` and `uv-manager` (alias `uvm`)
  are the same script. The first `uv` call on each CPU architecture downloads the latest uv
  (0.13.6 on 2026-10-31) into the user's state root; this needs outbound HTTPS.
- The module sets `UVM_ROOT=$SCRATCH/.uv` (from `$CLUSTER_SCRATCH`/`$RCAC_SCRATCH`), `UVM_REPAIR=1`,
  `UV_LINK_MODE=copy` and `UV_PYTHON_PREFERENCE=only-managed`. A value the user exported before
  loading wins, and is restored on unload. `uv-manager status` prints every path in use.
- Under the state root, per architecture: the uv binaries, the cache (`UV_CACHE_DIR`), tool
  environments (`UV_TOOL_DIR`) and managed Pythons. Nothing goes to `~/.cache/uv` or `~/.local`.
- **Python choice:** with `only-managed`, uv uses only Pythons it installs itself and fetches the
  newest when none is requested (CPython 3.15 on 2026-10-31). `--python 3.12`, a `.python-version`
  file, or `requires-python` pins it; `--python <path>` reaches any interpreter, such as
  `$(command -v python3)` after `module load conda`. Measured: without `only-managed`, uv on the
  el8 clusters (Anvil, Negishi) picked `/usr/bin/python3` (3.6.8) and `uvx ruff` fell back to an
  unbuildable 2022 release.
- **Purge:** scratch is purged per file (Anvil 30 days, other clusters 60). uv does not notice a
  partly purged tool environment or managed Python. With `UVM_REPAIR` on, the first `uv`/`uvx`
  call in a Slurm job checks and repairs once per job (keyed on `SLURM_JOB_ID`; arrays share a
  successful repair via `SLURM_ARRAY_JOB_ID`), and every other rank waits, then runs. Off is
  `0`, unset or empty. Repair needs `pypi.org`, `files.pythonhosted.org`, `releases.astral.sh`.
  Outside a job, `uv-manager doctor` reports damage; a stuck lock is cleared with
  `uvm clean lock --yes`.
- **Anvil:** `$PROJECT` is shared by the allocation and not purged; a per-user directory under it
  (`$PROJECT/$USER/.uv`) is the documented choice for long-lived state.
- **Advice from the README worth carrying:** prefer `uvx` over `uv tool install` on purged storage;
  keep project `.venv`s off scratch for long-lived work (Depot or home for small ones); run
  `uv cache prune` to keep inode counts down; `UV_COMPILE_BYTECODE=1` for many-rank jobs.
- **Not yet verified:** outbound HTTPS from compute nodes on Gilbreth, Negishi and Scholar
  (verified on Gautschi and Anvil).
