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
confirm — emit a literal `[NEEDS CLARIFICATION: …]` marker and ask (`AskUserQuestion`). Wrong or
invented documentation harms real users.

## Step 1 — Pre-flight

- Confirm you are on `main` with an otherwise-clean tree. The only permitted pending change is an
  untracked `spec/{slug}/GOAL.md` you are about to adopt. If not on `main`, STOP and tell the human.
- `git fetch origin || true` (best-effort freshness).

## Step 2 — Resolve slug / kind / appetite

- **kind:** `feature` (new material), `fix` (correction/enhancement), or `refactor` (restructure).
  Default `feature` unless the prompt/argument says otherwise.
- **appetite:** `small` or `big`. Default `small` for `fix`, `big` for a new user guide / tutorial
  series. `small` skips research fan-out and usually collapses to a single phase.
- **slug:** a short kebab-case name (≤ ~5 words), or take it from a given `spec/<slug>/GOAL.md` path.
- **branch:** `{kind}/{slug}` (e.g. `feature/gautschi-python-guide`).
- **Collision check:** `git rev-parse --verify {branch}` must fail (branch absent) and
  `spec/{slug}/` must not already be tracked. If either exists, pick a new slug or STOP.

## Step 3 — Create the branch

`git switch -c {branch} main`

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

## Step 6 — Commit

`git add spec/{slug}/GOAL.md` → `git commit -m "[{kind}] Shape {slug} goal"`
(no `Co-Authored-By` trailer).

## Step 7 — Report & hand off

Summarize the slug, kind, appetite, and the R-IDs; note any `[NEEDS CLARIFICATION]` awaiting the
human. Recommend `/docs-plan` once the GOAL is approved.
