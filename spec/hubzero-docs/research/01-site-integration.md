# Research 01 — Site integration: nav, archetype, front-matter, macros

Scope: where a 417-page imported section sits in RCAC-Docs and what the site's machinery
(nav, breadcrumbs, macros, toc, plugins) does to it. Read-only survey of the worktree at
`f013840e` (2026-10-08). Paths are repo-relative.

## Nav

- `nav:` is `mkdocs.yml:98` onward. Top-level order today: **HPC User Guides** (`:99`),
  **Storage User Guides** (`:222`), **RCAC Resources** (`:261`; holds Blogs, Software, Datasets,
  Profilers, Workshops), **RCAC Services** (`:372`), then `Contact us: contact.md`,
  `FAQs: faqs.md` (`:426–427`).
  Contact/FAQs stay last by convention.
- **Insertion point:** a new top-level `HUBzero` entry after `RCAC Services`, before
  `Contact us`. HUBzero is a platform RCAC runs, not a resource or a service page, and GOAL R1
  asks for `/hubzero/` top-level.
- The nav is manual (invariants §4) and the whole file is ~397 nav lines today. The HUBzero
  section adds ~430 entries (417 pages plus section headers). Hand-maintaining that is
  error-prone and breaks R8 (re-run reproduces with no diff).
- Options considered:
  1. Hand-written nav. Rejected: 430 entries, not reproducible.
  2. A nav plugin (`mkdocs-awesome-nav` / `literate-nav`). Rejected: new dependency in
     `requirements.txt`, changes the site-wide nav model, and `tools/generate_breadcrumbs.py`
     reads `mkdocs.yml` `nav:` directly (`tools/generate_breadcrumbs.py:3`), so it would stop
     seeing the section.
  3. **The importer writes the HUBzero subtree into `mkdocs.yml` between two marker
     comments.** Nav stays in `mkdocs.yml` (§4 honoured literally), breadcrumbs keep working,
     and the region is reproducible. Cost: a machine-written region inside a high-impact file.
     **Chosen** — recorded as a deviation in PLAN §3.
- Section hubs: `navigation.indexes` is on, so each section's first child is a bare
  `…/index.md`. Every HUBzero directory has a `README.md` (0 directories without one), which
  maps cleanly to `index.md`.
- Breadcrumbs: `python tools/generate_breadcrumbs.py` regenerates
  `docs/assets/data/breadcrumbs.json` from nav; it must be re-run in every phase that changes
  nav (generated file, §3).

## Archetype and front-matter

- Closest precedent for the landing page is the hub/landing archetype (style guide §E;
  exemplar `docs/lifesciences/index.md`: `title`, `tags`, grid cards).
- The imported pages are none of A–D. They are **reference pages with their own upstream
  contract** (`hubzero-cms/docs/STYLE.md`). Front-matter contract for this section:

  ```yaml
  ---
  tags:
    - HUBzero
  render_macros: false
  hubzero:
    upstream: docs/managers/09-components/04-blogs.md   # source path at the pinned commit
    commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
    status: rewritten
    reviewed: '2026-10-01'
    reviewed-against: 2.4-main @ 0ebd2294a3
    source: https://help.hubzero.org/…
    # …every other header key, verbatim
  ---
  ```

  `summary` (3 pages) also maps to `description` so Material emits it as the meta description.

## Macros / Jinja

- `mkdocs-macros-plugin==1.3.9` renders every page by default (`render_by_default: true`).
- **Per-page opt-out exists:** `render_macros: false` in front-matter returns the markdown
  untouched (`.venv/…/mkdocs_macros/plugin.py:629,682`). The HUBzero pages never use RCAC
  macros, so the importer sets it on every page. That neutralizes all five Jinja-hazard files
  (`{{ISSUE}}`, `{{{code}}}`, `{{uid}}`, `{{course}}` …) with no `{% raw %}` edits to content.
- `pre/post_macro_functions` still run when `render_macros` is false (`plugin.py:960,978`;
  `render()` returns the input unchanged). So `main.py` can define `on_post_page_macros(env)`
  to render the review-status banner from `page.meta.hubzero.status` (see 04). `main.py`
  defines no page hooks today.

## toc / anchors

- `toc: { permalink: true }`, default slugify. MkDocs 1.6.1; `validation.anchors` is unset
  (default `info`), so **`--strict` does not catch a broken fragment link**. R3 needs its own
  anchor check (see 03).

## Plugins that touch the section

- `search`: 417 more pages in `search_index.json`; measure growth in the integration phase.
- `tags`: `tags: [HUBzero]` is harmless (the tags page is commented out of nav).
- `git-revision-date-localized`: CI-only (`!ENV [CI, false]`); imported files get their
  commit date. No exclusion needed.
- `blog`, `rss`: untouched.

## Assets

- Images live under `docs/assets/images/<area>/…` and are referenced by absolute
  `/assets/…` paths (invariants §5). `docs/assets` is 81 MB today; HUBzero `media/` adds
  ≤ ~15 MB (only referenced files get copied, see 03).
