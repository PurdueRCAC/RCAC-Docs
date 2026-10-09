---
slug: hubzero-docs
title: Port the HUBzero documentation into a top-level /hubzero/ section
kind: feature
appetite: big
status: in_progress
branch: feature/hubzero-docs
base: main
current_phase: P7
last_updated: '2026-10-08'
phases:
- id: P1
  name: 'Importer + scaffold: landing, root pages, nav region, status hook'
  status: done
  satisfies:
  - R1
  - R6
  - R7
  - R8
  - R9
  depends_on: []
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P2
  name: Import the Tools book
  status: done
  satisfies:
  - R2
  - R3
  - R4
  - R6
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/tools/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P3
  name: Import the Hub users book
  status: done
  satisfies:
  - R2
  - R3
  - R4
  depends_on:
  - P2
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/users/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P4
  name: Import the Hub managers book
  status: done
  satisfies:
  - R2
  - R3
  - R4
  depends_on:
  - P3
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/managers/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P5
  name: Import the Developers book
  status: done
  satisfies:
  - R2
  - R3
  - R4
  depends_on:
  - P4
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/developers/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P6
  name: Import the Reference book, including the REST API
  status: done
  satisfies:
  - R2
  - R3
  - R5
  depends_on:
  - P5
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'hubzero/reference/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms
    .venv/bin/python tools/hubzero/import_docs.py check
- id: P7
  name: 'Integration: final check, a11y sweep, search growth, handoff'
  status: pending
  satisfies:
  - R1
  - R3
  - R8
  - R10
  - R11
  depends_on:
  - P6
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python
    tools/hubzero/import_docs.py check --final
review:
  last_reviewed_commit: ''
  verdict: none
  blocked_reason: ''
---
# TECH.md — Port the HUBzero documentation into a top-level /hubzero/ section

The **context engine and finite-state machine** for authoring this job. The YAML frontmatter
above is the resume ground-truth (read it with
`.venv/bin/python .agents/factory/bin/next_phase.py spec/hubzero-docs/TECH.md`); the per-phase
checklists below are the work. `docs-draft` executes the next actionable phase, runs its
`verify:` command, updates state via `.venv/bin/python .agents/factory/bin/set_phase.py …`, and
makes one atomic content+state commit. Run from the repo root with the project env active.

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md). R-IDs are the contract.
- **Authoritative design:** [`PLAN.md`](PLAN.md).
- **Backing research:** [`research/00-digest.md`](research/00-digest.md) and briefs 01–05.

## Frontmatter field reference

- `base`: the branch this merges into: **`main`** (trunk and production).
- `status` (top): `planned | in_progress | blocked | in_review | done`
- `appetite`: `small | big`. Caps phase count and draft-iteration budget (circuit breaker).
- phase `status`: `pending | in_progress | done | blocked`
- `satisfies`: GOAL R-IDs this phase delivers (traceability anchor for `docs-review`).
- `depends_on`: phase ids that must be `done` first.
- `parallel`: every phase is `false`. Each one rewrites the importer-owned nav region in
  `mkdocs.yml`, and books cross-link, so landing order matters.
- `hammerable`: every phase is `false`. R2 requires every source page, so scope-hammering may
  cut render polish inside a phase, never pages, links, or the build gate.
- `hill`: `uphill` → `crest` → `downhill`. A phase stuck `uphill` across drafts escalates.
- `verify`: the `--strict` gate, the book's nav entry, then `import_docs.py check`. `check`
  reads `site/`, so it must run after the build, and it needs the local clone at
  `HUBZERO_CMS`. It checks every book enabled in `tools/hubzero/import.yml`.

## Conventions (apply to every phase)

- Voice, archetype conventions, and load-bearing rules come from
  [`../../AGENTS.md`](../../AGENTS.md) (the constitution),
  [`../../.agents/factory/style-guide.md`](../../.agents/factory/style-guide.md), and
  [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md).
- One phase per `docs-draft` invocation; one atomic commit with **both** content and the
  `TECH.md` state change. Subjects: `[feature] Draft hubzero-docs P<n>: …`.
