# Research 03 — Links, anchors, and images

Scope: every link and image in the 413 book pages, and the rewrite rules that make them
resolve on docs.rcac.purdue.edu (R3, R4). Scan scripts: `/tmp/hzscan/scan.py`,
`scan2.py` (run with `python3 -I`, read-only).

## Link census (outside code)

- 3,286 relative links, 50 external, 494 bare `#fragment` links.
- By target extension: `.md` 1,625 · `.php` 1,544 · `.xml` 42 · none 45 · `.yml` 8 · `.css` 6
  · `.less` 6 · `.sh` 4 · `.json` 3 · `.js` 2 · `.ini` 1.
- **Every relative `.md` link resolves** to an existing file at the pinned commit (0 broken),
  and the links carry the numeric prefixes literally.
- Non-`.md` targets resolve, relative to the repo root, into `core/` (1,647), `.github/` (9),
  `docs/` (2), and one each `LICENSE`, `.gitignore`, `index.php`. The two `docs/` ones point at
  `docs/_tools/{lint,docs}` directories. **Hypothesis confirmed: non-page links are links into
  the hubzero-cms source tree.**

## Rewrite rules (mirror `make_link_resolver()`, `build_site.py:263`)

1. Link to a page that is imported: relative link to its new path (prefix-stripped,
   `README.md` → `index.md`, collision rule from 02). `--strict` validates these.
2. Link to a directory under `docs/` with a README: the same, to its `index.md`.
3. Link to a page in a book not yet imported (only while the phases land): the upstream
   GitHub blob URL. This keeps every intermediate phase `--strict`-clean; the next import run
   turns these into relative links.
4. Link to any other repository file: `https://github.com/hubzero/hubzero-cms/blob/<commit>/<path>`;
   to a repository directory: `…/tree/<commit>/<path>`.
5. Absolute URLs, `mailto:`, and bare fragments: unchanged.

**Pin to the commit SHA, not `2.4-main`.** 1,500+ links carry `#L<n>` line anchors
(`entriesv1_0.php#L155`). On a moving branch those drift silently; a SHA keeps them exact and
makes the output reproducible (R8). The trade-off is that links show the code as of the port.
The touch-up re-import refreshes them. Upstream uses `2.4-main`; see PLAN §5 (open question).

## Anchors

- 3,863 headings. Upstream ids are `slugify()` (`[^a-zA-Z0-9]+` → `-`, ASCII-folded) with
  duplicates suffixed `-2`, `-3` (`build_site.py:93,423`). Python-Markdown's default slugify
  **differs on 971 of them** (`a-wish-s-page` vs `a-wishs-page`,
  `membership-settings-join-policy` vs `membership-settingsjoin-policy`).
- 1,388 fragment links (same-page and cross-page): **all 1,388 resolve under the upstream
  scheme**, so preserving upstream ids fixes every anchor at once.
- Decision: the importer appends an explicit attr_list id `{ #<upstream-id> }` to each heading
  whose Python-Markdown id would differ (and to every heading ending in `}`; see 05). This
  leaves Python-Markdown's id where it already matches, keeps upstream deep links valid (useful
  if the HUBzero team later redirects hubzero.github.io anchors), and needs no site-wide
  `toc` slugify change.
- `--strict` does not validate anchors in MkDocs 1.6 (`validation.anchors` defaults to `info`).
  The importer's `check` command validates them in the built `site/` instead: every
  `href="…#frag"` inside `site/hubzero/` must hit an `id` in its target page.

## Images

- 149 Markdown images, all with alt text; 4 raw `<img>` tags. Paths are relative to a book's
  `media/` (`media/…` 40, `../media/…` 106, `../../media/…` 4). Only four `media/` directories
  exist (users, managers, tools, developers).
- Files on disk: 183 png, 4 gif, 2 jpg. Some are unreferenced.
- Rule: copy **referenced** images only, to `docs/assets/images/hubzero/<book>/<path-under-media>`,
  and rewrite the reference to the absolute `/assets/images/hubzero/<book>/…` path (invariants
  §5). Alt text carries through unchanged. The importer reports unreferenced files rather than
  copying them.
- R4 check (built site): every `<img>` under `site/hubzero/` has a non-empty `alt` and its
  `src` exists in `site/`.

## Upstream defects noticed (not ours to fix; non-goal)

- Two placeholder "tags" outside code (`<name>`, `<first>`) are swallowed as raw HTML by
  **both** renderers, so the text is already missing upstream. They are among the six files
  with raw tags outside code (`developers/11-templates/12-fontcons.md`,
  `developers/14-supergroups-gitlab.md`, `managers/03-maintenance/05-cron.md`,
  `users/01-collections.md`, `users/18-publications.md`, `users/28-usage.md`); P2–P5 pin down
  which. Carry them through as-is and report them to Nick.
