# GOAL — {Title}

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).
> Keep this at the right altitude: solved and bounded, but not over-specified — leave design
> freedom for the plan. Edit requirements here; do **not** silently drift them during drafting.

- **slug:** {slug}
- **kind:** feature | fix | refactor  ·  *feature = new material · fix = correction/enhancement · refactor = restructure*
- **appetite:** small | big  ·  *small caps research + phase count; a one-sentence change may skip
  the lifecycle entirely.*

## Problem

<The raw need, in plain language. What is missing, wrong, or confusing today, for which readers
(new users? researchers? a specific cluster's users?), and why it matters. One or two paragraphs.
Motivate the work — do not describe the solution yet.>

## Outcome / vision

<What "good" looks like when this ships. The reader-facing picture we're agreeing on — the page(s)
that will exist, what a reader can do after reading them.>

## Acceptance criteria (the contract)

Stable IDs (`R1`, `R2`, …) that survive squash-merge and anchor traceability. Prefer **EARS**
phrasing (see [`../../.agents/factory/ears.md`](../../.agents/factory/ears.md)) — it makes each line
directly testable — but plain, unambiguous prose is acceptable where EARS would be forced. State
reader-facing outcomes, not implementation (which macro/file is design → `PLAN.md`).

- **R1** — WHEN <a reader does X>, the <page/nav/table> SHALL <observable outcome>.
- **R2** — The <page> SHALL <ubiquitous requirement, e.g. appear in nav and build clean under `--strict`>.
- **R3** — IF <a reader follows a link added here>, THEN `mkdocs build --strict` SHALL <report no new warning>.
- **R4** — WHERE <the page includes screenshots>, each image SHALL <have alt text and an absolute asset path>.

## Non-goals (no-gos)

Explicit exclusions that keep scope bounded to the appetite. Naming what we are **not** doing is as
important as what we are (e.g. "not documenting cluster X", "not touching the software catalog",
"not theme/CSS changes").

- <thing deliberately out of scope>

## Clarifications

Questions resolved with the human during shaping. Unresolved ones stay marked `[NEEDS
CLARIFICATION: …]` and **block** `docs-plan` — never guess (especially HPC specifics).

- **Q:** <question> — **A:** <answer> (resolved YYYY-MM-DD).

## Related materials

- Issue: <https://github.com/PurdueRCAC/RCAC-Docs/issues/NN>
- <existing pages to mirror, gold-standard examples, reference sites (TACC/ALCF/NCSA), source specs>
