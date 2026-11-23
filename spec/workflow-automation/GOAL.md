# GOAL — Workflow Automation: choosing a tool, and a tiered HyperShell user guide

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** workflow-automation
- **kind:** feature
- **appetite:** big  ·  *one new section in two parts (a tool landscape and a tiered user guide);
  expect `docs-plan` to draft it in ordered phases and to scope-hammer nice-to-haves against this
  contract. The size circuit-breaker was considered and resolved as one cycle (see Clarifications).*

## Problem

Researchers on RCAC clusters routinely need to run thousands to millions of small, mostly
independent tasks: parameter sweeps, per-file conversions, ensembles of simulations, per-sample
pipelines. The naive approach (one Slurm job per task) floods the scheduler, hits per-user
submission limits, and leaves no queryable record of what ran and how it ended. Workflow
automation tools exist precisely to fix this, but `docs.rcac.purdue.edu` has no real treatment of
them. HyperShell, the tool RCAC builds and supports, appears only as a generated catalog stub
(`docs/software/apps_md/hypershell.md`), a module listing on several clusters' software pages, and
one paragraph in the HPC Exchange workshop (`docs/workshops/hpc_exchange/week4/workload-management.md`).
Nextflow has guides, but only under Life Sciences. There is no page that explains why these tools
matter, what separates one from another, or which one to reach for.

The result is that users either fall back on job-per-task submission or adopt a heavyweight
workflow engine for work that is really a flat list of commands, paying a conceptual and
operational cost for structure they never needed. Readers who do find HyperShell have nothing past
the catalog stub to tell them how to run it well, from a single Slurm job up to a persistent,
multi-cluster service.

## Outcome / vision

A new **Workflow Automation** section under RCAC Resources, in two parts.

**Part A, the landscape.** A landing page explains why workflow tools are necessary and the
dimensions that separate them: what a tool *defines* versus what *executes* the work; how you
describe the work (a shell command, a rule-file DSL, or a programming API); what coordinates and
remembers it (a single process, a server with workers and persisted state, a DAG engine, or a pool
manager); and whether the work is a flat list of tasks or a dependency graph. It argues, in
big-picture terms, that intentional simplicity is a sophisticated choice: most many-task work is
flat, and a DAG engine or programming API buys nothing for it. It recommends HyperShell as the
primary supported solution at Purdue, while saying honestly where each other tool wins. Coverage
spans Slurm job arrays (the baseline), GNU Make, GNU Parallel, Snakemake, Nextflow, Pegasus, Parsl,
and HyperShell, with brief notes on HTCondor, Dask, and Ray.

**Part B, the HyperShell user guide.** The section's deepest subsection: a guide in tiers of
escalating sophistication, using domain-science scenarios (climate, genomics, VFX rendering,
astronomy). Most readers stop at tier 1 with a single job script that covers most needs; later
tiers cover extreme scale, a pipeline with its own database and configuration run entirely
on-cluster, and a capstone composable system with a persistent server and database on Geddes fed
by an autoscaling relay on a login node. A page or section on GPU multiplexing shows how to run
many smaller tasks on large GPUs.

After reading, a researcher can decide whether they need a workflow tool at all, pick the right
kind for their work, and run HyperShell at the level of sophistication their work demands.

## Acceptance criteria (the contract)

Reader-facing, observable outcomes. Stable IDs survive squash-merge. R-IDs are grouped per tier
and per tool family by design (see Clarifications).

**Section and landing page (Part A)**

- **R1** — A **Workflow Automation** section SHALL appear under RCAC Resources in `mkdocs.yml`
  `nav:`, with a hub page that links to every tool page or section and to the HyperShell user
  guide, and the guide SHALL appear as the section's deepest subsection.
