---
name: docs-plan
description: >-
  Turn a shaped spec/{slug}/GOAL.md into a design and a phased roadmap. Runs an invariant gate
  against AGENTS.md, fans out read-only research subagents (scaled to appetite; existing-site-first),
  synthesizes spec/{slug}/PLAN.md, re-checks invariants, and generates spec/{slug}/TECH.md — the
  phased YAML-FSM driven by /docs-draft. Second step of the documentation factory
  (see .agents/factory/methodology.md).
disable-model-invocation: true
argument-hint: "[appetite small|big] [skip research] [status]"
allowed-tools: Read, Write, Edit, Grep, Glob, Agent, AskUserQuestion, WebSearch, WebFetch, Bash(git status *), Bash(git branch *), Bash(git rev-parse *), Bash(git log *), Bash(git add *), Bash(git commit *), Bash(python3 .agents/factory/bin/*), Bash(python3 -c *)
---

# docs-plan — research → PLAN → TECH

Design the change and generate the phased FSM the drafting step resumes from. Two invariant gates
bracket the design so it can't drift from the constitution.

## Step 1 — Pre-flight & load

- Confirm a `feature/`|`fix/`|`refactor/` branch with a clean tree; resolve `{slug}` from the branch.
- Assert the environment: `python3 -c "import yaml, mkdocs"` (activate `.venv`/conda if it fails).
- Read `spec/{slug}/GOAL.md`, `.agents/factory/invariants.md`, `.agents/factory/style-guide.md`,
  and `AGENTS.md`. GOAL.md must be committed with **no unresolved `[NEEDS CLARIFICATION]`** — if any
  remain, STOP and return to `/docs-feature`.

## Step 2 — Invariant gate #1 (pre-research)

List the invariant sections this change touches (branch/deploy, generated-content firewall,
nav-is-manual, links/assets, front-matter, macros/Jinja, build integrity, WCAG, per-cluster
parallelism, HPC accuracy). Confirm the intent is sane; STOP/escalate on a fundamental conflict.

## Step 3 — Research fan-out (appetite-scaled)

- `small` / `fix` / `skip research` → skip the fan-out; do a couple of targeted reads (the
  gold-standard page to mirror, the relevant macros in `main.py`, the nav neighborhood).
- `big` → launch parallel **read-only** `Agent` subagents, one per rabbit-hole topic, each writing
  `spec/{slug}/research/NN-topic.md` (numbered to avoid write conflicts). **Existing-site-first:**
  survey how the current docs handle this (archetype, macros, snippets, nav) before the web; reserve
  `WebSearch`/`WebFetch` for external unknowns (HPC vendor specs, reference sites). Then synthesize
  `spec/{slug}/research/00-digest.md`.

Research is the one place we parallelize; drafting never is.

## Step 4 — Write PLAN.md

From `.agents/factory/templates/PLAN.md`: summary; design at the right altitude (archetype, page
structure/outline, exact `nav:` placement, macros/snippets to reuse, assets, cross-links, a11y
plan); a **requirement → design map** covering every R-ID; rabbit holes resolved; risks/open
questions; and a **verification strategy** that seeds each phase's `verify:` (the `--strict` gate
plus nav/front-matter/render checks).

## Step 5 — Invariant gate #2 (post-design)

Re-walk the touched invariants against the drafted design; fill PLAN's **deviation-justification
table** (empty is the goal). STOP on an unavoidable CRITICAL conflict.

## Step 6 — Generate TECH.md (the FSM)

From `.agents/factory/templates/TECH.md`, author phases as **publishable units** (a page or coherent
section that builds clean, is wired into nav, and passes structural a11y), ordered scaffold-first
(the `index.md`/hub that sets nav anchors and the `resource` var), then dependent pages, then a final
integration phase (cross-links, breadcrumbs). Per phase set `id`, `name`, `satisfies` (R-IDs),
`depends_on`, `parallel` (`false` for anything editing `mkdocs.yml`/`main.py`/shared snippets/hubs),
`hammerable` (`false` for HPC-accuracy/a11y/build phases), `hill: uphill`, and a real `verify:`.
Set top `status: in_progress`, `current_phase` = first phase, `base: main`, `last_updated` today.

**Validate:** `python3 .agents/factory/bin/next_phase.py spec/{slug}/TECH.md` must exit 0 and report
the first phase. If it reports invalid, fix it before committing.

## Step 7 — Commit

`git add spec/{slug}/research spec/{slug}/PLAN.md spec/{slug}/TECH.md` →
`git commit -m "[{kind}] Plan {slug}: design + phased roadmap"` (no `Co-Authored-By` trailer).

## Step 8 — Report & hand off

Summarize the design, the phase list, and any risks/open questions for the human. Recommend
`/docs-draft` to begin executing the roadmap.
