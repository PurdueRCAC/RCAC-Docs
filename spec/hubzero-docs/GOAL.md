# GOAL — HUBzero documentation section

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** hubzero-docs
- **kind:** feature
- **appetite:** big

## Problem

HUBzero is an RCAC-run platform (nanoHUB and other science gateways run on it), but
docs.rcac.purdue.edu has no HUBzero material. HUBzero's documentation spent a decade in the
help.hubzero.org database as CKEditor HTML. In September 2026 Nick Kisseberth exported it to
Markdown in `hubzero/hubzero-cms` (`2.4-main`, `docs/`): 417 pages in five books (hub users,
hub managers, tools, developers, generated reference), including the REST API reference a
running hub normally serves live. That material uses its own conventions (`STYLE.md`, an
HTML-comment metadata header, per-book `media/`, numbered chapter files, its own static
builder) and doesn't fit RCAC-Docs as-is. Today it publishes separately, at
hubzero.github.io/hubzero-cms.

## Outcome / vision

docs.rcac.purdue.edu becomes the official, canonical home of the HUBzero documentation, as
RCAC leadership has agreed. All five books move into a top-level HUBzero section laid out
like the rest of the site, with working links, images, and search. After the port, the
HUBzero team maintains these pages in RCAC-Docs.

One docs site shows publicly that HUBzero is part of RCAC. It also leaves one place to
maintain, and the HUBzero books get the site's agentic tooling (the docs MCP server and
AskRCAC) from day one. The job doubles as a demonstration of the RCAC-Docs documentation
factory on a real, sizable migration.

## Acceptance criteria (the contract)

- **R1** — The site nav SHALL contain a top-level HUBzero section at `/hubzero/` whose
  landing page links each of the five books.
- **R2** — For every source page in `docs/` at the pinned source commit, the HUBzero section
  SHALL contain exactly one rendered page with the same title, whatever its review status.
- **R3** — IF a reader follows any internal link inside the HUBzero section, THEN it SHALL
  resolve, and `mkdocs build --strict` SHALL report no new warning.
- **R4** — Where a source page includes an image, the rendered page SHALL display it, with
  non-empty alt text.
- **R5** — The REST API reference SHALL render every endpoint listed in the source
  `reference/api` pages, with its method, path, and parameters.
- **R6** — Each HUBzero page SHALL show the source's review status, so an unreviewed page
  still says it's unreviewed, and SHALL record its upstream path and commit.
- **R7** — The source metadata header SHALL NOT appear as visible page text.
- **R8** — WHEN the import is re-run against the same source commit, it SHALL reproduce the
  committed pages with no diff, so a later touch-up sync starts from a known state.
- **R9** — The HUBzero landing page SHALL credit the upstream project and carry its MIT
  license notice.
- **R10** — Every HUBzero page SHALL pass the accessibility checks `docs-review` applies to
  the rest of the site.

## Non-goals (no-gos)

- Not correcting or reviewing HUBzero content. Nick's book-by-book review owns accuracy;
  this job carries his pages and their review status through unchanged.
- Not auto-generating the API reference from source the way the datasets and application
  catalogs are built. That's a later effort; this job imports the current `reference/api`
  pages as they stand.
- No continuous sync with upstream. This is a one-time port, with at most a touch-up
  re-import before the HUBzero team takes over maintenance here.
- Not retiring hubzero.github.io/hubzero-cms or redirecting help.hubzero.org. The HUBzero
  team does that once the section is live.
- Not writing anything back to `hubzero/hubzero-cms`.
- No theme or CSS changes beyond what the section needs to render.
- No HUBzero versions other than 2.4, and no translation.

## Clarifications

- **Q:** Source? **A:** `github.com/hubzero/hubzero-cms`, branch `2.4-main`, `docs/`, pinned
  at `9c1a8c67` for planning (resolved 2026-10-08).
- **Q:** Placement? **A:** A HUBzero section of its own, not folded into existing guides
  (Geoffrey, resolved 2026-10-08).
- **Q:** Canonical copy, or a mirror of hubzero.github.io? **A:** Canonical. RCAC-Docs is the
  primary home, agreed at the kickoff and the follow-up working session and approved by
  leadership (Geoffrey, resolved 2026-10-08).
- **Q:** Sync model? **A:** A one-off port. A touch-up re-import may follow, and then the
  HUBzero team maintains the pages here. API auto-generation is a separate, later effort
  (Geoffrey, resolved 2026-10-08).
- **Q:** Scope? **A:** All five books (Geoffrey, resolved 2026-10-08).
- **Q:** Unreviewed pages? **A:** Import them all now, with their review status showing
  (Geoffrey, resolved 2026-10-08).
- **Q:** URL and nav? **A:** `/hubzero/`, top-level (Geoffrey, resolved 2026-10-08).
- **Q:** Size? **A:** One feature job, not a pilot split. `TECH.md` phases it toward the full
  five-book port (Geoffrey, resolved 2026-10-08).

## Related materials

- Source: <https://github.com/hubzero/hubzero-cms/tree/2.4-main/docs>; its `README.md`,
  `STYLE.md`, and `plan/documentation-program.md`.
- Current render: <https://hubzero.github.io/hubzero-cms/>, built by `gh-pages/build_site.py`.
- Nick's generator and lint scripts: `docs/_tools/`.
- Prior factory jobs to mirror: `spec/agentic-ai-docs/`, `spec/globus-scheduled-transfers/`.
