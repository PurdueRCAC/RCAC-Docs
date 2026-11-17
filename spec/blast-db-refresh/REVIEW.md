# REVIEW — Announce the refreshed shared BLAST databases

> Adversarial QA by `docs-review`, run in an isolated/clean context. The correctness pass grades the
> branch diff against [`GOAL.md`](GOAL.md) + the invariants + the style guide **only** — it does not
> see `PLAN.md`/`TECH.md` (avoids grading-its-own-homework / plan-sycophancy). Every finding cites
> **evidence** — a build/render/link result or a direct read of the diff — not an assertion.

- **Reviewed commit:** 5e2e44a39065541694e9dc75395e6a90f9bce724  ·  **Base:** main  ·  **Date:** 2026-11-10
- **Verdict:** approved
- **Cycle:** 1 of ≤3

## Verification run

- `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py` → exit 1 on
  **one** warning: `workshops/genomics_exchange/fall2026/session4/index.md` → `session-5.md` not found.
  Pre-existing on `main` (`git show main:…/session4/index.md` line 51; no `session-5.md` in
  `git ls-tree main`), not touched by this branch, and out of scope per GOAL non-goals. It is fixed on
  `fix/ge-fall2026-session4-links`. No other warnings, no build errors. The RSS "creation date not
  recognized" INFO line appears for all 10 blog posts (including `uv_manager.md`), so it isn't specific to this post.
- Rendered `site/blog/…/blast-databases-refresh/index.html` → one H1 + seven H2s (no skipped levels);
  the database table renders with `<thead>`; `${BLASTDB}`, `${SLURM_CPUS_PER_TASK}`, `!seen[$1]++`
  render intact (no Jinja mangling); blog index shows only the excerpt + "Continue reading".
- nav check: n/a — blog posts are listed by the blog plugin; no `nav:` change (non-goal).
- front-matter: categories `Life Sciences`, `Announcements` ∈ `categories_allowed`; author `aseethar`
  in `.authors.yml`; `slug`, `date.created`, `<!-- more -->` (line 29) present; `Life Sciences` first tag.
- Job script extracted and `bash -n` clean; awk top-hit filter tested on sample input.

## Requirement → evidence matrix

| R-ID | Implemented by (file/commit) | Verified how | Status |
|------|------------------------------|--------------|--------|
| R1 | `docs/blog/posts/blast-databases-refresh.md:25-27` | diff read; `grep -i anvil` → none; no cluster list | ✅ |
| R2 | `…:33-42` | diff read (module load, export BLASTDB, `column -t $BLASTDB/MANIFEST.tsv`, `-db`, taxdb, v5, blast/2.13.0) | ✅ |
| R3 | `…:46-57` | render: table with header; core_nt recommended (132,327,666 seqs, NCBI build Oct 24, 2026); UniProt 2026_04; nr→protein tip | ✅ (completeness vs source list: human) |
| R4 | `…:59-65` | diff read; 5 bullets, no extra claims | ✅ (vs source list: human) |
| R5 | `…:67-115` | `bash -n`; megablast, outfmt quoted, `-max_target_seqs 5`, `-evalue 1e-10`, `${SLURM_CPUS_PER_TASK}` with `--cpus-per-task=32`, awk filter, optional blastp vs uniprot_sprot; no `--mem`; illustrative comments; compute-node admonition; no perf claims | ✅ |
| R6 | `…:117-125` | own H2 + warning admonition with `APPTAINERENV_BLASTDB` | ✅ |
| R7 | `…:127-143` | diff read: policy + MANIFEST.tsv/SNAPSHOT_INFO + `readlink` | ✅ |
| R8 | `…:149-154` | ticket URL identical to `docs/datasets/index.md:53` | ✅ |
| R9 | front-matter + render | see Verification run; links relative and resolve; descriptive text | ✅ |

Unmapped changes (possible scope creep): none.

## Findings

No CONFIRMED findings. PLAUSIBLE items for human triage (non-blocking):

### [LOW/PLAUSIBLE] `ncbi/blast` section doesn't mention binding `/depot`
- **Where:** `docs/blog/posts/blast-databases-refresh.md:117-125`
- **Concern:** if RCAC's `apptainer.conf` does not bind `/depot` by default, users running their own
  `ncbi/blast` image would also need `--bind /depot`. R6 requires only the env-var warning.
- **Authoritative source to check:** `bind path` entries in `apptainer.conf` on a `/depot`-mounting cluster.

### [LOW/PLAUSIBLE] `readlink` comment assumes a relative symlink
- **Where:** `…:92`, `…:141`
- **Concern:** `# snapshot name, e.g. week-45-2026` holds only if `latest` is a relative link; an
  absolute link prints the full path.
- **Authoritative source to check:** `ls -l /depot/datasets/bioinformatics/blast/latest`.

### [LOW/PLAUSIBLE] `column -t` splits on any whitespace
- **Where:** `…:36`, `…:142`
- **Concern:** misaligns if a MANIFEST field contains spaces; `column -t -s $'\t'` would be robust.
  R2 locks the exact command, so act only if fields contain spaces.

## Human-gate triggers

- Not triggered by files (no high-impact file touched; no CONFIRMED finding).
- Recommended quick human look at the PLAUSIBLE HPC items before publish. Reminder: `date.created`
  must be updated to the merge date at publish (per GOAL).

## Optional completeness sub-pass

- Not run (single-phase, small appetite).
