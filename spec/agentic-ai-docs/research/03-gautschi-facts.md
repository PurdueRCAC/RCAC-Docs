# Gautschi Cluster Facts Sheet (citable)

Purpose: exact, citable Gautschi facts for authoring the shared-context files `slurm.md`,
`filesystems.md`, `lmod.md`, `unix.md`, `policies.md`. HPC accuracy is safety-critical —
every fact below carries a `path:line` citation. Anything not verifiable in the source tree
is marked `[UNCONFIRMED]`.

All paths are relative to repo root
`/Users/geoffrey/Software/github.com/purduercac/RCAC-Docs`.

IMPORTANT META-NOTE ON WHERE TEXT LIVES: many Gautschi storage/account pages are thin
wrappers that pull real text from `main.py` macros or `docs/snippets/*.md`. Citations below
point at the actual source of the text (the macro/snippet), not just the wrapper page.

---

## 1. SYSTEM

- **OS:** Rocky Linux 9. "Gautschi nodes run Rocky Linux 9 and use Slurm ... as the batch
  scheduler." — `docs/userguides/gautschi/overview.md:40`. (Note: one apptainer example page
  shows `CentOS Linux release 7.3.1611` inside a *container* image — that is container OS, not
  the host — `docs/userguides/gautschi/run_jobs/apptainer_example.md:45`.)
- **Scheduler:** Slurm — `overview.md:40`, `run_jobs/index.md:14`.
- **CPU compute node (sub-cluster A):** Two AMD EPYC 9654 96-core "Genoa" CPUs @ 2.4 GHz =
  **192 cores/node, 384 GB memory**; 400 Gbps NDR InfiniBand; 338 nodes; retires 2030.
  — `overview.md:12`, `overview.md:22`, `overview.md:34`.
- **High-memory node (sub-cluster B):** Two AMD EPYC 9654 96-core "Genoa" @ 2.4 GHz = 192
  cores, **1.5 TB memory**; 6 nodes. — `overview.md:35`, `run_jobs/queues.md:98`.
- **Small-GPU node (sub-cluster G):** Two AMD EPYC 9554 64-core "Genoa" @ 3.1 GHz = 128
  cores, 384 GB memory, **Two NVIDIA L40S GPUs (48 GB each)**; 6 nodes.
  — `overview.md:36`, `run_jobs/queues.md:131`.
- **GPU/AI node (sub-cluster H):** Two Intel Xeon Platinum 8480+ 56-core CPUs @ 3.8 GHz = 112
  cores, **1 TB CPU memory**, **Eight NVIDIA H100 GPUs (80 GB each)**, 8-way NVLinked; 20
  nodes. — `overview.md:37`, `run_jobs/queues.md:75`. (`overview.md:22` says "1032 GB",
  `overview.md:12` says "1031 GB", table `overview.md:37` says "1TB" — minor internal
  inconsistency; treat as ~1 TB. `[UNCONFIRMED exact GB]`.)
- **Interconnect:** 400 Gbps NDR InfiniBand on all compute nodes — `overview.md:12`,
  `overview.md:22`.
- **Front-end / login nodes:** **8 front-end nodes**, each Two AMD EPYC 9654 96-core "Genoa"
  @ 2.4 GHz = 192 cores, **768 GB memory** — `overview.md:24-28`. (Observed login node
  hostname `login02` in an scontrol example — `run_jobs/monitoring_job.md:44`.)
- **Login hostname:** `gautschi.rcac.purdue.edu`. SSH form:
  `ssh username@gautschi.rcac.purdue.edu` — `main.py:520`, `main.py:528`, `main.py:52`
  (`ssh-copy-id ... username@{resource}.rcac.purdue.edu`, resource=gautschi via
  `accounts.md:12`).
- **Compute node naming:** `gautschi-a001.rcac.purdue.edu` style; short names `a166`,
  `a[014-015]` — `run_jobs/simple_job.md:45`, `run_jobs/monitoring_job.md:46`,
  `run_jobs/multiple_node.md:28`, `run_jobs/mpi_jobs.md:69`.
- **Other access endpoints:** ThinLinc remote desktop `desktop.gautschi.rcac.purdue.edu`
  (`main.py:181`, `main.py:190-191`, `index.md:19`); Open OnDemand "Gateway"
  `gateway.gautschi.rcac.purdue.edu` (`main.py:509`, `index.md:15`).
