# REVIEW — uv on RCAC clusters, and current Python guidance

> The blind `docs-review` pass was not run for this job. In its place the human owner built and served
> the branch and reviewed every page, and approved it for a PR. The automated gates below were run by
> `docs-draft` during each phase.

- **Reviewed commit:** 7f07d519  ·  **Base:** main  ·  **Date:** 2026-11-01
- **Verdict:** approved (human review, Geoffrey Lentner)
- **Cycle:** 1

## Verification run

- `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py` → PASS,
  no new warnings, at the end of every phase (P1–P7).
- `mkdocs build` + `mkdocs serve`, every new and changed page viewed by the human reviewer → looks good.
- Built-HTML checks: one H1 per page with H2s in order; the conda/uv table has a header row; the Anvil
  warning admonition renders; every link in the blog post resolves; each cluster page's include is
  non-empty (`UVM_REPAIR`, `only-managed` present).
- Nav: `userguides/anvil/python_uv.md` listed after Anvil Software; the four other pages are linked
  from their chapter's Python page, as their sibling pages are (amended R9); breadcrumbs regenerated.
- HPC accuracy: on the login nodes of Anvil, Gautschi, Gilbreth, Negishi and Scholar, `module load uv`
  loaded the deployed `uv/0.7.0`, and every command the pages show ran successfully (TECH.md P7).

## Requirement → evidence matrix

| R-ID | Implemented by | Verified how | Status |
|------|----------------|--------------|--------|
| R1 | P1: seeds, curated description, generated `apps_md/uv.md` | five `0.7.0 (D)` rows | ✅ |
| R2 | P2–P4: shared snippet + five cluster pages | strict build, include sentinels, commands run on all five clusters | ✅ |
| R3 | snippet "conda or uv?" table | render | ✅ |
| R4 | snippet "Scratch purges and repair in batch jobs" | render; `uv-manager doctor`/`help` run | ✅ |
| R5 | snippet "Choosing a Python version" | `uv run --python 3.12`, `uv python pin`, conda `--python` run | ✅ |
| R6 | Anvil page warning admonition | render | ✅ |
| R7 | `blog/posts/uv_manager.md` | links resolve in built HTML | ✅ |
| R8 | P5 edits | `grep` for `module load anaconda` and `python=3.8` in scope: none | ✅ |
| R9 | strict gate; Anvil nav; hub links | strict build | ✅ |
| R10 | `blog/.authors.yml` | rendered author card | ✅ |

Unmapped changes: the Genomics Exchange Session 3 link fix (`session-4.md` → `../session4/index.md`),
which unblocked the strict gate on `main` (GOAL clarification, 2026-10-31).

## Findings

None open.

## Human-gate triggers

The change touches high-impact paths (`mkdocs.yml`, `docs/snippets/**`, `tools/**`, `modulefiles/**`,
generated catalog output). The human gate is satisfied by the review above.
