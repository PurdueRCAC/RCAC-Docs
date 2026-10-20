# META — harness retrospective for hubzero-docs

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

## F1 — docs-feature assumes a branch switch in the main checkout
`origin=docs-feature severity=medium category=instruction status=open target=.agents/skills/docs-feature/SKILL.md`
- **What happened:** Step 1 requires being on `main` and Step 3 runs `git switch -c {branch} main`
  in place. The main checkout holds `main` while each job lives in its own worktree under
  `.worktrees/`, so the job branch was made with `git worktree add` instead, and the pre-flight
  "on `main`" check didn't apply where the GOAL was written.
- **Skill cause (not mine):** no worktree path in Steps 1 and 3; `allowed-tools` lacks `git worktree`.
- **Recommended fix:** add a worktree variant: pre-flight checks the main checkout is on clean
  `main`; Step 3 runs `git worktree add .worktrees/{slug} -b {branch} main` and works from there;
  allow `Bash(git worktree *)`. `docs-plan` Step 1 already works unchanged inside a worktree.
- **Confidence:** high · **Effort:** small

## F2 — docs-review's diff command leaks PLAN/TECH to the blind reviewer
`origin=docs-review severity=high category=instruction status=open target=.agents/skills/docs-review/SKILL.md`
- **What happened:** Step 2 hands the reviewer `git diff main...HEAD`, but `spec/{slug}/` is
  committed on the branch, so that diff carries `PLAN.md`, `TECH.md`, `research/`, and `META.md`
  in full. Read as written, it breaks the blindness the step exists for. The orchestrator ran
  `git diff main...HEAD -- . ':!spec/'` instead and passed GOAL.md inline.
- **Skill cause (not mine):** the diff recipe in Step 2 and in `review-rubric.md` ("What the
  reviewer sees") has no `spec/` exclusion.
- **Recommended fix:** use `git diff main...HEAD -- . ':!spec/'` (and the same for `--stat`) in
  both files; GOAL.md is already passed inline. Severity high because it's a gate-integrity gap.
- **Confidence:** high · **Effort:** small

## F3 — docs-draft's render check assumes a browser
`origin=docs-draft:P5 severity=medium category=missing-guidance status=open target=.agents/skills/docs-draft/SKILL.md`
- **What happened:** Step 4's "`mkdocs serve` and eyeball the rendered page" couldn't be done in a
  headless session (Remote Control from a phone, overnight). Scratch probes over `site/` stood in
  and caught two importer bugs that `--strict` and the phase gate passed (headings inside
  admonitions, collapsed list items). They still missed three that the blind reviewer found by
  diffing against upstream's renderer (emoji shortcodes, indented includes, list start numbers).
- **Skill cause (not mine):** the render step names no headless method. For migrations, the
  strongest check is a structural diff against the source's own renderer, and the skill doesn't
  mention it.
- **Recommended fix:** add a headless alternative to Step 4: grep or parse the built `site/` for
  the page's structure, and for ports, build the upstream renderer and compare element counts per
  page. Consider committing such a probe under `.agents/factory/bin/`.
- **Confidence:** medium · **Effort:** medium
