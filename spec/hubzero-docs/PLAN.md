# PLAN — HUBzero documentation section

> **Status:** Draft for review · **Last updated:** 2026-10-08
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/).
> Every design element traces to a GOAL R-ID.

## 1. Summary

Port all 416 published HUBzero pages with a small, deterministic importer (`tools/hubzero/import_docs.py`),
not by hand. The importer reads `hubzero/hubzero-cms` at a pinned commit, converts each page to
RCAC-Docs conventions (front-matter, relative links, absolute assets, preserved anchors,
expanded includes), and writes a top-level `/hubzero/` section plus its `mkdocs.yml` nav
subtree. Re-running it is the touch-up sync (R8), and its `check` subcommand is every phase's
acceptance gate. Phases land the scaffold, then one book at a time (smallest first), then
integration. This fits a big appetite: the work is mostly in the importer's edge cases, not in
writing prose.

## 2. Design

- **Archetype.** The landing page is the hub/landing archetype (style guide §E). The imported
  pages are reference pages under their own upstream contract (`hubzero-cms/docs/STYLE.md`).
  Section front-matter contract:

  ```yaml
  ---
  tags: [HUBzero]
  render_macros: false            # pages never use RCAC macros; neutralizes Jinja hazards
  description: …                  # only when the source header has `summary`
  hubzero:
    upstream: docs/<source path>  # R6: upstream path
    commit: <40-char sha>         # R6: upstream commit
    status: rewritten             # drives the banner/stamp (R6)
    <every other header key, verbatim, as strings>
  ---
  ```

- **Page structure.** Everything under `docs/hubzero/` is importer output:
  - `index.md`: the upstream `README.md` (H1 "Hubzero documentation"), which already links all
    five books, plus an importer-appended **About this documentation** block: credit to the
    HUBzero project and repository, the MIT notice with a link to `license.md`, and the pinned
    commit (R1, R9). Front-matter adds `hide: [footer]`.
  - `license.md` and `style.md` (from `STYLE.md`): the other two root pages upstream publishes
    (R2). `plan/` and `_tools/` are skipped, as upstream's `SKIP_DOC_DIRS` does; no published
    page links into them.
  - `<book>/index.md` and `<book>/<path>.md` for each book: numeric prefixes stripped,
    `README.md` → `index.md`, and the one collision mapped to `…/search/index/index.md`.
    Upstream slugs (kebab-case) are kept so URLs mirror hubzero.github.io one to one.
- **Navigation placement.** A top-level `HUBzero` entry after `RCAC Services`, before
  `Contact us`. The first child is `hubzero/index.md`. Then the five books in upstream order
  (Hub managers, Hub users, Tools, Developers, Reference), each a section whose first child is
  its `index.md`, nested by directory. Then an `About these docs` group (Writing guide,
  License). Labels are the plain-text H1s. The importer owns the subtree
  between `# >>> hubzero nav …` and `# <<< hubzero nav` markers. Breadcrumbs regenerate with
  `tools/generate_breadcrumbs.py` after every nav change.
- **Transforms** (per page, in order; [`research/04`](research/04-importer-design.md)):
  1. Strip the header comment and build the front-matter (R6, R7).
  2. Expand `<!--include: path[:a-b]-->` from the pinned commit, with upstream's language map.
  3. Rewrite links: imported page → relative; source file/directory → `github.com/hubzero/hubzero-cms/{blob,tree}/<sha>/…`;
     page in a not-yet-imported book → its GitHub blob URL until the book lands (R3).
  4. Rewrite images to `/assets/images/hubzero/<book>/…` and copy the referenced files (R4).
  5. Append `{ #<upstream-id> }` to headings whose Python-Markdown id would differ, and to every
     heading ending in `}` (R3, R5).
  6. Normalize the measured dialect gaps (4-space nested lists; a blank line before a list).
  7. Point hubzero.github.io references at the same page here: links relative, bare URLs
     absolute; its status page → the landing's About section (R12).
- **Status display (R6).** `main.py` gains `on_post_page_macros(env)`. For pages with
  `hubzero.status`, it prepends `!!! warning "Not yet reviewed"` (imported/merged, with
  upstream's wording and `modified`/`source-state`/`merged-from` clauses) or `!!! warning "Draft"`,
  and appends upstream's stamp ("Rewritten and checked against … on …", "Reviewed …",
  "Generated from the source tree at …"). The front-matter stays the single source, so
  maintainers flip one field, as STYLE.md says.
- **Reuse.** No RCAC macros or snippets are needed. Mirror upstream's own rules
  (`gh-pages/build_site.py`: `parse_meta`, `order_key_for`, `slug_for`, `slugify`,
  `make_link_resolver`, `expand_includes`, banner and stamp text) so the port matches what
  readers see today.
