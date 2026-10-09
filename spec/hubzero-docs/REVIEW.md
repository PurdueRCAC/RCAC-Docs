# REVIEW — Port the HUBzero documentation into a top-level /hubzero/ section

> Adversarial QA by `docs-review`, run in an isolated/clean context. The correctness pass grades the
> branch diff against [`GOAL.md`](GOAL.md) + the invariants + the style guide **only** — it does not
> see `PLAN.md`/`TECH.md` (avoids grading-its-own-homework / plan-sycophancy). Every finding cites
> **evidence** — a build/render/link result or a direct read of the diff — not an assertion.

- **Reviewed commit:** 087291b66a77dbd3fd199a2b36bf72bb158ea3d2  ·  **Base:** main (`f013840e`)  ·  **Date:** 2026-10-09
- **Verdict:** changes-requested
- **Cycle:** 1 of ≤3 (escalate to human on non-convergence)

Run unattended overnight on Geoffrey's go (Oct 8): one blind correctness reviewer (fresh subagent;
inputs were GOAL.md, `git diff main...HEAD -- . ':!spec/'`, invariants, rubric, style guide, strict
baseline, the runnable repo, the upstream clone at the pinned commit) and a separate completeness
reviewer that read TECH.md. The diff given to the blind reviewer excluded `spec/` because a plain
`git diff main...HEAD` carries PLAN.md and TECH.md.

## Verification run

- `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py` →
  `PASS: no new --strict warnings (0 present, all in baseline of 0)`. No hubzero WARNING/ERROR lines.
- No browser. The reviewer built upstream's own renderer (`gh-pages/build_site.py` from a `git archive`
  of `9c1a8c67`, markdown-it-py in a scratch venv): 416 pages, matched 1:1 to ours by source path
  (0 missing, 0 extra). Whole-corpus comparison of our `<article>` against upstream `div.prose` on
  all 416 pages: H1, banner, stamp, counts of every structural element, code-block content, word-level
  text diff (code excluded), heading ids, ordered-list `start` values, nesting depth.
- Own link checker over `site/hubzero/**`: 8,761 internal links, 0 unresolved, 0 bad anchors. 149
  content images present, none with empty alt. One H1 per page, no heading skips, all tables have
  header rows, no "click here".
- R8: re-import into a `git archive` copy, `diff -r` identical (`docs/hubzero`, images, `mkdocs.yml`,
  regenerated `breadcrumbs.json`).

## Requirement → evidence matrix

| R-ID | Implemented by | Verified how | Status |
|------|----------------|--------------|--------|
| R1 | `mkdocs.yml` nav region (427–878); `docs/hubzero/index.md` | nav read; landing links all five books | ✅ |
| R2 | `tools/hubzero/import_docs.py` | 416 = 416 vs upstream build, 1:1 by source path; 415/416 H1s identical | ✅ (F4) |
| R3 | importer link resolver | 8,761 links resolve; strict clean | ✅ |
| R4 | importer image rewrite | 149 images present, descriptive alt | ✅ |
| R5 | importer + `check` R5 | 245 endpoints as H2 with full `{id}` paths, parameter names match | ⚠️ partial (F1) |
| R6 | front-matter + `main.py` `on_post_page_macros` | banner/stamp text matches upstream on all 416 | ✅ |
| R7 | importer header strip | no header text visible | ✅ |
| R8 | importer determinism | re-import `diff -r` identical | ✅ |
| R9 | landing about paragraph, `license.md` | credit + MIT notice + link | ✅ |
| R10 | content a11y | sweep clean | ✅ (F7 triage) |
| R11 | `docs/index.md` card | renders `href="hubzero/"` | ✅ |
| R12 | importer `pages_url` resolver | 0 `hubzero.github.io` in docs/site | ✅ |

Unmapped changes (possible scope creep): none.

## Findings

### F1 [HIGH/CONFIRMED] `HH:mm:ss` renders as a Myanmar-flag emoji on the REST API pages
- **Where:** `docs/hubzero/reference/api/activity.md:42` and siblings; cause `pymdownx.emoji` (site-wide) + importer `convert()` not neutralizing `:shortcode:` text.
- **Failure scenario:** "YYYY-MM-DD HH🇲🇲ss" in parameter descriptions. 32 occurrences on 8 pages (api/activity, answers, blog, collections, forum, support, wiki; configuration/components/oaipmh).
- **Evidence:** built `site/hubzero/reference/api/activity/index.html` contains `HH<img alt="🇲🇲" class="twemoji" … title=":mm:" />ss)`; upstream has literal `HH:mm:ss`.
- **Touches:** R5; `tools/**`.

