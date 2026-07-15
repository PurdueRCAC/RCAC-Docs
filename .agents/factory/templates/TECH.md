---
slug: example-slug
title: "One-line human title for this documentation job"
kind: feature
appetite: big
status: in_progress
branch: feature/example-slug
base: main
current_phase: P1
last_updated: "2026-01-01"
phases:
  - id: P1
    name: "Scaffold: index + overview (sets nav anchor and resource var)"
    status: pending
    satisfies: [R1]
    depends_on: []
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py"
  - id: P2
    name: "Draft the Running Jobs article"
    status: pending
    satisfies: [R2, R3]
    depends_on: [P1]
    parallel: true
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py && grep -q 'run_jobs' mkdocs.yml"
review:
  last_reviewed_commit: ""
  verdict: none
  blocked_reason: ""
---

# TECH.md — {title}

The **context engine and finite-state machine** for authoring this job. The YAML frontmatter
above is the resume ground-truth (read it with
`python3 .agents/factory/bin/next_phase.py spec/{slug}/TECH.md`); the per-phase checklists
below are the work. `docs-draft` executes the next actionable phase, runs its `verify:`
command, updates state via `python3 .agents/factory/bin/set_phase.py …`, and makes one atomic
content+state commit. Run from the repo root with the project env active.

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md) — R-IDs are the contract.
- **Authoritative design:** [`PLAN.md`](PLAN.md).
- **Backing research:** [`research/00-digest.md`](research/00-digest.md) + briefs (if `appetite: big`).

## Frontmatter field reference

- `base`: the branch this merges into — **`main`** (trunk and production).
- `status` (top): `planned | in_progress | blocked | in_review | done`
- `appetite`: `small | big` — caps phase count and draft-iteration budget (circuit breaker).
- phase `status`: `pending | in_progress | done | blocked`
- `satisfies`: GOAL R-IDs this phase delivers (traceability anchor for `docs-review`).
- `depends_on`: phase ids that must be `done` first (a phase is actionable only when met).
- `parallel`: `true` for genuinely independent content pages (e.g. two sibling userguide
  articles a research fan-out *could* draft separately). Anything that edits shared surface —
  `mkdocs.yml` nav, `main.py` macros, `docs/snippets/**`, an `index.md` hub — is always `false`.
  (Note: `docs-draft` itself still authors one phase at a time; `parallel` documents which
  phases have no ordering coupling.)
- `hammerable`: `false` marks a phase whose content accuracy or build integrity scope-hammering
  must **never** cut (HPC-accuracy pages, a11y, the build gate).
- `hill`: `uphill` (still figuring it out) → `crest` (unknowns resolved) → `downhill` (just
  writing). A phase stuck `uphill` across drafts is a raised hand → escalate to the human.
- `verify`: the exact command that proves the phase — prefer the `--strict` gate plus a nav/
  front-matter check; add a `mkdocs serve` render check in the phase steps when layout matters.

## Conventions (apply to every phase)

- Voice, archetype conventions, and load-bearing rules come from
  [`../../AGENTS.md`](../../AGENTS.md) (the constitution),
  [`../../.agents/factory/style-guide.md`](../../.agents/factory/style-guide.md), and the curated
  [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md).
- One phase per `docs-draft` invocation by default; one atomic commit containing **both** the
  content and the `TECH.md` state change. Commit subjects follow `[{category}] Draft {slug} P<n>: …`
  (no `WIP:` prefix) — squashed into the single PR-title commit at `docs-publish`.
- **No `Co-Authored-By` trailer** (repo convention; overrides any default).
- **Adding or moving a page updates `mkdocs.yml` `nav:` in the same commit** (else it is orphaned);
  when nav changes, regenerate breadcrumbs: `python tools/generate_breadcrumbs.py` (CI also does
  this, but keep the PR self-consistent).
- Never hand-edit generated files (catalogs, breadcrumbs) — regenerate via `tools/`.

---

## Phase P1 — Scaffold: index + overview
**Satisfies:** R1 · **Depends on:** —
**Goal:** <the section hub + overview page exist, set the `resource` var / nav anchor, and build clean>.

- [ ] Create `docs/userguides/<cluster>/index.md` and `overview.md` from the userguide archetype.
- [ ] Add the section + pages to `mkdocs.yml` `nav:`.
- [ ] `python tools/generate_breadcrumbs.py`.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`
- **Touches:** `docs/userguides/<cluster>/index.md`, `overview.md`, `mkdocs.yml`.

## Phase P2 — Draft the Running Jobs article
**Satisfies:** R2, R3 · **Depends on:** P1
**Goal:** <a complete, accurate Running Jobs page with a working batch-script example>.

- [ ] Write `run_jobs/index.md` (prose + `bash` batch example + admonitions + macros/snippets).
- [ ] Add it to `nav:`; add cross-links and a back-link to the hub.
- [ ] `mkdocs serve` and eyeball the rendered page (tabs, admonitions, macro expansion).
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py && grep -q 'run_jobs' mkdocs.yml`
- **Touches:** `docs/userguides/<cluster>/run_jobs/index.md`, `mkdocs.yml`.

---

## How `docs-draft` drives this

1. `next_phase.py` prints the next actionable phase (statuses are authoritative; the
   `current_phase` pointer is reconciled against them).
2. Pre-flight: clean tree, on `branch`, `base` (`main`) reachable, project env active
   (`python3 -c "import yaml, mkdocs"`).
3. Execute every `[ ]` in the phase (consult `PLAN.md` / `research/` / `style-guide.md` for detail).
4. Run the phase's `verify:` command — never advance on a checkbox alone.
5. Amend this file freely if reality diverges (regenerate frontmatter with `set_phase.py`; note the
   amendment in the commit body). STOP and escalate only on a **`GOAL.md` contradiction**.
6. Mark the phase `done`, advance `current_phase`, `--touch`; one `[{category}]` commit; stop and report.
