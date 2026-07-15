# REVIEW — {Title}

> Adversarial QA by `docs-review`, run in an isolated/clean context. The correctness pass grades the
> branch diff against [`GOAL.md`](GOAL.md) + the invariants + the style guide **only** — it does not
> see `PLAN.md`/`TECH.md` (avoids grading-its-own-homework / plan-sycophancy). Every finding cites
> **evidence** — a build/render/link result or a direct read of the diff — not an assertion.

- **Reviewed commit:** {sha}  ·  **Base:** main  ·  **Date:** {YYYY-MM-DD}
- **Verdict:** approved | changes-requested
- **Cycle:** {n} of ≤3 (escalate to human on non-convergence)

## Verification run

Commands actually executed / pages actually rendered, and their outcomes (the spine of the review):

- `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py` → <result>
- `.venv/bin/mkdocs serve` + viewed <page(s)> → <what rendered: tabs, admonitions, macros, layout>
- nav check: <new page(s) present in `mkdocs.yml` / resolve without "not in nav" warning>
- front-matter / a11y spot-check → <observed>

## Requirement → evidence matrix

Bidirectional traceability. Flag requirements with no implementing change **and** changes that map
to no requirement (scope creep).

| R-ID | Implemented by (file/commit) | Verified how | Status |
|------|------------------------------|--------------|--------|
| R1   | <…>                          | <command/render> | ✅ / ❌ |

Unmapped changes (possible scope creep): <list or "none">.

## Findings

Severity: **CRITICAL** (any invariant violation, or a wrong HPC command/path, is auto-CRITICAL) ·
**HIGH** · **MEDIUM** · **LOW**. Verdict: **CONFIRMED** (reproduced by command/render or direct diff
read) vs **PLAUSIBLE** (a real risk that is not machine-checkable — HPC accuracy, prose/semantic
a11y — needs human triage). Only CONFIRMED findings auto-loop to `docs-draft`; PLAUSIBLE findings go
to a human.

### [CRITICAL/CONFIRMED] <one-line defect>
- **Where:** `file:line`
- **Failure scenario:** <what a reader sees / what breaks — e.g. broken link, wrong flag, nav orphan>
- **Evidence:** <the command run / page rendered and what it showed>
- **Touches invariant / requirement:** <R-ID or invariant §>

### [HIGH/PLAUSIBLE] <one-line accuracy concern>
- **Where:** `file:line`
- **Concern:** <e.g. "`--gpus-per-node=4` may be wrong for the `gpu` partition">
- **Authoritative source to check:** <gold-standard page / RCAC spec / vendor doc>

## Human-gate triggers

Set if any CONFIRMED finding touches a **high-impact file** (`mkdocs.yml`, `main.py`,
`docs/snippets/**`, `overrides/**`, `tools/**`+`modulefiles/**`, CI, k8s, a generated output, or the
dev-only a11y layer), **or** an unresolved HPC-accuracy concern remains on a high-traffic page.
Remember: merging to `main` auto-deploys to production within ~5 minutes — there is no staging gate.

- <triggered? which finding?>

## Optional completeness sub-pass (separate reviewer; may see TECH.md)

- Was every planned phase actually shipped? Did scope balloon beyond the appetite? <notes>