- **Assets.** Only referenced images (149 references, about 15 MB at most) go under
  `docs/assets/images/hubzero/{users,managers,tools,developers}/`. The importer lists
  unreferenced files instead of copying them.
- **Cross-links & tags.** `tags: [HUBzero]` on every page. The landing page links back to the
  upstream repo. The site home page (`docs/index.md`) gets a HUBzero card as the fifth card in
  its **RCAC Resources** grid, after Datasets, in the existing card format (R11, P7).
- **Accessibility plan.** At source: every image has alt text, each page has exactly one H1, no
  heading-level skips, no vague link text (measured, [`research/00`](research/00-digest.md)
  §10). Markdown tables always have header rows. Admonition titles are text. `check` re-asserts
  the image and alt rules on the built site.
- **Maintainer handoff.** `tools/hubzero/README.md` explains running `import`/`check`, the
  touch-up procedure, and that `check`'s R8 comparison stops holding once hand edits begin. At
  that point the importer and the nav markers can be retired.

### Requirement → design map

| R-ID | Design element(s) that satisfy it |
|------|-----------------------------------|
| R1   | Top-level `HUBzero` nav entry → `hubzero/index.md`; the upstream README already links all five books (P1 scaffold; the links become relative as each book lands; complete at P7) |
| R2   | Importer maps all 416 published source pages (413 book + 3 root) one-to-one, H1 unchanged; `check` asserts the count and title parity |
| R3   | Link resolver (relative / commit-pinned GitHub); preserved upstream heading ids; `--strict` gate plus `check`'s anchor scan of `site/hubzero/` |
| R4   | Referenced images copied to `/assets/images/hubzero/…`; alt carried through; `check` asserts `<img>` alt and `src` exist |
| R5   | Brace-safe heading ids; `check` asserts all 245 endpoint `h2`s render with id and full path, per API page |
| R6   | `hubzero.{upstream,commit,status,…}` front-matter; `main.py` `on_post_page_macros` banner/stamp |
| R7   | Header comment stripped from the body; `check` asserts no leakage |
| R8   | Deterministic importer reading via `git show <sha>`; `check` regenerates into a temp tree and byte-compares |
| R9   | Importer-appended "About this documentation" block on the landing page, plus `license.md` |
| R10  | Source is clean (measured); `check` asserts image alt; the review rubric's a11y pass applies |
| R11  | HUBzero card in the home page's RCAC Resources grid, linking `hubzero/index.md` (P7) |
| R12  | Resolver maps GitHub Pages URLs to pages here (`pages_url`, `site_url`, `pages_targets` in `import.yml`); `check` asserts no `hubzero.github.io` remains |

## 3. Invariant gate (constitution check)

