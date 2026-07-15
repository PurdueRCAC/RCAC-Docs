---
name: docs-feature
description: >-
  Start a new RCAC-Docs documentation job (feature/fix/refactor) from a clean main branch.
  Safety-checks the tree, derives a {slug}, creates feature/{slug} | fix/{slug} | refactor/{slug},
  ingests an inline prompt or an untracked GOAL.md, and refines it into spec/{slug}/GOAL.md —
  appetite, non-goals, EARS acceptance criteria with stable R-IDs, resolved clarifications.
  Shaping only: no deep research, no drafting of pages. The first step of the documentation
  factory lifecycle (see .agents/factory/methodology.md).
disable-model-invocation: true
argument-hint: "<inline description> | spec/<slug>/GOAL.md [fix|refactor] [appetite small|big]"
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion, Bash(git status *), Bash(git branch *), Bash(git switch *), Bash(git checkout *), Bash(git rev-parse *), Bash(git fetch *), Bash(git add *), Bash(git commit *), Bash(git log *)
---

# docs-feature — shape the goal

Shape a documentation job into a locked `spec/{slug}/GOAL.md` on a fresh branch. This is the
first step of the factory (see `.agents/factory/methodology.md`). Produce exactly one artifact
and stop for the human's sign-off before the more expensive `/docs-plan`.

**Never guess.** Where intent is ambiguous — which cluster, which audience, an HPC spec you can't
confirm — emit a literal `[NEEDS CLARIFICATION: …]` marker and ask the human. Wrong or invented
documentation harms real users. **Shaping is not research:** answer from a quick local
`Read`/`Grep` (the prompt, the files it references, the nav) or from the human — do **not** open a
research rabbit hole here. Anything needing external verification (an HPC spec, a repo, a vendor
doc) is marked `[NEEDS CLARIFICATION]` and deferred to `/docs-plan`.

> **Harness portability (smaller models / non-Claude harnesses).** Degrade gracefully, don't fail:
> gather clarifications with `AskUserQuestion` **if your harness has it, otherwise ask the questions
> in plain text and STOP** for the human. The `allowed-tools` / `disable-model-invocation`
> front-matter keys are Claude-Code-specific and are harmlessly ignored elsewhere.

## Step 1 — Pre-flight

- Confirm you are on `main`. **"Clean" tree = no *uncommitted* changes** (an untracked
  `spec/{slug}/GOAL.md` you are about to adopt is fine). **Being ahead of / diverged from
  `origin/main` is normal and is NOT a blocker** — the `.agents/` factory may exist only on local
  `main`. If not on `main`, STOP and tell the human.
- `git fetch origin || true` (best-effort freshness). **Do not** `reset`/rebase onto `origin` to
  reconcile divergence — you branch off **local** `main` (HEAD) in Step 3.

## Step 2 — Resolve slug / kind / appetite

- **kind:** `feature` (new material), `fix` (correction/enhancement), or `refactor` (restructure).
  Default `feature` unless the prompt/argument says otherwise.
- **appetite:** `small` or `big`. Default `small` for `fix`, `big` for a new user guide / tutorial
  series. `small` skips research fan-out and usually collapses to a single phase.
- **slug:** a short kebab-case name (≤ ~5 words), or take it from a given `spec/<slug>/GOAL.md` path.
- **branch:** `{kind}/{slug}` (e.g. `feature/gautschi-python-guide`).
- **Collision check:** `git rev-parse --verify {branch}` must fail (branch absent) and
  `spec/{slug}/` must not already be tracked. If either exists, pick a new slug or STOP.

> **Substitute the placeholders — never emit a literal `{slug}`/`{branch}`.** Worked example: slug
> `gautschi-python-guide` → branch `feature/gautschi-python-guide` → artifact
> `spec/gautschi-python-guide/GOAL.md`.

## Step 3 — Create the branch

`git switch -c {branch} main`  — off **local** `main` (HEAD), never `origin/main` (which may lack
the `.agents/` factory).

## Step 4 — Write / refine GOAL.md

From `.agents/factory/templates/GOAL.md`, write `spec/{slug}/GOAL.md`:

- Record `slug`, `kind`, `appetite` in the header bullets.
- **Problem** and **Outcome / vision** in plain language (what's missing/wrong, for which readers).
- **Acceptance criteria** as stable `R1`, `R2`, … nudged toward EARS
  (`.agents/factory/ears.md`) — reader-facing, observable outcomes, not implementation.
- **Non-goals** — explicit exclusions bounding scope to the appetite.
- **Clarifications** — dated Q/A; any unresolved item stays `[NEEDS CLARIFICATION: …]`.
- **Related materials** — issue link, gold-standard pages to mirror, reference sites, source specs.

If adopting a hand-written untracked `GOAL.md`, refine it in place rather than overwriting intent.

## Step 5 — Coherence self-check

Bounded to the appetite · no unresolved `[NEEDS CLARIFICATION]` left silently · every criterion is
testable (renderable/checkable) · the archetype is implied or stated.

**Size circuit-breaker.** If the job needs more than ~8–10 acceptance criteria, or spans several
distinct deliverable types / "pillars," it is probably too big for one job. Surface this to the
human and offer to split into a **pilot + follow-ups** (record the deferrals in Non-goals) rather
than shaping a mega-GOAL that a downstream draft can't land cleanly.

## Step 6 — Commit

`git add spec/{slug}/GOAL.md` → `git commit -m "[{kind}] Shape {slug} goal"`
(no `Co-Authored-By` trailer).

## Step 7 — Report & hand off

Summarize the slug, kind, appetite, and the R-IDs; note any `[NEEDS CLARIFICATION]` awaiting the
human. Recommend `/docs-plan` once the GOAL is approved.

**GOAL is the locked contract — but not frozen forever.** It MAY be amended later (during
`/docs-plan`, or after review feedback) **only with explicit human direction**, recorded in a dated
Clarifications sub-block with the affected R-IDs re-confirmed. It must never drift *silently* during
drafting.
