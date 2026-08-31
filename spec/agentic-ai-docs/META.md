# META — harness retrospective for agentic-ai-docs

> **Notes to the toolmaker, not to the reader.** Process/skillset feedback captured *while building
> this job* — orthogonal to `GOAL/PLAN/TECH/REVIEW` (which are about the doc). Each `docs-*` skill's
> **meta-note step** appends a finding here **only** when a concrete instruction/steering/tooling
> problem in the *skillset itself* cost something during that step; otherwise it stays silent.
> `/docs-harness` reads this file to propose fixes (human-gated). **This file is kept out of the
> blind reviewer's context** (it can reveal author intent). None below == the skills worked.

## F1 — scope/branch-hygiene check is optional, so bundled non-content commits nearly slipped past review
`origin=docs-review severity=low category=missing-guidance status=open target=.agents/skills/docs-review/SKILL.md`
- **What happened:** the branch carried nine `[harness]` commits (`.agents/**` + `AGENTS.md`, ~1k
  lines) alongside the content work. The **blind correctness pass** (Step 2) is scoped to content vs
  `GOAL.md` and only listed them as "unmapped changes" — it did not surface the real consequence
  (a squash-merge folds `[harness]` tooling into a content-titled commit on the production trunk).
  That consequence was caught only because the orchestrator chose to run the **optional** Step 5
  completeness sub-pass, which can see the appetite and reason about the squash-PR.
- **Skill cause (not mine):** `docs-review` has no *mandatory* step that checks branch hygiene —
  whether the diff mixes commit `[category]`s foreign to the feature (e.g. `[harness]` on a content
  branch) and what a squash merge would do to them. It's left to an optional pass, so by default a
  material publish-time concern is missed.
- **Recommended fix:** add a cheap mandatory pre-flight check (Step 1) or correctness-pass item —
  `git log --oneline main..HEAD`, flag any commit whose `[category]` differs from `{kind}`, and note
  the squash-fold implication for `docs-publish`. Does **not** weaken any `hammerable:false` gate.
- **Confidence:** medium · **Effort:** small
