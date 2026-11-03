# PLAN — uv module 0.8.0: catalog, user guide and blog update

> **Status:** Draft · **Last updated:** 2026-11-03
> Vision/contract: [`GOAL.md`](GOAL.md). Phases: [`TECH.md`](TECH.md).

## 1. Summary

Small fix, no research fan-out. The facts come from the uv-manager 0.8.0 README and release notes,
and from a load test of the 0.8.0 module on four clusters (2026-11-03). The cluster pages need no
edits of their own: all five include `docs/snippets/examples/apps/python/uv.md`, so the user-guide
changes land there once.

## 2. Design

- **Catalog (R1):** add `uv/0.8.0.lua` and retarget `default` in each `modulefiles/<cluster>/…/uv/`
  seed directory, copied from the deployed modulefiles; run `cd tools && make` on a Linux login node
  (bash 4) from a copy without macOS metadata; commit only what CI commits.
- **Shared text (R2–R4):**
  - Intro: uv's files stay on scratch; only small tool records go in home.
  - *Running scripts and tools*: a `uv tool install ruff` / `ruff check .` example.
  - *Where uv keeps its files*: `$UVM_DATA`, its default, its size, and how to move it.
  - *Scratch purges*: what the first call repairs (managed Pythons, installed tools from their
    records, uv's cache environments), tools run by name, the fail-loudly case and
    `uv-manager clean cache --yes`. The "prefer `uvx` over `uv tool install`" habit is replaced.
  - New last section before *More information*: *Coming from uv/0.7.0*.
- **Blog (R2, R5):** correct the home-directory sentence; add `date.updated`; append a dated
  *Update: uv-manager 0.8.0* section.

## 3. Verification

`mkdocs build --strict`; every new command run against the live default `uv` module on Anvil,
Gilbreth, Negishi and Scholar, with a throwaway `UVM_ROOT` and `UVM_DATA` on scratch.
