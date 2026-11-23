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

