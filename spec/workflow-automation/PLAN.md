# PLAN — Workflow Automation: choosing a tool, and a tiered HyperShell user guide

> **Status:** Revised after the plan gate (2026-11-22) · **Last updated:** 2026-11-22
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/)
> (digest: [`research/00-digest.md`](research/00-digest.md)). Every design element traces to a GOAL
> R-ID.

## 1. Summary

A new `docs/workflows/` section under RCAC Resources. The landing page carries the landscape
argument and places every rostered tool on four dimensions. There is one short page per rostered
tool. A HyperShell user guide (`docs/workflows/hypershell/`) is the section's deepest subsection:
a guide landing page, tiers 1–4 (tier 4 in two pages), and a GPU multiplexing page right after
tier 1. Every job script is a byte-exact file under `docs/snippets/workflows/`, assembled per
cluster in content tabs from a header file and a shared body file. The published scripts are
therefore the files the validator runs. Eight phases go scaffold-first. Each phase that carries
scripts closes only after a cluster validation run recorded in `VALIDATION.md`.

## 2. Design

### Archetypes

- **Reference / hub / landing** (style guide §E): `docs/workflows/index.md` and
  `docs/workflows/hypershell/index.md`. Grid cards, H1, short prose.
- **Tutorial / guide lesson** (style guide §D, lighter): every tool page and every tier page.
  Pedagogical, second person, progressive. Each tier page opens with *Who this is for*, *Move on
  when*, and *Minimum version*.
- **Front-matter contract (all pages in the section)**, following the Agentic AI and Profilers
  precedent (01 §front-matter):
  ```yaml
  ---
  title: <Page title>
  tags:
    - Workflows            # section tag; tool pages add the tool (e.g. Nextflow, HyperShell)
  authors:
    - <rcac-handle>        # see §5 Q9
  search:
    boost: 2
  ---
  ```
  No `hide` on any page. No `resource` variable: the section is cluster-spanning, and cluster
  variants live in tabs, not macros.

### Page structure (all new unless marked)

**Part A — `docs/workflows/`**

| File | H1 / content | R-IDs |
|---|---|---|
| `index.md` | *Workflow Automation*. Why: the job-per-task anti-pattern (scheduler load, submit limits, no record of outcomes). The four dimensions (definition vs execution; how work is described: shell command, rule-file DSL, programming API; what coordinates and remembers it: single process, server + workers + persisted state, DAG engine, pool manager; flat vs DAG), as prose plus one placement table with a header row covering all 11 tools. The case for intentional simplicity in flat work. The recommendation of HyperShell as RCAC's primary supported tool, stated alongside where each other tool wins. A short "Which tool?" decision list. *Other tools you may meet*: one paragraph each for HTCondor, Dask and Ray. Grid cards linking every tool page and the guide. A closing line to the Workflow catalog. | R1, R2, R5 |
| `job_arrays.md` | *Slurm Job Arrays*. What they are, `--array` with `%N` throttling, `SLURM_ARRAY_TASK_ID`, one minimal worked array script (tabs), how to check limits (`scontrol show config`, `sacctmgr show qos`) without printing numbers, where arrays win, where they stop (thousands of short tasks, no outcome record, reruns by hand) and HyperShell takes over. | R3 |
| `gnu_make.md` | *GNU Make*. What it is, file-driven incremental rebuilds, `make -j` inside one job, where it wins, where it stops (one node, no record, no multi-node). | R3 |
| `gnu_parallel.md` | *GNU Parallel*. What it is, its templating, one in-job example, where it wins (zero-setup single-node parallelism), where it stops (one node, ad-hoc resume via joblog, no shared record). Availability: not on Scholar. | R3 |
| `snakemake.md` | *Snakemake*. Rule-file DSL, file-dependency DAGs, per-rule environments, where it wins. Availability: Anvil `snakemake` module (6.8.0, predates executor plugins) and Biocontainers; or a user environment. Composition in general terms (executor plugins). | R4 |
| `nextflow.md` | *Nextflow*. Dataflow DSL, containerised portable pipelines, nf-core. Cross-links to `../lifesciences/guides/nextflow.md` and `nextflow-gautschi.md` without duplicating them. Availability per catalog (not Gilbreth or Scholar). Composition over a lower-level executor in general terms only; no mention of any unreleased executor. | R4 |
| `pegasus.md` | *Pegasus*. Planner over abstract DAGs (staging, cleanup, provenance, multi-site). No cluster module. Two verified hosted routes to Anvil: Pegasus in the Anvil Notebook Service (link `../userguides/anvil/notebook.md` and RCAC news 7628), and ACCESS Pegasus (`pegasus.access-ci.org`) through HTCondor Annex with an Anvil allocation. States that Purdue community clusters have no verified route. No link to the HUBzero `pegasuswf.md` page, which serves hub tool developers. | R4 |
| `parsl.md` | *Parsl*. Python-native parallel scripting with a Slurm provider; workflows decided at run time; install in your own `conda` or `uv` environment (no module). | R4 |

