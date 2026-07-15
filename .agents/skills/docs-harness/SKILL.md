---
name: docs-harness
description: >-
  Apply the documentation factory's self-improvement findings. Reads a job's spec/{slug}/META.md
  (the harness-retrospective log the docs-* skills append to), proposes the recommended skillset
  fixes, and — human-gated, defaulting to all but scopable to specific finding ids — applies them to
  the .agents/ factory, one atomic [harness] commit each, recording every decision in
  .agents/factory/harness-log.md. A META/maintenance skill: it changes the TOOLCHAIN, not any
  documentation. Not part of the content lifecycle; it never writes META.md (no meta-on-meta).
disable-model-invocation: true
argument-hint: "<slug | spec/<slug>/META.md | --all> [F1 F3 …] [--severity high] [--dry-run]"
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion, Bash(git status *), Bash(git branch *), Bash(git switch *), Bash(git checkout *), Bash(git rev-parse *), Bash(git log *), Bash(git diff *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(gh pr *), Bash(uv *), Bash(.venv/bin/python *), Bash(python3 .agents/factory/bin/*), Bash(grep *)
---

# docs-harness — apply the factory's self-improvement findings

The **act** side of the self-improvement loop. The `docs-*` skills *observe* friction and append
findings to `spec/{slug}/META.md`; this skill *reads* those findings and, **with human review**,
edits the `.agents/` factory to fix them. It touches the toolchain only — never documentation, never
`GOAL/PLAN/TECH/REVIEW`, and **never `META.md` findings' text** (it only flips their `status`).

> **This skill can degrade the factory if misused — so it is human-gated by construction.** It never
> auto-applies; it previews every edit; and it refuses to weaken a safety gate without an explicit
> typed override (see Step 3). `.agents/**` changes do **not** trigger the production deploy (the CI
> path filter skips factory bookkeeping), so this is low-blast-radius — but review the diffs anyway.

> **Harness portability.** Uses `AskUserQuestion` if available, else asks in plain text and STOPs.
> Everything else is `git` + stdlib `python3` (`meta_status.py`) and is portable.

## Step 1 — Resolve target & working branch

- **Target:** a `{slug}`, an explicit `spec/<slug>/META.md` path, or `--all` (every
  `spec/*/META.md` with open findings — process one job at a time).
- **Where to run** (keep toolchain edits unentangled from doc content):
  - **Recommended — post-merge:** the job is already merged, so `spec/{slug}/META.md` is on `main`.
    From a clean `main`, create `git switch -c harness/{slug} main`; apply there; PR to `main`.
  - **In-branch (test-drive convenience):** if the job isn't merged yet, run on its feature branch so
    the fixes ride with the content PR. State clearly that this mixes toolchain + content.
- Ensure the uv-synced `.venv` (AGENTS.md "Setup") if you will run any script self-tests.

## Step 2 — Enumerate the findings

- `python3 .agents/factory/bin/meta_status.py spec/{slug}/META.md --status open` → the open findings
  (id · severity · category · target · title). Zero findings → nothing to do; report and stop.
- **Scope from the args:** positional ids (`F1 F3`) restrict to those; `--severity high` filters;
  `--dry-run` = preview only, make no edits/commits.
- **Consult `.agents/factory/harness-log.md` first:** flag any selected finding that repeats a prior
  **rejected** decision, or whose fix would **revert** a recently applied change — these need explicit
  human ack, not silent re-application.

## Step 3 — Triage & confirm (the human gate)

For each selected finding, read its `target` file **fresh** (findings store a file, not a line — never
trust a stale locator) and derive the **minimal** edit. Then screen it:

- **Safety rail — never bypass.** If the fix would weaken a `hammerable:false` gate or a load-bearing
  invariant (build integrity, HPC accuracy, WCAG a11y, branch/deploy model), do **not** apply on the
  finding's say-so: default to `deferred` and require the human to *explicitly type an override* to
  proceed. A finding that argues to loosen a guardrail is itself a warning sign.
- **Generality test.** A fix must improve the skill for *all* jobs. If it bakes in this job's
  specifics (a cluster name, one archetype, a one-off path), **reject** it (`rejected: overfit`).
  Prefer adding an *example* over a hard rule.
- **Minimality.** Smallest change that resolves the finding; don't opportunistically refactor.

Then present the batch (each finding: id, target, the proposed diff, and reject/defer flags) and get
approval — `AskUserQuestion` if available, else plain text + STOP. Default proposal = apply all
selected; the human may prune ("apply F0 and F3 only") or reject individually. Respect `--dry-run`:
show the previews and stop.

## Step 4 — Apply (one atomic commit per finding)

For each approved finding:

- Make the edit to `target`.
- **Post-apply verification** — never commit a broken tool:
  - script edited (`bin/*.py`) → run it (`.venv/bin/python … --help` / a smoke invocation) and, for
    `strict_check.py`, its ERROR/clean self-checks; `settings.json` → JSON-lint; `TECH.md`/template →
    `next_phase.py` still exits 0.
  - skill/template/doc → read it back; confirm no broken reference.
- Flip the finding in META.md: `status=open` → `status=applied` on its attributes line (a targeted
  string replace — do not rewrite the file).
- Append a row to `.agents/factory/harness-log.md` (date · `Fid` + title · job · `applied` · target ·
  short note). Use today's date from context.
- Commit: `git commit -m "[harness] Apply {slug} {Fid}: {short title}"` (no `Co-Authored-By`). **One
  finding per commit** so any single fix is independently revertable.

## Step 5 — Rejections, deferrals & pruning

- Declined finding → flip `status=rejected` (or `deferred`) and append `· <status>: <reason>` to its
  attributes line; log it in `harness-log.md` so it does not recur.
- Stale/unapplicable finding (target moved, already fixed) → `status=rejected` with `stale`.
- Commit these META/log updates together: `[harness] Triage {slug} META findings`.

## Step 6 — Report & (optional) PR

- Summary: applied / deferred / rejected counts, each finding's outcome, and the commits.
- On a `harness/{slug}` branch: offer to `git push` + `gh pr create --base main` (human-confirmed).
  Note the deploy CI skips `.agents/**`, so this PR does not roll production — but it still changes how
  every future job is built, so it deserves a real review.

## Guardrails recap (do not violate)

- **Never** auto-apply; **never** weaken a safety/`hammerable:false` gate without an explicit human
  override; **never** apply an overfit fix; **never** write or invent META findings; **never** recurse
  (`/docs-harness` produces no META). Cap ~8 applied findings per run without re-confirmation. When in
  doubt, `defer` and ask.
