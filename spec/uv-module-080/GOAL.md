# GOAL — uv module 0.8.0: catalog, user guide and blog update

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md).

- **slug:** uv-module-080
- **kind:** fix
- **appetite:** small

## Problem

The `uv` module now loads [uv-manager 0.8.0](https://github.com/PurdueRCAC/uv-manager/releases/tag/0.8.0)
by default on Anvil, Gautschi, Gilbreth, Negishi and Scholar; `uv/0.7.0` stays loadable. The pages
written for 0.7.0 ([`spec/uv-module`](../uv-module/GOAL.md)) are now wrong or incomplete in four ways:

- The catalog lists `0.7.0 (D)` only.
- The shared uv text and the blog post say nothing uv-manager stores goes in the home directory.
  0.8.0 keeps a small record of each installed tool under `$UVM_DATA` (default `~/.local/share/uvm`).
- The repair section covers only `uv` and `uvx` calls, and advises against `uv tool install`. 0.8.0
  also repairs an installed tool run by its own name, and the environments in uv's cache.
- Nothing tells a 0.7.0 user what to do once after upgrading, or how to recover if they go back to
  `uv/0.7.0` after using 0.8.0.

## Outcome / vision

A reader of any cluster's uv page, the catalog or the blog post sees what 0.8.0 does, with no claim
that 0.8.0 contradicts, and knows the one-time steps that apply when coming from 0.7.0.

## Acceptance criteria (the contract)

- **R1** — The software catalog's `uv` entry SHALL list `0.8.0 (D)` and `0.7.0` on all five clusters,
  produced by the catalog generator from seed modulefiles (not hand-edited).
- **R2** — The shared uv text SHALL show installing a tool with `uv tool install` and running it by
  name, and SHALL state that a record of each installed tool, a few KB, is kept under `$UVM_DATA`
  (default `~/.local/share/uvm`), off scratch. No uv page or the blog post SHALL say that nothing
  uv-manager stores goes in the home directory.
- **R3** — The repair section SHALL state that, with `UVM_REPAIR` set, the first call of an installed
  tool by its own name is covered, that installed tools are restored from their records, and that the
  environments `uv run <script>` and `uvx` run from uv's cache are repaired; and SHALL say what
  happens, and what to run, when a repair cannot show where a package came from.
- **R4** — WHEN a reader reaches the end of the shared uv text, THEN it SHALL tell a 0.7.0 user to
  run `uv-manager doctor` once, and, IF a tool fails under `uv/0.7.0` with
  `unknown command: _trampoline` after 0.8.0 has run, to run `uvm trampolines` once.
- **R5** — The blog post SHALL end with a dated update announcing 0.8.0 as the default, summarising
  what it adds, and linking the release notes.
- **R6** — Every command the new text shows SHALL have run against the live `uv` module.
- **R7** — `mkdocs build --strict` SHALL pass.

## Non-goals

- New pages or nav changes; per-cluster page edits beyond what the shared text carries.
- Documenting every repair edge case; the uv-manager README remains the reference.
- The Anaconda-era numpy and source pages on Gilbreth and Negishi (an existing follow-up).

## Clarifications

- 2026-11-03 — Scope set by the maintainer in chat: catalog regenerated in this PR after the
  modulefile changes merge; a note at the bottom advising `uvm trampolines` once for users coming
  from 0.7.0 who hit the `_trampoline` error; a note at the end of the blog post.
- 2026-11-03 — R6: Gautschi's scratch filesystem was unavailable from its login node; the maintainer
  ruled the Gautschi check unnecessary. The other four clusters verify R6.

## Related materials

- uv-manager [0.8.0 release notes](https://github.com/PurdueRCAC/uv-manager/releases/tag/0.8.0) and README.
- The original job: [`spec/uv-module/`](../uv-module/GOAL.md).