**Part B — `docs/workflows/hypershell/`**

| File | H1 / content | Scenario | R-IDs |
|---|---|---|---|
| `index.md` | *HyperShell User Guide*. What HyperShell is (one paragraph). The **version admonition** (see below). The tier map table (tier, who it's for, features, move on when). `module load hypershell` (unpinned) and `hs --version`. Key handling via `HYPERSHELL_SERVER_AUTH` or `server.auth`, never on a command line. Concepts in brief: task file, server, clients, database. Cards to every tier page. | — | R1, R6, R12 |
| `single_job.md` | *Tier 1: One Job Script*. A complete per-cluster tabbed script running `hsx frames.txt --restart` with a stable `HYPERSHELL_SITE` for the campaign, one node or several (`--launcher=srun`, one client per node, `-N` executors per client). Resubmitting after the walltime runs out picks up only unfinished work. Inspecting outcomes with `hs list --failed`, `hs list --completed`, `hs info`. Re-running failures: `hs update --failed --revert`, then resubmit, or `-r` retries during the run. States that this one script covers most needs. | VFX: render an animation frame by frame (stand-in renderer) | R6, R7, R12 |
| `gpu_multiplexing.md` | *Running Many Small Tasks on Large GPUs*. One node, n GPUs, k executors per GPU (`-N n×k`); a small POSIX `gpu-pick` wrapper choosing a device by `TASK_SLOT`; measure k with `nvidia-smi` and `hs info` timings; caveats (GPU memory × k, host cores and memory, time-slicing vs MPS vs MIG). MPS and Scholar MIG variants appear only if live checks pass (otherwise one sentence each). Tabs: Gautschi, Anvil, Gilbreth, Scholar; Negishi (AMD) only if the ROCm variant validates. | Climate: hyperparameter sweep of small ML emulators | R6, R11, R12 |
| `extreme_scale.md` | *Tier 2: Extreme Scale*. Bundling (`-b`, `-w`), executors and clients per node, `--no-confirm`, `--no-db` trade-offs, staggered starts (`--delay-start=-N`), task timeouts, logging volume, per-task files avoided, a quick throughput measurement. States that Purdue workloads rarely need this. Written so the advice holds at leadership-class facilities (site launchers, `mpiexec`/`srun`, filesystem etiquette). | Climate: a perturbed-parameter ensemble of 10⁶+ short tasks | R6, R8, R12 |
| `pipelines.md` | *Tier 3: A Pipeline on One Cluster*. A persistent configuration set once with `hs config` (database, server, key via `server.auth`), `hs initdb`, a long-lived `hs server --forever` on a login node (presented as the design choice of one coordination host; not moved into a batch job), phases submitted with `hs submit -g N --zone Z` from a login node, and a helper script that compares outstanding work per zone with running client jobs and `sbatch`es `hs client --zone Z -T <idle>` jobs into the matching partition. Introduces **groups** (when: phases in order; the reached-group rule) and **zones** (where: routing to `cpu` vs `highmem`), each with what it does and when to use it. Uses `TASK_SLOT`, not `{slot}`. | Genomics: a crop diversity-panel pipeline (per-sample → per-region → merge) | R6, R9, R12 |
| `geddes_service.md` | *Tier 4: A Persistent Service on Geddes*. Builds on and links the Geddes database guide. Architecture table. Rancher steps in the `database.md` style: Opaque Secrets (database password, queue key, TLS certificate and key); one Deployment with two containers (TimescaleDB, then HyperShell server with arguments `--autoscaling --initdb`); a PVC for the database; Recreate upgrade policy; a LoadBalancer Service on the private pool exposing the queue port (50001) and PostgreSQL (5432), with the DNS name to use. States how credentials are stored, how data persists across pod restarts, and what network exposure the server needs. One-line note that an MCP-server container is out of scope. At most one collapsed reference of the two container entries (about 30 lines); no Service, PVC or Secret YAML. | Astronomy: a nightly time-domain survey run as a service | R6, R10, R12 |
| `autoscaling.md` | *Tier 4: Autoscaling Clients Across Clusters*. Presents login00 as a system design choice: one host per cluster for persistent, low-CPU coordination processes (GOAL non-goal: RCAC's wider login-node guidance is not restated). Configure `login00.gautschi.rcac.purdue.edu`: one config file for `hs submit`/`hs list` (database via `password_eval`) and for the relay (`[relay]`, `[relay.upstream]` with `auth_eval` and the TLS fingerprint, zone tables with `srun` launchers). The minimum viable autoscaling script (start, keep alive, drain with `SIGUSR1`, stop), Submitting nightly work with zones and groups together (group 0 calibrate in zone `cpu` → group 1 detect in zone `gpu` → group 2 catalog in zone `cpu`). **Adding a second cluster**: the same script on `login00.negishi.rcac.purdue.edu` with its own `site` and zone tables (Negishi serves zone `cpu` only), and `autoscale.distribution` (`spread` or `fill`) deciding how the shared `cpu` zone's clients split between the clusters (§5 Q3). Operate and maintain: back up with `pg_dump`, upgrade, rotate the key. | Same survey | R6, R10, R11, R12 |

**Version admonition** (once, prominently, on `hypershell/index.md`; GOAL gate): Purdue is the
primary site of HyperShell's development, and new versions with fixes and features land often
through module updates. The guide documents HyperShell 2.9.0. Check with `hs --version`; module
versions differ by cluster. Each tier page then carries a one-line *Minimum version* note that
links back to it. Minimums: 2.9.0 for file-aware `--restart`, slots, zones and the relay; 2.8.0 for
task groups and the default SQLite database (02 §12).

**Tier 4 zones (plan gate: planner's choice).** Two zones. `cpu` is served by both relays
(Gautschi `cpu` partition, Negishi `cpu` partition). `gpu` is served by Gautschi's relay only (an
NVIDIA partition, linking the GPU multiplexing page). A zone names a capability, not a cluster, so
adding a site that offers the same capability changes no submitted task. A shared `cpu` zone is
where the server's autoscaler visibly spreads or fills clients across two clusters. Negishi's GPUs
are AMD and the guide's GPU material targets NVIDIA, so the worked `gpu` zone stays on Gautschi.
Groups order the nightly phases; zones place them.

**Snippet files (new; `docs/snippets/workflows/`, excluded from the build, included with `--8<--`):**

```
docs/snippets/workflows/
  job_arrays/{header-<cluster>.sh, body.sh}        # Part A worked array script
  frames/{header-<cluster>.sh, body.sh, render-frame.sh}       # tier 1
  gpu_sweep/{header-<cluster>.sh, body.sh, gpu-pick}           # GPU page
  ensemble/{header-<cluster>.sh, body.sh}                       # tier 2
  panel/{config.toml, submit-phases.sh, schedule-clients.sh, client-<cluster>.sh}  # tier 3
  survey/{relay.toml, run-relay.sh, submit-night.sh}            # tier 4
```

Each tab is one fenced block holding the two includes, so every tab is a complete copy-pasteable
script:

````markdown
=== "Gautschi"

    ```bash title="frames.sub"
    --8<-- "docs/snippets/workflows/frames/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/frames/body.sh"
    ```
````

Conventions: each header opens `#!/bin/bash` and `# FILENAME: <name>.sub` (style guide), holds
only `#SBATCH` lines and module lines, and uses `-A myallocation` (Scholar: `-A scholar`). Each
`body.sh` opens with the comment line `# --- same on every cluster ---`, which
is also the render sentinel. Tab labels exactly `Anvil`, `Gautschi`, `Gilbreth`, `Negishi`,
`Scholar` (alphabetical, linked site-wide). An example gets a tab only for clusters where it
applies: Gilbreth only for GPU examples, Negishi left out of NVIDIA-specific ones. Headers follow
the per-cluster table in research 06 §2, mirroring each cluster's `queues` page, not the stale
example pages.

### Navigation placement (exact)

Insert after the Profilers block and before `- RCAC Workshops:` under `- RCAC Resources:` in
`mkdocs.yml` (today lines 293/294), with the same indentation as its siblings:

```yaml
    - Workflow Automation:
      - workflows/index.md
      - Slurm Job Arrays: workflows/job_arrays.md
      - GNU Make: workflows/gnu_make.md
      - GNU Parallel: workflows/gnu_parallel.md
      - Snakemake: workflows/snakemake.md
      - Nextflow: workflows/nextflow.md
      - Pegasus: workflows/pegasus.md
      - Parsl: workflows/parsl.md
      - HyperShell User Guide:
        - workflows/hypershell/index.md
        - "Tier 1: One Job Script": workflows/hypershell/single_job.md
        - GPU Multiplexing: workflows/hypershell/gpu_multiplexing.md
        - "Tier 2: Extreme Scale": workflows/hypershell/extreme_scale.md
        - "Tier 3: A Pipeline on One Cluster": workflows/hypershell/pipelines.md
        - "Tier 4: A Persistent Service on Geddes": workflows/hypershell/geddes_service.md
        - "Tier 4: Autoscaling Across Clusters": workflows/hypershell/autoscaling.md
```

Each phase adds only its own lines. Breadcrumbs regenerate (`.venv/bin/python
tools/generate_breadcrumbs.py`) in every phase that touches nav. No change to the generated Workflow
catalog.

### Reuse

- No `main.py` macro emits Slurm headers. Cluster variance lives in snippet header files and tabs,
  not in a new macro. Adding a macro would touch `main.py` (high-impact), and tabs are what the GOAL
  gate chose.
- Gold-standard pages to mirror: `docs/lifesciences/index.md` and the Agentic AI hub (hub);
  each cluster's `run_jobs/queues.md` (headers); `docs/userguides/geddes/examples/database.md`
  (Rancher steps); `docs/faqs.md` (cluster tab labels).
- Link, don't duplicate: Life Sciences Nextflow guides; `docs/lifesciences/guides/running-bioinformatics.md#array-jobs`
  and the HPC Exchange job-array section from `job_arrays.md`; the `apps_md` catalog pages for
  hypershell, nextflow, parallel, uv; `docs/userguides/anvil/notebook.md` (Pegasus); the Geddes guide
  pages (`access.md`, `services.md`, `registry.md`, `storage.md`, `troubleshooting.md`).

### Assets

None required. The architecture of tier 4 and the tier map are tables. If the drafter adds a
diagram, it goes in `/assets/images/workflows/` with full alt text. Rancher screenshots are optional.
The Geddes database guide uses few, and screenshots taken during validation may be added with alt
text describing the form state.

### Cross-links into the section (one line each, no rewrites; within non-goals)

- `docs/lifesciences/guides/nextflow.md` after line 22 and `docs/lifesciences/guides/nextflow-gautschi.md`
  after line 55: a one-sentence "See also" to `workflows/index.md`.
- `docs/workshops/hpc_exchange/week4/workload-management.md` line 195 (end of the pilot-job
  paragraph naming HyperShell): append one sentence linking the guide.
- Not edited: cluster `software.md` pages (would touch five cluster guides for one link; §10
  parallelism), generated catalogs (§3), the home page grid (follow-up).

### Accessibility plan (R14)

One H1 per page; H2/H3 descend without skips; tier pages share the same H2 skeleton (Who this is
for · Move on when · Minimum version · …). Every table, including the placement table, tier map,
architecture and env-var tables, has a header row. Link text names its target ("the Geddes
database guide", not "here"). No color-only meaning: admonition titles carry the meaning in words,
and tab labels are text. Any image gets alt text describing its content. Code blocks carry a language
and a `title=` filename.

### Requirement → design map

| R-ID | Design element(s) that satisfy it |
|---|---|
| R1 | `Workflow Automation` nav section under RCAC Resources; `workflows/index.md` cards to all seven tool pages and the guide; `HyperShell User Guide` is the only nested subsection (deepest) |
| R2 | `workflows/index.md`: anti-pattern, four dimensions, placement table for all rostered tools, simplicity thesis, HyperShell recommendation |
| R3 | `job_arrays.md`, `gnu_make.md`, `gnu_parallel.md`, each with fit / wins / stops-serving sections |
| R4 | `snakemake.md`, `nextflow.md` (cross-links Life Sciences, composition in general terms), `pegasus.md` (verified hosted routes only), `parsl.md`; availability statements from research 03 §3 plus validation V3 |
| R5 | `workflows/index.md` *Other tools you may meet*: HTCondor, Dask, Ray paragraphs |
| R6 | Tier order in nav and tier map; *Who this is for / Move on when / Minimum version* on every tier page; scenarios VFX, climate, genomics, astronomy |
| R7 | `single_job.md` + `frames/` snippets; rerun semantics stated per research 02 §2.2 (see §5 Q2) |
| R8 | `extreme_scale.md` |
| R9 | `pipelines.md` + `panel/` snippets (config, `hs submit` phases, helper scheduling client jobs); groups and zones introduced and explained |
| R10 | `geddes_service.md` (Rancher pod, Secrets, PVC, LoadBalancer) + `autoscaling.md` (the same relay script on login00 of Gautschi and Negishi, zones + groups together) |
| R11 | `gpu_multiplexing.md` (after tier 1; linked from tiers 3 and 4) |
| R12 | Top-level commands only; key via `HYPERSHELL_SERVER_AUTH`/`server.auth`, and the relay's upstream key via `relay.upstream.auth_eval` (R12 as amended at the plan gate); P8 grep sweep |
| R13 | Nav per phase; front-matter contract above; relative links; snippets keep `{%`/`{#`/`{{` out of the Jinja pass; `--strict` gate every phase |
| R14 | Accessibility plan above; P8 sweep |
| R15 | Byte-exact snippet scripts; validation envelope (§6) with a recorded PASS per phase in `VALIDATION.md`, enforced by each phase's `verify:` |

## 3. Invariant gate (constitution check)

Walked against [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md) before
research (sane: a cross-cutting content section, no theme or generated-file work) and again after
this design.

- **§1 Branch & deploy** — work on `feature/workflow-automation`, squash PR to `main`. The draft PR
  may open at any time; the merge waits on the publish rule (§5 Q1).
- **§2 Dev-only a11y layer** — untouched. No CSS, JS or overrides.
- **§3 Generated-content firewall** — no edits to `docs/software/**`, catalogs or
  `breadcrumbs.json` beyond running the generator.
- **§4 Nav is manual** — every page added to nav in the phase that creates it; breadcrumbs regenerated.
- **§5 Links relative, assets absolute** — all page links relative (`../lifesciences/guides/nextflow.md`
  from `docs/workflows/`, `../../userguides/geddes/examples/database.md` from
  `docs/workflows/hypershell/`); no assets planned, any added are absolute.
- **§6 Front-matter** — the contract in §2; no blog post.
- **§7 Macros/Jinja** — scripts live in snippet files (spliced after the macros pass). Pages
  carry no literal `{{`, `{%` or `{#`; any inline exception is wrapped in `{% raw %}`. A draft-time
  grep enforces it.
- **§8 Build integrity** — `--strict` gate in every phase; include sentinels grepped in `site/`;
  INFO-level anchor messages grepped for new paths.
- **§9 WCAG** — §2 accessibility plan; P8 sweep.
- **§10 Per-cluster parallelism** — no per-cluster chapter is added; the section is cluster-spanning.
- **§11 HPC accuracy** — every script validated on a cluster before its phase closes (§6); headers
  mirror the `queues` pages; HyperShell options grounded in research 02.
- **§12 Commits** — `[feature] Draft workflow-automation P<n>: …`, no trailer.

### Deviation justifications

| Deviation | R-ID | Why needed | Simpler alternative rejected because |
|---|---|---|---|
| Tabs omit Bell from the GOAL-gate list | R15 (GOAL gate *Clusters*) | Bell is decommissioned; its docs were removed 2026-11-04 (PR #323). No partitions or versions to cite. | A Bell tab would be invented HPC specifics, violating §11 |
| New files under `docs/snippets/workflows/` (a high-impact path) | R7, R9, R10, R11, R15 | One byte-exact source per script: tabs get complete scripts, bodies stay out of the Jinja pass, and the validator runs the published files | Inline scripts per tab duplicate each body five times, break on `{%`/`{#`, and drift from what was validated. A new `main.py` macro is a worse high-impact edit. Accept the human review gate. |
| Per-example tab sets differ (Gilbreth only in GPU examples; Negishi out of NVIDIA-specific ones) | R15 | Gilbreth has only GPU partitions; Negishi's GPUs are AMD | Uniform tabs would print headers that cannot run |
| ~~The relay's upstream key uses `relay.upstream.auth_eval`, not `server.auth`~~ | R12 | Resolved: R12 amended at the plan gate (2026-11-22) to name the relay's own setting | — |
| Persistent low-CPU HyperShell processes on login nodes (tier 3 server, tier 4 relay), presented as a system design choice without restating RCAC login-node guidance | R9, R10 | Tier 3's `hs submit` on a login node and tier 4's relay on login00 are required by the GOAL. Login-node policy is a GOAL non-goal (plan gate, 2026-11-22). | Hosting them in batch jobs breaks tier 3's single-host database access and contradicts R10's login00 |

## 4. Rabbit holes (resolved)

- **Cluster tabs inside scripts** → one complete script per tab from header + body includes; built
  `--strict` clean in a scratch copy ([01](research/01-site-integration.md)).
- **Which clusters get tabs** → Anvil, Gautschi, Gilbreth, Negishi, Scholar; Bell retired
  ([01](research/01-site-integration.md), [06](research/06-cluster-headers-and-validation.md)).
- **Headers per cluster** → research 06 §2 table, mirrored from `queues` pages; known stale examples
  listed so the drafter avoids them ([06](research/06-cluster-headers-and-validation.md)).
- **What `--restart` re-runs** → unfinished and interrupted tasks; failures need `hs update --failed
  --revert` or `-r` ([02](research/02-hypershell-reference.md) §2.2).
- **Launcher vs `--ntasks-per-node`** → multi-node tier 1 uses `--launcher=srun` with one client
  per node: the header requests whole nodes with `--ntasks-per-node=1` and `--cpus-per-task=<cores>`,
  or the body passes `srun --ntasks-per-node=1`. The executors per client come from `-N`. The
  exact form is fixed at drafting and checked in V4
  ([06](research/06-cluster-headers-and-validation.md) §2, [02](research/02-hypershell-reference.md) §2.3).
- **Where zones and groups first appear** → tier 3; combined in tier 4 ([04](research/04-tiers-and-gpu.md)).
- **GPU multiplexing mechanism** → `TASK_SLOT`-based device pick, `-N n×k`; MPS/MIG conditional on
  live checks ([04](research/04-tiers-and-gpu.md) §4).
- **Pegasus** → no cluster module; Anvil Notebook Service and ACCESS Pegasus are the verified routes
  ([03](research/03-landscape.md) §5).
- **Geddes pod** → TimescaleDB + HyperShell server, Opaque Secrets, PVC, LoadBalancer exposing 50001
  and 5432 (because `hs submit`/`hs list` use the database) ([05](research/05-geddes-capstone.md)).
- **Second cluster** → Negishi: the same relay script on `login00.negishi`, upstream to the same
  Geddes server; zone `cpu` on both clusters, zone `gpu` on Gautschi only. Gilbreth has no login00
  (plan gate) ([05](research/05-geddes-capstone.md) §4, [02](research/02-hypershell-reference.md) §6).
- **Images** → `ghcr.io/hypershell/hypershell:<2.9.0 tag>` (no `latest`); TimescaleDB
  `2.32.1-pg17` through the Geddes Docker Hub cache ([05](research/05-geddes-capstone.md) §2).
- **Jinja hazards** → scripts in snippets; draft-time grep ([01](research/01-site-integration.md)).

## 5. Risks & open questions

Q1–Q4 were decided at the plan gate on 2026-11-22 (GOAL *Plan gate, 2026-11-22*). The rest stand
as risks with the mitigation shown.

1. **HyperShell 2.9.0 is not released, and modules stop at 2.7.0 (Gilbreth 2.5.2).** The tier 1
   script (`FILE --restart`) fails on 2.7.0. The relay, zones and slots do not exist before 2.9.0.
   **Decided (publish rule):** draft now, and validate on Gautschi's `hypershell/develop` module (it
   reports 2.9.0a8 today; record the exact `hs --version` at each validation) or a recorded `develop`
   commit. The draft PR may open at any time. The merge waits until 2.9.0 is tagged, the default
   module on Gautschi and Anvil is 2.9.0, and V4's tier 1 checks have been re-run on that module.
   P8 records the hold, and the PR body states it. *Residual risk:* `hs server --initdb` and
   environment variables for underscore keys (e.g. `auth_eval`) are broken in 2.9.0a8. If the
   `develop` module still reports a8 at V6/V7, those steps validate on a recorded `develop` commit
   instead, or wait for the module.
2. **R7 wording vs behaviour.** **Decided:** R7 amended. Tier 1 explains that a `--restart` rerun
   skips tasks that already ran, failed ones included, and shows `hs update --failed --revert`
   followed by a resubmit.
3. **Second cluster.** **Decided:** R10 held as "login00 of one or more clusters"; the same relay
   script runs on each cluster's login00. The worked pair is Gautschi and Negishi
   (`login00.negishi.rcac.purdue.edu`). Gilbreth is dropped from the capstone: it has no login00
   (front-ends `gilbreth-feNN`; `login00.gilbreth` does not resolve, checked 2026-11-22). Zones as in
   §2 (*Tier 4 zones*).
4. **Persistent processes on login nodes.** **Decided:** a GOAL non-goal. The pages present login00
   as a system design choice (one host per cluster for persistent, low-CPU coordination processes)
   and neither reconcile nor restate RCAC's wider login-node guidance. The tier 3 server stays on a
   login node.
5. **Network reachability (unverified).** Compute nodes → a login node's HyperShell port (tiers 3,
   4; Gautschi and Negishi); login00 → the Geddes LoadBalancer on 50001 and 5432 (tier 4).
   **Mitigation:** first items in V6/V7. On failure, stop and escalate to the human: the design keeps
   the tier 3 server on a login node, so a blocked port needs RCAC network help, not a redesign.
6. **Geddes vs Geddes2.** The guide's examples are Geddes-era; a Geddes2 migration section exists
   with a different registry and ingress. **Recommendation:** mirror `database.md` (Geddes) as it
   stands; the validator deploys where RCAC currently directs new workloads and records label
   differences; if that is Geddes2, the drafter adjusts registry and pool wording in a P7 amendment.
7. **Image source on Geddes.** No GHCR cache is documented. **Recommendation:** pull
   `ghcr.io/hypershell/hypershell:<tag>` directly if V7 confirms egress; otherwise document copying
   it into the user's Harbor project. Never `:latest` (it does not exist).
8. **`hyper-shell` executable in the module.** Relay site clients launch as `hyper-shell client`;
   a module that links only `hs`/`hsx` breaks the relay. **Recommendation:** a V7 check; report
   upstream to the module maintainers if missing.
9. **Page authors handle.** No `authors:` named in GOAL. **Default:** the HyperShell author's
   existing site handle (as on the Agentic AI pages) unless the human names another.
10. **SQLite on shared filesystems.** Tier 1 keeps one SQLite file per campaign on a shared path;
    tier 3's server and `hs submit` share one file from one host. **Recommendation:** V4/V6 validate
    the chosen path (scratch vs home vs depot) with WAL; pages name the validated location.
11. **PostgreSQL memory defect.** A task requesting ≥ 2 GB memory is refused and hangs on
    PostgreSQL/TimescaleDB (open upstream). **Recommendation:** tier 4 examples never use `-m`/`memory:`
    ≥ 2G; revisit if fixed in 2.9.0.
12. **Phase count is 8**, at the circuit-breaker. **Recommendation:** keep one cycle (GOAL
    resolved this). If validation stalls on tier 4 infrastructure (Q5–Q7), split P7 into a
    follow-up cycle rather than block P1–P6.
13. **One config shared across module versions.** On Gautschi, the default `hypershell/2.7.0`
    crashed on `hs --version` with `AttributeError: 'auth' has more than one variant` (raised from
    cmdkit's namespace handling) under an account whose HyperShell config may carry 2.9-era auth
    keys. The cause is unconfirmed. **Mitigation:** a V4 check (§6). If confirmed, the version
    admonition gains a one-line caution against using one HyperShell config with module versions
    from both sides of 2.9.0.

## 6. Verification strategy

**Per phase (seeds `verify:` in TECH):**

- **Build:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`.
- **Nav:** `grep -q '<page>.md' mkdocs.yml` for each page the phase adds.
- **Include sentinels:** for pages with scripts, `grep -rqF -- '--- same on every cluster ---' site/workflows/<path>/`
  (body) and `grep -rqF 'FILENAME: <name>.sub' site/workflows/<path>/` (header), so an empty
  include fails.
- **Validation record:** phases with scripts end with `grep -q '^P<n>: PASS' spec/workflow-automation/VALIDATION.md`.
- **Draft-time checks (in each phase's steps):** `grep -nE '\{\{|\{%|\{#' docs/workflows/**/*.md` shows
  nothing unescaped; the INFO lines of the build log name no anchor under `workflows/`; `.venv/bin/mkdocs serve`
  render check of tabs, admonitions and tables; front-matter per §2.
- **Accessibility:** heading order, table header rows, link text, alt text (P8 sweep).

**Validation envelope (R15).** Step agents never run anything on a cluster. The cycle's validator
(the human, or the agent running the cycle's cluster checks) executes this envelope and records one
line per phase in `spec/workflow-automation/VALIDATION.md` (`P<n>: PASS — <date>, <clusters>,
HyperShell <version/commit>`), with notes on anything that changed the draft. Account, partition
and QOS values below are placeholders the validator fills; scripts run exactly as published:
`cat header-<cluster>.sh body.sh > job.sub`.

- **Build under test (publish rule, §5 Q1).** Gautschi's `hypershell/develop` module (record the
  exact `hs --version`; 2.9.0a8 today) or a recorded `develop` commit installed in user space
  (`module load uv`, `uv tool install` from the repository or a wheel copied to the cluster). Where a
  step needs a fix made after a8 (`hs server --initdb`, underscore-key env vars) and the module
  still reports a8, that step uses the recorded commit. The Geddes image tag must match the build
  under test, and `VALIDATION.md` records it.
- **Merge hold.** The draft PR may open at any time. Before merge: 2.9.0 is tagged, the default
  module on Gautschi and Anvil is 2.9.0, and V4's tier 1 checks have been re-run on that default
  module (recorded in `VALIDATION.md` as a `P4-release: PASS` line).
- **Header check, every tab (all phases with scripts):** on each cluster's login node, `module load
  hypershell` succeeds (record `hs --version`), and `sbatch --test-only job.sub` accepts each tab's
  header with the validator's real account. This catches partition, QOS and account syntax without
  spending allocation.

| Run | Phase | Where | Size (placeholders) | What is checked |
|---|---|---|---|---|
| V2 | P2 | Gautschi `cpu`, `-q standby` | 1 node, 15 min | Job-array script runs every index with `%N` throttle; Make and Parallel snippets produce the stated outputs; `scontrol show config | grep -i MaxArraySize` and `sacctmgr show qos` commands print (values not published); `module load parallel` on Anvil, Gautschi, Negishi, Gilbreth |
| V3 | P3 | Login nodes, all five | none | `module spider nextflow`, `snakemake`, `parallel` per cluster match the pages' availability statements; any page command runs |
| V4 | P4 | Gautschi `cpu`/`standby`; Anvil `wholenode` | 2 nodes, 15 min each | Tier 1 on 1 and 2 nodes (one client per node). `scancel` mid-run, resubmit: only unfinished frames run. Planted failures appear in `hs list --failed`; `hs update --failed --revert` + resubmit runs only those. The resubmit-without-changes gate behaves as stated. The SQLite path chosen works across jobs. **Config across versions:** with a config written for 2.9.0 (including `server.auth`), load the default 2.7.0 module and run `hs --version`; record whether it fails with `'auth' has more than one variant`, then repeat with the config moved aside (§5 Q13). |
| V5 | P5 | Gautschi `ai` (or `smallgpu`); Gautschi `cpu`/`standby` | 1 node × 2 GPUs, 15 min; 2 nodes, 20 min | GPU: each task's device is one of the job's; `nvidia-smi` shows k processes per GPU for k = 1, 2, 4; no OOM at the chosen size; wall-time trend recorded. Live: compute mode, MPS availability, Scholar MIG request syntax, ROCm variable on Negishi. Tier 2: ≥10⁵ trivial tasks with default vs tuned bundling; `--no-confirm`, `--no-db` runs complete; throughput numbers only as illustrations. |
| V6 | P6 | Gautschi login node (server host) + `cpu` (and `highmem` or a stand-in zone) | ≤ 4 client jobs × 1 node, 30 min | Probe compute node → login node port first. `hs config`/`hs initdb`/`hs server --forever`; three `hs submit` phases in groups; reached-group refusal; helper script launches clients per zone; `hs list`/`hs wait` per phase. |
| V7 | P7 | Geddes namespace; `login00.gautschi.rcac.purdue.edu` (`cpu` + one GPU partition); `login00.negishi.rcac.purdue.edu` (`cpu`) | Pod; ≤ 4 client jobs per cluster, 30 min | **Manual Rancher walk-through** (cannot be machine-validated): follow `geddes_service.md` literally, screenshot each form, record label differences; Secrets as env and as volume; pod logs show TimescaleDB ready and the server listening with TLS and autoscaling. Then from login00: resolve the LoadBalancer name, open 50001 and 5432; `hs submit` across two zones and three groups; start the relay script; clients launch via `srun`; tasks finish; delete the pod (not the PVC) and confirm `hs list` still shows earlier tasks; from Negishi's login00, confirm it resolves and reaches the LoadBalancer on 50001, compute nodes there reach login00:50002, and start the same relay script; confirm `cpu`-zone clients land on both clusters under `spread` (and on the first-listed site under `fill`) and `gpu`-zone tasks run only on Gautschi; drain with `SIGUSR1`. Record image tags and both `hs --version` results. |
| — | P8 | none | — | All of P2–P7 show PASS; re-run any validation a P8 edit touches. Merge hold recorded (publish rule). |

**What cannot be machine-validated, and how it is checked instead:** Rancher UI labels and flows,
and network reachability. The V7 walk-through checks both (the validator follows the page as written
and records deviations, and the drafter amends). `docs-review` classifies these PLAUSIBLE with the
`VALIDATION.md` record as evidence. Login-node policy is a GOAL non-goal and is not validated.

---

*Backing research: [`research/00-digest.md`](research/00-digest.md).*
