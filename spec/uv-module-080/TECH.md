---
slug: uv-module-080
title: 'uv module 0.8.0: catalog, user guide and blog update'
kind: fix
appetite: small
status: in_review
branch: fix/uv-module-080
base: main
current_phase: done
last_updated: '2026-11-03'
phases:
- id: P1
  name: 'Catalog: 0.8.0 seeds and generated entry'
  status: done
  satisfies:
  - R1
  depends_on: []
  parallel: false
  hammerable: false
  hill: downhill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && test $(grep -c '0.8.0 (D)' docs/software/apps_md/uv.md) -eq 5
- id: P2
  name: Shared uv text, blog update, live-module check
  status: done
  satisfies:
  - R2
  - R3
  - R4
  - R5
  - R6
  - R7
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: downhill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'uvm trampolines' docs/snippets/examples/apps/python/uv.md && grep
    -q 'UVM_DATA' docs/snippets/examples/apps/python/uv.md && grep -q 'uv-manager
    0.8.0' docs/blog/posts/uv_manager.md
review:
  verdict: approved
  last_reviewed_commit: 0b807a62
---
# TECH.md — uv module 0.8.0

Resume ground truth: `.venv/bin/python .agents/factory/bin/next_phase.py spec/uv-module-080/TECH.md`.
Design: [`PLAN.md`](PLAN.md). Conventions as in [`spec/uv-module/TECH.md`](../uv-module/TECH.md):
one commit per phase with content and state, no `Co-Authored-By`, never hand-edit generated files,
no cluster names in the shared snippet.

## Phase P1 — Catalog
**Satisfies:** R1 · **Depends on:** —

- [x] Copy each cluster's deployed `uv/0.8.0.lua` into its `modulefiles/…/uv/` seed directory and
  retarget `default -> 0.8.0.lua`; keep `0.7.0.lua`.
- [x] `cd tools && make` on a Linux login node; commit only `apps_md/uv.md`, `app_catalog.md`,
  `index.md`, `apps_descriptions.json`, limited to uv and the date/count line. Anything else: stop.
  Ran on a Negishi login node, 2026-11-03, with `requests` from a venv built by the live `uv` module;
  `apps_descriptions.json` came out unchanged.

## Phase P2 — Shared text and blog
**Satisfies:** R2–R7 · **Depends on:** P1

- [x] Snippet edits per PLAN §2.
- [x] Blog: home-directory sentence, `date.updated`, closing update section.
- [x] Run every new command against the live module on Anvil, Gilbreth, Negishi, Scholar.
  2026-11-03: 15 checks, all passing on each of the four, with the live default `uv/0.8.0`, a
  throwaway `UVM_ROOT` and `UVM_DATA`: `uv tool install ruff`, `ruff check .` by name from
  `$UVM_DATA/bin`, `uv-manager doctor` writing the record, `uvx`, the `_trampoline` failure under
  `uv/0.7.0` and its `uvm trampolines` fix, back to 0.8.0, `uv-manager clean cache --yes`, and a
  user-exported `UVM_DATA`. `mkdocs build --strict`: no warnings.
