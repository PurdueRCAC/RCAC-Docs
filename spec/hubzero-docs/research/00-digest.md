# Research digest — hubzero-docs

Synthesis of five briefs, researched sequentially (this harness has no subagent tool). The
cited detail lives in each brief; this is the decision-ready summary that `PLAN.md` and
`TECH.md` build on.

- [`01-site-integration.md`](01-site-integration.md): nav insertion, the nav-region decision,
  front-matter contract, `render_macros`, anchors not validated by `--strict`.
- [`02-source-format.md`](02-source-format.md): 417 source pages (416 published; `plan/` is
  excluded, see Decided), the metadata header and status
  semantics, ordering and URLs, the one slug collision, include directives, dialect.
- [`03-links-anchors-assets.md`](03-links-anchors-assets.md): link census and rewrite rules,
  the anchor-id mismatch, the image rule, upstream defects.
- [`04-importer-design.md`](04-importer-design.md): the importer, its `check` gate,
  determinism, and the front-matter-driven status display.
- [`05-rendering-hazards-and-api.md`](05-rendering-hazards-and-api.md): Jinja, trailing-brace
  headings, raw HTML, and the REST API reference (R5).

## Settled

1. **An importer, not hand conversion.** `tools/hubzero/import_docs.py` reads the pinned
   commit through `git show` (never the working tree), regenerates `docs/hubzero/**` and
   `docs/assets/images/hubzero/**`, and rewrites a marked nav region in `mkdocs.yml`.
   Re-running it is the touch-up sync. Its `check` subcommand is every phase's R-gate.
2. **Top-level `HUBzero` nav** after RCAC Services, before Contact us/FAQs. Books follow
   upstream order (managers, users, tools, developers, reference). Labels are page and section
   H1s. Upstream slugs are kept (prefix stripped, `README.md` → `index.md`), so URLs mirror
   hubzero.github.io one to one. One collision (`managers/…/search/05-index.md`) maps to
   `search/index/index.md`, as upstream does.
3. **Front-matter:** `tags: [HUBzero]`, `render_macros: false`, and a `hubzero:` map holding the
   upstream path, commit, and every header key verbatim. The header comment leaves the body
   (R6, R7).
4. **Status display comes from front-matter** through `on_post_page_macros` in `main.py`, using
   upstream's banner and stamp wording as Material admonitions. Maintainers flip one field, as
   STYLE.md prescribes (R6).
5. **Links:** page links become relative to the new paths; links into the source tree (1,647)
   go to commit-pinned GitHub blob/tree URLs (keeping 1,500+ `#L` anchors exact); links into
   books not yet imported fall back to GitHub until they land.
6. **Anchors:** preserve upstream heading ids with `{ #id }` where Python-Markdown's would
   differ (971 of 3,863). All 1,388 fragment links resolve under that scheme. `check` validates
   them in `site/`, because `--strict` doesn't.
7. **Images:** copy referenced files only, to `/assets/images/hubzero/<book>/…`; alt text is
   already present on all 149.
8. **Hazards neutralized mechanically:** Jinja (`render_macros: false`), headings ending in `}`
   (51, mostly API endpoints, which would silently lose `{id}`), includes (69 files, expanded
   from the pinned commit), and dialect gaps (11 list items normalized).
9. **R5** needs no special renderer: 245 endpoint sections across 30 API pages, checked by count
   and by the id and path text of each rendered `h2`.
10. **R10** is clean at source: no heading skips, exactly one H1 per page, no vague link text, and
    every image has alt.

## Decided (Geoffrey, 2026-10-08; see PLAN §5)

- Source links pin to the commit SHA, not `2.4-main`.
- `plan/documentation-program.md` is not published: upstream `build_site.py` skips `plan/`,
  and no published page links to it. R2 now counts 416 pages; briefs 01 and 02 predate this
  and still say 417.
- The site home page gets a HUBzero card (R11).
