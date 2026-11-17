# GOAL — Announce the refreshed shared BLAST databases

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md).

- **slug:** blast-db-refresh
- **kind:** feature
- **appetite:** small

## Problem

RCAC refreshed the shared BLAST databases under `/depot/datasets/bioinformatics/blast` and moved
them to a monthly, snapshot-based update cycle with version manifests. Researchers have no page
telling them where the databases are, which ones exist, how to point BLAST at them, how to run a
search correctly on the clusters, or how to record the database version for a methods section.

## Outcome / vision

A short, plain blog post in the Life Sciences category. A researcher who reads it can find the
databases, set `BLASTDB`, submit a working BLAST job, and record the snapshot and database versions
for reproducibility — within a few minutes. No marketing tone.

## Acceptance criteria (the contract)

- **R1** — The post SHALL state the location `/depot/datasets/bioinformatics/blast/latest`, that
  `latest` is a symlink to the current snapshot (`week-45-2026`, published Nov 9, 2026), and that the
  databases are available on all RCAC clusters that mount `/depot`, without listing clusters and
  without mentioning Anvil.
- **R2** — WHEN a reader follows the Quick start, they SHALL be able to set
  `BLASTDB=/depot/datasets/bioinformatics/blast/latest`, list the databases with versions via
  `column -t $BLASTDB/MANIFEST.tsv`, and select a database with `-db <name>`; the post SHALL say that
  `BLASTDB` also lets BLAST find `taxdb` (so `sscinames`/`scomnames` work), that the databases are
  BLAST v5 format, and that they work with the `blast/2.13.0` biocontainer module
  (`module load biocontainers blast/2.13.0`).
- **R3** — The post SHALL list every database in the source-of-truth set, grouped as Nucleotide,
  Protein, and Taxonomy, at most one line each, with `core_nt` marked as the recommended general
  nucleotide database (with its sequence count and NCBI build date) and UniProt sets marked as
  release 2026_04; it SHALL note that `nr` is protein (blastp/blastx) and to use `core_nt` or `nt`
  for blastn.
- **R4** — The post SHALL list what is new versus the 2024 copy, limited to the source-of-truth items.
- **R5** — The post SHALL give one copy-ready Slurm example (taxonomic screening of contigs against
  `core_nt` with megablast, the specified `-outfmt`, `-max_target_seqs 5`, `-evalue 1e-10`,
  `-num_threads` from Slurm, a one-line top-hit filter, and an optional `blastp` line against
  `uniprot_sprot`), with no `--mem`, 32 cores / 12:00:00 marked illustrative, and an instruction to
  run on compute nodes, not login nodes. No performance claims.
- **R6** — The post SHALL have its own short section warning that inside the `ncbi/blast` container
  image, users must set `APPTAINERENV_BLASTDB` instead of `BLASTDB`.
- **R7** — The post SHALL describe the refresh policy (monthly, first Saturday; dated
  `week-WW-YYYY` snapshots; `latest` switched only after every database passes `blastdbcheck`;
  current + previous kept; longer holds by ticket) and reproducibility guidance (`MANIFEST.tsv`,
  `SNAPSHOT_INFO`; record `readlink latest` and versions from `MANIFEST.tsv` in methods).
- **R8** — The post SHALL point to a Purdue Service Portal ticket for questions and database requests.
- **R9** — The post SHALL use valid blog front-matter (allowed categories, known author `aseethar`,
  `slug`, `<!-- more -->` excerpt marker), relative page links, and content-level WCAG 2.1
  (logical heading order, table header rows, descriptive link text), and `mkdocs build --strict`
  SHALL report no new warnings or errors beyond the pre-existing baseline on `main`.

## Non-goals (no-gos)

- No permanent guide page under `docs/lifesciences/guides/` (possible follow-up).
- No dataset-catalog entry (`tools/` source → regenerate) — a follow-up after merge.
- No edits to `running-bioinformatics.md` (its `--mem=32G` is left as-is in this branch).
- No Anvil coverage (Anvil has a separate copy documented in the ACCESS-specific docs).
- No `nav:` changes (blog posts are listed by the blog plugin).
- No fix for the pre-existing broken `session-5.md` link in
  `docs/workshops/genomics_exchange/fall2026/session4/index.md` (present on `main`, unrelated).
- No claims beyond the source-of-truth facts supplied by the requester.

## Clarifications

- **Q:** Which clusters mount `/depot`? — **A:** All RCAC clusters except Anvil. Say "all RCAC
  clusters that mount /depot"; do not list clusters; do not mention Anvil. (resolved 2026-11-10)
- **Q:** Which BLAST module? — **A:** `module load biocontainers blast/2.13.0`, verified on Negishi
  to read these databases. Replace "tested with BLAST+ 2.16.0" with "works with the blast/2.13.0
  biocontainer module". (resolved 2026-11-10)
- **Q:** Does host `BLASTDB` reach the biocontainer wrapper? — **A:** Yes, verified
  (`export BLASTDB=...` then `blastdbcmd -db core_nt -info` works). Keep `export BLASTDB`; keep the
  `ncbi/blast` warning as its own section. (resolved 2026-11-10)
- **Q:** `--mem`? — **A:** Omit. Do not touch `running-bioinformatics.md` here. (resolved 2026-11-10)
- **Q:** Example resources? — **A:** Keep 32 cores / 12:00:00, commented as illustrative (scale to
  query size). (resolved 2026-11-10)
- **Q:** Date and author? — **A:** Merge date; author `aseethar`. Drafted with today's date
  (2026-11-10); `date.created` must be updated to the merge date at publish. (resolved 2026-11-10)
- **Q:** Ticket link? — **A:** The generic RCAC form from `docs/datasets/index.md`. (resolved 2026-11-10)
- **Q:** Placement? — **A:** Blog post only. (resolved 2026-11-10)
- **Q:** Tags? — **A:** Put `Life Sciences` first. (resolved 2026-11-10)
- **Q:** blastp parameters? — **A:** `-evalue 1e-5` and `stitle` are fine. (resolved 2026-11-10)

## Related materials

- Gold-standard blog post: `docs/blog/posts/uv_manager.md`.
- Job-script conventions: `docs/lifesciences/guides/running-bioinformatics.md`.
- Link targets: `docs/lifesciences/guides/{running-bioinformatics,hpc-orientation,reproducibility}.md`,
  `docs/datasets/index.md`.