### F2 [MEDIUM/CONFIRMED] Include-expanded code blocks inside list items are garbled
- **Where:** importer `_expand_line`; `developers/templates/accessibility.md:148`, `:186`; `managers/components/search/index/index.md:39` (all 3 indented includes in the source).
- **Failure scenario:** literal "```php" on the page, PHP as proportional text, docblocks as `<em>`.
- **Evidence:** built accessibility page has `<p>```php\n  public static function id(...`; "```" outside `<pre>` occurs only on these 2 pages.
- **Touches:** R2 fidelity; `tools/**`.

### F3 [MEDIUM/CONFIRMED] Numbered steps restart at 1
- **Where:** `managers/users/user-notes.md:121` ("4. Select Save" renders as step 1); `managers/maintenance/notices.md:56` (3–4 render as 1–2).
- **Evidence:** upstream `<ol start="4">`/`<ol start="3">`; ours plain `<ol>` (Python-Markdown `lazy_ol`). Only 2 mismatches in the corpus.
- **Touches:** R2 fidelity; `tools/**`.

### F4 [LOW/CONFIRMED] Landing title differs from upstream
- **Where:** `docs/hubzero/index.md:13` H1 "Hubzero documentation"; hubzero.github.io titles the page "About Hubzero" (site.json) and drops the body H1. `build_model` prefers the body H1 over `import.yml`'s title.

### F5 [LOW/CONFIRMED] Escaped pipe shows backslashes in a table code span
- **Where:** `tools/developers/grid/submitcmd.md:91` renders `--help [tools\|venues\|managers\|examples]`; upstream `[tools|venues|…]`.

### F6 [LOW/CONFIRMED] Malformed upstream markup renders differently from upstream (both wrong)
- **Where:** empty code spans in generated config pages (answers, members ×3, plugins/system); a wrapped "**Citation\n- Default**" in `managers/components/citations.md`. Upstream source defects.

### F7 [LOW/PLAUSIBLE] Empty headings (R10 triage)
- **Where:** source-generated `###` with no text in `reference/configuration/plugins/courses.md` (4) and `cron.md` (10). Upstream renders them the same; §9 doesn't list empty headings, but it's a WCAG heading-content issue.
- **Authoritative source to check:** WCAG 2.1 SC 2.4.6 / 1.3.1.

### F8 [LOW/PLAUSIBLE] Landing contradicts itself
- **Where:** README prose ("Everything here is Markdown in the hubzero-cms repository") vs. the appended paragraph (the HUBzero team maintains the pages here). Content changes are a non-goal; human call.

## Human-gate triggers

- **Triggered.** F1–F5 are rooted in `tools/hubzero/import_docs.py` (high-impact `tools/**`), and
  their fixes regenerate `docs/hubzero/**` and may touch the nav region in `mkdocs.yml`. Geoffrey
  signs off before `docs-publish`.

## Optional completeness sub-pass (separate reviewer; may see TECH.md)

Complete: every phase shipped, gates reproduce (`--strict` PASS; `check --final` PASS, 416 pages),
Touches essentially clean (P7's `upstream-note.md` sits outside its declared Touches), scope within
the big appetite, no unanchored work. Growth numbers reproduce. Corrections to TECH.md narrative:

1. P7 claims `check --final` asserts the landing links all five books relatively; it doesn't (true
   by inspection, not by the gate).
2. P5's "461 blob and 41 tree links" was counted across all four imported books at the time; the
   developers book alone had 316 blob (51 fallbacks into Reference) and 28 tree.
3. P2's "fires twice" is stale (P3 corrected it to once).
4. P6's goal line says 30 API pages; there are 31 with endpoints plus `index.md`.
5. Planning estimates differ from what was built (heading ids 1090 vs ~971; 146 images, ~10 MB vs
   149, ≤15 MB; 811 callouts converted of 814 source lines). Not defects.
6. The `imported`/`merged` "Not yet reviewed" banner never renders: no page at the pin has those
   statuses (draft 2, generated 153, reviewed 23, rewritten 235, empty 3).
7. PLAN §6's `mkdocs serve` render check was done by scratch probes over `site/`, which are not
   committed or part of the gate.
8. R8 compares in memory, not via a temp tree; same effect.
