# META — harness retrospective for workflow-automation

> **Notes to the toolmaker, not to the reader.** Process/skillset feedback captured *while building
> this job* — orthogonal to `GOAL/PLAN/TECH/REVIEW` (which are about the doc). Each `docs-*` skill's
> **meta-note step** appends a finding here **only** when a concrete instruction/steering/tooling
> problem in the *skillset itself* cost something during that step; otherwise it stays silent.
> `/docs-harness` reads this file to propose fixes (human-gated). **This file is kept out of the
> blind reviewer's context** (it can reveal author intent). None below == the skills worked.

<!--
Append one finding per real problem, as a "## F<n> — <title>" section (n = next integer).
Line 2 of each section is the machine-readable attributes line (parsed by meta_status.py) — keep the
`key=value` tokens space-separated, values with NO spaces (paths are fine):

    origin   = which skill/step raised it (docs-feature | docs-plan | docs-draft:P3 | docs-review)
    severity = high | medium | low        (high = a safety/gate/correctness gap)
    category = instruction | steering | tooling | template | missing-guidance
    status   = open | applied | rejected | deferred   (skills write `open`; /docs-harness updates it)
    target   = best-guess file the fix touches (a path, no line number)

THE BAR (write only if YES): "Was this the *instructions'* fault — not mine, not the task's?"
Qualifies: hand-fixed a command the skill gave (wrong flag/path/unquoted YAML); a genuinely
ambiguous instruction; a [NEEDS CLARIFICATION] better guidance could have pre-empted; an
allowed-tools/step mismatch; a gate that passed/failed misleadingly.
Stay silent: the task was just hard; you erred against a clear instruction; a one-off *content*
issue (that belongs in REVIEW/GOAL); a vague preference with no measured cost.
Cap ≤3 findings/invocation, terse. If an equivalent finding exists, append "· seen again" to its
attributes line instead of duplicating. A fix that would weaken a `hammerable:false` gate is
`severity=high` and must say so explicitly.
-->

## F1 — no pattern for a phase that closes only after out-of-band (cluster) validation
`origin=docs-plan severity=medium category=missing-guidance status=open target=.agents/skills/docs-plan/SKILL.md`
- **What happened:** R15 / invariants §11 require every job script to be validated on a cluster before
  publish, and step agents never touch clusters. The plan had to invent a split (draft run → external
  validation recorded in `VALIDATION.md` → close run), with each `verify:` ending in a grep for a
  `P<n>: PASS` line, and a convention that the draft run runs `verify:` minus that clause.
- **Skill cause (not mine):** `docs-plan` Step 6 and `docs-draft` Step 4 assume `verify:` is fully
  machine-runnable in the drafting session; docs-draft treats any non-zero verify as STOP, with no
  defined state for "drafted, awaiting external validation". The split now lives only in this cycle's
  TECH conventions, and the verify recipe cannot express "partial verify for the draft run".
- **Recommended fix:** document an "externally validated phase" pattern in docs-plan Step 6 and
  docs-draft Step 4/5 (a validation-log file, a `P<n>: PASS` grep as the last `verify:` clause, an
  `in_progress`/`crest` draft-commit state, and the close run). Optionally a `validate:` phase field
  that `next_phase.py` reports. Strengthens, does not weaken, the `hammerable:false` gates.
- **Confidence:** high · **Effort:** small–medium

## F2 — "serve and eyeball" step has no recipe an unattended step agent can run
`origin=docs-draft:P1 severity=low category=instruction status=open target=.agents/skills/docs-draft/SKILL.md`
- **What happened:** TECH P1 and docs-draft Step 4 ask for `.venv/bin/mkdocs serve` and an eyeball of
  the render. A step agent has no browser, so it substituted a structural check of the built
  `site/<page>/index.html` (H1 count and heading order, `<thead>` and row count of each table, the
  rendered `href`s).
- **Skill cause (not mine):** the step names a human action with no machine-runnable equivalent, so
  each drafter improvises its own check, or skips it.
- **Recommended fix:** in docs-draft Step 4, give a short built-HTML check recipe (one H1, heading
  levels, tables with `<thead>`, include sentinels, links) as the unattended form of the eyeball step,
  keeping `mkdocs serve` for attended runs. Strengthens, does not weaken, a gate.
- **Confidence:** medium · **Effort:** small

## F3 — first `set_phase.py` run restyles the whole TECH frontmatter
`origin=docs-draft:P1 severity=low category=tooling status=open target=.agents/factory/bin/set_phase.py`
- **What happened:** advancing one phase rewrote every line of the YAML frontmatter (flow lists to
  block lists, double to single quotes), a ~170-line diff for a two-field state change, which buries
  the real state change from the gate reviewer.
- **Skill cause (not mine):** the script re-dumps the YAML in its own style instead of preserving the
  planner's; `docs-plan` writes a style the script does not round-trip.
- **Recommended fix:** have `set_phase.py` round-trip the existing style (e.g. `ruamel.yaml`), or have
  `docs-plan` emit the frontmatter through `set_phase.py`'s own dumper so the first draft run is not a
  restyle.
- **Confidence:** high · **Effort:** small
