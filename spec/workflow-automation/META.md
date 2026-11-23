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

## F4 — "byte-exact" snippet includes expand tabs
`origin=docs-draft:P2 severity=medium category=instructions status=open target=.agents/factory/style-guide.md`
- **What happened:** the style guide's "Publishing a file verbatim" pattern (a `--8<--` include
  inside a fenced block) is presented as byte-exact. It is not for tabs: Python-Markdown's
  whitespace normalizer expands every tab to spaces after the snippet is spliced in, so a Makefile
  published this way renders with spaces in its recipes and fails with "missing separator" when
  copied. Checked with the repo's own extensions; the P2 Makefile works around it with
  `.RECIPEPREFIX = >`.
- **Skill cause (not mine):** the guide promises byte-exact output and TECH flagged only `{`-hazards
  for the Makefile, so nothing warned that tab-significant files (Makefiles, TSV, Go) lose their tabs.
- **Recommended fix:** add one line to the style guide's verbatim-file pattern: tabs are expanded to
  spaces on render; avoid tab-significant content, or use a tab-free form (`.RECIPEPREFIX` for Make).
- **Confidence:** high · **Effort:** small

## F5 — P3 `verify:` has no include sentinel although the phase publishes snippet files
`origin=docs-draft:P3 severity=medium category=instruction status=open target=spec/workflow-automation/TECH.md`
- **What happened:** P3's pages publish three files through `--8<--` includes (a Snakefile and two
  Parsl files). A mistyped include renders an empty block and `--strict` stays silent (invariants §8),
  but P3's `verify:` checks only the build and the nav. The drafter grepped `site/` by hand.
- **Skill cause (not mine):** PLAN §6 ties include sentinels to "pages with scripts", meaning job
  scripts, so the planner left them out of phases whose includes are other verbatim files.
- **Recommended fix:** in docs-plan, add a sentinel clause to `verify:` for every phase that adds a
  `--8<--` include, whatever the file type (for P3: `grep -rqF glob_wildcards site/workflows/snakemake/`
  and `grep -rqF SlurmProvider site/workflows/parsl/`). Strengthens, does not weaken, a gate.
- **Confidence:** high · **Effort:** small

## F6 — a later phase's checklist misses a placeholder an earlier phase planted on pages it did not list
`origin=docs-draft:P4 severity=low category=instructions status=open target=.agents/skills/docs-plan`
- **What happened:** P2's checklist told the drafter to leave a "HyperShell User Guide" sentence for
  P4 to turn into a link, and P4's checklist and *Touches* name only the three P2 pages. P3's drafter
  wrote the same sentence on its four pages, so P4 had to amend TECH to touch seven pages, not three.
- **Skill cause (not mine):** the plan records a deferred edit only on the phase that plants it; a
  later phase that copies the pattern is not told to register its pages with the phase that resolves
  it.
- **Recommended fix:** in docs-plan, phrase a deferred edit as a grep the resolving phase runs
  (`grep -l 'HyperShell User Guide in this section' docs/workflows/*.md`) instead of a fixed page
  list, or have docs-draft append its pages to the resolving phase's *Touches* when it plants the
  same placeholder.
- **Confidence:** medium · **Effort:** small
