# Review rubric — the `docs-review` operating manual

The operating manual for the `docs-review` adversarial QA pass. The correctness review runs
in an **isolated context (a fresh subagent)** and grades the branch diff against **`GOAL.md`
+ the invariants + the style guide only**. It is **denied `PLAN.md`/`TECH.md`/`research/`** —
showing the author's own rationale triggers grading-its-own-homework and plan-sycophancy.

**Verification is by rendering the site and reading the diff — never by assertion.** Where a
claim can be checked by a command (build, link, nav, front-matter) it must be; where it
cannot (technical accuracy, prose accessibility) it is surfaced for a human, not asserted.

## What the reviewer sees / doesn't see

- ✅ `GOAL.md` (the locked contract — the `R#` IDs)
- ✅ the branch diff (`git diff main...HEAD`) + `git log --oneline main..HEAD` + the full
  runnable repo (can `mkdocs build`/`serve`)
- ✅ `invariants.md`, `style-guide.md`, `ears.md`, `strict-baseline.txt`
- ❌ **NOT** `PLAN.md`, `TECH.md`, or `research/` (for the correctness pass)
- A separate, later **completeness sub-pass** *may* read `TECH.md` to ask "did every planned
  phase ship? did scope balloon?" — kept isolated so the plan never contaminates the
  correctness verdict.

## Scope — flag ONLY these

1. **Content defects** — wrong or broken rendered output: a broken internal link, a nav
   orphan, a `--strict` regression, malformed front-matter, an unescaped `{{`/`{%` that
   breaks the build, a table that doesn't render, a missing/empty `alt`.
2. **HPC technical inaccuracy** — a wrong `#SBATCH` flag, a non-existent partition/module,
   an incorrect path/quota/spec, a stale gateway URL.
3. **GOAL-requirement gaps** — an `R#` with no implementing change, or implemented wrong.
4. **Invariant violations** (`invariants.md`) — auto-CRITICAL.
5. **Scope creep** — changes that map to no `R#` (report; don't necessarily block).

**Do NOT report:** style nitpicks the style guide doesn't mandate, speculative
"you could also add…", rephrasing for taste, or theme-level a11y (that lives on `dev`).
A gap-hunting reviewer manufactures gaps, which drives over-authoring. **Silence on a
clean diff is a valid, valuable result.**

## Refutation protocol — try to disprove each finding first

1. **Reproduce it.** Run the command or render the page that would reveal it:
   - build/nav/link/front-matter/`--strict` →
     `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`
     and inspect the log for the specific file;
   - rendering/a11y-structure → `mkdocs serve` and view the page (or inspect the built
     HTML under `site/`);
   - requirement coverage → read the diff for the `R#`'s implementing change.
2. Classify the outcome (below).
3. If it dissolves under scrutiny → **drop it silently.** Default to dropping when uncertain.

## CONFIRMED vs PLAUSIBLE — the documentation split

Not every documentation defect is machine-checkable. Classify honestly:

- **CONFIRMED** — reproduced by an executed command or a direct read of the rendered
  output/diff. Examples: `strict_check.py` reports a new warning; a page is absent from
  nav; front-matter is missing a required key; an image has no `alt`; an `R#` has no diff.
  Only CONFIRMED findings auto-loop back to `docs-draft`.
- **PLAUSIBLE** — a real risk you *cannot* prove by command: **HPC technical accuracy**
  (is `--gpus-per-node=2` right for this partition?), **prose/semantic accessibility**
  (is this `alt` text actually meaningful? is the heading order logical for a screen
  reader?), factual claims about hardware/policy. These go to a **human for triage** — do
  **not** auto-loop and do **not** assert them as fact. Cite the specific concern and the
  authoritative source you'd check.

This split is essential: without it the reviewer either rubber-stamps accuracy or
hallucinates accuracy findings. Build/link/nav/front-matter/structural-a11y are objective;
accuracy and prose-a11y are judgment calls that belong to a person.

## Severity

| Severity | Meaning |
|---|---|
| **CRITICAL** | Any `invariants.md` violation (§1–§11); a wrong HPC command/path that would misdirect a user; content that breaks the build or ships a broken link to production. |
| **HIGH** | A GOAL `R#` unmet or implemented wrong; a real defect on a common page. |
| **MEDIUM** | A defect on an edge/rarely-hit page; a partial requirement. |
| **LOW** | Minor content risk; a missing-but-non-blocking cross-link or tag. |

A §12 (commit/PR-convention) violation is **HIGH**, not auto-CRITICAL.

## Verdict & loop

- Emit findings via **`ReportFindings`** (most-severe first, each with its CONFIRMED/PLAUSIBLE
  verdict) **and** write `spec/{slug}/REVIEW.md`.
- **CONFIRMED** findings → `set_phase.py --top-status blocked --verdict changes-requested
  --reviewed-commit <sha> --blocked-reason "<short>" --touch` → loop back to `docs-draft`.
- **PLAUSIBLE** findings → surface to the human for triage; do **not** auto-loop.
- **Clean pass** → `set_phase.py --verdict approved --reviewed-commit <sha> --touch` →
  proceed to `docs-publish`.
- **Bounded loop:** at most **2–3 review↔draft cycles**. On non-convergence, STOP and
  escalate to a human — self-correction does not reliably converge.

## Mandatory human sign-off gate

A human must approve before `docs-publish` whenever **any** CONFIRMED finding touches a
**high-impact file** (`invariants.md` header list: `mkdocs.yml`, `main.py`,
`docs/snippets/**`, `overrides/**`, `tools/**`+`modulefiles/**`, CI, k8s, a generated
output, or the dev-only a11y layer). And remember the standing reality: **a merge to `main`
auto-deploys to production within ~5 minutes with no staging gate** — so when a
CONFIRMED-or-PLAUSIBLE **HPC-accuracy** concern remains on a high-traffic page, prefer human
sign-off even if no high-impact *file* is touched.

## Optional variants

- **`debate`** (high-risk diffs, e.g. touching `main.py`/`mkdocs.yml`/many pages): run two
  independent fresh reviewers — one arguing "ship", one "block" — and reconcile. Independent
  instances beat single-model introspection. Reserve for genuinely high-risk changes (cost).
- **`completeness`**: a separate fresh reviewer that *may* read `TECH.md` — did every
  planned phase ship? did scope balloon past appetite? Appends to `REVIEW.md`.