- **Authentication:** SSH public keys OR Purdue MFA (two-factor). "Gautschi supports either
  Purdue's MFA two-factor authentication or SSH keys." — `main.py:515`. Password login:
  "enter your Purdue career account password. Your MFA app will then receive a notification to
  approve the login." — `main.py:531`; Gateway: "Career account username and Purdue Login MFA
  client" — `docs/userguides/gautschi/gateway.md:20`. SSH-key setup is a 3-step
  keygen/copy/test flow — `main.py:28-70`. **`[UNCONFIRMED]`: the term "BoilerKey" does not
  appear anywhere in the Gautschi docs or `main.py`; the docs say "Purdue Login MFA" / "MFA".**
- **Account eligibility:** must be in a research group that purchased access; external
  collaborators need a valid Purdue career account (R4P if none) — `main.py:492-497`.

## 2. SLURM

### Account / allocation model
- Every Gautschi job request has **four parts**: resources, **account** (`-A/--account=`),
  **QOS** (`-q/--qos=`), and **partition** (`-p/--partition=`) — `run_jobs/queues.md:14-19`.
- **You MUST explicitly specify BOTH the account and the partition.** "you must explicitly
  define the account that you want to submit to using the '-A/--account=' option"
  (`queues.md:27`); "instead of only needing to specify the account name in the job script,
  the desired partition must also be specified." (`queues.md:47`).
- Accounts = queues, named after the purchasing partner; behave like bank accounts of
  purchased cores / GPU-hours. Use **`slist`** to list your accounts and their balances —
  `queues.md:25`, `run_jobs/mpi_jobs.md:127`, `run_jobs/gpu_usage_monitoring.md:106`.
- "standby"/"highmem"/"gpu" are **no longer accounts** on Gautschi (they were on older
  clusters) — they are now QOS/partitions — `queues.md:27`, `queues.md:41`.

### QOS model
Two QOS classes: **Partition QOS** (auto-applied by the partition) and **Job QOS** (chosen
with `-q/--qos=`) — `queues.md:31-36`. Job QOSes available to every user/account:
- **`normal`** (default if no `-q` given): high priority, no extra limits — `queues.md:40`.
- **`standby`** (opt-in `-q standby`/`--qos=standby`): access to idle resources, **low
  priority, max 4 hours**, usage **NOT** charged against the account; replaces the old
  `-A standby` style — `queues.md:41`.
- **`preemptible`** (AI partition only, `-q preemptible`): low priority, charged **0.25
  GPU-hour per GPU per hour** (4x cheaper), max 2 weeks, **can be cancelled/preempted** to make
  room for `normal` jobs — "imperative to use checkpointing" — `queues.md:87-92`.

### Partitions (authoritative list from queues.md)
| Partition | Nodes | Node type | Cores/node | Memory model | GPUs | QOSes | Max walltime | Submit |
|---|---|---|---|---|---|---|---|---|
| **`cpu`** | 336 Gautschi-A | AMD EPYC 9654, 192c | 192 | ~2 GB/core requested | — | normal, standby | normal: **2 weeks**; standby: 4 h | `-p cpu` |
| **`ai`** | 20 Gautschi-H | Intel Xeon 8480+, 112c | 112 | ~9 GB/core requested | 8× H100 80 GB/node (160 total) | normal, preemptible | **2 weeks** | `-p ai` |
| **`highmem`** | 6 Gautschi-B | AMD EPYC 9654, 192c | 192 | ~8 GB/core; 1.5 TB/node | — | normal | **24 h** | `-p highmem` |
| **`profiling`** | 2 Gautschi-A | AMD EPYC 9654 (perf counters) | 192 | whole-node only | — | normal | **24 h** | `-p profiling` |
| **`smallgpu`** | 6 Gautschi-G | AMD EPYC 9554, 128c | 128 | ~3 GB/core | 2× L40S 48 GB/node | normal | **24 h** | `-p smallgpu` |

Citations: cpu `queues.md:49-71`; ai `queues.md:73-94`; highmem `queues.md:96-110`; profiling
`queues.md:112-127`; smallgpu `queues.md:129-142`.

