# Research 03 — The tool landscape (Part A)

- **Cycle:** workflow-automation · **Step:** PLAN research · **Date:** 2026-11-22
- **Serves:** R2 (landing page), R3 (job arrays, Make, Parallel), R4 (Snakemake, Nextflow,
  Pegasus, Parsl), R5 (HTCondor, Dask, Ray), R15 (accuracy of availability statements).
- **Provenance legend used below:** **[catalog]** = read from the generated catalog pages in
  this repository on 2026-11-22; **[live]** = checked on a login node on 2026-11-22 (Anvil and
  Gautschi only); **[guide]** = stated in an existing page of this site; **[web]** = verified on
  the cited public page on 2026-11-22; **[confirm]** = not verified, needs a live check before
  publish.

---

## 1. Framing: dimensions and argument structure

Sources: `docs/alternatives.rst` in the HyperShell repository ("How HyperShell Compares",
develop branch), and the HyperShell website draft's page of the same name, which carries the
same structure and argument (the website draft is a near-verbatim Markdown port of the docs
page; nothing structural differs). Both are written from HyperShell's side. The section must
borrow the *shape* of the argument, not its text, and must tone the advocacy down to a
site-docs register.

### 1.1 Dimensions the sources use

The sources name two axes explicitly and two more implicitly. GOAL R2(b) asks for four, which
map onto them cleanly:

| R2(b) dimension | What the sources say (paraphrased) | Values |
|---|---|---|
| **Definition vs execution** | Implicit. Some tools *define* work and hand it to something else to run (Pegasus is a planner/compiler that runs nothing itself; Snakemake and Nextflow define a graph and submit jobs through executors); others *execute* a list they are given (Parallel, bundlers, HyperShell). The sources lean on this most in the Pegasus and Nextflow sections ("compose HyperShell *under* a workflow manager"). | definer · executor · both |
| **Interface: how work is described** | Explicit axis 1. A shell command line meets users where their shell script already is; a rule file or DSL and an embedded API both ask the user to restate work inside the tool's model. | shell command · rule-file DSL · programming API |
| **Control plane: what coordinates and remembers it** | Explicit axis 2, plus an orthogonal note that *state* runs from none, to a log file, to a queryable database. | single process · server + workers + persisted state · DAG engine · standing pool manager / pilot system |
| **Flat vs DAG** | The "Dependencies" column of the sources' summary table, and the core thesis. HyperShell's task groups sit between: ordered phases (all of group N before group N+1), not a graph. | flat · ordered phases · full DAG (static or dynamic) |

Two further columns in the sources' table are useful for the landing page's comparison table
but are not R2 requirements: **standing infrastructure** (none / a self-contained server / a
daemon pool / a hosted service) and **elasticity** (fixed to one allocation vs workers that
join and leave).

### 1.2 Argument structure to borrow

1. **Name the anti-pattern first.** One scheduler job per task floods the queue, runs into
   per-user submit limits, and leaves no record of task outcomes beyond accounting and output
   files. Job arrays soften it but stay coarse. Every reader compares against the scheduler,
   so start there (the sources open with "The Baseline: the batch scheduler itself").
2. **Classify before comparing.** "Workflow tool" is used loosely; sort tools by *kind* on the
   axes before saying which is better.
3. **The thesis: most many-task work is flat.** Parameter sweeps, per-file conversions,
   ensembles: no dependency graph worth the name. For that work a DAG engine, a DSL, or a
   programming API is cost without benefit. Choosing the simplest tool that fits is a
   deliberate engineering judgement, not a lack of sophistication (R2(d)).
4. **Credit each alternative where it genuinely wins**, and say where it is operating in a
   different regime rather than competing.
5. **Own HyperShell's trade-offs**: no full DAG engine (task groups cover staged pipelines);
   no data-locality management (relies on the shared filesystem); a single server as the
   coordination point, mitigated by database-persisted state.
6. **Composition over competition**: for a real graph, let a workflow manager own the graph
   and let a flat executor run the wide steps.
7. **Close with "where it fits"** and an at-a-glance table.

