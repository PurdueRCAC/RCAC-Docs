# PLAN — Announce the refreshed shared BLAST databases

> **Status:** Approved · **Last updated:** 2026-11-10
> **Authoritative design.** Vision/contract is [`GOAL.md`](GOAL.md); the phased roadmap is
> [`TECH.md`](TECH.md). `appetite: small` — no research fan-out; targeted reads only.

## 1. Summary

One new blog post, `docs/blog/posts/blast-databases-refresh.md`, in the Life Sciences category. It
gives the location, a three-line quick start, the grouped database list, what changed since 2024, one
Slurm example, the `ncbi/blast` container caveat, the refresh/reproducibility policy, and a help
link. The blog plugin lists the post, so there is no `nav:` change. One phase.

## 2. Design

- **Archetype:** blog post (style-guide §C). Front-matter: `date.created` (drafted 2026-11-10;
  **set to the merge date at publish**), `categories: [Life Sciences, Announcements]` (both allowed),
  `title`, `slug: blast-databases-refresh`, `tags: [Life Sciences, BLAST, Bioinformatics, Datasets]`,
  `authors: [aseethar]` (present in `.authors.yml`), and a `<!-- more -->` marker after the intro.
  Mirrors `docs/blog/posts/uv_manager.md` (H1 repeating the title, then intro, then `##` sections).
- **Page structure (about 500 words + code):**
  - `#` title → intro (2–3 sentences) → `<!-- more -->`
  - `## Quick start` — `module load`, `export BLASTDB`, `column -t $BLASTDB/MANIFEST.tsv`, `-db`;
    taxdb note; v5 format; works with `blast/2.13.0`.
  - `## Available databases` — table (header row: Type | Databases), then one-line notes for
    `core_nt`, genome accessions, UniProt release; `!!! tip` on `nr` vs `core_nt`/`nt`.
  - `## What's new since the 2024 copy` — bullets.
  - `## Example: taxonomic screening of contigs` — `!!! important` compute-nodes note, job script,
    `awk` top-hit line, optional `blastp` line.
  - `## Using the ncbi/blast container image` — `!!! warning` with `APPTAINERENV_BLASTDB`.
  - `## Updates and reproducibility` — policy bullets, `readlink`/`MANIFEST.tsv` commands.
  - `## Getting help` — ticket button.
- **Navigation placement:** none (blog plugin). Breadcrumbs unchanged.
- **Reuse:** no `main.py` macro covers BLAST/datasets; content is cluster-agnostic. Job-script
  placeholders (`<account-name>`, `<partition-name>`), `module --force purge`, `%x_%j` output names
  follow `running-bioinformatics.md`.
- **Assets:** none.
- **Cross-links:** `../../lifesciences/guides/running-bioinformatics.md`,
  `../../lifesciences/guides/hpc-orientation.md`, `../../lifesciences/guides/reproducibility.md`,
  `../../datasets/index.md`; ticket form URL from `docs/datasets/index.md`.
- **Accessibility:** one H1, `##` only below it; table with header row; descriptive link text; no images.

### Requirement → design map

| R-ID | Design element(s) |
|------|-------------------|
| R1 | Intro paragraph |
| R2 | `## Quick start` |
| R3 | `## Available databases` table + notes + tip |
| R4 | `## What's new since the 2024 copy` |
| R5 | `## Example: taxonomic screening of contigs` |
| R6 | `## Using the ncbi/blast container image` |
| R7 | `## Updates and reproducibility` |
| R8 | `## Getting help` |
| R9 | Front-matter, relative links, heading/table structure, strict build |

## 3. Invariant gate (constitution check)

Checked before and after design.

- §1 Branch/deploy — work on `feature/blast-db-refresh`, local commits only; no push/PR yet.
- §3 Generated content — untouched (dataset catalog is a follow-up).
- §4 Nav — blog posts are plugin-listed; no `nav:` edit needed.
- §5 Links/assets — all page links relative from `docs/blog/posts/`; no assets.
- §6 Front-matter — blog contract as above.
- §7 Jinja — no `{{`/`{%` in the post (awk uses single braces); nothing to escape.
- §8 Build integrity — strict gate; see §5 below for the pre-existing `main` warning.
- §9 WCAG — as in the accessibility plan.
- §11 HPC accuracy — every fact comes from the requester's source-of-truth list or the resolved
  clarifications (module `blast/2.13.0` verified on Negishi; `BLASTDB` pass-through verified).
- §2, §10 — not touched.

### Deviation justifications

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| — | — | — |

## 4. Rabbit holes (resolved)

- Blog vs other placement → blog plugin exists with `Life Sciences` allowed; blog only (human decision).
- Module/version → `blast/2.13.0` (human-verified on Negishi); the docs only mention `blast/2.11.0`
  and the catalog `blast-plus` 2.12.0 (Anvil).
- Does `BLASTDB` reach the biocontainer wrapper → yes (human-verified).

## 5. Risks & open questions

- **Pre-existing strict warning on `main`:** `workshops/genomics_exchange/fall2026/session4/index.md`
  links `session-5.md`, which does not exist. It is not in `strict-baseline.txt`, so `strict_check.py`
  fails on a clean `main` too. Out of scope here; needs a human decision (fix on its own branch, or
  baseline it). This job's bar: no warnings beyond that one.
- `date.created` must change to the merge date at `/docs-publish`.

## 6. Verification strategy

- **Build integrity:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`
  — expected to report only the pre-existing `session-5.md` warning.
- **Render:** the built page exists under `site/blog/**/blast-databases-refresh/index.html` and
  contains a sentinel (`APPTAINERENV_BLASTDB`); the blog index shows the excerpt cut at
  `<!-- more -->`; check admonitions and the table in `mkdocs serve`.
- **Front-matter:** allowed categories, known author, slug, excerpt marker.
- **HPC accuracy:** each claim checked against the GOAL's source-of-truth facts and clarifications.