Partition-specific limits/notes:
- **cpu:** memory ~2 GB per requested core; `normal` withdraws cores from account until job
  ends; GPU-only groups may use `cpu` only via `standby` — `queues.md:51-69`.
- **ai:** memory ~9 GB per requested core; `normal` charges **1 GPU-hour per GPU per hour**
  (tracked by the minute) — `queues.md:75-85`.
- **highmem:** ~8 GB/core; **no expectation of start time**; max **2 running / 8 submitted**
  jobs; **your job must use more than 48 of the 192 cores** — `queues.md:102-108`.
- **profiling:** hardware perf counters (e.g. AMD MicroProf); **whole-node only**; max 1
  running job; monitored to prevent use as plain compute — `queues.md:114-125`.
- **smallgpu:** ~3 GB/core; request cores proportional to GPUs used; up to **2 GPUs**; max 8
  submitted jobs — `queues.md:131-140`.

### Default limits
- Access sold in units of 48 cores (quarter of a CPU node) or a 5-GPU-year package —
  `overview.md:14`.
- **`[UNCONFIRMED]`: no explicit default walltime or default node/core count is stated on any
  Gautschi page.** (The generic `main.py` macro `slurm_general_jobs` states "time: 30 minutes,
  nodes: 1" at `main.py:335-336`, but that macro is NOT invoked by any Gautschi page — see
  §Modules note — so do not attribute it to Gautschi.)

### Example real `#SBATCH` directives (gold-standard submit script)
From `run_jobs/creating_the_submission_script.md:15-34` (cpu partition):
```bash
#!/bin/bash
# FILENAME:  myjobsubmissionfile
#SBATCH --account=myLabAccount
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
module load matlab
cd $SLURM_SUBMIT_DIR
matlab -nodisplay -singleCompThread -r myscript
```
Combined `-A ... -p ...` on one directive line — `run_jobs/directives.md:26-28`. Full
command-line form: `sbatch -A myLabAccount -p cpu -q normal -N1 -n1 -t 1-00:00:00 file`
— `run_jobs/submit_script.md:28`.

### Slurm / cluster commands referenced in Gautschi docs (verified present)
- **`sbatch`** — submit batch job — `submit_script.md:16`, `directives.md:16`.
- **`squeue -u <user>`** — view your jobs — `monitoring_job.md:15,21`.
- **`scontrol show job <id>`** — job detail — `monitoring_job.md:31`.
- **`scontrol hold job <id>` / `scontrol release job <id>`** — hold/release —
  `docs/snippets/holding_job.md` (included by `run_jobs/holding_job.md:11`).
- **`scancel <jobid>`** — cancel job — `docs/snippets/cancelling_job.md:6` (included by
  `run_jobs/cancelling_job.md:11`).
- **`sinteractive -A <acct> -p <part> -N.. -n..`** — interactive job — `interactive_jobs.md:15-21`.
- **`srun` / `mpiexec`** — launch MPI ranks; `srun --mpi=pmi2` for Intel MPI —
  `mpi_jobs.md:35,44,47`, `monitoring_resources.md:53,62`.
- **`slist`** — list accounts / balances (incl. GPU-hour balance) — `queues.md:25`,
  `mpi_jobs.md:127`, `gpu_usage_monitoring.md:106`, `gateway/jobs.md:17`,
  `gaussian_example.md:110`.
- **`sfeatures`** — node/GPU feature detail — `gpu_jobs.md:92`.
- **`myquota`** — home/scratch quota — `docs/snippets/storage_quota.md:8`.
- **`findscratch`** — print scratch path — `docs/snippets/scratch_space.md:15`.
- **`purgelist`** — files scheduled for scratch purge — `docs/snippets/scratchpurge.md:21-24`.
- **`monitor`** (module) — resource telemetry — `monitoring_resources.md:21-25`.
- **`[UNCONFIRMED]`: `sinfo`, `sacct`, `jobinfo`, `mybalance`, `showpartitions`, `wait_time`
  do NOT appear anywhere under `docs/userguides/gautschi/`** (grep-verified). `mybalance`,
  `showpartitions`, `wait_time`, and the `wholenode` partition appear only in the generic
  `main.py` macro `slurm_general_jobs` (`main.py:301-391`), which Gautschi does not use — do
  not present them as Gautschi commands.

