# META — harness retrospective for blast-db-refresh

> **Notes to the toolmaker, not to the reader.** Process/skillset feedback captured *while building
> this job* — orthogonal to `GOAL/PLAN/TECH/REVIEW`. Kept out of the blind reviewer's context.

## F1 — strict gate exits 1 on a branch with zero new warnings when `main` itself regressed
`origin=docs-review severity=medium category=tooling status=open target=.agents/factory/bin/strict_check.py`
- **What happened:** invariant 8 says "no new warnings vs the baseline on `main`", but `strict_check.py`
  compares against the static `strict-baseline.txt`, which lacks a warning now present on `main`
  (session4 `session-5.md`). The gate failed on a clean branch; the reviewer had to prove the
  warning pre-existed via `git show main:…` by hand.
- **Skill cause (not mine):** the baseline file is the only tolerance mechanism and it drifts from `main`.
- **Recommended fix:** have the review/verify step diff against a fresh `main` build (or document a
  procedure to refresh the baseline when `main` regresses). Must not loosen the gate for branch-introduced
  warnings (invariant 8 is `hammerable:false`).
- **Confidence:** medium · **Effort:** small
