# Research 05 — Rendering hazards and the REST API reference

Scope: things that build cleanly but render wrong under Python-Markdown + macros, and what R5
needs from the 31 `reference/api` pages.

## Jinja (macros plugin)

Five files carry literal `{{`/`{%`: `users/23-wiki.md` (`{{{code}}}`, `{{{#!html …}}}`),
`managers/09-components/23-newsletters.md` (`{{ISSUE}}`, `{{PRIMARY_STORIES}}` …),
`managers/09-components/04-blogs.md` (`{{uid}}`), and `reference/configuration/plugins/{courses,members}.md`
(`{{course}}` …). Some are inside inline code, which Jinja does not respect. **Resolved by
`render_macros: false` on every HUBzero page** (01). Adding `{% raw %}` would edit content and
need re-applying on every import.

## attr_list braces in headings (silent; R5 hazard)

`attr_list` treats a trailing `{…}` on a heading as an attribute list. **51 headings end in
`}`**, nearly all API endpoints such as `## GET /tags/{id}`. Python-Markdown would read `{id}`
as attributes and render "GET /tags/" with the path parameter gone. Nothing warns. Fix: the
importer appends `{ #<upstream-id> }` to every heading ending in `}`; only the final brace
group is parsed, so `{id}` stays as text. No `{:…}`, `{#…}`, or `{.…}` patterns occur in prose
outside code (0 found), so the issue is confined to headings.

## Raw HTML

- 4 `<img>`, 5 `<a>`, 1 `<span>`, and a few `<a id="…">` anchors inside headings. They pass
  through Python-Markdown as inline HTML; `md_in_html` isn't needed. The `<a id>` heading
  anchors keep working as link targets (03 counts them).
- `<name>` / `<first>` placeholders: lost in both renderers (03); carried as-is.

## Dialect gaps

10 under-indented nested list items (4 files) and 1 list with no preceding blank line (02).
The importer normalizes them; the render spot-check in each book phase confirms it.

## REST API reference (R5)

- `reference/api/`: `README.md` plus 30 component pages (`activity` … `wiki`), all
  `status: generated` with `source:` = the controller directory (for example
  `core/components/com_tags/api/controllers/`).
- Shape per page: an H1 (`# Tags API`); an intro; a summary table (Method | Endpoint | Purpose)
  whose endpoint cells link to `#post-tags`-style fragments; then one `## METHOD /path` section
  per endpoint, each with a line naming the task and controller file (`entriesv1_0.php#L155`)
  and a parameter table (Parameter | Type | Required | Default | Description).
- **245 endpoint sections in total.** They are plain Markdown tables and headings, so they need
  no special renderer, only the three fixes above: heading ids preserved (the summary-table
  fragments use the upstream scheme), trailing-brace protection, and controller links rewritten
  to commit-pinned GitHub URLs.
- R5 check: for each api page, count `^## (GET|POST|PUT|DELETE|PATCH) ` in the source, and
  require the same number of `h2` elements with matching ids in `site/hubzero/reference/api/<page>/index.html`,
  with each `h2` text including the full path (which catches the brace bug).
- Out of scope: generating these pages from code (GOAL non-goal). `docs/_tools/docs/gen_api_reference.py`
  is the upstream generator and the likely starting point for that later effort.

## The rest of `reference/`

`configuration/` (component, module, and plugin config tables) and `events/`, plus `muse.md`:
123 more `generated` pages with the same table-heavy shape. Two of them are Jinja-hazard
files, covered above.