### KNOWN DOC ERRORS to NOT propagate (copy-paste leftovers from Gilbreth)
- `run_jobs/gpu_jobs.md:41,49-51` and `run_jobs/mpi_jobs.md:32` use **`--partition=a10`**,
  which is **not a Gautschi partition** (valid GPU partitions are `ai` and `smallgpu`).
  Grep count: 7 uses of `--partition=a10` under gautschi. **Do not use `a10` in generated docs.**
- `run_jobs/mpi_jobs.md:94` uses **`#SBATCH -A standby`** — invalid on Gautschi (standby is a
  QOS `-q standby`, not an account). — contradicts `queues.md:41`.

## 3. MODULES (Lmod)

- Gautschi's `software.md` demonstrates module use directly with **`module avail`**,
  **`module spider <name>`**, **`module load <name>/<version>`** — `software.md:23-56`.
  (`module spider` is an Lmod-specific command, so the module system is **Lmod**; note the
  word "Lmod" itself is only in the `module_system` macro, which Gautschi does **not** invoke —
  see below. `[UNCONFIRMED that a Gautschi page literally names "Lmod"]`.)
- **Default compiler + MPI (recommended):** **GCC 14.1.0** and **OpenMPI** —
  `overview.md:42-45`. `[UNCONFIRMED: exact OpenMPI version not stated on any Gautschi page.]`
- Example load lines: `module load hypershell/2.7.0` (`software.md:55`), `module load cuda`
  (`gpu_jobs.md:26`), `module load matlab` (`creating_the_submission_script.md:27`),
  `module load monitor` (`monitoring_resources.md:24`).
- Core Applications sample (`module avail`) includes `amduprof/5.1.701`,
  `anaconda/2024.10-py312`, `anaconda/2025.06-py313 (D)`, `hypershell/*`, `ngc/default`,
  `oclfpga/2024.1.0`, `openblas/0.3.27` — `software.md:25-29`.
- **Do NOT attribute the generic Lmod write-up to Gautschi:** the `module_system(resource)`
  macro (`main.py:540-632`, describes hierarchy, `module unload/purge/show/help`,
  `$RCAC_APPNAME_ROOT`, auto compiler/MPI/CUDA loading) is invoked by anvil/bell/gilbreth/
  hammer/negishi software pages **but not by Gautschi** (grep-verified: `module_system` usage
  is in `docs/userguides/{anvil,bell,gilbreth,hammer,negishi}` only). Those extra module
  commands are RCAC-standard and almost certainly apply, but are `[UNCONFIRMED for Gautschi
  specifically]` from the Gautschi page set. General module commands (`module unload`,
  `module purge`, `module list`, `module show`) do appear in Gautschi job-script examples/prose
  via `main.py:360-363` only if a Gautschi page calls that macro — it does not; however
  `module purge`/`module list` appear as generic script comments. Verified in-Gautschi:
  `module avail`, `module spider`, `module load` (software.md), `module avail openmpi`
  (`mpi_jobs.md:18`).

## 4. FILESYSTEMS

Text lives in `main.py` macros / `docs/snippets/`; wrapper pages just include them.

- **Home directory:** path **`/home/myusername`**, env var **`$HOME`**. On GPFS. Long-term,
  medium-performance, **not** for heavy-I/O jobs. — `docs/snippets/home_directory.md:8-13,29-34`
  (included via `storage/home_directory.md:11`). Snapshots: **nightly for 7 days, weekly for 4
  weeks, monthly for 3 months** — `home_directory.md:27`.
- **Home quota:** the `myquota` example shows a **25.0 GB** home limit
  (`docs/snippets/storage_quota.md:14-15`), but this is illustrative example output in a shared
  snippet, and home quota "cannot be increased beyond current level"
  (`storage_quota.md:54`). **`[UNCONFIRMED: 25 GB is an example, not a Gautschi-stated
  official quota.]`**
