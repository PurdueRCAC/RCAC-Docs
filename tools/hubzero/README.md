# HUBzero documentation importer

`import_docs.py` ports the HUBzero documentation (the `docs/` tree of
[hubzero-cms](https://github.com/hubzero/hubzero-cms)) into this site under
`/hubzero/`. It is a one-off port tool: once the HUBzero team starts editing the
pages here, it has done its job. See `spec/hubzero-docs/` for the why.

## What it writes

- `docs/hubzero/**`: one page per published source page, plus the root pages
  (`index.md` from `README.md`, `style.md`, `license.md`).
- `docs/assets/images/hubzero/**`: the images and files those pages reference.
- The `HUBzero` nav subtree in `mkdocs.yml`, between the
  `# >>> hubzero nav` and `# <<< hubzero nav` markers.

All three are generated. Do not edit them by hand while the importer is in use;
`check` will flag it.

## Inputs

- `import.yml`: the source repository, the **pinned commit**, the books in
  `site.json` order, `books:` (the books enabled so far), the root pages, and the
  collision map for the one pair of sources that would map to the same output.
- `$HUBZERO_CMS`: a local clone of hubzero-cms that contains the pinned commit.
  Files are read with `git` at that commit, never from the clone's working tree.

```bash
git clone --depth=1 https://github.com/hubzero/hubzero-cms ~/Software/github.com/hubzero/hubzero-cms
git -C ~/Software/github.com/hubzero/hubzero-cms fetch --depth=1 origin <commit>   # if missing
```

## Running it

From the repository root:

```bash
export HUBZERO_CMS=~/Software/github.com/hubzero/hubzero-cms
.venv/bin/python tools/hubzero/import_docs.py import
.venv/bin/python tools/generate_breadcrumbs.py
.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
.venv/bin/python tools/hubzero/import_docs.py check            # after the build
.venv/bin/python tools/hubzero/import_docs.py check --final    # all books, 416 pages, home card
```

`import` deletes and regenerates its outputs, then prints counts and any warnings
(missing includes, broken source links, unreferenced files).

`check` exits non-zero and names the page and rule (GOAL R2–R8, R11) for each
finding. It re-imports in memory and byte-compares with what is committed (R8),
then checks titles, front-matter, and the built `site/hubzero/` for links,
anchors, images, alt text, and API endpoint headings.

## What it changes, and why

The rules mirror upstream `gh-pages/build_site.py`, so a page here shows what
hubzero.github.io shows:

- The `<!-- status: …; … -->` header becomes `hubzero:` front-matter. `summary`
  becomes `description`. Every page gets `tags: [HUBzero]` and
  `render_macros: false` (some pages contain `{{ … }}` that is not ours).
- Paths lose their numeric prefixes and `README.md` becomes `index.md`.
- `<!--include: path[:start-end]-->` becomes a fenced block from the pinned
  commit. Unlike upstream, a directive inside a code block is left as text.
- Links to pages become relative links. Links to pages in books not yet imported,
  and to code in the repository, go to GitHub at the pinned commit. A link to a
  source file that does not exist at that commit (an upstream defect) goes to its
  nearest existing directory, with a warning. Images go to
  `/assets/images/hubzero/`.
- Headings whose Python-Markdown id would differ from upstream's get an explicit
  `{ #id }`, so existing anchors keep working.
- `> **Note:** …` callouts (Note, Tip, Warning, Important, Caution) become
  Material admonitions, as upstream renders them as styled callouts. A callout
  ends at the next heading, list item, fence, or rule, as a CommonMark blockquote
  does.
- Python-Markdown needs a few things CommonMark does not, so the importer adds
  them: list content re-indented to 4 spaces; a blank line before a list that
  follows a paragraph; a blank line where a heading, list, fence, quote, or HTML
  block directly follows a table row; and a blank line before a list item that
  follows a later paragraph of the previous item.
- References to hubzero.github.io point here instead (GOAL R12), the one change
  to what a page says. A link becomes a relative link to the same page; a bare
  URL in prose becomes its `docs.rcac.purdue.edu/hubzero/` URL. Pages with no
  source page (upstream's generated status page) map through `pages_targets` in
  `import.yml`. `check` flags any reference that survives.

The review-status banner and stamp are **not** in the page body. `main.py`
(`on_post_page_macros`) renders them from `hubzero.status` at build time, so a
maintainer changes a page's status by editing that one field.

## Lifecycle

1. **Port** (done): all five books, 416 pages, imported at the pinned commit;
   `check --final` passes.
2. **Touch-up re-import** (optional, once): below.
3. **Handover**: the HUBzero team edits the pages in this repository.
4. **Retire** the importer: see "After the handover".

## Touch-up re-import

To pick up later upstream changes before the handover: bump `commit` in
`import.yml`, fetch it into `$HUBZERO_CMS`, run `import`, review the diff, and
run the full check. Do this **before** anyone edits pages here; after hand edits,
a re-import overwrites them, and changes must be reconciled by hand.

## After the handover

Once the HUBzero team maintains the pages here, `check`'s R8 comparison fails by
design. At that point delete `tools/hubzero/` and the two nav marker comments in
`mkdocs.yml`; the nav becomes ordinary hand-maintained nav. The `main.py` status
hook stays, since it reads only front-matter.
