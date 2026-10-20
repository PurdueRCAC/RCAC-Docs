# Research 02 — The HUBzero source format

Scope: what `hubzero/hubzero-cms` `docs/` contains at the pinned commit and how its own
builder (`gh-pages/build_site.py`) interprets it. Local clone
`~/Software/github.com/hubzero/hubzero-cms`, HEAD
`9c1a8c678002bdfb41860f90915a3589ab60339e` (2026-10-07). Read-only.

## Inventory

- **417 Markdown pages.** 413 sit in the five books; four sit at the root: `README.md`
  (H1 "Hubzero documentation", the landing page), `LICENSE.md` ("License"), `STYLE.md`
  ("Writing guide"), `plan/documentation-program.md` ("Hubzero Documentation Program",
  403 lines). `docs/_tools/` holds scripts, not pages.

  | Book | `.md` | Other files | `media/` |
  |---|---|---|---|
  | users | 34 | 54 | yes |
  | managers | 90 | 114 | yes |
  | tools | 34 | 11 | yes |
  | developers | 101 | 10 | yes |
  | reference | 154 | 0 | no |

- Book order comes from `gh-pages/site.json` `books[]`: **managers, users, tools, developers,
  reference**. Book H1s: "Hub managers", "Hub users", "Tools", "Developers", "Reference".
- Every directory has a `README.md`; each page has exactly one H1.

## Metadata header

Every page opens with an HTML-comment header (`<!--\nkey: value\n…\n-->`), parsed by
`parse_meta()` (`build_site.py:127`): `key: value` lines, keys `[a-z][a-z0-9-]*`. Key
frequency: status 413, source 383, reviewed 259, reviewed-against 258, screenshots 171,
source-id 133, modified 112, imported 81, source-state 10, merged-from 5, summary 3.

Status semantics (`STYLE.md:52`) and how upstream shows them (`build_site.py:594–630`):

| Status | Count | Meaning | Upstream display |
|---|---|---|---|
| rewritten | 235 | replaced wholesale after review | stamp "Rewritten and checked against `<reviewed-against>` on `<reviewed>`." |
| generated | 153 | produced by a script from the source tree | stamp "Generated from the source tree at `<reviewed-against>`." |
| reviewed | 23 | checked against the code | stamp "Reviewed against … on …." |
| draft | 2 | still being written | banner "**Draft.** This page is still being written." |
| imported / merged | 0 | converted from help.hubzero.org, unreviewed | banner "**Not yet reviewed.** This page was imported from help.hubzero.org and has not been checked against Hubzero 2.4." (+ `modified` year, `source-state`, `merged-from` clauses) |

No page is `imported`/`merged` at this commit, but a touch-up re-import may bring some back,
so the banner logic must cover all six values. STYLE.md's maintainer workflow is "flip the
status in the header once reviewed"; keeping that one-field workflow matters because the
HUBzero team maintains these pages here afterwards.

## Ordering and URLs

- `order_key_for()` (`build_site.py:148`): explicit `order` meta, then the numeric filename
  prefix, then the name. No page sets `order` at this commit.
- `slug_for()` (`:158`): numeric prefix dropped, then slugified. `README.md` is the directory
  page. URLs: `/<book>/<path-without-prefixes>/`.
- **One collision after prefix stripping:** `managers/09-components/31-search/README.md` and
  `…/31-search/05-index.md` both strip to `search/index.md`. Upstream publishes the latter at
  `…/search/index/`. Rule: a non-README file whose stripped name is `index.md` maps to
  `index/index.md` (URL `…/search/index/`, matching upstream). No other collisions.

## Include directives

- `<!--include: path[:start-end]-->` is expanded by the builder into a fenced code block from a
  **repository** file (`expand_includes()`, `:177`; language from `INCLUDE_LANGS`, `:71`). The
  Markdown holds only the directive, so without expansion the code vanishes (an HTML comment).
- 69 files use it: developers 52, managers 14, users 1, STYLE 1, plan 1; tools and reference
  have none. None sit inside a code fence. Upstream expands every match and leaves a directive
  whose file is missing untouched; the importer mirrors that, reading files at the pinned
  commit.

## Markdown dialect

- Upstream renders with `markdown-it-py` CommonMark + `table` + `strikethrough`, `html: true`,
  `typographer: true` (`:391`). RCAC-Docs uses Python-Markdown + pymdownx.
- Measured divergences: nested list items indented < 4 spaces (10 items, 4 files) and a list
  starting with no blank line after a paragraph (1). Both flatten or merge under
  Python-Markdown. Typographer smart quotes are cosmetic. Rendering hazards are in 05.

## Builder files not imported

`gh-pages/redirects.json` (666 help.hubzero.org → new-path mappings) and the generated
`/status/` report. Redirects are a non-goal, but the importer keeps upstream slugs so the
HUBzero team can reuse this map later.