- **Scratch:** path **`/scratch/gautschi/myusername`** (`{cluster}` = `gautschi`), env var
  **`$RCAC_SCRATCH`** (NOT `$CLUSTER_SCRATCH`). Find it with **`findscratch`**. High-
  performance parallel filesystem; not backed up; not recoverable. — `docs/snippets/
  scratch_space.md:12-27` (via `storage/scratch_space.md:11`), `docs/snippets/
  environment_variables.md:12,28,37`. **CORRECTION to task hypothesis: the variable is
  `$RCAC_SCRATCH`, and there is no `$CLUSTER_SCRATCH` in these docs.**
- **Scratch purge policy:** **files not accessed or content-modified in 60 days are purged**
  (Gautschi uses the default 60-day threshold; only Anvil/Bell are rewritten to 30 days by
  `main.py:755-757`). — `docs/snippets/scratch_space.md:10`, `docs/snippets/scratchpurge.md:10`,
  `scratchpurge.md:67`. Purge is by last access + content-modification time; metadata changes
  don't protect a file; no warning emails; use `purgelist` to see candidates —
  `scratchpurge.md:8-19,21-33`.
- **Scratch quota:** `myquota` example shows scratch **100.0 TB / 2,000k files**
  (`storage_quota.md:15`) — illustrative example output, not a Gautschi-official figure.
  **`[UNCONFIRMED exact Gautschi scratch quota.]`** Quota increases available on request
  (`storage_quota.md:58`).
- **/tmp:** node-local short-term storage on each front-end/compute node; data lives only
  while the program runs; not backed up; not recoverable — `docs/snippets/tmp_directory.md:4-6`
  (via `storage/tmp_directory.md:11`).
- **Data Depot:** long-term storage for active research data (purchasable); listed as an
  archival target for staging scratch data — `docs/snippets/scratchpurge.md:6,47,51`;
  purchasable via `storage_quota.md:54`. `[UNCONFIRMED: no Gautschi page states the Depot mount
  path or per-space quota; Depot path is typically `/depot/<group>` on RCAC but not cited here.]`
- **Fortress (long-term / archive):** HPSS archival system, **>10 PB** capacity; use `hsi`/
  `htar`. — `docs/snippets/long_term_storage.md:4-9` (via `storage/long_term_storage.md:11`),
  `scratch_space.md:4`.
- **Quota-check command:** **`myquota`** (reports home + scratch, size and file-count) —
  `docs/snippets/storage_quota.md:8-16`.
- **Storage environment variables:** `HOME` = `/home/myusername`; `PWD`; `RCAC_SCRATCH` =
  `/scratch/gautschi/myusername` — `docs/snippets/environment_variables.md:10-12`.
- **Slurm/runtime env vars documented for Gautschi:** `SLURM_SUBMIT_DIR` (used in gold
  submit script, `creating_the_submission_script.md:30`), `SLURM_JOB_NODELIST`
  (`multiple_node.md:20`), `CUDA_VISIBLE_DEVICES` (`gpu_jobs.md:30`). The fuller table
  (`SLURM_SUBMIT_DIR`, `SLURM_JOBID`, `SLURM_JOB_NAME`, `SLURM_JOB_NODELIST`,
  `SLURM_SUBMIT_HOST`, `SLURM_JOB_PARTITION`) exists in the generic macro `main.py:310-317`
  but that macro is not used by Gautschi — the individual vars above ARE used in Gautschi pages.

## 5. POLICIES

- **Login-node "do not run compute" wording (quote it):**
  > "Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end
  > login host. All users share the front-end hosts, and running anything but the smallest
  > test job will negatively impact everyone's ability to use Gautschi. Always use SLURM to
  > submit your work as a job."
  — `docs/userguides/gautschi/run_jobs/index.md:16-17` (an `!!! important` admonition).
- **Front-end use policy (external link):** "The normal acceptable front-end use policy ...
  applies" → <https://www.rcac.purdue.edu/policies/frontenduse> —
  `docs/userguides/gautschi/gateway/cluster_tools.md:18`.
- **Scratch purge policy (external link):**
  <https://www.rcac.purdue.edu/policies/scratchpurge> — `docs/snippets/scratch_space.md:10`.
- **Acceptable Use:** scratch snippet states using scratch as long-term storage or
  circumventing purging "is considered a violation of Acceptable Research Resource Use"
  — `docs/snippets/scratchpurge.md:71-73` (anchors to
  `#acceptable-purdue-it-research-resource-use`). `[UNCONFIRMED: no direct link to a Purdue IT
  AUP URL is present on the Gautschi pages read; the reference is an in-page anchor.]`