Checked against [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md)
before research (gate #1) and again after this design (gate #2).

- **§1 Branch/deploy:** work on `feature/hubzero-docs` in a worktree; PR into `main`; never `dev`.
- **§2 Dev a11y layer:** untouched; no `overrides/`, `extra.css`, or `a11y.js` edits.
- **§3 Generated-content firewall:** `breadcrumbs.json` is only regenerated, never hand-edited.
  The HUBzero pages are **imported, not generated**: after the handover they are maintained by
  hand, so they carry no `do not edit` marker. The nav region in `mkdocs.yml` *is* generated
  and carries a marker comment (see deviations).
- **§4 Nav is manual:** every page sits in `nav:`, in `mkdocs.yml`; hubs are `index.md`;
  breadcrumbs are regenerated each phase.
- **§5 Links relative / assets absolute:** page links relative; images under absolute
  `/assets/images/hubzero/…`; links to source code go to absolute GitHub URLs (external, not
  site pages).
- **§6 Front-matter:** section contract defined in §2. Landing uses `hide: [footer]`.
- **§7 Macros/Jinja:** `render_macros: false` on all HUBzero pages, instead of `{% raw %}`.
  `main.py` gains one page hook. `snippets/` is untouched.
- **§8 Build integrity:** every phase runs the `--strict` gate. `check` adds the anchor
  validation that `--strict` can't do in MkDocs 1.6.
- **§9 Content a11y:** see §2 accessibility plan.
- **§10 Per-cluster parallelism:** not touched (no cluster guide).
- **§11 HPC accuracy:** not applicable. HUBzero content accuracy is a GOAL non-goal (Nick's
  review owns it); we carry the review status through faithfully.
- **§12 Commits/PR:** `[feature] Draft hubzero-docs P<n>: …` per phase; squash PR; no trailer.
- **High-impact files touched:** `mkdocs.yml`, `main.py`, `tools/**`. Any confirmed review
  finding on them forces the human gate. Expected and appropriate.

### Deviation justifications

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| A machine-written region (~430 lines) inside `mkdocs.yml` `nav:` | 416 pages must stay in nav (§4) and reproduce exactly (R8) | Hand-writing it is error-prone and can't be re-run for the touch-up; a nav plugin adds a dependency and `generate_breadcrumbs.py` reads `mkdocs.yml` nav directly |
| Kebab-case filenames and a lowercase `hubzero/` tree, not house `snake_case` | URL parity with hubzero.github.io (for the HUBzero team's later redirects) and clean touch-up diffs | Renaming to snake_case breaks the 1:1 path map in `redirects.json` and adds a mapping layer with no reader benefit (the style guide already lets generated/dataset entries keep source casing) |
| A page hook in `main.py` for the status banner (adds complexity to a high-impact file) | Keeps `hubzero.status` the single source, so the maintainer workflow is one field | Baking the banner text into the body duplicates state: maintainers would edit front-matter **and** prose to change a status |
| ~971 explicit heading ids `{ #… }` added to imported text | Keeps upstream anchors, so all 1,388 fragment links and the API summary tables resolve | Rewriting the links to Python-Markdown slugs breaks inbound upstream deep links; a site-wide `toc` slugify change would alter anchors on every existing page |

## 4. Rabbit holes (resolved)

- Jinja in five files would break the macros pass → `render_macros: false`, which the plugin
  honours per page ([`research/01`](research/01-site-integration.md)).
- Includes hold only a directive, not code; 69 files would lose code blocks → expand from the
  pinned commit, mirroring upstream ([`research/02`](research/02-source-format.md)).
- `## GET /tags/{id}` silently loses `{id}` under attr_list (51 headings) → explicit trailing
  id ([`research/05`](research/05-rendering-hazards-and-api.md)).
- 971 headings get different ids under Python-Markdown, and `--strict` would not notice the
  broken fragments → preserve upstream ids and check them in `site/`
  ([`research/03`](research/03-links-anchors-assets.md)).
- One slug collision after prefix stripping → upstream's `index/` mapping ([`research/02`](research/02-source-format.md)).
- 1,647 links into the source tree → commit-pinned GitHub URLs ([`research/03`](research/03-links-anchors-assets.md)).
- 430 nav entries → importer-owned nav region ([`research/01`](research/01-site-integration.md)).

## 5. Risks & open questions

- **Resolved: source links pin to the commit,** not `2.4-main`: `#L` anchors stay exact and the
  output reproducible (Geoffrey, 2026-10-08).
- **Resolved: `plan/documentation-program.md` is not published.** Upstream skips `plan/`, so
  R2 now covers only published pages: 416 (GOAL amended, Geoffrey, 2026-10-08).
- **Resolved: the home page gets a HUBzero card** (new R11, built in P7; Geoffrey,
  2026-10-08).
- **Risk: the source commit must stay available.** The local clone is shallow. The importer
  reads via `git show <sha>` and fails with a `git fetch --depth=1 origin <sha>` hint.
- **Risk: `verify:` needs the local hubzero-cms clone** (`HUBZERO_CMS`). CI never runs
  `check`, so this binds only the drafting machine.
- **Risk: dialect drift beyond what was measured.** CommonMark (upstream) and Python-Markdown
  differ in edge cases the scan didn't target. Mitigation: a render spot-check per book phase,
  with each fix landing as an importer rule, never a page hand-edit.
- **Risk: search index and repo growth.** About 416 pages and up to 15 MB of images. P7
  measures `site/search/search_index.json` before and after.
- **Risk: hand edits before the touch-up sync** get overwritten by a re-import.
  `tools/hubzero/README.md` sequences it: touch-up first, then the handover.
- **Upstream defects found (report to Nick; don't fix):** two `<name>`/`<first>` placeholders
  lost as raw HTML ([`research/03`](research/03-links-anchors-assets.md)).

## 6. Verification strategy

- **Build integrity:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`.
- **Nav:** `grep -q 'hubzero/<book>/index.md' mkdocs.yml` for the book each phase lands.
- **R-gate:** `HUBZERO_CMS=$HOME/Software/github.com/hubzero/hubzero-cms .venv/bin/python tools/hubzero/import_docs.py check`
  runs after the build (it reads `site/`). It covers R2 count and titles, R3 anchors and links,
  R4 images and alt, R5 endpoints, R6/R7 front-matter and header leakage, and R8 byte-identical
  re-import. `check --final` (P7) also requires all five books and no remaining GitHub fallback
  links to docs pages.
- **Silent-failure guard:** no `--8<--` includes are used. HUBzero's own includes are expanded
  at import time, and `check`'s R8 comparison catches a regression.
- **Render:** `.venv/bin/mkdocs serve`, then eyeball a sample per book: a banner/stamp page, an
  include page, an image page, an API page with `{id}` headings, and nested lists.
- **Front-matter:** asserted by `check` (§2 contract).
- **Accessibility:** measured clean at source; `check` asserts alt on the built site.
- **Accuracy:** not applicable (GOAL non-goal); fidelity to the source is what `check` proves.

---

*Backing research: [`research/00-digest.md`](research/00-digest.md).*
