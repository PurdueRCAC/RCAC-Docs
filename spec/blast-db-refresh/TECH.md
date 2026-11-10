---
slug: blast-db-refresh
title: Announce the refreshed shared BLAST databases
kind: feature
appetite: small
status: in_review
branch: feature/blast-db-refresh
base: main
current_phase: done
last_updated: '2026-11-10'
phases:
- id: P1
  name: Draft the BLAST databases blog post
  status: done
  satisfies:
  - R1
  - R2
  - R3
  - R4
  - R5
  - R6
  - R7
  - R8
  - R9
  depends_on: []
  parallel: false
  hammerable: false
  hill: downhill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -rlq 'APPTAINERENV_BLASTDB' site/blog/ --include=index.html
review:
  last_reviewed_commit: ''
  verdict: none
  blocked_reason: ''
---
# TECH.md — Announce the refreshed shared BLAST databases

The FSM for this job. Read state with
`.venv/bin/python .agents/factory/bin/next_phase.py spec/blast-db-refresh/TECH.md`; mutate it with
`set_phase.py`.

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md).
- **Authoritative design:** [`PLAN.md`](PLAN.md).

## Conventions

Per [`../../AGENTS.md`](../../AGENTS.md), [`style-guide.md`](../../.agents/factory/style-guide.md),
and [`invariants.md`](../../.agents/factory/invariants.md). One atomic content+state commit; no
`Co-Authored-By` trailer.

---

## Phase P1 — Draft the BLAST databases blog post
**Satisfies:** R1–R9 · **Depends on:** —
**Goal:** a complete, accurate post that builds clean (beyond the pre-existing `main` warning) and renders.

- [x] Write `docs/blog/posts/blast-databases-refresh.md` per PLAN §2.
- [x] Check every fact against GOAL source-of-truth and Clarifications; no extra claims.
- [x] Run the verify command; the only allowed strict warning is the pre-existing
      `session4/index.md → session-5.md` link (PLAN §5).
- [x] Render check: built page exists, excerpt cut on the blog index, admonitions and table render.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -rlq 'APPTAINERENV_BLASTDB' site/blog/ --include=index.html`
- **Touches:** `docs/blog/posts/blast-databases-refresh.md`.
- **At publish:** set `date.created` to the merge date.