Things in the sources the section should **not** carry over: scaling-test numbers and
throughput claims (not RCAC-verified for this cycle), the HyperQueue / Balsam / FireWorks /
Merlin / RADICAL / TaskVine / Flux / OSPool detail (outside the roster; at most a passing
mention per the GOAL's non-goals), the Globus Compute composition code, any statement about a
HyperShell Nextflow executor (GOAL non-goal), and the security/pickle discussion.

---

## 2. Per-tool briefs

Each brief: what it is · how work is described · what coordinates/remembers it · flat or DAG ·
where it genuinely wins · (R3 tools) where it stops serving and HyperShell takes over ·
official docs.

### 2.1 Slurm job arrays (the baseline, R3)

- **What:** a native Slurm feature: one `sbatch --array=...` submission creates many array
  tasks that share a script and differ only in `SLURM_ARRAY_TASK_ID`.
- **Described by:** a job script plus an index range (`0-31`, lists `1,3,5`, steps `1-7:2`,
  and a concurrency cap `%N`, e.g. `0-15%4`) [web]. The script maps the index to its input,
  usually `sed -n "${SLURM_ARRAY_TASK_ID}p" list.txt` (the pattern this site already uses).
- **Coordinates/remembers:** the Slurm controller. Record = accounting (`sacct`) and the
  user's own output files (`slurm-%A_%a.out`).
- **Flat or DAG:** flat; coarse chaining via `--dependency` between whole arrays.
- **Wins:** zero extra software; every RCAC user already has it; right for tens to a few
  hundred tasks of uniform shape and length, each worth a scheduler entry; per-element
  `scancel`; natural per-task resource isolation and accounting.
- **Stops serving:** each element is still a scheduler job, so arrays count against per-user
  limits (Slurm's docs: array tasks count against limits such as MaxJobs/MaxSubmitJobs [web]),
  are bounded by the site's `MaxArraySize`, pay queue wait and node-startup cost per element,
  make heterogeneous per-task resources awkward, and give no queryable per-task catalog.
  Finding and resubmitting only the failed indices is manual. A failed element leaves a
  dependent job pending with `DependencyNeverSatisfied`, silently [guide:
  `docs/lifesciences/guides/script-to-pipeline.md`]. **HyperShell takes over** when tasks
  are many (thousands+), short relative to queue wait, or need a rerun-only-the-failures
  record: one allocation, many tasks inside it, a database of outcomes, `--restart`.
- **Docs:** <https://slurm.schedmd.com/job_array.html> [web].

### 2.2 GNU Make (R3)

- **What:** the classic build tool: "controls the generation of executables and other
  non-source files" from sources [web]; used in science as a file-driven pipeline runner.
- **Described by:** a Makefile of rules: target, prerequisites, recipe (shell commands);
  pattern rules for many files.
- **Coordinates/remembers:** a single process; state = file timestamps on disk (rebuild what
  is out of date). Parallelism: `make -j N` on one node.
- **Flat or DAG:** a file-level DAG (static).
- **Wins:** ubiquitous (part of the OS toolchain, no module needed [confirm]); incremental
  rebuilds by timestamp; ideal for a small, file-shaped pipeline on one node; the conceptual
  ancestor of Snakemake (the Life Sciences Nextflow guide already frames Make, Snakemake, and
  Nextflow as the three common managers [guide: `docs/lifesciences/guides/nextflow-gautschi.md`]).
- **Stops serving:** single node (`-j` is local); timestamps are the only state, with no record
  of exit codes, timing, or retries; awkward for "the same command over 100,000 inputs" (you
  generate rules or targets); no multi-node scale-out. **HyperShell takes over** for the wide,
  flat step: Make (or a shell script) can *generate* the task list and HyperShell runs it
  across nodes with a durable record; or Make stays as the outer driver for a handful of
  ordered stages, each a HyperShell run.
- **Docs:** <https://www.gnu.org/software/make/> (manual at `/software/make/manual/`) [web].

### 2.3 GNU Parallel (R3)

- **What:** a single Perl program that runs shell commands in parallel, on one machine or
  over SSH to several; the closest tool to HyperShell in feel.
- **Described by:** shell commands from stdin or arguments, with rich input expansion
  (replacement strings such as `{}`, `{.}`, `{/}`, `{#}`; Cartesian products via `:::`).
- **Coordinates/remembers:** a single controller process that pushes jobs; optional flat
  `--joblog` file enabling `--resume` / `--retry-failed` across reruns.
- **Flat or DAG:** flat.
- **Wins:** zero infrastructure; superb on one node or a few known hosts; richer input
  templating and output ordering than HyperShell aims for; already a module on most RCAC
  clusters [catalog]; the right reach inside a single-node job for a few thousand quick
  commands. NERSC's workflow guidance points flat high-throughput work at tools like it.
- **Stops serving:** one controller per run, no server that workers connect to, no database or
  cross-run queryable catalog, no tags, no elastic pool; multi-node use means SSH host lists
  inside a Slurm allocation, which is fragile. **HyperShell takes over** when work spans
  many nodes or several allocations, when the record must outlive the job (which task
  failed, how long each took, rerun only those), or when workers should come and go.
- **Docs:** <https://www.gnu.org/software/parallel/> (gnu.org rate-limited automated fetches at
  research time; URL is the project's canonical home, also linked from the HyperShell docs)
  [web, partial].

### 2.4 Snakemake (R4)

- **What:** a Python-based workflow system for "reproducible and scalable data analyses",
  running on servers, clusters, grids, and clouds [web]; current release 9.27.2 at research
  time [web].
- **Described by:** a Snakefile (a Python superset) of rules with input/output file patterns
  and `{wildcards}`; the graph is inferred by matching outputs to inputs.
- **Coordinates/remembers:** a single driver process (a DAG engine) that submits jobs through
  executor plugins; state = filesystem plus the `.snakemake/` directory.
- **Flat or DAG:** file-driven DAG.
- **Wins:** genuine dependency graphs over files; Make-like reruns of only what is out of
  date; per-rule conda/container environments; a large bioinformatics user base; a
  plugin catalog of executors (Slurm, generic cluster, cloud batch) since Snakemake 8.0 [web].
- **Docs:** <https://snakemake.readthedocs.io/> [web]; plugin catalog
  <https://snakemake.github.io/snakemake-plugin-catalog/> [web].

### 2.5 Nextflow (R4)

- **What:** a dataflow workflow engine on the JVM.
- **Described by:** a Groovy-based DSL (DSL2): processes connected by channels.
- **Coordinates/remembers:** a JVM head process (DAG/dataflow engine); state = the `work/`
  directory and a cache enabling `-resume`.
- **Flat or DAG:** dataflow DAG.
- **Wins:** portable, containerised, reproducible pipelines; the nf-core community catalog of
  production pipelines (the strongest "existing ecosystem" case on the roster); executor
  abstraction across schedulers and clouds. Already documented on this site under Life
  Sciences (`docs/lifesciences/guides/nextflow.md`, `docs/lifesciences/guides/nextflow-gautschi.md`)
  with an institutional Gautschi profile; R4 requires cross-linking, not duplicating.
- **Caveat worth stating:** grid executors (Slurm among them) submit each task as its own
  scheduler job and poll it [web: executor page]; the Life Sciences guide already tunes
  `queueSize` and `submitRateLimit` to be kind to the scheduler [guide]. The process
  reference lists an `array` directive ("submit tasks as job arrays, for executors that
  support it") [web]; its introducing version was not shown on the page [confirm if used].
- **Docs:** <https://www.nextflow.io/> ; reference docs now live at
  <https://docs.seqera.io/nextflow/> (the old `nextflow.io/docs/latest/...` URLs redirect
  there) [web].

### 2.6 Pegasus (R4; in depth in §5)

- **What:** the Pegasus Workflow Management System (USC/ISI): a workflow *planner*. It maps an
  abstract, resource-independent workflow onto an executable DAG for a specific site and hands
  that to HTCondor DAGMan to run; Pegasus itself executes nothing. Current docs: 5.1.3 [web].
- **Described by:** a Python API (`Workflow`, `Job`, `File`) plus replica, transformation, and
  site catalogs; `pegasus-plan` compiles and submits.
- **Coordinates/remembers:** HTCondor (schedd + DAGMan) underneath; provenance and monitoring
  in a database populated by Pegasus' monitoring daemon.
- **Flat or DAG:** DAG with data flow.
- **Wins:** automatic data management (planner inserts stage-in, transfer, registration, and
  cleanup jobs, with integrity checks); workflow reduction (skip jobs whose outputs exist);
  job clustering; rescue-DAG fault tolerance; deep provenance; multi-site workflows. Flagship
  use includes LIGO.
- **Docs:** <https://pegasus.isi.edu/documentation/> [web].

### 2.7 Parsl (R4)

- **What:** "extends parallelism in Python beyond a single computer" [web]; University of
  Chicago / Argonne.
- **Described by:** a Python driver program with decorated functions (`@python_app`,
  `@bash_app`); futures passed between apps create dependencies.
- **Coordinates/remembers:** the driver process plus executors (e.g. the
  HighThroughputExecutor) whose providers request Slurm blocks; state is in-process, with an
  optional SQLite monitoring database.
- **Flat or DAG:** implicit dynamic DAG from data flow.
- **Wins:** Python-native workflows whose structure is computed at run time; portability
  across schedulers and clouds through its provider/launcher abstraction; heterogeneous
  multi-resource workflows; pairs with Globus Compute for reaching remote resources.
- **Cost for flat work:** a Python driver and a per-site executor/provider/block
  configuration to write and tune.
- **Install:** `python3 -m pip install parsl`, or `conda install parsl` from conda-forge [web].
- **Docs:** <https://parsl.readthedocs.io/> [web].

### 2.8 HyperShell (entry to Part B)

- **What:** a cross-platform, high-throughput utility for running shell commands over a
  distributed, asynchronous queue (catalog description) [catalog]; built and supported at RCAC.
- **Described by:** shell command lines from a file or stdin, with `{}` templating and tags.
- **Coordinates/remembers:** a server with elastic clients; a SQL database (SQLite or
  PostgreSQL) holding every task's state, exit status, and timing; or `hsx` / `hs cluster`
  running server and clients together in one job.
- **Flat or DAG:** flat, with task groups giving ordered phases (2.9.0; see Part B research
  for minimum versions).
- **Wins:** the shell-command front door of Parallel with a persistent, queryable record;
  `--restart` reruns only unfinished or failed tasks; scales from one node to many and across
  allocations; no DSL, no API required, no standing daemon pool.
- **Honest limits:** no general DAG; no data-locality management; one server process is the
  coordination point (mitigated by persisted state).
- **Docs:** <https://hypershell.readthedocs.io> (GOAL related materials).

### 2.9 Brief tools (R5)

- **HTCondor** — a distributed high-throughput computing system: a standing pool of daemons
  that matches jobs to machines (ClassAds), with DAGMan for workflows and `htcondor annex` /
  "bring your own resources" for adding HPC or cloud capacity [web]. A reader chooses it when
  working within an HTCondor pool (OSPool, a campus pool) or through a service built on it
  (Pegasus). Not installed on Anvil's login node [live]; RCAC does not operate an HTCondor pool
  per anything found in this repository. Docs: <https://htcondor.readthedocs.io/> [web].
- **Dask** — "a Python library for parallel and distributed computing" [web]: lazy task graphs,
  futures, and parallel arrays/dataframes executed by a distributed scheduler with in-memory
  data passing. Choose it to scale NumPy/pandas-style analysis past one node; Dask-Jobqueue
  deploys it on Slurm [web]. Docs: <https://docs.dask.org/> [web].
- **Ray** — "an open source framework to build and scale your ML and Python applications" [web]:
  remote tasks, stateful actors, and a shared object store, with ML libraries (Tune, Train,
  Serve, RLlib). Choose it for tightly coupled, stateful distributed Python (hyperparameter
  search, RL, distributed training). Running on Slurm is a community-supported guide
  (`sbatch` + `srun` starting Ray across the allocation) [web:
  <https://docs.ray.io/en/latest/cluster/vms/user-guides/community/slurm.html>]. Docs:
  <https://docs.ray.io/> [web].

### 2.10 Placement on the dimensions (landing-page table candidate)

| Tool | Defines or executes | How work is described | What coordinates and remembers it | Flat or DAG |
|---|---|---|---|---|
| Slurm job arrays | Executes (the scheduler) | Job script + index range | Slurm controller; accounting + output files | Flat (whole-array dependencies) |
| GNU Make | Both, one node | Rule file (Makefile) | Single process; file timestamps | File DAG |
| GNU Parallel | Executes | Shell command | Single process; optional job log file | Flat |
| HyperShell | Executes | Shell command | Server + clients; SQL database | Flat + ordered task groups |
| Snakemake | Defines (submits via executors) | Rule-file DSL (Python superset) | DAG engine (single driver); filesystem + `.snakemake/` | File DAG |
| Nextflow | Defines (submits via executors) | DSL (Groovy DSL2) | DAG/dataflow engine (JVM); `work/` + resume cache | Dataflow DAG |
| Pegasus | Defines (plans; HTCondor executes) | Programming API + catalogs | Planner over HTCondor DAGMan; provenance database | DAG with data flow |
| Parsl | Both | Programming API (Python) | Driver + executor pilots; in-process (optional monitor DB) | Implicit dynamic DAG |
| HTCondor | Executes | Submit file (+ DAGMan file) | Standing pool manager (daemons) | Flat + DAGMan |
| Dask | Both | Programming API (Python) | DAG engine (scheduler + workers), in memory | Dynamic DAG |
| Ray | Both | Programming API (Python) | Head node + workers; in-memory object store | Dynamic DAG |

Accessibility (R14): a header row, no colour-only meaning; values are words.

---

## 3. RCAC availability per tool per cluster

Catalog source: `docs/software/apps_md/*.md` and `docs/software/workflow_catalog.md` (generated;
read-only). Live source: login-node checks on 2026-11-22 for Anvil and Gautschi only.

| Tool | Anvil | Gautschi | Negishi | Gilbreth | Scholar |
|---|---|---|---|---|---|
| **HyperShell** (`hypershell`) | 2.0.2–2.7.0 (D 2.7.0) [catalog, live] | develop, 2.5.2, 2.6.5, 2.7.0 (D) [catalog, live] | 2.0.2–2.7.0 (D 2.7.0) [catalog] | 2.5.2 (D) [catalog] | 2.7.0 (D) [catalog] |
| **Nextflow** (`nextflow`) | 22.10.1 [catalog]; 21.10.0 and 22.10.1 [live] | 24.04.3, 25.10.04, 26.04.2 [catalog, live] | 22.10.1, 23.04.1, 25.10.04, 26.04.2 [catalog] | none in catalog | none in catalog |
| **nf-core tools** (`nf-core`) | 2.7.2, 2.8 [catalog] | none in catalog | 2.7.2, 2.8, 2.11.1 [catalog] | none | none |
| **GNU Parallel** (`parallel`) | 20200822 [catalog, live] | 20241022 (D) [catalog] | 20220522 [catalog] | 20241022 [catalog] | none in catalog |
| **Snakemake** | `snakemake/6.8.0` [live]; no catalog page | not found in catalog [confirm] | not in catalog; a Life Sciences tutorial loads it via `ml biocontainers; ml snakemake` [guide: `docs/lifesciences/tutorials/braker.md`, cluster not stated] | [confirm] | [confirm] |
| **GNU Make** | OS-provided, not a module [confirm] | same [confirm] | same [confirm] | same [confirm] | same [confirm] |
| **Slurm job arrays** | yes (Slurm) | yes | yes | yes | yes |
| **Pegasus WMS** | not as a module; no `pegasus-plan` or `condor_submit` on the login node [live]; available through the Anvil Notebook Service (see §5) [web, guide] | no; `cadence/pegasus/*` is Cadence's EDA tool, not Pegasus WMS [live] | none in catalog | none in catalog | none in catalog |
| **HTCondor** | not on the login node PATH [live] | none in catalog | none | none | none |
| **Parsl / Dask / Ray** | no module; user-space install | same | same | same | same |

Notes:

- **Anvil Nextflow discrepancy:** the catalog lists only 22.10.1; the live check also found
  21.10.0. Any page naming versions should follow `module spider nextflow` and avoid pinning.
- **Snakemake on Anvil:** the live module name `snakemake/6.8.0` has no catalog page, and the
  Life Sciences tutorial reaches Snakemake through the `biocontainers` module tree. 6.8.0 also
  predates Snakemake 8's executor plugins, so any Snakemake-on-Slurm guidance must say
  "install a current Snakemake in user space" or be version-neutral. **[confirm]** on which
  clusters `module spider snakemake` (with and without `biocontainers`) resolves.
- **Parsl, Dask, Ray: what the site supports.** No catalog module for any of the three. The
  site's supported route for Python packages is user-space environments: the `conda` module
  (Miniforge; catalog versions on all five clusters) and the `uv` module (0.7.0 and 0.8.0 on
  all five clusters [catalog]); the site's published module guidance says `conda` replaces the
  `anaconda` module for new environments [guide: `docs/snippets/agentic-ai/anvil/agents.d/lmod.md`]. So the pages should say: install with
  `pip`/`uv` into a project environment, or `conda install` from conda-forge, inside a `conda`
  or `uv` environment. Parsl documents both pip and conda-forge installs [web].
- **Bell:** no `BELL` column in any catalog page, no `docs/userguides/bell/`, and no nav
  entry; the only traces are stale example output in `docs/snippets/monitoring_job.md` and
  `docs/snippets/examples/slurm/mpi.md`, and a line in `docs/lifesciences/guides/nextflow.md`
  saying the Negishi steps "work on Bell". The GOAL's tab list (Anvil, Bell, Gautschi,
  Negishi, Gilbreth, Scholar) should **drop Bell unless a live check finds a Bell cluster
  carrying HyperShell**. Recommend: tabs for Anvil, Gautschi, Negishi, Gilbreth, Scholar.
- **Gilbreth HyperShell is 2.5.2 only** [catalog], far below the 2.9.0 the guide documents;
  the GOAL's admonition on module updates covers this, but the landing page should not imply
  feature parity across clusters.

**Needs live confirmation (validation envelope):**

1. `module spider snakemake` on Gautschi, Negishi, Gilbreth, Scholar (and whether it lives
   under `biocontainers`).
2. `module spider parallel` on Scholar (catalog shows none).
3. `module spider nextflow` on Gilbreth and Scholar (catalog shows none).
4. `which make` on each cluster (expected OS-provided).
5. `module spider pegasus` / `which pegasus-plan condor_submit` on Negishi, Gilbreth, Scholar.
6. Whether any Bell cluster exists and carries `hypershell`.
7. `scontrol show config | grep -E 'MaxArraySize|MaxJobCount'` and
   `sacctmgr show qos format=Name,MaxSubmitPU,MaxJobsPU` on each cluster (see §4).

---

## 4. Slurm job arrays at RCAC

**What the site already says.** No cluster user guide under `docs/userguides/*/run_jobs/` has a
job-array page or states an array limit. Array examples on this site live in:

- `docs/workshops/hpc_exchange/week4/workload-management.md` — "Slurm Job Arrays" section,
  `#SBATCH --array=1-30`, `SLURM_ARRAY_TASK_ID`.
- `docs/lifesciences/guides/productivity-tips.md` §14 — `--array=1-24`, `--array=1-100%20`
  ("be nice to the queue"), `scancel <jobid>_<taskid>`, `sed -n "${SLURM_ARRAY_TASK_ID}p"`.
- `docs/lifesciences/guides/sra-download.md` — `--array=1-10%5`.
- `docs/lifesciences/guides/script-to-pipeline.md` — arrays chained with
  `--dependency=afterok`, and the silent `DependencyNeverSatisfied` failure mode.

**Stated limits found (per-partition, not array-specific):**

- **Anvil** (`docs/userguides/anvil/jobs.md`, queue table): "Max Running Jobs per User" and
  "Max Running + Submitted Jobs" per partition, e.g. `debug` 1 / 2, `wholenode` 64 / 2500,
  `wide` 5 / 10, `highmem` 2 / 4; `shared` limited to 1280 cores; GPU partitions capped by GPUs
  in use (12 per user, 32 per allocation). Because Slurm counts array tasks against
  submit/job limits [web: Slurm job-array page], an array on Anvil's `wholenode` partition is
  bounded by the 2500 running+submitted figure *in addition to* `MaxArraySize`. (Anvil's
  table does not state a limit for `shared`, the default partition, beyond cores.)
- **Negishi** (`docs/userguides/negishi/run_jobs/queues.md`): `highmem` — 2 running, 8
  submitted; `gpu` — 2 GPUs, 8 submitted.
- **Gautschi** (`docs/userguides/gautschi/run_jobs/queues.md`): explains limits through QOS, with
  only a toy example ("no single user can have more than 200 jobs"), which is illustrative,
  not a real limit; the AI partition's limits changed 2026-11-02 (links RCAC news 7941).
- **Scholar** (`docs/userguides/scholar/run_jobs/queues.md`): `debug` QOS — one running job;
  `normal` 4 h, `long` 3 days walltime.
- **Gilbreth:** no per-user job-count limits stated.

**Not stated anywhere in the repository:** `MaxArraySize`, `MaxJobCount`, or a per-user
`MaxSubmitJobs` for any cluster. Slurm's default `MaxArraySize` is 1001 (indices 0–1000), with a
maximum supported value of 4000001 [web]; RCAC's configured values are **unknown** and must be
read live with `scontrol show config` before the page quotes any number. Recommendation: the
job-array page should show how to *check* (`scontrol show config | grep MaxArraySize`,
`sacctmgr show qos ... format=Name,MaxSubmitPU`) rather than print numbers, unless the
validation step reads them and the page dates them.

Slurm syntax to document (all [web], <https://slurm.schedmd.com/job_array.html>): `--array=0-31`,
lists, steps `1-7:2`, throttle `%N`; `SLURM_ARRAY_JOB_ID`, `SLURM_ARRAY_TASK_ID`,
`SLURM_ARRAY_TASK_COUNT`, `SLURM_ARRAY_TASK_MIN`/`MAX`; `%A`/`%a` in output names (default
`slurm-%A_%a.out`); `squeue -r` to expand elements.

---

## 5. Pegasus in depth (resolves R4)

### 5(a) No cluster-side Pegasus WMS

- **Anvil:** no Pegasus WMS module, and no `pegasus-plan` or `condor_submit` on the login
  node's PATH [live, 2026-11-22].
- **Gautschi:** `cadence/pegasus/*` modules are Cadence's EDA tool (physical verification),
  **not** the Pegasus workflow system [live]. The pages must not cite them.
- **Negishi, Gilbreth, Scholar:** no `pegasus` page in the generated catalog; not checked
  live [catalog; confirm].

### 5(b) Hosted routes to Pegasus that reach Anvil (web-verified)

There are **two distinct hosted routes**, and the R4 wording should keep them apart.

**Route 1 — Pegasus in the Anvil Notebook Service (Purdue-operated, Anvil-native).**

- RCAC news, 2026-03-10, "Scientific workflow management system, Pegasus, available on
  Anvil" (<https://www.rcac.purdue.edu/news/7628>) [web]: Pegasus is deployed on Anvil
  through the Anvil Notebook Service (browser-based Jupyter on Anvil); the environment bundles
  Pegasus, HTCondor for workflow execution management, and preconfigured integration with
  Anvil's Slurm scheduler; users develop and debug workflows with the Pegasus Python API or
  command-line tools, submit under their Anvil allocations, and monitor from the notebook; no
  user installation or configuration is required. Anvil access comes through ACCESS or NAIRR
  allocations.
- ACCESS documentation, "Pegasus Workflows"
  (<https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/564887553/Pegasus+Workflows>)
  [web] lists three hosted Pegasus environments; one is **Purdue Anvil**: "a JupyterLab
  environment running on Anvil's composable partition", submitting directly to Slurm with
  access to Anvil file systems, "available to all Anvil users via Anvil Notebooks"
  (<https://notebook.anvilcloud.rcac.purdue.edu/>).
- This site already has a stub: `docs/userguides/anvil/notebook.md` → "## Pegasus on Anvil",
  one line linking the ACCESS page above [guide]. Who can use the Notebook Service: "any ACCESS
  researcher with an allocation on the Anvil resource"; log in with ACCESS credentials and
  choose an allocation [guide].
- A web search snippet (attributed to a former RCAC knowledge-base page, now 404) described
  the steps as: log in to the Notebook Service with ACCESS credentials, select the *Pegasus
  Notebook* environment, choose an Anvil allocation. **Unverified** on a live page; the exact
  environment name in the Notebook Service launcher needs a live look before the docs name it.

**Route 2 — ACCESS Pegasus (ISI-operated, multi-site, HTCondor Annex).**

- ACCESS documentation, "ACCESS Pegasus"
  (<https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/1372291083/ACCESS+Pegasus>)
  [web]: log in at <https://pegasus.access-ci.org> with ACCESS credentials; example workflows
  run as Jupyter notebooks (`ACCESS-Pegasus-Examples/` in the user's home); tutorial notebooks
  run on a small bundled resource with **no allocation needed**; real workflows need the user's
  own allocation; compute is added with **HTCondor Annex**, which sends pilot jobs (glideins)
  to ACCESS HPC clusters under the user's allocation, each pilot running only that user's jobs.
  Other resource types listed: TestPool, Cloud, OSPool, Manual Glideins.
- Pegasus blog, 2022-09-28, "ACCESS Pegasus – Hosted workflow environment"
  (<https://pegasus.isi.edu/2022/09/28/access-pegasus/>) [web]: hosted environment = Open
  OnDemand interface + Jupyter + HTCondor Annex; available to all ACCESS users.
- ACCESS documentation, "HTCondor Annex"
  (<https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/564887666>) [web]:
  resource table lists **Purdue Anvil** (nickname `anvil`, queue tested `standard`) alongside
  PSC Bridges-2 (`RM`) and SDSC Expanse (`compute`); states "You have to have an allocation at
  the resource provider you want to use"; setup is: find your Anvil username in the ACCESS
  profile's "Resource Provider Site Usernames" table, confirm the allocation, generate a
  dedicated SSH key on the ACCESS Pegasus host, and map hosts/usernames to it in
  `~/.ssh/config`. (Search snippets showed an example of the form
  `htcondor annex create ... --project <project> $USER standard@anvil`; the exact command was
  in a truncated part of the page and is **not** verified verbatim. Do not print it.)

**Who can use them, and what an Anvil user needs:**

| Route | Operator | Who | What an Anvil user needs |
|---|---|---|---|
| Anvil Notebook Service, Pegasus environment | RCAC (Anvil) | Any ACCESS researcher with an Anvil allocation | ACCESS credentials and an active Anvil allocation; nothing to install |
| ACCESS Pegasus + HTCondor Annex to Anvil | Pegasus team (ISI), ACCESS | All ACCESS users (tutorials need no allocation) | ACCESS credentials; an Anvil allocation and site username; a dedicated SSH key set up for the annex |

**Purdue-only (non-ACCESS) community-cluster users** (Gautschi, Negishi, Gilbreth, Scholar)
have **no verified route** to Pegasus: neither route serves those clusters, and no cluster-side
install exists. Say so plainly.

### 5(c) Reconciling `docs/hubzero/tools/developers/grid/pegasuswf.md`

- **What it describes:** for HUBzero *tool developers*, the hub's `submit` command can run a
  workflow through Pegasus, either one `submit` generates from a parameter sweep or one the
  developer builds (`submit pegasus-plan --dax ...`), with venues chosen by `submit`; the
  hub's `use` command puts Pegasus on the PATH. The page carries its own caveats: `submit` is
  separate software not in that repository, unverified against code, and the `--dax` syntax
  belongs to old Pegasus releases. Upstream source modified 2012.
- **Applies to RCAC cluster users?** **No.** It is a HUBzero hub feature for building science
  gateway tools, executed through the hub's submit venues, not something an Anvil, Gautschi, or
  Negishi user runs from a login node. It is historical prior art.
- **Link plan:** do **not** link it from the Pegasus coverage as a "how to use Pegasus at
  RCAC" route. At most, one clause noting that HUBzero tool developers have a separate
  hub-side Pegasus integration, linked to `../hubzero/tools/developers/grid/pegasuswf.md` (path
  relative to the new section; planner to compute), and only if the planner wants
  completeness. Recommended: omit, or one parenthetical.

### 5(d) Recommended R4 wording (verified facts only)

> Pegasus is a workflow planner from USC's Information Sciences Institute. You describe an
> abstract workflow with its Python API; Pegasus plans it onto a site and runs it through
> HTCondor's DAGMan, adding data staging, cleanup, retries, and provenance along the way. It
> is not installed as a module on RCAC's community clusters. Anvil users can use it through
> the [Anvil Notebook Service](link to `../userguides/anvil/notebook.md`), where a Pegasus
> environment with HTCondor and Slurm integration is ready to use under your Anvil
> allocation. ACCESS users can also use [ACCESS Pegasus](https://pegasus.access-ci.org), a
> hosted Jupyter environment that sends pilot jobs to ACCESS resources, Anvil among them,
> through HTCondor Annex; that route needs your own allocation on the target resource.

Link plan: link the site's own Anvil Notebook page (internal, survives URL churn); link the
RCAC news item (2026-03-10) for the announcement; link the ACCESS "Pegasus Workflows" page as
the external authority listing both environments; link `https://pegasus.access-ci.org` for
ACCESS Pegasus; link `https://pegasus.isi.edu/documentation/` for the tool. Avoid printing the
`htcondor annex create` command (not verified verbatim). Optional follow-up outside this cycle:
the one-line "Pegasus on Anvil" stub in `docs/userguides/anvil/notebook.md` could carry the
news item's facts; that edit is outside this cycle's section and is the planner's call
(it is a per-cluster guide, so check invariants §10 before touching it).

---

## 6. Composition: a workflow manager over a lower-level executor (general terms only)

- **Nextflow** separates *what* a pipeline computes from *where* it runs: an **executor**
  (`local` by default; grid executors such as `slurm` submit each task as a scheduler job;
  cloud batch executors) is selected in configuration without touching the pipeline [web:
  <https://docs.seqera.io/nextflow/executor>]. Nextflow **plugins** can define custom executors
  usable with the `executor` directive [web:
  <https://docs.seqera.io/nextflow/plugins/developing-plugins>].
- **Snakemake** (8.0+) does the same with **executor plugins** from its plugin catalog (Slurm,
  generic cluster, Kubernetes, cloud batch) [web].
- **The general pattern to describe (R4 "MAY"):** the workflow manager owns the graph,
  containers, and caching; a lower-level executor owns *how tasks are placed*. Today a reader
  can compose them without any special integration: (1) a single wide, flat step in a
  Snakemake rule or Nextflow process can be one task that runs `hsx` over a generated task
  file inside one allocation, instead of fanning out into thousands of scheduler jobs; or (2)
  run the workflow manager's `local` executor inside a large allocation and let it fill the
  cores. Either avoids the one-job-per-task pattern at scale.
- **Do not** mention, hint at, or name any HyperShell executor or plugin for Nextflow
  (GOAL non-goal: an unreleased prototype). The HyperShell docs page's paragraph about
  HyperShell being "well-positioned" as a Nextflow executor backend must not be paraphrased.

---

## Recommendations for PLAN

**Page vs section per tool.**

- **Landing page** (hub, `docs/lifesciences/index.md` archetype): why (anti-pattern), the four
  dimensions, the §2.10 table, the flat-work thesis, the HyperShell recommendation, a "which
  tool?" short decision list, and links to every tool page and to the guide. The R5 trio
  (HTCondor, Dask, Ray) can live **on the landing page** as three short paragraphs under
  "Other tools you may meet", satisfying "brief paragraph, no full page".
- **One page each for R3:** Slurm job arrays, GNU Make, GNU Parallel. Each has a small example
  and an explicit "when to move to HyperShell" section; this is where R3's comparison is
  graded. Job arrays page also carries the "check your limits" commands (§4).
- **R4:** one page per tool (Snakemake, Nextflow, Pegasus, Parsl) or one "Workflow managers"
  page with four H2 sections. Recommendation: **one page each** for Nextflow (mostly
  cross-links to Life Sciences plus the composition note) and Pegasus (the two hosted routes
  need room); **Snakemake and Parsl may share a page or be short pages**. Planner's call; the
  nav hub must link each either way (R1).
- **HyperShell:** its landing-page row links into Part B; no separate "tool page" beyond the
  guide's own landing page.

**Honest "where it wins" lines (one sentence each, landing-page ready):**

- **Job arrays:** nothing to install, and right for tens to hundreds of uniform tasks that each
  deserve their own scheduler entry.
- **GNU Make:** incremental, file-driven rebuilds of a small pipeline on one node.
- **GNU Parallel:** instant, zero-setup parallelism on one node, with the richest input
  templating of any tool here.
- **Snakemake:** true file-dependency graphs with per-rule software environments and
  rerun-only-what-changed.
- **Nextflow:** containerised, portable pipelines and the nf-core catalog of ready-made
  community pipelines.
- **Pegasus:** data-heavy DAGs where the planner handles staging, cleanup, provenance, and
  multi-site placement for you.
- **Parsl:** workflows written as ordinary Python whose structure is decided at run time.
- **HTCondor / Dask / Ray:** respectively, working within an HTCondor pool; scaling
  array/dataframe analysis in Python; stateful distributed Python and ML.
- **HyperShell:** a flat list of commands of any size, with a database of what ran and how it
  ended, and reruns of only what failed.

**Availability wording:** never pin versions on landing or tool pages; say "load with
`module load <name>`; check versions with `module spider <name>`". State Pegasus as "not a
module; available on Anvil through the Anvil Notebook Service and ACCESS Pegasus". State
Parsl/Dask/Ray as "install in your own `conda` or `uv` environment". Mark Snakemake's module
status only after the §3 live checks.

**Cluster tabs (Part B):** drop Bell unless live-confirmed; five tabs (Anvil, Gautschi,
Negishi, Gilbreth, Scholar).

**Workshop cross-link:** `docs/workshops/hpc_exchange/week4/workload-management.md` ends its
"Pilot Job Paradigm" section naming HTCondor and HyperShell; a one-line "see also" to the new
section is a cheap win if the planner wants it (no rewrite, per non-goal).