- **No `Co-Authored-By` trailer.**
- **Never hand-edit `docs/hubzero/**`, `docs/assets/images/hubzero/**`, or the nav region.**
  Every fix to imported output lands as an importer rule, then a re-import. This is what keeps
  R8 true and the touch-up sync safe.
- After every nav change: `.venv/bin/python tools/generate_breadcrumbs.py`.
- Pinned source commit: `9c1a8c678002bdfb41860f90915a3589ab60339e` (recorded in
  `tools/hubzero/import.yml`, never read from the clone's HEAD).
- Each book phase ends with a `.venv/bin/mkdocs serve` spot-check (PLAN §6 sample list) and a
  short note in the commit body of anything the render check fixed.

---

## Phase P1 — Importer + scaffold
**Satisfies:** R1, R6, R7, R8, R9 · **Depends on:** —
**Goal:** the importer exists and is deterministic. `/hubzero/` exists with the landing page,
the three other root pages, a nav region, and the status hook. No book is imported yet.

- [x] `tools/hubzero/import.yml`: repo URL, pinned commit, book order and titles (from
      `site.json`), `books: []` (enabled books, grown one per phase), and the explicit
      collision map (PLAN §2).
- [x] `tools/hubzero/import_docs.py import`: read via `git show <sha>:<path>` from
      `$HUBZERO_CMS` (fail with a `git fetch --depth=1 origin <sha>` hint); header →
      front-matter; include expansion; link, image, and anchor rewrites; dialect
      normalization; deterministic output (sorted walks, LF, stable YAML key order, no
      timestamps). Mirror `gh-pages/build_site.py` rules ([`research/04`](research/04-importer-design.md)).
- [x] Nav: write the `HUBzero` subtree between `# >>> hubzero nav (generated by tools/hubzero/import_docs.py; do not edit)`
      and `# <<< hubzero nav` markers, after `RCAC Services`, before `Contact us`.
- [x] Root pages: `docs/hubzero/index.md` (README + appended **About this documentation**:
      HUBzero credit, MIT notice, link to `license.md`, pinned commit), `license.md`,
      `style.md`. Skip `plan/` and `_tools/` (upstream `SKIP_DOC_DIRS`). Links into books go
      to GitHub until each book lands.
- [x] `main.py`: `on_post_page_macros(env)` renders the banner and stamp from
      `page.meta.hubzero` (upstream wording, `build_site.py:594–630`). Confirm the hook fires on
      `render_macros: false` pages (the PLAN §5 hypothesis). If it doesn't, stop and revise
      PLAN before baking banners into bodies.
- [x] `import_docs.py check`: R2 count and titles, R3 link and anchor scan of `site/hubzero/`,
      R4 image `src` and alt, R6/R7 front-matter and no header leak, R8 re-import into a temp
      tree and byte-compare. Each failure names the page and rule.
- [x] `tools/hubzero/README.md`: how to run `import` and `check`, touch-up procedure,
      retirement after handover.
- [x] `.venv/bin/python tools/generate_breadcrumbs.py`.
- **Amended in P1 (2026-10-08, draft findings; no GOAL change):**
  - *Hook confirmed.* `on_post_page_macros` fires on `render_macros: false` pages: throwaway
    `imported` (all three clauses), `draft`, and `rewritten` pages rendered the banner after the
    H1 and the stamp at the end, with `{{ … }}` left literal. The banner drops upstream's bold
    lead ("**Not yet reviewed.**") because the admonition title already says it.
  - *Callouts (new dialect rule, applies to every book).* `> **Note:**`/Tip/Warning/Important/
    Caution blockquotes become `!!! note` … `!!! caution` (Material types/aliases), mirroring
    upstream `_apply_admonitions`. 814 such blockquotes across the source; README has 2.
  - *Includes inside code blocks are not expanded.* Upstream expands them everywhere, which in
    STYLE.md (a ```` ```markdown ```` example of the directive) nests fences and breaks the page.
  - *Landing provenance joins README's existing "About the documentation" section* rather than
    adding a near-duplicate "About this documentation" H2. The appended paragraph still carries
    all of R9: the HUBzero credit, the MIT notice linking `license.md`, and the pinned commit.
  - *GitHub Pages references repoint here (GOAL R12, added 2026-10-08).* The resolver maps
    `hubzero.github.io/hubzero-cms/<path>` to the page with that URL path here (paths mirror
    upstream slugs) as a relative link; `pages_targets` in `import.yml` sends `status/` to the
    landing page's `#about-the-documentation`. Bare URLs in prose become absolute
    `docs.rcac.purdue.edu/hubzero/` URLs. `check` flags any survivor (R12). Three published
    occurrences at the SHA: README :22 and :57 (done here), `developers/18-contributing.md`
    :298 (resolves when P5 enables the book). The rest of README's sentence stays verbatim.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/{index,license,style}.md`, `mkdocs.yml`,
  `main.py`, `docs/assets/data/breadcrumbs.json`.

## Phase P2 — Tools book
**Satisfies:** R2, R3, R4, R6 · **Depends on:** P1
**Goal:** all 34 Tools pages render. The smallest book, and the only one with `reviewed` and
`draft` pages, so it proves every banner and stamp variant first.

- [x] Enable `tools` in `import.yml`; re-run `import` (root-page links to Tools turn relative).
- [x] Render check: a `reviewed` page, the `draft` page, a `rewritten` page, an image page.
- [x] Fold any render fix into the importer; re-import; breadcrumbs.
- **Amended in P2 (2026-10-08, draft findings; no GOAL change):**
  - *Render check.* `tools/index.md` (draft: "Draft" banner, no stamp),
    `developers/invoke.md` (reviewed stamp), `administrators.md` (rewritten stamp),
    `developers/overview.md` (image with alt). All 9 referenced images resolve; the importer
    lists 2 unreferenced `media/` files and doesn't copy them. No `{{` leaks.
  - *Blocks after a table (new dialect rule, applies to every book).* GFM ends a table at the
    next block; Python-Markdown reads that line as another row. `check` caught it as a dead
    `#webdav` anchor: in `developers/06-accesshomedir.md` `## WebDAV` directly follows the sFTP
    command table and vanished into it. `normalize_dialect` now inserts a blank line where a
    heading, list, fence, quote, or HTML block directly follows a table row. Across the whole
    source this fires twice: here and `users/23-wiki.md` :179 (P3).
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/tools/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/**`, `docs/assets/images/hubzero/tools/`,
  `mkdocs.yml`, `docs/assets/data/breadcrumbs.json`.

## Phase P3 — Hub users book
**Satisfies:** R2, R3, R4 · **Depends on:** P2
**Goal:** all 34 Hub users pages render, with their images (the heaviest `media/` user).

- [x] Enable `users`; re-import.
- [x] Render check: an image-heavy page, `users/23-wiki.md` (Jinja hazard, renders literally),
      the include page, and `users/01-collections.md`, `18-publications.md`, `28-usage.md`
      (raw-tag pages; note which carries the lost placeholder).
- [x] Fold fixes into the importer; re-import; breadcrumbs.
- **Findings in P3 (2026-10-08; no importer change, no GOAL change):**
  - `collections` (19 images, the heaviest page) resolves every image with alt. `wiki` shows its
    `{{{…}}}` examples literally. `projects` expands its one include
    (`databases.php:79-83`) into a code block. The other "include" hit, `07-events.md`:96, is
    prose.
  - Raw tags: `collections` and `usage` carry intentional `<a id>` anchors, which render as
    anchors. The lost placeholder in this book is `18-publications.md`, in the curation table:
    "*Assigned to `<name>`*" is passed through as an unknown HTML element, so readers see
    "Assigned to". This is an upstream defect; it goes in the P7 note to Nick.
  - The 23-wiki.md :179 table-then-fence case named in P2 sits inside an example and needs
    no fix (the blank-after-table rule still fired only once).
  - The importer listed 14 unreferenced `users/media/` files and didn't copy them.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/users/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/**`, `docs/assets/images/hubzero/users/`,
  `mkdocs.yml`, `docs/assets/data/breadcrumbs.json`.

## Phase P4 — Hub managers book
**Satisfies:** R2, R3, R4 · **Depends on:** P3
**Goal:** all 90 Hub managers pages render, including the one slug collision.

- [x] Enable `managers`; re-import.
- [x] Render check: `09-components/31-search/` (`index.md` and `index/index.md` both present and
      in nav), the `draft` page, `04-blogs.md` and `23-newsletters.md` (Jinja), an include
      page, `03-maintenance/05-cron.md` (raw tag).
- [x] Fold fixes into the importer; re-import; breadcrumbs.
- **Findings in P4 (2026-10-08; no importer change, no GOAL change):**
  - The search section's landing page (`…/search/`) and "Maintaining the index"
    (`…/search/index/`) both build and are listed in the nav in upstream order.
  - The draft page is `00-installing.md`: "Draft" banner, no stamp. Blogs and newsletters
    show their `{{ … }}` literally. The include pages (`00-installing`, `03-maintenance/01-approvingcontent`)
    render their code blocks.
  - Cron's raw tags are intentional `<a id="editfields-…">` anchors and work. The second lost
    placeholder (`<first>`) is not in this book.
  - Render probe (scratch script comparing source with `site/`: lost headings, blocks swallowed
    into tables, leaked markdown, missing images or alt) is clean on all 158 book pages so far.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/managers/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/**`, `docs/assets/images/hubzero/managers/`,
  `mkdocs.yml`, `docs/assets/data/breadcrumbs.json`.

## Phase P5 — Developers book
**Satisfies:** R2, R3, R4 · **Depends on:** P4
**Goal:** all 101 Developers pages render, with the 52 include-bearing pages showing their code.

- [x] Enable `developers`; re-import.
- [x] Render check: include pages with line ranges and language mapping, a page with many
      source-tree links (pinned GitHub URLs with `#L` anchors), `11-templates/12-fontcons.md`
      and `14-supergroups-gitlab.md` (raw tags), nested-list fixups.
- [x] Fold fixes into the importer; re-import; breadcrumbs.
- **Amended in P5 (2026-10-08, draft findings; no GOAL change):**
  - *Includes.* All 111 include directives in the book expand to exactly their source line
    ranges; fences carry the mapped language (php 293, xml 23, bash 19, …).
  - *Source links.* 461 blob and 41 tree links are pinned to the commit. The book has no `#L`
    anchors; they live in `reference/api` (P6). The one `tree/2.4-main` URL is README's own
    absolute link, kept verbatim (P1).
  - *Raw tags.* fontcons' tags are inside code blocks; supergroups-gitlab's
    `` `hub-<first label …>` `` is a code span that spans lines and renders. Neither carries a
    lost placeholder; a scan of every built page for unknown elements finds only P3's
    `<name>`. Upstream's second "`<first>`" placeholder is re-checked in P6.
  - *Callouts end at a block (importer fix, all books).* `convert_callouts` took any non-`>`
    line after a `> **Note:**` blockquote as lazy continuation, so a following heading or
    list item was pulled into the admonition. Nine headings across seven pages (in
    tools, users, managers, developers) rendered inside note boxes, and
    `users/20-registration.md` steps 10–11 moved into its note. CommonMark never continues a
    paragraph with a list marker, heading, fence, or rule; neither does the importer now.
  - *List item after a later paragraph (new dialect rule, all books).* Python-Markdown reads a
    list marker that directly follows an item's second paragraph as text: registration
    steps 3–9 collapsed into step 2. A blank line is inserted there (9 places in 4 pages); the
    item is already loose, so spacing is unchanged.
  - *Structure parity.* After both fixes, every imported page renders the same number of list
    items as its source, and the render probe (headings, headings inside admonitions, blocks
    in table cells, leaked markdown, images, alt) is clean on all 259 book pages. Neither
    regression was visible to `check` or `--strict`; the probes are scratch scripts, not part
    of the gate.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/developers/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/**`,
  `docs/assets/images/hubzero/developers/`, `mkdocs.yml`,
  `docs/assets/data/breadcrumbs.json`.

## Phase P6 — Reference book and REST API
**Satisfies:** R2, R3, R5 · **Depends on:** P5
**Goal:** all 154 Reference pages render; every one of the 245 endpoint sections on the 30 API
pages shows its method, full path (with `{id}`-style parameters intact), and parameters.

- [x] Enable `reference`; re-import.
- [x] Extend `check` with the R5 assertion: per API page, endpoint `h2` count matches source and
      each `h2` keeps its upstream id and full path text.
- [x] Render check: an API page with `{id}` headings and its summary table's anchor links,
      `configuration/plugins/courses.md` and `members.md` (Jinja), a `generated` stamp.
- [x] Fold fixes into the importer; re-import; breadcrumbs.
- **Amended in P6 (2026-10-08, draft findings; no GOAL change):**
  - *R5 in `check`.* Per `reference/api` page: the rendered endpoint-`h2` count equals the
    source's; each `## METHOD /path` renders with its full path text and the upstream id
    (`slugify`); and its Parameter table renders the same parameter names in order (GOAL R5
    says "with its parameters"). Coverage: 245 endpoints, 912 parameters. A negative test (one
    id and one parameter cell broken in `site/`) produced three R5 findings.
  - *`{id}` headings.* `PUT /tags/{id}` renders as `<h2 id="put-tags-id">PUT /tags/{id}`; the
    summary tables' anchors resolve (R3).
  - *Links to source files missing at the commit (new importer rule).*
    `reference/events/user.md` links `core/components/com_cart/site/controllers/test.php#L197`,
    which isn't in the tree at `9c1a8c67` (the generator likely saw an untracked file), and
    `--strict` flagged it. Such a link now points to the nearest existing directory on GitHub,
    at the commit, and the importer warns (`check` prints it as a note). This one goes in the
    upstream note.
  - Courses and members show their `{{ … }}` literally. The generated stamp reads "Generated
    from the source tree.", matching upstream `build_site.py:623` for headers without
    `against`.
  - *Lost placeholders: one, not two.* A scan of all 416 built pages for unknown HTML elements
    finds only `users/18-publications.md`'s `<name>`. The "`<first>`" in research/03 is
    `developers/14-supergroups-gitlab.md`'s `` `hub-<first label …>` ``, a code span that
    renders on both hubzero.github.io and here (checked live, 2026-10-08).
  - The render probe and list-item parity are clean on all 154 Reference pages.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'hubzero/reference/index.md' mkdocs.yml && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
- **Touches:** `tools/hubzero/**`, `docs/hubzero/**`, `mkdocs.yml`,
  `docs/assets/data/breadcrumbs.json`.

## Phase P7 — Integration
**Satisfies:** R1, R3, R8, R10, R11 · **Depends on:** P6
**Goal:** the whole section passes `check --final`, reads well end to end, and is ready to hand
over.

- [ ] `check --final`: all five books enabled, 416 pages, zero remaining GitHub fallback links to
      docs pages, landing links all five books relative (R1).
- [ ] a11y sweep per the review rubric: one H1, no skips, image alt, admonition titles, table
      headers (source measured clean; confirm on `site/`).
- [ ] Measure `site/search/search_index.json` and repo growth before and after; record in the
      commit body. Flag if search degrades.
- [ ] Finalize `tools/hubzero/README.md` (touch-up, then handover, then retire).
- [ ] Draft (don't send) the upstream-defects note for Nick Kisseberth: the lost placeholders.
- [ ] Home-page HUBzero card (R11): fifth card in the `docs/index.md` **RCAC Resources** grid,
      after Datasets, in the existing format (icon, bold title, rule, one sentence,
      `:octicons-arrow-right-24:` link to `hubzero/index.md`).
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check --final`
- **Touches:** `tools/hubzero/**`, `docs/index.md`.

---

## How `docs-draft` drives this

1. `next_phase.py` prints the next actionable phase (statuses are authoritative; the
   `current_phase` pointer is reconciled against them).
2. Pre-flight: clean tree, on `branch`, `base` (`main`) reachable, the uv-synced `.venv` present
   (`.venv/bin/python -c "import yaml, mkdocs"`), and `$HUBZERO_CMS` has the pinned commit.
3. Execute every `[ ]` in the phase (consult `PLAN.md` / `research/` for detail).
4. Run the phase's `verify:` command. Never advance on a checkbox alone.
5. Amend this file freely if reality diverges (regenerate frontmatter with `set_phase.py`; note
   the amendment in the commit body). STOP and escalate only on a **`GOAL.md` contradiction**.
6. Mark the phase `done`, advance `current_phase`, `--touch`; one `[feature]` commit; stop and
   report.
