---
name: docs-draft
description: >-
  Resume and execute a documentation job's phased roadmap. Discovers spec/{slug}/TECH.md from the
  current feature/fix/refactor branch, reads the FSM via next_phase.py, authors the next phase
  (default one at a time), runs that phase's verify command (mkdocs --strict + nav/render checks),
  updates state via set_phase.py, and makes one atomic content+state commit. May amend TECH.md freely
  as reality dictates; only a GOAL.md contradiction forces a stop. The resume-and-write driver of the
  documentation factory (see .agents/factory/methodology.md).
disable-model-invocation: true
argument-hint: "[status | dry run | phase P3 | through P5 | next 2 | skip review]"
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git status *), Bash(git branch *), Bash(git rev-parse *), Bash(git log *), Bash(git diff *), Bash(git add *), Bash(git commit *), Bash(uv *), Bash(.venv/bin/python *), Bash(.venv/bin/mkdocs *), Bash(python3 .agents/factory/bin/*), Bash(python3 -c *), Bash(grep *)
---

# docs-draft — execute the roadmap

Resume the FSM in `spec/{slug}/TECH.md` and author the next phase. The frontmatter is the
ground-truth; you never hand-edit its YAML — `next_phase.py` reads it and `set_phase.py` mutates it.

## Step 0 — status / dry-run (when requested)

Print the FSM state (`.venv/bin/python .agents/factory/bin/next_phase.py …`) and what the next phase
would do. No edits, no commits.

## Step 1 — Pre-flight

- Clean tree on a `feature/`|`fix/`|`refactor/` branch; resolve `{slug}`. ("Clean" = no uncommitted
  changes; ahead of / diverged from `origin` is fine — never `reset`/rebase onto `origin` to fix it.)
- **Ensure the toolchain env** — a `uv`-synced `.venv` (see AGENTS.md "Setup"); run everything via
  `.venv/bin/…`, never system Python. Idempotent bootstrap:
  ```bash
  [ -x .venv/bin/python ] || uv venv
  uv pip install -q -r requirements.txt --python .venv/bin/python
  # fallback without uv: [ -x .venv/bin/python ] || python3 -m venv .venv; .venv/bin/python -m pip install -q -r requirements.txt
  ```
- `.venv/bin/python .agents/factory/bin/next_phase.py spec/{slug}/TECH.md`. If it warns of pointer
  drift, reconcile with `.venv/bin/python .agents/factory/bin/set_phase.py --current <id>` before acting.
- **Remediation mode:** if `top_status: blocked` or `review.verdict: changes-requested`, read
  `spec/{slug}/REVIEW.md`, reopen the phase(s) covering the failing R-IDs with
  `set_phase.py --phase P<n> --phase-status in_progress` and `--top-status in_progress`.

## Step 2 — Identify the target phase & load context

Target = the `next_phase` output (or the arg-selected phase). Confirm its `depends_on` are all
`done`. Read `PLAN.md`, the relevant `research/`, `.agents/factory/style-guide.md`, and the actual
files/pages you will touch (and a gold-standard page to mirror).

## Step 3 — Author the phase

Execute every `[ ]` step to the archetype conventions (`style-guide.md`) and the invariants:

- Correct front-matter for the archetype; **relative** page links, **absolute** asset paths.
- Reuse `main.py` macros / `docs/snippets/` includes for cluster-variable content; escape literal
  `{{`/`{%` with `{% raw %}`.
- **Add every new page to `mkdocs.yml` `nav:` in this same phase** (else it is orphaned), and when
  nav changes run `.venv/bin/python tools/generate_breadcrumbs.py`.
- Never hand-edit generated files (catalogs, breadcrumbs beyond the generator) — regenerate via `tools/`.
- Content images need meaningful `alt`; verify HPC specifics against an authoritative source.

## Step 4 — Verify gate

Run the phase's `verify:` command — at minimum
`.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`
plus any nav/front-matter check. When layout matters, also `.venv/bin/mkdocs serve` and eyeball the
rendered page. **A non-zero verify (a new `--strict` warning, a build ERROR, or a failed check) is a
STOP condition — do not advance the phase.**

## Step 5 — Update the FSM

Check off the `[ ]` items in the body; advance state via
`.venv/bin/python .agents/factory/bin/set_phase.py spec/{slug}/TECH.md --phase {id} --phase-status done --current {next_id_or_done} --touch`
(regenerate — never hand-edit YAML). Update `--hill` when the honesty signal changes. When all phases
are done, also `--top-status in_review`.

**Meta-note (self-improvement; usually skip).** If *this phase* hit a problem in the *skillset
itself* — the bar is **"instructions' fault, not mine or the task's"** (a wrong/ambiguous
instruction, a `verify:` recipe you had to hand-fix, an allowed-tools gap, a gate that mis-fired) —
append one terse finding to `spec/{slug}/META.md` (from `.agents/factory/templates/META.md` if
absent), `origin=docs-draft:{id}`. It rides Step 6's `git add -A`. Silence by default; ≤1–2 per phase;
add "· seen again" rather than duplicating; a fix that would weaken a `hammerable:false` gate is
`severity=high`. **Recording only** — `/docs-harness` applies fixes later, human-reviewed.

## Step 6 — Commit (atomic content + state)

`git add -A` → `git commit -m "[{kind}] Draft {slug} {id}: {phase name}"` (no `WIP:` prefix, no
`Co-Authored-By` trailer; body only for non-obvious decisions or a TECH.md amendment).

## Step 7 — Continue or stop

Default: one phase, then stop and report. Loop for `through P<n>` / `next N`. Amend `TECH.md` freely
if reality diverges from the plan (regenerate via `set_phase.py`; note it in the commit body) — but a
contradiction with the **locked `GOAL.md`** stops you for the human.

**Circuit breaker.** If a phase fails its verify gate across repeated attempts, do not thrash —
STOP and recommend re-shaping via `/docs-plan`.

## Final report

State the phase(s) completed, verify results, and remaining phases. When the FSM is fully done
(`status: in_review`), recommend a clean-session `/docs-review`.