- **Data-sensitivity guidance:** `[UNCONFIRMED]` — no explicit data-classification/sensitivity
  (e.g. HIPAA/export-control/regulated-data) statement found in the Gautschi page set read.
- **Network-drive access requires campus network/VPN** (CIFS "Z: drive") —
  `docs/userguides/gautschi/faqs.md:29`.
- **Data-retention / access removal:** losing Gautschi access removes mailing-list
  subscription; copy data out first — `faqs.md:18`.
- **Cluster lifetime:** hardware "service through 2030" / "Retires in 2030" — `overview.md:12`,
  `overview.md:28,34-37`.

## 6. UNIX / GENERAL

- **Default shell:** `[UNCONFIRMED]` — no Gautschi page states the default login shell.
  Submission-script examples use `#!/bin/bash` (e.g. `simple_job.md:18`,
  `creating_the_submission_script.md:16`) and some generic examples `#!/bin/sh -l`
  (`main.py:277`). The env-var snippet documents both bash (`export`) and tcsh/csh (`setenv`)
  syntax — `docs/snippets/environment_variables.md:41-51`, implying csh/tcsh users exist.
- **Home is CWD at login:** "Your home directory becomes your current working directory, by
  default, when you log in." — `docs/snippets/home_directory.md:4`.
- **Gautschi home is isolated:** the Gautschi home directory is exclusive to Gautschi front-
  ends/compute nodes; not shared with or synced to other RCAC clusters — `faqs.md:32`.
- **Scratch is per-cluster:** only `/scratch/gautschi` is mounted on Gautschi; no other
  cluster's scratch is available — `docs/snippets/scratch_space.md:26-27`.
- **Env-var best practice:** use `$HOME`, `$RCAC_SCRATCH`, etc. instead of hard-coded paths
  (paths may change) — `docs/snippets/environment_variables.md:4`,
  `docs/snippets/scratch_space.md:19`.
- **Module gotcha:** the generic guidance "do not put `module load` in your bash profile (can
  break ThinLinc init)" lives in the `module_system` macro (`main.py:587`) which Gautschi does
  not invoke — `[UNCONFIRMED for Gautschi]` but standard RCAC advice.
- **GUI apps:** launch via ThinLinc (Applications → Cluster Software) — `faqs.md:38-41`.
- **X11 forwarding:** supported via `ssh -Y`; `$DISPLAY` must be left as SSH sets it —
  `main.py:159,162`.
- **App-specific gotchas documented:** Firefox lock ("Firefox is already running") and Jupyter
  "database is locked" recovery — `faqs.md:76-82` (snippets `firefox_lock.md`, `jupyter_lock.md`).

---

## Summary of `[UNCONFIRMED]` items
1. Exact GPU-node CPU memory (1 TB vs 1031 vs 1032 GB — internal inconsistency).
2. "BoilerKey" — term never used; docs say "Purdue Login MFA" / SSH keys.
3. Default Slurm walltime / default nodes-cores for Gautschi (generic macro value not
   attributable to Gautschi).
4. `sinfo`, `sacct`, `jobinfo`, `mybalance`, `showpartitions`, `wait_time`, `wholenode` — not
   in Gautschi docs.
5. Literal "Lmod" naming and full module command set (`unload`/`purge`/`show`/`help`) not on a
   Gautschi page (module_system macro unused by Gautschi).
6. Exact OpenMPI version (only "OpenMPI" + "GCC 14.1.0" stated).
7. Official home quota (25 GB) and scratch quota (100 TB / 2000k files) — shown only as
   illustrative `myquota` example output in a shared snippet.
8. Data Depot mount path / quota; Purdue IT AUP direct URL; data-sensitivity/classification
   policy; default login shell.

## Documentation-error warnings (do NOT propagate into generated shared context)
- `--partition=a10` in `gpu_jobs.md` and `mpi_jobs.md` — invalid Gautschi partition (use `ai`
  or `smallgpu`).
- `#SBATCH -A standby` in `mpi_jobs.md:94` — `standby` is a QOS (`-q standby`), not an account.
</content>
</invoke>
