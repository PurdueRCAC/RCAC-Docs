# GOAL — Scheduling recurring Globus transfers between scratch and Data Depot

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** globus-scheduled-transfers
- **kind:** feature
- **appetite:** small

## Problem

Life sciences researchers run analyses that outlast the scratch purge window. Their working data
lives on cluster scratch, which is optimised for active computation, has no backup service, and
purges any file not accessed or modified within the configured age threshold (60 days on most
clusters, 30 on Anvil and Bell). A lab three months into an assembly or annotation project can
lose everything generated so far, and scratch files are not recoverable by any means.

The site documents Globus thoroughly for **one-off** transfers — `docs/snippets/globus.md` (via the
`globus_snippet` macro) and `docs/userguides/depot/storage/transfer.md` both cover login, collection
selection, the two-pane File Manager, the Personal client, and the CLI. Nothing anywhere on the site
mentions **Globus Timers** / recurring transfers: a repo-wide search for `globus timer`,
`timer create`, `recurring transfer` and `scheduled transfer` returns zero hits. A researcher who
wants a weekly scratch-to-Depot backup has to work it out from generic Globus documentation, where
the two settings most likely to destroy their data — the delete-on-destination sync option, and the
difference between a timer *request* succeeding and the *transfer* succeeding — are not framed
against RCAC's purge behaviour.

## Outcome / vision

One Life Sciences guide that takes a researcher who has used Globus once, by hand, and gets them to
a working weekly scratch-to-Depot timer they can trust and verify. It states the working model
(master copy on Depot, compute on scratch, scheduled sync back), walks the web-app flow and the CLI
equivalent, and is explicit about the failure modes that make a scheduled transfer different from a
manual one: the delete-on-destination option turning a purge into data loss, quota exhaustion
failing at task level while the timer still looks healthy, and consent expiry stopping an
unattended timer weeks later.

This first draft is optimised for **review by Rose Wilfong** (Globus/data transfer owner at RCAC),
who presents this material to the DeWoody lab on Tuesday — readable and correctable, with unknowns
marked rather than guessed.

## Acceptance criteria (the contract)

- **R1** — The guide SHALL exist at `docs/lifesciences/guides/globus-scheduled-transfers.md`, appear
  in the `Life Sciences:` nav block of `mkdocs.yml`, and build clean under `mkdocs build --strict`.
- **R2** — The guide SHALL state why scratch is unsuitable as the only copy (purge, no backup, not
  recoverable) and what Data Depot provides instead, without restating the Depot or Globus basics
  that `docs/userguides/depot/` and the `globus_snippet` macro already cover — those SHALL be linked.
- **R3** — WHEN a reader reaches any instruction that configures a transfer, a `!!! danger`
  admonition warning against enabling *delete files on destination that do not exist on source*
  SHALL already have appeared above it on the page.
- **R4** — The guide SHALL give both the Globus web-app flow (File Manager → Transfer & Timer
  Options → Schedule Start + Repeat interval → Start) and the CLI equivalent using
  `globus timer create transfer` with `--interval` and `--recursive`.
- **R5** — The guide SHALL recommend an `mtime`-based sync level over exists-only, and say why
  (modified files re-transfer).
- **R6** — The guide SHALL state that the timer is one-way scratch → Depot, and that restoring after
  a purge is a separate manual transfer rather than a second timer.
- **R7** — WHEN a reader wants to confirm the backup is running, the guide SHALL direct them to the
  per-run task history under **Activity**, and SHALL state that a successful timer request does not
  imply a successful transfer.
- **R8** — The guide SHALL cover sizing the Depot allocation before scheduling, and SHALL link to the
  Depot user guide for purchasing rather than restating price or process.
- **R9** — The guide SHALL cover three troubleshooting cases: silent failure after weeks
  (consent/credential expiry), quota exhaustion, and Depot permission errors where the group manager
  has not granted access to all required root folders.
- **R10** — Every RCAC-specific fact the draft could not verify from the repo SHALL carry a literal
  `[NEEDS CLARIFICATION: …]` marker for Rose, rather than a plausible guess.

## Non-goals (no-gos)

- Not documenting Globus basics (login, collection search, Personal client) — link the existing
  snippet/user-guide coverage instead.
- Not documenting Depot purchasing, permissions model, or snapshot/recovery mechanics — link them.
- Not covering Fortress archival, `htar`/`hsi`, or `rsync`/`scp` as alternatives.
- Not covering Globus Flows, guest collections, or sharing with external collaborators.
- Not editing the per-cluster `docs/userguides/*/storage/globus.md` pages or the shared
  `docs/snippets/globus.md`.
- Not adding screenshots in this draft — the web-app flow is described in text, and Rose may prefer
  her own captures from the DeWoody session.
- Not publishing: no PR. Draft goes to Rose first.

## Clarifications

Resolved during shaping from the repo itself:

- **Q:** Does `main.py` or a snippet already supply any of this? — **A:** Partly. `globus_snippet`
  (→ `docs/snippets/globus.md`) supplies login, collection names, the File Manager flow, Personal
  client and CLI intro; `scratch_purge` and `scratch_space` supply purge policy and scratch paths;
  `storage_quota` supplies `myquota`. **Nothing supplies timers** — that is entirely new content
  (resolved 2026-08-27).
- **Q:** Are the RCAC collection names known? — **A:** The repo gives *"Purdue Research Computing -
  Data Depot"* for Depot, and *"{Cluster} Cluster Collection"* for a cluster's home+scratch
  (`docs/snippets/globus.md`). `docs/userguides/depot/storage/transfer.md` instead lists *"Purdue
  Research Computing - Home Directories"* for home and does not name a scratch collection. The two
  pages disagree, so the per-cluster scratch names still need Rose (resolved 2026-08-27, partial).

Unresolved — **these block `/docs-plan` and are flagged in the draft for Rose:**

- `[NEEDS CLARIFICATION: exact Purdue Globus collection name for scratch on each cluster, and for
  Data Depot — the two existing pages disagree on the home/scratch naming.]`
- `[NEEDS CLARIFICATION: are those collections GCSv5 with persistent consent? This determines
  whether an unattended timer keeps working over a multi-month project, and drives the whole
  "silent failure after weeks" troubleshooting section.]`
- `[NEEDS CLARIFICATION: anything in the Purdue web-app flow that differs from generic Globus
  documentation — label wording, option placement, or an RCAC-specific step.]`
- `[NEEDS CLARIFICATION: the brief describes Depot as "redundantly backed up across two sites", but
  docs/userguides/depot/recover/index.md states snapshots are NOT a substitute for backups and
  directs users to Fortress, while overview.md says redundant arrays in multiple campus
  datacenters. The draft uses the existing docs' wording. Rose to confirm which is correct for the
  DeWoody audience.]`

## Related materials

- Reuse: `main.py` → `globus_snippet`, `scratch_purge`, `scratch_space`, `storage_quota`;
  `docs/snippets/globus.md`, `docs/snippets/scratchpurge.md`.
- Link targets: `docs/userguides/depot/overview.md` (purchase, capacity),
  `docs/userguides/depot/storage/transfer.md` (Globus basics for Depot),
  `docs/userguides/depot/permissions/index.md` (Unix groups / root folder access),
  `docs/userguides/depot/recover/index.md` (snapshots).
- Archetype: **D** (tutorial/lesson) per `.agents/factory/style-guide.md` — `title` + `tags` +
  `search.boost: 1`, hub back-link at the foot.
- Reviewer: Rose Wilfong (Globus / data transfer, RCAC). Presenting to the DeWoody lab Tuesday.
