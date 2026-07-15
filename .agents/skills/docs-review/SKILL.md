---
name: docs-review
description: >-
  Adversarial QA of a completed documentation branch. Delegates the correctness pass to a FRESH
  reviewer subagent that sees only GOAL.md + the branch diff + the invariants + the style guide + the
  runnable repo — NOT PLAN.md/TECH.md (avoids grading-its-own-homework). The reviewer verifies by
  building (mkdocs --strict), rendering, and checking links/nav/front-matter/a11y; classifies each
  finding CONFIRMED (machine-checked) or PLAUSIBLE (HPC accuracy / prose a11y → human). CONFIRMED
  findings loop back to /docs-draft; high-impact files force a human gate. Fourth step of the
  documentation factory (see .agents/factory/review-rubric.md).
disable-model-invocation: true
argument-hint: "[debate] [completeness] [status]"
allowed-tools: Read, Grep, Glob, Write, Agent, ReportFindings, AskUserQuestion, Bash(git status *), Bash(git branch *), Bash(git log *), Bash(git diff *), Bash(git rev-parse *), Bash(git add *), Bash(git commit *), Bash(python3 .agents/factory/bin/set_phase.py *)
---

# docs-review — blind adversarial QA

Grade the branch against the locked `GOAL.md` and the invariants, in a clean context, by rendering
the site — not by assertion. Full operating manual: `.agents/factory/review-rubric.md`.

## Step 1 — Pre-flight

- On the `feature/`|`fix/`|`refactor/` branch; resolve `{slug}`; read `base` (`main`) and `kind`
  from `TECH.md` (metadata only — do **not** feed PLAN/TECH content to the reviewer).
- Capture the head SHA: `git rev-parse HEAD`.
- If `TECH.md` `status` is not `in_review`/`done`, ask whether to proceed anyway.

## Step 2 — Delegate the correctness pass (blind)

Spawn a fresh `Agent` (general-purpose) given **inline, ONLY**:

- the full text of `spec/{slug}/GOAL.md` (the R-IDs);
- the diff command to run: `git diff main...HEAD` (+ `git log --oneline main..HEAD`);
- the full text of `.agents/factory/invariants.md`, `.agents/factory/review-rubric.md`,
  `.agents/factory/style-guide.md`, and `.agents/factory/strict-baseline.txt`;
- instructions to work in the runnable repo (project env active) and **verify by executing**:
  `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`, `mkdocs serve`
  + view changed pages, nav/front-matter/a11y checks;
- an explicit instruction to **NOT read `PLAN.md`, `TECH.md`, `research/`, or `META.md`** (the last
  can leak author intent and would break blindness).

Required return: structured findings — each with severity, **CONFIRMED** (reproduced by
command/render/diff) vs **PLAUSIBLE** (HPC accuracy or prose a11y that isn't machine-checkable →
human triage), `file:line`, failure scenario/concern, executed evidence — plus a requirement→evidence
matrix and any unmapped (scope-creep) changes.

`debate` → spawn two independent reviewers (one arguing "ship", one "block") and reconcile.

## Step 3 — Collect, sanity-check, report

Write `spec/{slug}/REVIEW.md` from the template. Call `ReportFindings` (most-severe first, each
carrying its CONFIRMED/PLAUSIBLE verdict). Silence on a clean diff is a valid result — do not
manufacture findings.

## Step 4 — Set verdict & route

- **Clean pass:** `set_phase.py spec/{slug}/TECH.md --verdict approved --reviewed-commit {sha} --touch`
  → recommend `/docs-publish`.
- **CONFIRMED findings:** `set_phase.py … --top-status blocked --verdict changes-requested
  --reviewed-commit {sha} --blocked-reason "<short>" --touch` → recommend `/docs-draft`. If any
  CONFIRMED finding touches a **high-impact file** (see review-rubric) → STOP and require human sign-off.
- **PLAUSIBLE only:** surface to the human for triage; do not auto-block.
- Then commit the review: `git commit -m "[{kind}] Review {slug}: cycle {n} — {verdict}"`
  (no `Co-Authored-By` trailer).

## Step 5 — Optional completeness sub-pass (`completeness`)

A separate fresh subagent that *may* read `TECH.md`: did every planned phase ship? did scope balloon
past appetite? Append its notes to `REVIEW.md`.

## Step 6 — Meta-note (process only; usually a no-op)

**You (the orchestrator), not the blind reviewer, write this — after `REVIEW.md` exists.** Append a
finding to `spec/{slug}/META.md` **only** if the *rubric or the review skill itself* was unclear or
mis-steered the pass (e.g. an invariant that was ambiguous to apply, a verify step that didn't catch
what it should). **Content findings do NOT go here — they go in `REVIEW.md`.** The bar is the same:
*the instructions' fault, not the task's.* `origin=docs-review`, terse, ≤2, silence by default; a
fix that would weaken a `hammerable:false` gate is `severity=high`. Commit it with the review. This
records only — `/docs-harness` applies fixes later.

## Final report

Verdict, finding counts (CONFIRMED vs PLAUSIBLE), human-gate status, R-ID coverage, and the next
step. Bounded loop: escalate to the human on the 2nd–3rd non-converging cycle. Remember a merge to
`main` auto-deploys to production within ~5 minutes — review is the last line of defense.