- **R2** — WHEN a reader opens the landing page, it SHALL (a) explain why workflow tools are
  necessary, naming the job-per-task anti-pattern; (b) explain the dimensions that separate tools:
  definition versus execution, how work is described (shell command, rule-file DSL, programming
  API), what coordinates and remembers it (single process, server with workers and persisted
  state, DAG engine, pool manager), and flat tasks versus dependency graphs; (c) place every
  rostered tool on those dimensions; (d) argue that intentional simplicity is a deliberate,
  sophisticated choice for flat work; and (e) recommend HyperShell as the primary supported
  solution at Purdue.

**Tool coverage (Part A; page versus section is the planner's call)**

- **R3** — Slurm job arrays (as the baseline every reader compares against), GNU Make, and GNU
  Parallel SHALL each be covered with what the tool is, the work it fits, where it wins over
  HyperShell, and where it stops serving and HyperShell takes over.
- **R4** — Snakemake, Nextflow, Pegasus, and Parsl SHALL each be covered with what the tool is,
  how it describes work, and where it genuinely wins (for example, true dependency graphs or an
  existing community pipeline ecosystem). The Nextflow coverage SHALL cross-link the existing Life
  Sciences Nextflow guides rather than duplicate or move them, and MAY describe composing a
  workflow manager over HyperShell in general terms. Any statement about a tool's availability on
  an RCAC cluster SHALL reflect what plan research verified.
- **R5** — HTCondor, Dask, and Ray SHALL each receive a brief paragraph stating what kind of tool
  it is and when a reader would choose it, without a full page.

**HyperShell user guide (Part B)**

- **R6** — The guide SHALL present its tiers in order of escalating sophistication, and each tier
  SHALL state who it is for and when a reader should move on to the next. Its worked scenarios
  SHALL draw on domain-science use cases (climate, genomics, VFX rendering, astronomy). Each page
  SHALL state the minimum HyperShell version any feature it uses requires.
- **R7** — **Tier 1, the canonical single job.** WHEN a reader opens tier 1, it SHALL give a
  complete, copy-pasteable Slurm job script that runs `hsx` over a task file on one or more nodes
  with `--restart`, explain how a rerun picks up only unfinished or failed work, show how to check
  which tasks succeeded or failed, and state that this one job script addresses most needs.
- **R8** — **Tier 2, extreme scale.** Tier 2 SHALL describe the additional HyperShell options and
  practices that serve very large runs, SHALL state that Purdue workloads rarely need them, and
  SHALL be written so that it also serves as guidance for running HyperShell at leadership-class
  facilities.
- **R9** — **Tier 3, separation of concerns on-cluster.** Tier 3 SHALL show a pipeline with an
  intentional database and persistent configuration; one or more distinct `hs submit` phases run
  on a login node; and a helper script that schedules client jobs as desired. Where zones or task
  groups are introduced, the tier SHALL explain what each does and when to use it.
- **R10** — **Tier 4, the capstone composable system on Geddes.** Building on and linking the
  existing Geddes database guide, tier 4 SHALL give step-by-step instructions through the Rancher
  web interface to deploy a persistent HyperShell server and a TimescaleDB database in one pod,
  stating how credentials are stored, how data persists across pod restarts, and what network
  exposure the server needs. It SHALL also give a minimum viable autoscaling script, using the
  HyperShell relay, that runs on login00 and schedules clients for one or more clusters, and it
  SHALL show zones and task groups working together as a total solution.
- **R11** — The guide SHALL include a page or section, placed where the planner judges best, that
  shows how to run many smaller tasks concurrently on large GPUs (GPU multiplexing).

**HyperShell command conventions**

- **R12** — Every HyperShell example in the section SHALL use only top-level commands (`hs submit`,
  `hs list`, `hs info`, `hs wait`, `hs run`, `hs update`, `hs server`, `hs client`, `hs cluster` or
  `hsx`, `hs relay`, `hs config`, `hs initdb`) and SHALL NOT use any `hs task …` subcommand form.
  No example SHALL pass the queue key on a command line (no `-k`); examples SHALL supply it through
  `HYPERSHELL_SERVER_AUTH` or the `server.auth` configuration setting.

**Build, accessibility, accuracy (hammerable: false — never trimmed to fit appetite)**

- **R13** — Every new page SHALL be included in `mkdocs.yml` `nav:`, carry the front-matter of its
  archetype, use relative page-to-page links and absolute asset paths, and render any literal
  `{{` or `{%` safely; `mkdocs build --strict` SHALL introduce no new warnings versus
  `strict-baseline.txt` and SHALL NOT fail.
- **R14** — Every content image SHALL carry meaningful `alt` text; headings SHALL descend without
  skipping, with one H1 per page; link text SHALL be descriptive; tables SHALL use header rows; and
  no meaning SHALL be conveyed by color alone (content-level WCAG 2.1).
- **R15** — Every job script and command in the section SHALL be validated before publish, and all
  HPC specifics (Slurm directives, partitions, accounts, `module load` lines, filesystem paths,
  hostnames, Rancher steps, HyperShell options and configuration keys) SHALL be correct for the
  cluster or HyperShell version they name; no invented flag, path, or option.

## Non-goals (no-gos)

- **Updating the deployed HyperShell module** on any cluster. The guide documents HyperShell 2.9.0;
  bringing the RCAC modules up to that version is a separate effort.
- **Heavy Kubernetes YAML.** The Geddes capstone is Rancher web-interface steps, not a full
  manifest.
- **Reproducing the HyperShell tutorial's literal examples.** The guide borrows the tutorial's
  tiering and kinds of domain scenarios, not its datasets, scripts, or walkthroughs.
- **Moving or rewriting Life Sciences content.** The Nextflow guides stay where they are and are
  cross-linked.
- **Generated catalog pages.** No hand-edits to `docs/software/apps_md/**`, the software catalogs
  (including the Workflow catalog), or breadcrumbs (they regenerate from the nav change through
  the normal workflow).
- **An MCP-server container for HyperShell.** Out of scope for the capstone pod; at most a
  one-line note.
- **An unreleased Nextflow executor prototype for HyperShell.** Not documented; the Nextflow
  coverage speaks of composition in general terms only.
- **Per-cluster user guide chapters.** No new workflow chapter is added to each cluster's user
  guide (invariants §10); the section is cluster-spanning.
- **Rewriting the HPC Exchange workshop material.** Whether to add a cross-link from it is the
  planner's call.
- **Full pages for HTCondor, Dask, or Ray**, and tools beyond the roster (for example Flux,
  HyperQueue, xargs) beyond a passing mention.
- **Theme, CSS, or JS changes**, or any accessibility-theme-layer edit (invariants §2).
- **A companion announcement blog post**, deferred to a possible follow-up.

## Clarifications

Resolved with the human before shaping; recorded 2026-11-22.

- **Q:** Where does the material live? — **A:** One new **Workflow Automation** section under
  RCAC Resources in `mkdocs.yml` `nav:`, holding the landing page, the tool pages, and the
  HyperShell user guide as its deepest subsection. The Life Sciences Nextflow pages are
  cross-linked, not moved. (resolved 2026-11-22)
- **Q (size circuit-breaker):** The job spans two pillars (a tool landscape and a five-part user
  guide) and more than the skill's ~8–10 criteria; split into a pilot and follow-ups? — **A:** No.
  One cycle, one branch, one draft PR. Criteria are grouped per tier and per tool family (twelve
  content R-IDs plus the three standing build, accessibility, and accuracy R-IDs), and `docs-plan`
  drafts them in ordered phases. (resolved 2026-11-22)
- **Q:** Which tools are covered? — **A:** Slurm job arrays (the baseline), GNU Make, GNU
  Parallel, Snakemake, Nextflow, Pegasus, Parsl, and HyperShell (the entry into Part B); HTCondor,
  Dask, and Ray as brief paragraphs only. Page versus section per tool is the planner's call.
  (resolved 2026-11-22)
- **Q:** What runs in the Geddes capstone pod, and where does autoscaling run? — **A:** The pod is
  a HyperShell server and a TimescaleDB database only. The relay-based autoscaling script runs on
  login00, named as such. An MCP-server container is out of scope (at most a one-line note).
  (resolved 2026-11-22)
- **Q:** Which HyperShell version does the guide document? — **A:** HyperShell 2.9.0 (relay,
  zones, groups); each page states the minimum version a feature needs. Updating the deployed RCAC
  module is a separate effort and a non-goal. (foreman default — confirm at GOAL gate, 2026-11-22)
- **Q:** Is the unreleased Nextflow executor prototype documented? — **A:** No. The Nextflow
  coverage may describe composing a workflow manager over HyperShell in general terms only.
  (foreman default — confirm at GOAL gate, 2026-11-22)
- **Q:** How are job scripts and commands validated? — **A:** Every job script and command is
  validated before publish (the HPC accuracy invariant, R15); how and where is decided at the plan
  gate. (foreman default — confirm at GOAL gate, 2026-11-22)
- **Q:** Is Pegasus available on Anvil? — **A:** Believed set up on Anvil, unverified.
  `[NEEDS CLARIFICATION: confirm Pegasus availability, version, and access route on Anvil (and any
  other cluster) during plan research; R4 states only what is verified.]` A local grep found
  Pegasus documented under HUBzero grid tools (`docs/hubzero/tools/developers/grid/pegasuswf.md`),
  which plan research should reconcile with any cluster availability.
- **Q:** RCAC modules currently top out at HyperShell 2.7.0 (generated catalog, read 2026-11-22),
  below the 2.9.0 the guide documents. How should a reader get 2.9.0 meanwhile? —
  `[NEEDS CLARIFICATION: until the modules are updated, do the pages direct readers to a
  user-space install (and by which route), or note the version gap and wait? This decides what
  tiers 1–4 tell a reader to run first.]`
- **Q:** Which clusters do the guide's job scripts and helper scripts target? —
  `[NEEDS CLARIFICATION: one primary cluster with notes for the others, or worked specifics for
  every community cluster that carries HyperShell (Anvil, Gautschi, Negishi, Gilbreth, Scholar)?
  Partitions, accounts, and module lines differ per cluster (R15).]`
- **Q:** Which host is login00 for the capstone relay? —
  `[NEEDS CLARIFICATION: login00 of which cluster (its full hostname), and from that host which
  clusters' schedulers the autoscaling script can submit clients to. Plan research may settle the
  hostname; the intended cluster set is the human's call.]`

## Related materials

- Existing HyperShell mentions: `docs/software/apps_md/hypershell.md` (generated, read-only);
  `docs/userguides/{gautschi,gilbreth,negishi,scholar}/software.md` (module listings);
  `docs/workshops/hpc_exchange/week4/workload-management.md`.
- Life Sciences Nextflow guides to cross-link: `docs/lifesciences/guides/nextflow.md`,
  `docs/lifesciences/guides/nextflow-gautschi.md`.
- Geddes capstone base: `docs/userguides/geddes/examples/database.md` (Rancher web-interface
  database deployment, the step style to mirror).
- Pegasus prior art on this site: `docs/hubzero/tools/developers/grid/pegasuswf.md`.
- HyperShell documentation: <https://hypershell.readthedocs.io>.
- HyperShell project website: the "How HyperShell Compares" page (its intro frames the
  interface and control-plane dimensions and the case for flat, simple work) and the tutorial draft
  (chapter tiering and domain scenarios only; not its literal examples).
- Gold-standard pages to mirror: `docs/lifesciences/index.md` (hub archetype);
  `docs/userguides/gautschi/run_jobs/` (Slurm job-script conventions).
- Reference sites (same MkDocs-Material lineage): docs.tacc.utexas.edu, docs.alcf.anl.gov,
  docs.ncsa.illinois.edu.
- Issue: *(none yet — create and back-link if desired).*
