# META — harness retrospective for {slug}

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

<!-- EXAMPLE (delete when you add a real one):
## F1 — verify gate passes on build ERRORs
`origin=docs-plan severity=high category=tooling status=open target=.agents/factory/bin/strict_check.py`
- **What happened:** the verify recipe only caught new WARNINGs; a macros/Jinja error would PASS.
- **Skill cause (not mine):** the template's `verify:` had the hole.
- **Recommended fix:** fail the gate on ERROR/traceback lines too.
- **Confidence:** high · **Effort:** small
-->
