---
name: docs-publish
description: >-
  Land an approved documentation branch on main. Default: push the branch and open a squash PR to
  main with a rich, artifact-linked body (Summary/Goal/Design/Research/Phases/Verification).
  Alternative (local): squash-merge into main locally. Confirms before any irreversible/outward step;
  never targets dev. NOTE: merging to main auto-deploys to production (Geddes) within ~5 minutes —
  this is the one irreversible, outward step. Final step of the documentation factory.
disable-model-invocation: true
argument-hint: "[pr (default) | local] [merge]"
allowed-tools: Read, Grep, Glob, AskUserQuestion, Bash(git status *), Bash(git branch *), Bash(git log *), Bash(git diff *), Bash(git rev-parse *), Bash(git fetch *), Bash(git push *), Bash(git switch *), Bash(git checkout *), Bash(git merge *), Bash(git add *), Bash(git commit *), Bash(gh pr *), Bash(gh repo *), Bash(.venv/bin/python .agents/factory/bin/meta_status.py *)
---

# docs-publish — ship the branch to main

Open a squash PR to `main` (default) or squash-merge locally. **Merging to `main` deploys to
production within ~5 minutes — there is no staging gate.** Always confirm before the irreversible step,
and never target `dev` (CI blocks `dev → main` anyway; `dev` is the a11y branch).

## Step 0 — status (when requested)

Report the review verdict, commits vs `main`, and any existing PR (`gh pr status`). No action.

## Step 1 — Pre-flight

- On the `feature/`|`fix/`|`refactor/` branch, clean tree; resolve `{slug}`.
- Read `kind` and `review.verdict` from `TECH.md` — **STOP if the verdict is not `approved`**
  (unless the human explicitly overrides). If review flagged a human gate, confirm sign-off happened.
- `git fetch origin`; flag if the branch is behind `main`.

## Step 2 — Compose PR title + body

- **Title:** `[{kind}] {imperative summary}` synthesized from `GOAL.md` (never Conventional Commits
  like `feat:`/`docs:`).
- **Body** (link artifacts via SHA-pinned permalinks using `git rev-parse HEAD`; link, don't quote):
  - **Summary** — what changed and why (from GOAL).
  - **Goal** → `spec/{slug}/GOAL.md`
  - **Design** → `spec/{slug}/PLAN.md`
  - **Research** → `spec/{slug}/research/*.md` (if present)
  - **Phases completed** → from the `TECH.md` FSM (id · name · satisfies R-IDs)
  - **Verification** → from `spec/{slug}/REVIEW.md` (build/render/link/nav/a11y results, verdict)
  - **🔧 Harness feedback** *(only if
    `.venv/bin/python .agents/factory/bin/meta_status.py spec/{slug}/META.md --status open` reports `open > 0`)*
    → a short, collapsed section listing each open finding (`id · severity · title`), then label the
    PR: `gh pr edit --add-label harness-feedback`. Keep it terse (link to `META.md` for detail) so it
    doesn't dominate the PR; route them later with `/docs-harness`. Do **not** write or resolve
    findings here.
  - `Closes #NN` (this auto-closes the issue — `main` is the default branch)
  - trailing line: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`

## Step 3 — Confirm with the human (mandatory)

`AskUserQuestion`: mode (PR vs local), title, and body. This is the last gate before production.

## Step 4a — PR (default)

`git push -u origin {branch}` → `gh pr create --base main --head {branch} --title "…" --body-file …`.
If `merge` is confirmed: `gh pr merge {N} --squash --subject "{title}" --body "…" --delete-branch`.

## Step 4b — local

`git switch main && git pull --ff-only` → `git merge --squash {branch}` →
`git commit -m "{title}"` → `git branch -D {branch}`. Do not push `main` unless explicitly asked
(a push to `main` triggers the production deploy).

## Step 5 — Report

PR URL / merge result, the squash subject, and the retained `spec/{slug}/` artifacts. Remind the
human that a merge to `main` rolls out to `docs.rcac.purdue.edu` within ~5 minutes.
