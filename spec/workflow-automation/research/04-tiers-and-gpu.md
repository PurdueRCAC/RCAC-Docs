# Research 04 — Tier structure, scenario design, and GPU multiplexing

> Plan research for `workflow-automation` (Part B, the HyperShell user guide). Covers R6–R11.
> Sources: the HyperShell website draft (tutorial chapters, structure only); the HyperShell
> repository `docs/` at the 2.9.0 development line; this repository's `docs/userguides/`.
> Read 2026-11-22. Nothing here was run on a cluster; every "confirm live" item is open.

## 1. The website draft's tutorial: structure, escalation, voice

Summarized in our own words. Recorded: structure and kinds of scenario only. Its datasets,
file names, scripts and commands are deliberately left out, because the GOAL non-goal forbids
reproducing them.

### Chapter order and what each one teaches

| # | Chapter (kind) | Difficulty | Feature escalation it carries |
|---|---|---|---|
| 0 | Setup | beginner | Install, confirm the version, choose a platform, run a trivial first task list, and read a self-check. |
| 1 | Climate: many files on one machine | beginner | A loop over inputs becomes a parallel run on one machine. Teaches command templates, executor count and where speedup stops, per-task capture, finding failures from the database, and file-aware resume. |
| 2 | Launchers (systems chapter, continues chapter 1's study) | intermediate | The launcher contract ("anything shaped like srun"), keeping the key in the environment, a long-lived server with clients started by hand, autoscaling, idle timeouts, and zones as labels a launcher can read. |
| 3 | Genomics: uneven tasks sized to the work | intermediate | Per-task cores, memory and timeout, packing and backfill, diagnosing a task killed for memory from the database, per-executor slots, and JSON task input. |
| 4 | VFX: a render farm | advanced | A persistent server with workers that join and leave, task groups as global barriers (and what a barrier costs), retries, resume after a crash, trials of the same work, and zones that send work to GPU or CPU hardware, with one GPU per executor. |
| 5 | Astronomy: one campaign across sites | advanced | Relays: a second site joins a running campaign, site compute stays off the upstream network, the campaign rides out an upstream outage, and stages run near their data. |

Platform appendix: a launcher index plus one short page per platform (laptop, Slurm, four
clouds). Each page says what the head node is, what the launcher is, and what a zone means
there. On Slurm, a zone means a partition or a constraint.

**Escalation axis.** Each chapter takes one dimension of control away from the default:
(1) parallelism on one machine plus the database as a record, (2) where clients run and how
many, (3) what each task needs, (4) the order of the work and which hardware runs it, persistent
service, (5) spanning sites. The draft does **not** treat scale (millions of tasks, bundling,
running without the database) as a chapter of its own.

### Kinds of domain scenario

Every chapter is framed as a real study with a single research question and public data, and
ends with a result (a figure or a table). The kinds of scenario:

- **climate:** a per-station statistic over a large set of weather-station files (identical,
  independent, short tasks);
- **genomics:** a per-sample variant-calling pipeline over clones from a long-running evolution
  experiment, with tasks whose sizes vary about tenfold;
- **VFX:** rendering open-licensed animation scenes frame by frame, then encoding and cutting
  them into a film;
- **astronomy:** reducing raw telescope exposures to calibrated images, with compute at two sites
  (a cloud region beside an archive, and a campus cluster).

### Voice and tone traits

- Second person and present tense, in short declarative sentences. The draft hedges very little
  and states mechanisms plainly ("A launcher has four jobs").
- Each chapter opens by naming the shape of the work and why the previous chapter's approach is
  no longer enough, then puts the new idea in one bold term.
- It gives a "scale ladder" (laptop, workstation, cluster rungs) with dials the reader can turn.
- Exercises carry hidden hints and solutions. Pitfall admonitions name the common error.
  Keypoints and goals list measurable evidence, and a self-check script closes each chapter.
- Platform differences go in tab-like provider blocks, and the HyperShell commands stay
  identical across them. This is the same idea as the GOAL's per-cluster content tabs.
- It plants failures on purpose so that the reader finds them from the database rather than
  from logs.

### How it says "who it is for" and "when to move on"

There is no explicit "who this is for" section. Audience shows through front-matter
(`difficulty`, `prereqs`, `question`, `summary`) and through each opening paragraph, which
describes the work that outgrows the previous chapter ("most real workloads outgrow that").
Moving on is signalled by forward pointers at the end of a section: the single-node chapter
ends by saying that spreading across nodes is the next chapter. The RCAC guide needs R6's
explicit statements, so it should make these implicit signals into a one-line "Who this is for"
and a one-line "Move on when" on every tier page. Tier 1 additionally needs the explicit claim
that this one job script covers most needs (R7).

## 2. Mapping the escalation onto the GOAL's four tiers

The draft's ladder is organized by **control dimension**. The GOAL's ladder is organized by
**operational shape**: one job, a very large job, a pipeline on the cluster, and a persistent
service. They map like this:

| GOAL tier | Draft chapters it absorbs | What tier adds beyond the draft |
|---|---|---|
| **1. Canonical single job** (R7) | Ch. 1 (templates, `-N`, capture, failures, `--restart`), plus the Slurm launcher idea from ch. 2 (multi-node via `srun` inside the job) | A full `#SBATCH` script and resume *across job submissions*: the walltime runs out, the same script is resubmitted, and only unfinished work runs. The database must live at a path that is stable across jobs. |
| **2. Extreme scale** (R8) | None (the draft has no scale chapter) | Bundling (`-b`, `-w`), `--no-db` and `--no-confirm`, staggered client start (`-d`), aggregated output instead of per-task files, launching clients with `--mpi` or `--launcher`, and practices for leadership-class facilities. |
| **3. On-cluster pipeline** (R9) | Ch. 2 (long-lived server, clients started separately), ch. 3 (per-task resources), ch. 4 (groups, zones) | Persistent configuration (`hs config`) and a database chosen on purpose. Phases submitted with `hs submit` from a login node. A helper script that `sbatch`es client jobs per zone. First introduction of zones and groups. |
| **4. Geddes capstone** (R10) | Ch. 2 (autoscaling), ch. 4 (zones and groups together), ch. 5 (relay) | A persistent server and TimescaleDB in one Rancher pod, a relay on `login00.gautschi.rcac.purdue.edu` that autoscales clients per zone, and a second cluster. |
| GPU multiplexing (R11) | Ch. 3 and ch. 4 touch per-executor slots (one GPU per executor) | k tasks per GPU (more than one executor per device), with MPS and MIG as options. |

### One fresh scenario per tier

Rules for the selection: each tier uses a different domain. No scenario reuses a draft scenario's
study, dataset or pipeline shape. Every scenario runs on **stand-in commands** (small
stdlib-Python or shell scripts that generate synthetic data and burn a controllable amount of
CPU or GPU), so validation needs no real datasets. Each stand-in should be deterministic (seeded),
so that a checksum or line count proves completeness and no-duplicates.

#### Tier 1 — VFX / scientific visualization: rendering an animation frame by frame

- **Story.** A lab renders a fly-through animation of a simulation for a talk or paper. Each
  frame is independent. The whole animation is longer than one job's walltime, so the job
  stops partway and gets resubmitted. This differs from the draft's VFX chapter: there is no farm,
  no server, no groups, no zones, and no ordering. It is one batch job over a frame list.
- **Tasks and scale.** About 2,000 to 5,000 frames, each 10 to 60 s, on one or two CPU nodes.
  A walltime chosen to be too short for the whole list makes the resubmission a planned event,
  not an accident.
- **What the reader runs.** A task file of one render command per frame. A single job script
  runs `hsx` over it with `--restart` across one or more nodes. The reader resubmits the same
  script and then queries outcomes with `hs list` (failed or succeeded counts) and
  `hs info --stderr`.
- **Features.** The `hsx` task file, templates (output named after the frame), `-N` (auto with
  `0`), `--launcher=srun` for more than one node, file-aware `--restart`, `--capture` or
  `-f`/`--failures`, `--max-retries`, `hs list --failed`, and `hs info`.
- **Why these features matter here.** Frames are embarrassingly parallel. Walltime cut-offs are
  routine for renders, so file-aware `--restart` (no double renders) is the main value. A few
  frames crash (a planted out-of-range frame or a deliberate non-zero exit), which gives the
  reader something to find from the database.
- **Stand-in.** A stdlib-Python "renderer" that computes one frame of a procedural image (for
  example a fractal zoom, where the frame number sets the zoom) and writes a small PPM. Cost is
  tunable by resolution and iteration count, and output is deterministic, so checksums prove
  completeness.
- **Validate on a cluster.** `python3` is present on compute nodes without a module (or name the
  module). The job script works on one node and on two nodes (`--launcher=srun` in a multi-node
  allocation). A deliberately short walltime, then resubmission, shows that only unfinished
  frames ran (`hs list` shows each frame exactly once). Check that the database path survives
  across jobs and works on the chosen filesystem. Open question: SQLite on Lustre scratch versus
  home or depot. The draft's Slurm page keys `HYPERSHELL_SITE` to the job ID, which would
  **defeat** cross-job resume, so tier 1 must not copy that pattern.

#### Tier 2 — Climate: a very large perturbed-parameter ensemble

- **Story.** A climate group runs a cheap model (a box model or a statistical-downscaling
  kernel) across a huge parameter space: millions of members or point-years, each lasting
  about a second. This differs from the draft's climate chapter, which has hundreds of identical
  file tasks on one machine. Here the problem is task *count* and per-task overhead, not files.
- **Tasks and scale.** 10⁶ to 10⁷ tasks of about 0.5 to 2 s. At Purdue, many nodes for a few
  hours. At a leadership facility, hundreds to thousands of nodes.
- **What the reader runs.** A generated (or streamed) task list, one job across many nodes
  with clients launched by `srun` or `--mpi`, with bundling tuned. A comparison run with
  `--no-db` shows the trade-off between throughput and record-keeping. Output is aggregated
  (results written to standard output or node-local `/tmp` and gathered at the end), not
  millions of small files on a parallel filesystem.
- **Features.** `-b/--bundlesize`, `-w/--bundlewait`, `--no-db`, `--no-confirm`,
  `-d/--delay-start` (with a leading `-` for random stagger), `--mpi` or `--launcher`,
  `-o/-e/-f` outputs, task-file chunking across jobs, and log-level control. R8 also needs a
  "rarely needed at Purdue" statement and leadership-class practices: compute nodes often cannot
  reach login nodes or the internet, so the server runs inside the job; clients start through the
  site launcher (`srun`, `mpiexec`); per-task files on the shared filesystem are avoided; very
  long runs are split into several jobs, each over its own chunk.
- **Why these features matter here.** At about one second per task, scheduling round trips and
  database writes rival the work itself. Bundling and dropping confirmations recover throughput.
  The database becomes a choice rather than a default.
- **Stand-in.** A deterministic one-line model (seeded arithmetic in Python or `awk`) that prints
  a result line per member. Interpreter start-up cost is realistic for tiny tasks.
- **Validate on a cluster.** Run about 10⁶ trivial tasks on 4 to 8 nodes (CPU partition,
  standby QOS where offered) and record throughput with the database and with `--no-db`.
  Confirm that `--mpi` and `--launcher=srun` both start one client per node under each tabbed
  cluster's Slurm. Confirm that `-d=-…` staggering behaves as documented. Nothing about
  leadership-class facilities can be validated here, so word those notes as general practice and
  cite only public facility docs (the reference sites the GOAL lists).

#### Tier 3 — Genomics: a crop diversity-panel pipeline in phases

- **Story.** A plant-genomics group genotypes a diversity panel (several hundred inbred lines of
  a crop) as sequencing batches arrive. Per-sample work (QC, then alignment) runs as batches
  land. When all samples are in, joint genotyping runs **per genome region across all
  samples**, a differently shaped and memory-heavy phase, followed by a merge-and-filter step.
  This differs from the draft's genomics chapter, which runs one per-clone task with resource
  sizing. Here the lesson is phases, a different task shape per phase, and routing to hardware.
- **Tasks and scale.** About 300 to 500 samples × 2 steps in group 0, about 100 to 200 regions in
  group 1, and one merge in group 2. Minutes per task. It runs over days, with clients that come
  and go.
- **What the reader runs.** A configuration file set once with `hs config` (the database, server
  address, and key via `server.auth`). A long-lived server. `hs submit` from a login node for
  each sample batch (group 0), then for the region phase (group 1, zone `highmem`), then the
  merge (group 2). A helper script that looks at outstanding work and `sbatch`es `hs client`
  jobs into the right partition per zone.
- **Features.** `hs config`, `hs initdb`, `hs server --forever`, `hs submit` with `-g`/group
  directives and `--zone`, `hs client --zone` in client jobs, `hs list` and `hs wait` for phase
  status, and `hs update` to cancel or revert. The reached-group rule matters: a submission
  below the reached group is refused. So all sample batches must land before group 1 starts,
  and that is a teaching point in its own right.
- **Why these features matter here.** The phases have different shapes and hardware needs.
  Submission is spread over days, so the database has to outlive any one job. A helper script
  keeps client jobs matched to the queue, instead of leaving one giant allocation idle while a
  group drains.
- **Zones and groups are introduced here (R9).** Groups order the phases (per-sample → per-region
  → merge). Zones send the region phase to high-memory nodes (Gautschi `highmem` or Negishi
  `highmem`) and the per-sample phase to `cpu`.
- **Stand-in.** A seeded synthetic-reads generator (random bases, size per sample varied on
  purpose). "QC" counts bases and GC with `awk`. "Align" hashes chunks and sleeps in proportion
  to size. "Genotype region" reads every sample's chunk for that region and holds a configurable
  amount of memory (so the highmem routing is visible). "Merge" concatenates.
- **Validate on a cluster.** Find out whether a long-running `hs server` on a login node is
  acceptable under RCAC login-node policy. The only site text found is "No heavy compute on
  login nodes" (`docs/snippets/agentic-ai/gautschi/agents.d/policies.md:27`). If not, the server
  runs in a long, small job instead. Confirm that compute nodes can reach the server's port on a
  login node (firewall). Confirm Gautschi's highmem rule that a job must use more than 48 cores
  (`docs/userguides/gautschi/run_jobs/queues.md`, Highmem section), which shapes the helper
  script's client size. Confirm that zone names can match partition names. Confirm that the
  reached-group refusal shows as documented.

#### Tier 4 — Astronomy: a nightly time-domain survey run as a service

- **Story.** A group follows a time-domain survey for weeks. Every night a new batch of
  exposures arrives and runs through image subtraction, source detection, a small ML classifier
  on GPU, and a nightly catalog merge. The server and database live on Geddes for the whole
  campaign. A relay on `login00.gautschi.rcac.purdue.edu` autoscales clients per zone, and a
  second cluster joins for extra CPU capacity. This differs from the draft's astronomy chapter,
  which is one reduction across a cloud archive site and a campus site, focused on outages and
  data locality. Here the lesson is a standing service with nightly cadence, autoscaling per zone,
  and time-series history in TimescaleDB.
- **Tasks and scale.** About 500 to 2,000 exposures a night × 3 stages, plus 1 merge per night,
  over many nights. Minutes per task, with GPU classification tasks of seconds to a minute.
- **What the reader runs.** The Rancher steps (server and TimescaleDB pod), then a relay
  configuration with per-zone tables (`[relay.zone.cpu]`, `[relay.zone.<gpu zone>]` with its own
  launcher and `min`/`max`/`init`), then a nightly `hs submit` of that night's stages, then
  `hs list` and `hs wait` against the remote server.
- **Features.** Zones per hardware (`cpu`, a GPU zone, and the second cluster's site), groups
  numbered per night (for example night *k* uses groups 3k, 3k+1, 3k+2) so that nights stay
  ordered under the global-barrier semantics, `{zone}` substituted into a per-zone launcher,
  `HYPERSHELL_ZONE` in the launched environment, `hs server --autoscaling` with relay sites, and
  TimescaleDB queries over weeks of task history.
- **Why these features matter here.** The work never "finishes" (`--forever`), so autoscaling
  per zone keeps idle allocations at zero between nights. Zones keep GPU hours for the
  classifier only, and groups keep each night's stages in order.
- **Stand-in.** A seeded synthetic "exposure" generator (an array of numbers with planted point
  sources), a subtraction against a template, threshold detection, and a GPU stand-in for the
  classifier (the same small CUDA program as the GPU page, below). The merge concatenates.
- **Validate on a cluster.** The relay launcher form from login00 (for example
  `srun --partition={zone} …` with account, QOS and GPU flags), since `srun` from a login node
  creates its own allocation and blocks until the client exits, as the launcher contract needs.
  Network exposure from login00 to the Geddes service. The second cluster and how its scheduler
  is reached from login00 (a GOAL plan question). GPU-zone partition and limits.

#### Spread of domains

Tier 1 VFX, tier 2 climate, tier 3 genomics, tier 4 astronomy. The GPU page (below) uses a
**climate ML-emulator hyperparameter sweep**, a second climate use, chosen because small-model
sweeps are the textbook GPU multiplexing workload. If a fifth domain is wanted, a genomics
alternative is many small GPU inference batches (for example basecalling chunks).

## 3. "Who it's for" and "Move on when" one-liners

| Tier | Who it's for | Move on when |
|---|---|---|
| 1 | Anyone with a list of independent commands, from hundreds to hundreds of thousands, that fits in one Slurm job (or a few resubmissions of it). That covers most readers. | You need phases that run in order, different hardware per phase, submissions spread over days, or more tasks than one job's throughput can drain. |
| GPU page | Tier 1 readers whose tasks each use a fraction of a large GPU (small models, short inference, small renders). | Each task saturates a GPU on its own. Then use one GPU per executor (tier 1 as written), or a distributed-training guide. |
| 2 | Readers with millions of tasks of seconds each, or anyone running HyperShell at a leadership-class facility. Rarely needed at Purdue. | Throughput is fine with defaults (go back to tier 1), or your problem is structure rather than scale (tier 3). |
| 3 | Groups whose work has distinct phases, varied hardware needs, and a life longer than any one job, kept entirely on one cluster. | The pipeline should run as a standing service, survive login-node and job boundaries without a person present, scale itself, or span clusters. |
| 4 | Labs running a long campaign or shared service: persistent server and database, autoscaled clients, more than one cluster. | This is the top tier. Further growth (more sites, more zones) reuses the same pieces. |

## 4. GPU multiplexing (R11)

### (a) What the HyperShell docs say (2.9.0)

- **Executor slots.** Each client runs `N` executors (`-N/--num-threads`), and each owns a fixed
  zero-based slot `0..N-1` for its lifetime. The template patterns `{slot}` and `{slot_count}`
  and the task environment variables `TASK_SLOT` and `TASK_SLOT_COUNT` expose it "so a task can
  claim a non-overlapping share of the node's cores, memory, or GPUs". The documented GPU example
  is one GPU per executor, `CUDA_VISIBLE_DEVICES={slot}`. **New in 2.9.0** (`docs/_include/templates.rst`,
  Execution Slot; `docs/getting_started.rst`, "Pin resources per task slot", `versionadded:: 2.9.0`).
- **Important limit.** `{slot}` and `{slot_count}` are resolved when the *client* expands the
  template (the normal line-input path). They are **not available when the template is expanded
  at submit time**, which covers `--from-json` and the `hs submit` command. There the docs say to
  use `TASK_SLOT` and `TASK_SLOT_COUNT`, which are always defined (`docs/_include/templates.rst`).
  Consequence: tier 3 and tier 4 (phases fed by `hs submit`) must use the environment variables,
  not `{slot}`. A small wrapper script that reads `TASK_SLOT` works in every tier.
- **Other task environment.** `TASK_ID`, `TASK_ARGS`, `TASK_SUBMIT_TIME` and others are listed
  in `docs/getting_started.rst`. Any `HYPERSHELL_EXPORT_<NAME>` variable is injected into each
  task as `<NAME>`. Tasks run through `/bin/sh` (the client starts them with `shell=True`, in the
  repository's `src/hypershell/client.py`), so POSIX shell arithmetic works in a template, but
  bash arrays do not.
- **No GPU resource accounting.** The client's resource-aware scheduling tracks **host** cores
  and memory only: `-c/--cores`, `-m/--memory`, `-C/--client-cores`, `-M/--client-memory`, and
  `#HYPERSHELL: cores:… memory:…` (`docs/_include/cluster_help.rst`, `docs/_include/client_help.rst`).
  There is no GPU or GPU-memory resource. GPU concurrency is governed only by how many executors
  a client runs and how the slots map to devices. The guide must not suggest `-m` models GPU
  memory.
- **Zones.** `--zone` on `hsx`, `hs submit` and `hs client` is new in 2.9.0 (`docs/cli/cluster.rst`,
  `docs/cli/client.rst`). A relay can give a GPU zone its own launcher and bounds in a
  `[relay.zone.NAME]` table, and `{zone}` in a launcher is replaced by the zone name, with
  `HYPERSHELL_ZONE` set in the launched process (`docs/cli/relay.rst`, Topology). This is how
  tier 4 routes GPU tasks, and the GPU page's pattern runs inside those GPU-zone clients
  unchanged.
- **Logging note.** "One client per rank (e.g. under `srun` with one client per GPU) is
  expected" (`docs/logging.rst`). That is an alternative layout: one client per GPU, each with
  `-N k`.
- The online docs at https://hypershell.readthedocs.io mirror the repository `docs/`. MPS and MIG
  are mentioned nowhere in the HyperShell docs.

### (b) Generic mechanisms, and what the RCAC site states

Three ways to put k tasks on one GPU:

1. **Several processes per GPU by device selection (time-slicing).** Give each executor a device
   by `TASK_SLOT mod (GPUs in the job)`, with `-N = GPUs × k`. In NVIDIA's Default compute mode,
   kernels from different processes are time-sliced, not run at the same time. This suits tasks
   with a low GPU duty cycle (CPU preprocessing or I/O between kernels), because one task's
   CPU phase overlaps another's GPU phase. Memory is not isolated: k × (task memory + per-process
   CUDA context overhead) must fit in the card, or a task fails with an out-of-memory error.
2. **NVIDIA MPS (Multi-Process Service).** A per-job control daemon (`nvidia-cuda-mps-control -d`,
   with `CUDA_MPS_PIPE_DIRECTORY` and `CUDA_MPS_LOG_DIRECTORY` pointed at job-private
   directories, stopped with `quit`) lets kernels from several processes run **concurrently** on
   the SMs. It helps when each task underuses the GPU's compute. NVIDIA documents per-client
   limits (`CUDA_MPS_ACTIVE_THREAD_PERCENTAGE`, a pinned device-memory limit), and documents that
   a fatal fault in one client can affect the other clients on that GPU. This only works if the
   GPU's compute mode allows it and the site permits a user-run daemon.
3. **MIG (Multi-Instance GPU).** Hardware partitions with isolated memory and compute
   (A100, A30, H100). An administrator configures them, never the user. Each slice looks like a
   separate device, and a CUDA process uses one slice. Running one executor per slice is the
   simplest and safest multiplexing where the site provides slices.

**What the RCAC site says** (repository docs read 2026-11-22):

| Cluster | GPUs per node (site docs) | MIG | MPS | Notes |
|---|---|---|---|---|
| Gautschi | 8 × H100 80 GB (`ai`), 2 × L40S 48 GB (`smallgpu`) (`docs/userguides/gautschi/overview.md:22,36-37`) | not mentioned | not mentioned | GPU-hours are charged per GPU (`queues.md:82`), so multiplexing raises useful work per charged hour. |
| Gilbreth | A10 ×3, A30 ×3, A100 40 GB ×2/×4, A100 80 GB ×2/×4, H100 (`docs/userguides/gilbreth/overview.md:37-46`) | not mentioned | not mentioned | GPU type is chosen by partition. |
| Anvil | 4 × A100 (`gpu`), 4 × H100 (`ai`) (`docs/userguides/anvil/jobs.md:98-99`) | not mentioned | not mentioned | The `sfeatures` sample shows GRES `gpu:4` only, with no MPS or shard GRES listed (`jobs.md:98-99`). |
| Negishi | 3 × **AMD MI210** 64 GB (`docs/userguides/negishi/run_jobs/queues.md:72`) | n/a (AMD) | n/a (AMD) | ROCm devices: `CUDA_VISIBLE_DEVICES` does not apply. ROCm uses `HIP_VISIBLE_DEVICES` / `ROCR_VISIBLE_DEVICES`. Which one Slurm sets is unconfirmed. |
| Scholar | V100 32/16 GB, A30, A40, and **MIG slices**: "eight 6GB Multi-Instance GPUs (MIGs) configured from two NVIDIA A30" (H-MIG) and "four 6GB MIGs … from one A30" (I-MIG) (`docs/userguides/scholar/overview.md:38-39`) | **yes (A30 slices)** | not mentioned | The only cluster whose docs state MIG. The agent-context snippet lists "A30 MIG slices" in the `gpu` partition (`docs/snippets/agentic-ai/scholar/agents.d/slurm.md:23`). |
| Bell | no user guide in this repository | — | — | No GPU facts available here. Leave Bell out of the GPU page's tabs unless confirmed live. |

No page on the site mentions MPS, GPU compute mode, time-slicing or GPU sharing (grep for
`MPS`, `compute mode`, `EXCLUSIVE_PROCESS`, `time-slic`, `HIP_VISIBLE_DEVICES`,
`ROCR_VISIBLE_DEVICES` across `docs/` found nothing relevant).

**Needs live confirmation (validation envelope):**

1. GPU compute mode on Gautschi `ai` and `smallgpu`, Gilbreth, and Anvil `gpu`/`ai` nodes
   (`nvidia-smi --query-gpu=compute_mode --format=csv` inside a job): Default or
   Exclusive_Process.
2. Whether `nvidia-cuda-mps-control` exists on GPU nodes and a user can start a per-job daemon.
   Whether Slurm exposes `mps` or `shard` GRES anywhere (the Anvil sample suggests not).
3. Whether any H100 or A100 on Gautschi, Anvil or Gilbreth is MIG-partitioned (the site says
   nothing, so assume not).
4. Scholar MIG: how a slice is requested (the GRES type string, if any), how many slices one job
   can get, and what `CUDA_VISIBLE_DEVICES` holds (MIG UUIDs or indices).
5. What Slurm sets in `CUDA_VISIBLE_DEVICES` for a 2-GPU job on each NVIDIA cluster (renumbered
   `0,1` under cgroup device constraint, or physical indices). This decides whether `{slot} % n`
   is safe or whether the wrapper (below) must read the inherited list.
6. Negishi: which of `ROCR_VISIBLE_DEVICES` / `HIP_VISIBLE_DEVICES` Slurm sets, if Negishi gets a
   tab at all.
7. That `module load cuda` and `nvcc` work on Gautschi `ai` nodes (for the stand-in), or that a
   PyTorch module or environment is available instead.

### (c) Slurm GPU request syntax per cluster guide (cited)

| Cluster | Partition / QOS for GPUs | GPU count syntax the guide uses | Cited |
|---|---|---|---|
| Gautschi | `-p ai` (H100; QOS `normal`, `preemptible`, `burst`; normal: up to 4 days, at most 2 GPUs or twice the purchased count, whichever is larger); `-p smallgpu` (L40S; at most 2 GPUs, 24 h; request cores in proportion to GPUs) | `#SBATCH --gpus-per-node=N` (`openmp_jobs.md:47`, `mpi_jobs.md:29,92`, `examples/example_distributed.md:46`). The GPU page shows `--gres=gpu:1`, `--gpus-per-node=1` and `--gpus-per-task=1`, all three. | `docs/userguides/gautschi/run_jobs/queues.md:80,86-106,146-155`; `docs/userguides/gautschi/run_jobs/gpu_jobs.md:41,49-51` |
| Gilbreth | `-p a10`, `a30`, `a100-40gb`, `a100-80gb` (QOS `normal` or `standby`, standby 4 h); `-p training -q training`; NVLink nodes take `--constraint='nvlink'` | "GPU jobs must specify the number of GPUs using the `--gpus-per-node` option, as well as the memory" | `docs/userguides/gilbreth/run_jobs/queues.md:38,57,76,95,119`; `docs/userguides/gilbreth/run_jobs/submit_script.md:19,28` |
| Anvil | `-p gpu` (A100), `-p ai` (H100), `-p gpu-debug` (1 node, 2 GPUs, 30 min). At most 12 GPUs in use per user and 32 per allocation. GPU and AI credits are separate. | `#SBATCH --gpus-per-node=1` with `-p gpu`, after `module load modtree/gpu` | `docs/userguides/anvil/jobs.md:48,53-54,58-59,467-476` |
| Negishi | `-p gpu` (MI210; at most 2 GPUs, 24 h, QOS `normal` only) | `--gpus-per-node=1` with `--partition=gpu` | `docs/userguides/negishi/run_jobs/queues.md:72-81`; `docs/userguides/negishi/run_jobs/submit_script.md:52-53` |
| Scholar | `-A scholar -p gpu` | `--gres=gpu:1` (queues page) and `--gpus-per-node=1` (submit page). The GPU page shows all three forms. | `docs/userguides/scholar/run_jobs/queues.md:50-63`; `docs/userguides/scholar/run_jobs/submit_script.md:46`; `docs/userguides/scholar/run_jobs/gpu.md:38,44-46` |

**Site inconsistencies the drafter must not copy:**

- `docs/userguides/gautschi/run_jobs/gpu_jobs.md:41,49-51` uses `--partition=a10`, but Gautschi
  has no `a10` partition. Its GPU partitions are `ai` and `smallgpu` (`queues.md`). The
  agent-context snippet says so explicitly: "Do NOT use `--partition=a10` — it is not a Gautschi
  partition" (`docs/snippets/agentic-ai/gautschi/agents.d/slurm.md:48`). Worth a separate
  site-fix issue, out of this cycle's scope.
- The Gautschi snippet gives `ai` "up to 2 weeks" (`slurm.md:23`), but `queues.md` (updated for
  the 2026-11-02 change) gives normal QOS up to 4 days and preemptible up to 30 days. Trust
  `queues.md` and confirm live.
- Recommended form for the guide: **`--gpus-per-node=N`**, the one form every cluster guide
  shows, and the one Gilbreth requires.

### (d) Recommended page design

**Placement.** A page of its own, **right after tier 1** and before tier 2. Its pattern is the
tier 1 job script plus one wrapper and a different `-N`, and GPU readers are mostly tier-1-level
users. Tiers 3 and 4 link back to it from their GPU-zone clients, noting that `TASK_SLOT` (not
`{slot}`) is what works under `hs submit`.

**Worked pattern: one node, n GPUs, k tasks per GPU.**

- Job: Gautschi `-p ai`, `--nodes=1`, `--gpus-per-node=2`. Two GPUs fit every group's
  normal-QOS limit (`queues.md:91`), so any reader can run it. Request cores to match: memory
  follows cores at about 9 GB per core (`queues.md:80`). The exact core count is a PLAN and
  validation decision. Other clusters go in tabs with their partition (`a100-80gb` on Gilbreth,
  `ai` or `gpu` on Anvil, `gpu` on Scholar). Negishi needs the ROCm variable and should be
  dropped from this page's tabs if unconfirmed.
- `hsx tasks.in -N $((2 * k)) -t 'gpu-pick ./train-small {}'`, with k = 4 as the worked value.
- `gpu-pick` (POSIX sh, so it works under `/bin/sh` and under `hs submit`) selects a device from
  the job's own GPU list by slot. This sketch is for the drafter and must be validated:

  ```sh
  #!/bin/sh
  # gpu-pick: run the given command on one of this job's GPUs, chosen by executor slot.
  gpus=$(printf '%s' "${CUDA_VISIBLE_DEVICES:?no GPUs in this job}" | tr ',' ' ')
  n=$(echo $gpus | wc -w)
  i=$(( TASK_SLOT % n + 1 ))
  CUDA_VISIBLE_DEVICES=$(echo $gpus | cut -d' ' -f"$i")
  export CUDA_VISIBLE_DEVICES
  exec "$@"
  ```

  Slots `0..2k-1` mod 2 put exactly k executors on each GPU. Under plain `hsx` the inline form
  `CUDA_VISIBLE_DEVICES=$(( {slot} % 2 ))` also works, provided item 5 above confirms renumbered
  devices.
- Optional MPS block: start a per-job daemon before `hsx` and stop it after. Show this only if
  live checks 1 and 2 pass. Otherwise, one sentence saying that MPS needs site support.
- Scholar MIG variant: request slices and run `-N` = slices with one executor per slice (k = 1
  per slice). Show this only if live check 4 settles the request syntax.
- **Measure, don't guess k.** Show `nvidia-smi --query-compute-apps=pid,used_memory --format=csv`
  sampled during the run (k processes per GPU), and compare wall time at k = 1, 2, 4 from
  `hs list`/`hs info` timing. A small table of these results makes the "where it stops paying" point.

**Caveats to state.**

- GPU memory per task × k, plus about a few hundred MB of CUDA context per process, must fit the
  card: 80 GB H100 or A100-80, 40 GB A100-40, 48 GB L40S, 24 GB A10 or A30, 32 or 16 GB V100,
  6 GB per Scholar MIG slice. HyperShell does not track GPU memory.
- Host side: n × k processes share the job's CPU cores and RAM, so request enough of both.
  `-C`/`-M` can bound the client.
- Time-slicing (the default) gives overlap only when tasks idle the GPU part of the time. MPS
  gives true concurrency but couples faults. MIG gives isolation but its sizes are fixed by the
  site.
- Past saturation, raising k only adds contention. Measure.
- **Version:** `{slot}`, `{slot_count}`, `TASK_SLOT` and `TASK_SLOT_COUNT` need HyperShell
  **2.9.0**.

**Stand-in for validation.** A tiny CUDA program (compiled with `nvcc` after `module load cuda`)
that allocates a requested amount of device memory and spins a kernel for T seconds. A small
PyTorch script is the alternative if a module provides it. Validate on Gautschi `ai` with
2 GPUs, k ∈ {1, 2, 4}: every task's device is one of the job's two, `nvidia-smi` shows k
processes per GPU, there are no out-of-memory failures at the chosen size, and the wall-time
trend is recorded. Scenario framing: a climate ML-emulator hyperparameter sweep (hundreds of
small training runs, each a few GB).

## 5. Recommendations for PLAN

**Guide page list and order** (under the Workflow Automation section, the deepest subsection):

1. **Guide landing page** (`…/hypershell/index.md`): what HyperShell is in one paragraph, how to
   read the tiers, a tier map table (tier, who it's for, features, move on when; built from §3),
   `module load hypershell` (unpinned), key handling via `HYPERSHELL_SERVER_AUTH` or
   `server.auth` (R12), and **the version admonition**.
2. **Tier 1: the canonical single job** (VFX frames). Min version **2.9.0** (file-aware
   `--restart` is `versionchanged:: 2.9.0`, `docs/cli/cluster.rst`).
3. **GPU multiplexing** (climate emulator sweep). Min version **2.9.0** (slots).
4. **Tier 2: extreme scale** (climate ensemble). Min version: 2.9.0 as the documented baseline.
   Several options changed in 2.9.0, among them duration units on `-w`/`-d` and `--no-db` leaving
   the database alone (`docs/cli/cluster.rst`).
5. **Tier 3: an on-cluster pipeline** (crop genomics). Min version **2.9.0** (zones). Task groups
   exist from **2.8.0** (first tagged release containing the task-groups feature commit), with
   2.9.0 validation changes (`docs/_include/task_groups_alt.rst`, `versionchanged:: 2.9.0`).
6. **Tier 4: the capstone on Geddes** (astronomy survey service). Min version **2.9.0** (relay,
   `versionadded:: 2.9.0`, `docs/cli/relay.rst`; relay topology and server autoscaling with relay
   sites).

**Version admonition: put it on the guide landing page.** Almost every feature the tiers use
(file-aware `--restart`, `--zone`, slots, relay) is new or changed in 2.9.0, while RCAC modules
top out at 2.7.0. The reader has to see the admonition before tier 1. The GOAL asks for "once,
prominently", so the landing page holds it, and each tier page carries only its one-line
minimum-version note, which can link back to it.

**Where zones and groups are first introduced: tier 3.** R9 needs each one explained (what it
does, when to use it) where it is introduced. Tier 3's phases (groups) and its CPU versus
high-memory routing (zones) motivate both naturally, entirely on one cluster. Tier 4 then shows
them working together across relay sites and clusters (R10), including per-night group numbering
under the reached-group rule. Tiers 1 and 2 and the GPU page use neither. The GPU page links
forward to tier 3 for zones only in passing.

**Other notes for PLAN:**

- The tier 1 database location must persist across resubmissions. Do not key `HYPERSHELL_SITE`
  to `$SLURM_JOB_ID`, as the website draft's Slurm provider does.
- Prefer `--gpus-per-node=N` in every GPU tab. Never use `--partition=a10` on Gautschi.
- Bell has no user guide in this repository, so its tab contents (partition, account, module)
  need live confirmation, or Bell drops from the tab set.
- Scenario stand-ins must stay generic and our own, and borrow nothing from the website draft's
  scripts or datasets. The planted-failure device is generic pedagogy, but vary its form (for
  example an out-of-range frame number rather than a missing download).
