# 03 — Scholar facts for `scholar.yml` and template audit

Source: `docs/userguides/scholar/**` only, plus the shared snippets and `main.py` macros those
pages render with `resource = scholar`. All paths are relative to the repo root; a citation is
`file → heading`. "Shared snippet" means the text is the same on every cluster guide that
includes it, so it confirms what the Scholar guide says, but it was not written for Scholar.

## Summary

- Scholar is RCAC's teaching cluster: 6 front-ends (3 of them with a GPU) and a small set of
  sub-clusters (`docs/userguides/scholar/overview.md` → *Scholar Overview*, *Scholar
  Specifications*). Faculty request it per class through the semester and CRN. Students
  registered for the class get login access automatically (`accounts.md` → *Obtaining an
  Account*; `overview.md` → *Scholar Overview*).
- Login is `scholar.rcac.purdue.edu`. The guide does not state the OS of the x86_64 nodes. The
  Spark nodes run Ubuntu 24.04 LTS on `aarch64`.
- Slurm account: `scholar`. Partitions: `cpu`, `gpu`, `spark-batch` and `spark-interactive`.
  QOS: `normal` (the default, up to 4 h), `long` (up to 3 days) and `debug` (30 min). Scholar
  has **no `standby`, `preemptible` or `training` QOS**.
- Home is the shared GPFS snippet with snapshots. It belongs to Scholar alone and is not
  shared with other RCAC clusters. Scratch is `/scratch/scholar` with a 60-day purge, from the
  shared snippet. The scratch technology is not stated. `/depot` is mounted. Fortress, `hsi`
  and `htar` are documented. The guide also names `/class` and `/apps` but does not describe
  either one.
- The templates cannot render Scholar correctly as they stand:
  - `os` must be non-null.
  - `long` and `debug` have no QOS branch, so they would silently disappear.
  - The `-A standby` prohibition always renders and asserts a `standby` QOS.
  - `slist` is described as showing "balances", and `policies.md` talks about "allocations"
    and charging. The Scholar guide documents neither.
  - The guide never mentions `purgelist`.

## Proposed `scholar.yml`

```yaml
# Agentic-AI context data model for Scholar.
# Edit this file (not docs/snippets/agentic-ai/scholar/**) and re-run
# tools/generate_agent_context.py. Facts verified against docs/userguides/scholar/.
cluster: scholar
title: Scholar
login_host: scholar.rcac.purdue.edu   # accounts.md → "SSH Client Software"
# The OS of the x86_64 front-ends and compute nodes is not stated anywhere in
# docs/userguides/scholar/. The Spark nodes (spark-* partitions) run Ubuntu 24.04 LTS on
# aarch64 (scholar-spark.md → "Specifications"). unix.md.j2 renders {{ os }}
# unconditionally, so null renders "None". The template needs a null branch ("check
# /etc/os-release") before this can stay null. See Open questions.
os: null
# storage/scratch_space.md → "Scratch Space" (scratch_space macro, cluster=scholar);
# storage/environment_variables.md → RCAC_SCRATCH = /scratch/scholar/myusername
scratch_path: /scratch/scholar

filesystems:
  home:
    # storage/home_directory.md (shared snippet) → "Home Directory": "physically resides on a
    # GPFS storage system". faqs.md → "Does Scholar have the same home directory as other
    # clusters?": exclusive to Scholar, no sync with other RCAC homes.
    tech: GPFS
    # storage/home_directory.md → "Lost File Recovery"; storage.md → "Storage Options"
    # ("Daily snapshots ... for a limited time").
    snapshots: nightly snapshots kept for 7 days, weekly for 4 weeks, and monthly for 3 months (recoverable)
  scratch:
    # scratch_space.md → "Performance" says only "high-performance, large-capacity parallel
    # filesystem"; technology not stated.
    tech: null
    # scratch_space.md → danger admonition: "not been accessed or had content modified in
    # 60 days are purged". Shared snippet; no Scholar or semester-specific rule is stated.
    purge_days: 60
  # /depot is mounted on Scholar: scholar-spark.md → "Layout" (/home, /scratch, /depot,
  # /class, /apps); run_jobs/apptainer_example.md → "Purdue Cluster Specific Notes";
  # gateway/files.md → "Files"; storage.md → "Storage Options". Whether class/student
  # accounts have a Depot space is NOT stated. See Open questions.
  depot: true
  # storage/long_term_storage.md → "Long-Term Storage" (Fortress/HPSS);
  # storage/hsi.md, storage/htar.md ("provided on all research systems"). Whether students
  # hold Fortress accounts is NOT stated.
  fortress: true

# No default or recommended compiler/MPI stack is stated. compile/compile_serial.md (shared
# snippet) shows `module load intel` / `module load gcc`; run_jobs/mpi.md → "MPI Jobs"
# names OpenMPI and Intel MPI and says to use `module avail`. Spark nodes use a separate
# module tree (`module load modtree/spark`; gcc/14.2.0 (D) in its listing).
toolchain: null

scheduler:
  # Scholar has no standby QOS (run_jobs/queues.md → "Quality of Service (QoS)").
  standby_max_hours: null

# run_jobs/queues.md → "Quality of Service (QoS)": Normal (default), Long, Debug.
# NOTE: slurm.md.j2 has branches only for normal/standby/preemptible/training, so `long`
# and `debug` will not render until the template gains branches (see audit).
qos:
  - normal   # default; jobs up to 4 hours
  - long     # more than 4 h, max 3 days; lower priority
  - debug    # high priority; 1 running job; up to 2 nodes; 30 minutes

# run_jobs/queues.md → "Scholar Partitions"; node specs from overview.md → "Scholar
# Sub-Clusters"; Spark specs from scholar-spark.md → "Specifications".
# Which QOS each partition accepts, and the Spark time limits, are NOT stated per partition.
partitions:
  - name: cpu
    use: "CPU jobs (`scholar-a`: 128 cores, 256 GB; `scholar-b`: 64 cores, 256 GB)"
    notes: "`-A scholar`; QOS `normal` (default, up to 4 h), `long` (up to 3 days) or `debug` (30 min)"
  - name: gpu
    use: "NVIDIA GPU jobs (`scholar-g` V100, `scholar-h` 2× A30, `scholar-h`/`scholar-i` A30 MIG slices, `scholar-j` 2× A40)"
    notes: "`-A scholar`; you must request GPUs (`--gres=gpu:N` or `--gpus-per-node=N`)"
  - name: spark-batch
    use: "NVIDIA GB10 (DGX Spark) nodes with exclusive resources; `aarch64`, Ubuntu 24.04"
    notes: "`-A scholar`; run `module load modtree/spark` first; `x86_64` binaries do not run"
  - name: spark-interactive
    use: "NVIDIA GB10 (DGX Spark) nodes, oversubscribed, for shared interactive work; `aarch64`"
    notes: "`-A scholar`; run `module load modtree/spark` first; `x86_64` binaries do not run"

anti_patterns:
  # queues.md → "Quality of Service (QoS)"
  - "**Do NOT** request a `standby`, `preemptible`, or `training` QOS — Scholar has none. Its QOS are `normal` (default, up to 4 h), `long` (up to 3 days, lower priority), and `debug` (high priority, one running job, up to 2 nodes, 30 min)."
  # queues.md → "Normal (default)", "Long"
  - "**Do NOT** request more than 4 hours under the default `normal` QOS; add `--qos=long` for jobs up to 3 days."
  # queues.md → "Scholar Queue"; run_jobs/mpi.md → note ("available to everyone ... is scholar")
  - "**Do NOT** invent an account name. The documented account is `scholar` (`-A scholar`); check `slist` for the accounts available to you."
  # queues.md → "GPU Partition"; run_jobs/gpu.md → "GPU Jobs"
  - "**Do NOT** submit to the `gpu` partition without requesting GPUs (`--gres=gpu:N` or `--gpus-per-node=N`)."
  # scholar-spark.md → warning admonitions; "Software and Applications"; FAQ "Exec format error"
  - "**Do NOT** run `x86_64` software, or modules from the `rcac` or `modtree/all` trees, on `spark-batch`/`spark-interactive` nodes — they are `aarch64`. Load `module load modtree/spark` and rebuild or reinstall software there (check with `uname -m`)."
  # cross-cluster guard, mirrors negishi.yml / gautschi.yml
  - "**Do NOT** assume `ai`, `smallgpu`, `highmem`, `a10`/`a30`/`a100-*`, or `training` partitions — those belong to other RCAC clusters. Scholar's partitions are `cpu`, `gpu`, `spark-batch`, and `spark-interactive`."
```

**Scholar facts that have no template slot.** These render nowhere today. `anti_patterns`
only render under `slurm.md` → *Prohibitions*.

- Home on Scholar is not your research-cluster home. It is "exclusive to Scholar cluster
  front-end hosts and compute nodes", with no automatic sync. Copy files deliberately
  (`faqs.md` → *Does Scholar have the same home directory as other clusters?*). This belongs
  in `filesystems.md`.
- The guide names `/class` and `/apps` as shared filesystems (`scholar-spark.md` → *Layout*),
  but documents neither one's purpose, quota or durability. Verify live before mentioning
  them.
- Teaching context (`overview.md` → *Scholar Overview*; `accounts.md` → *Obtaining an
  Account*):
  - Access comes from class registration (semester and CRN), and instructors or TAs are added
    by the faculty member.
  - Access is tied to the Scholar mailing list (`faqs.md` → *Can you remove me from the
    Scholar mailing list?*).
  - The only statement that Scholar is "not intended for production research workloads"
    comes from outside the user guide (`docs/workshops/hpc_exchange/week2/clusters.md` →
    *Scholar (Teaching Resource)*).
- Login supports Purdue MFA or SSH keys (`accounts.md` → *SSH*, *SSH Client
  Software*). The guide also documents a ThinLinc desktop (`desktop.scholar.rcac.purdue.edu`)
  and Gateway/Open OnDemand (`gateway.scholar.rcac.purdue.edu`), which offers Jupyter,
  RStudio, MATLAB, Compute Desktop, Windows Desktop, and the Spark apps (`index.md`;
  `gateway/interactive_apps.md`; `scholar-spark.md` → *Interactive Open OnDemand
  Applications*).
- Job defaults: the default walltime is 30 minutes, and by default jobs share nodes with other
  jobs (`run_jobs/submit_script.md` → *Submitting the script as a job*).
- Spark conda environments go to `~/.conda/envs_aarch64/` by default (`scholar-spark.md` →
  *Example: Pytorch Conda Environment*). Keep `x86_64` and `aarch64` binaries in separate
  directories (*How can I separate my x86_64 applications from aarch64 applications?*).
- The guide contains no academic-integrity, course-use, or end-of-semester data-retention
  policy. It only links an external Faculty Guide (`overview.md` → *Scholar
  Specifications*). Do not encode one.

## Template audit

Key: **OK** = confirmed (cite); **Scholar-equiv** = Scholar has a different equivalent;
**Unconfirmed** = not stated in docs, verify live; **Wrong** = contradicts the Scholar guide or
would assert something Scholar lacks (R2).

| Template:line | Claim / command | Verdict | Evidence / Scholar equivalent |
|---|---|---|---|
| unix:3 | `runs **{{ os }}**` | **Unconfirmed / breaks** | OS not stated for the x86_64 nodes. Spark: Ubuntu 24.04 LTS (`scholar-spark.md` → *Specifications*). `os: null` renders "None"; the template needs a null branch. |
| unix:9 | `{{ login_host }}` = `scholar.rcac.purdue.edu` | OK | `accounts.md` → *SSH Client Software* |
| unix:9–11 | "one of several shared front-end nodes" | OK | `overview.md` → *Scholar Overview* (6 login servers); `gateway/cluster_tools.md` → *Shell*. Note: 3 front-ends have a V100 (`overview.md` → *Scholar Front-Ends*). Spark has no front-ends; `spark-interactive` takes that role (`scholar-spark.md` → *Layout*). |
| unix:13–15 | no heavy work on login nodes | OK (wording) | `run_jobs/index.md` → *Running Jobs* admonition. "May be killed by administrators" is **Unconfirmed**; the guide only links the front-end use policy (`gateway/cluster_tools.md`). |
| unix:21 | no `sudo`/root | Unconfirmed (generic) | Not stated in the Scholar guide. Low risk. |
| unix:30, fs:51 | `myquota` | OK | `storage/storage_quota.md` → *Checking Quota* |
| unix:31 | `slist` — "accounts you can charge and their balances" | **Wrong wording** | `slist` exists. It shows queue status: nodes allocated and available, max walltime (`run_jobs/queues.md` → *Scholar Queue*), and which accounts you can use (`run_jobs/mpi.md` note). Balances and charging are not stated. |
| unix:32 | `sfeatures` | OK (mention only) | `run_jobs/gpu.md` → last paragraph ("output of `sfeatures` command") |
| unix:33 | `module avail` / `module list` | OK | `software.md` → *Find available apps in the terminal* |
| fs:8 | `/home/$USER` (`$HOME`) | OK | `storage/home_directory.md`; `storage/environment_variables.md` |
| fs:10 | home tech + snapshots | OK (shared snippet) | `home_directory.md` → *Home Directory*, *Lost File Recovery*; `storage.md` → *Storage Options*. Add: home is exclusive to Scholar (`faqs.md`). |
| fs:11–12 | home is medium-performance | OK | `home_directory.md` → *Performance* |
| fs:15, 18, 54 | `{{ scratch_path }}/$USER`, `$RCAC_SCRATCH` | OK | `storage/scratch_space.md`; `storage/environment_variables.md` |
| fs:17 | scratch tech null → generic text | OK | `scratch_space.md` → *Performance* |
| fs:19 | `findscratch` | OK | `scratch_space.md` → *Scratch Space* |
| fs:20–21 | purged after 60 days (access and content modification) | OK (shared snippet) | `scratch_space.md` danger admonition. The clause "touching metadata does not protect a file" is **Unconfirmed**: Scholar does not render the purge-policy snippet that says it. |
| fs:21–22 | `purgelist` | **Unconfirmed** | The Scholar guide never mentions `purgelist`. Verify live, or render it conditionally. |
| fs:24–25 | "move to Data Depot or Fortress" | Partly unconfirmed | Both are documented (see below). The guide does not say whether class/student accounts have a Depot space or a Fortress account. |
| fs:31–34 | `/tmp` node-local, ephemeral | OK | `storage/tmp_directory.md` |
| fs:40–41 | Depot is "group project space on GPFS (under `/depot`)" | Partly | The `/depot` path is confirmed (`scholar-spark.md` → *Layout*; `apptainer_example.md`). The guide does not state GPFS for Depot or student entitlement. |
| fs:44–45 | Fortress is HPSS; `hsi`, `htar` | OK | `storage/long_term_storage.md`; `storage/hsi.md`; `storage/htar.md`. Fortress needs an account ("how to obtain an account"). |
| fs (missing) | `/class`, `/apps` | Unconfirmed | Named only in `scholar-spark.md` → *Layout*; purpose undocumented. |
| lmod:8–12 | `module avail/spider/load/list/purge` | OK | `software.md` → *View module prequisites*, *Load the module*. `purge` is standard Lmod. |
| lmod:20 | toolchain branch | n/a | `toolchain: null` (none stated) |
| lmod:23–24 | "where provided, `module load rcac`" | Partly / **wrong on Spark** | `rcac` is named only as an `x86_64` module tree. Its modules "will not work on Spark nodes", which need `module load modtree/spark` (`scholar-spark.md` → *Software and Applications*). Nothing documents `rcac` as the recommended-stack loader. |
| lmod:29–31 | no `apt`/`yum`/`sudo` | Unconfirmed (generic) | Not stated; low risk |
| lmod:35–36 | prefer `anaconda` modules | OK | `software.md` listing: `anaconda/2024.10-py312`, `anaconda/2025.06-py313 (D)`. The Python example uses `module load conda` (`run_jobs/python_example.md` via `snippets/apps/python.md`). On Spark, the `modtree/spark` tree has `anaconda/2025.12-py313` and `conda`. |
| slurm:8–11 | "MUST set both `-A` and `-p`"; also `-q` | OK, with caveat | Partition required: `queues.md` → *Scholar Partitions*. Account `scholar`: `queues.md` → *Scholar Queue* ("All jobs ... should utilize the `scholar` queue"). Several examples omit `-A` (`gpu.md`, `serial_jobs.md`, `mpi.md`, `submit_script.md`), so the docs are inconsistent; the strict rule is the safe one. `-q` is optional because `normal` is the default. |
| slurm:13 | `slist` for accounts and balances | **Wrong wording** | Same as unix:31 |
| slurm:15 | memory proportional to cores | Partly | Stated only for Gateway Jupyter (`gateway/interactive_apps.md` → *Jupyter Notebook*). Not stated for batch jobs. |
| slurm:27–29 | `normal` default, "charged against your account" | Partly | Default confirmed (`queues.md` → *Normal (default)*, max 4 h). Charging is not stated anywhere for Scholar. |
| slurm:30–41 | `standby`/`preemptible`/`training` blocks | n/a, plus **gap** | Scholar has none of them. The template has **no branch for `long` or `debug`**, so Scholar's QOS section would render only `normal`. Needs branches, or a data-driven `qos` list carrying descriptions. |
| slurm:45–47 | `sbatch`, `squeue -u`, `scontrol show job`, `scontrol hold/release`, `scancel`, `sinteractive`, `srun` | OK | `submit_script.md`; `monitoring_job.md`; `holding_job.md`; `cancelling_job.md` (snippet); `interactive_jobs.md`; `queues.md` examples; `mpi.md` |
| slurm:54–55 | "Do NOT write `-A standby` — `standby` is a QOS (`-q standby`)" | **Wrong (R2)** | Asserts a `standby` QOS that Scholar lacks (`queues.md` → *Quality of Service (QoS)*). Must be conditional on `'standby' in qos`. |
| slurm:58 | "valid sets are listed above" | **Wrong until fixed** | False while `long`/`debug` do not render |
| policies:4 | "charged to their allocation" | **Unconfirmed** | Scholar access is class-based (`accounts.md`). The guide documents no allocation or charging. |
| policies:8–9 | Purdue AUP + "approved allocations and project scope" | Partly | The front-end use policy is linked (`gateway/cluster_tools.md`). The Purdue AUP is not named in the Scholar guide. "Allocations/project scope" does not fit class accounts. |
| policies:26–28 | "Watch allocation balances with `slist`" | **Wrong wording** | As unix:31. No balances are documented. |
| policies:37–40 | Apptainer auto-mounts `/home`, `/depot`, `/scratch` (writable) | OK, plus extra mounts | `run_jobs/apptainer_example.md` → *Purdue Cluster Specific Notes*: `/home/$USER`, `/apps`, `/scratch`, `/depot`, `/etc/resolv.conf`, `/etc/hosts`, "the same as outside the container". "Writable" is implied, not stated. Apptainer on Spark (`aarch64`) nodes is not stated. |
| policies:44–45 | `rcac-help@purdue.edu` | Unconfirmed | Not in the Scholar guide; RCAC-wide address |

## Open questions

1. **OS of the x86_64 front-ends and compute nodes.** Not in the guide. Either verify it live
   or add a null branch to `unix.md.j2`. Spark is Ubuntu 24.04 LTS / `aarch64`, so the cluster
   is mixed. The `os` line should probably say so.
2. **Depot and Fortress for students.** `/depot` is mounted and Fortress is documented, but
   neither is shown to be available to class accounts. If students have neither, the
   "move it to Data Depot or Fortress" line misleads. Consider a third mode: "copy anything
   you want to keep off Scholar".
3. **Scratch retention.** The 60-day figure comes from the shared snippet. The guide is
   silent on end-of-semester account removal or scratch cleanup. Is `purgelist` installed on
   Scholar?
4. **`/class` filesystem.** What is it, who can write to it, and is it durable? Named only in
   `scholar-spark.md`.
5. **Accounts.** Is `scholar` the only Slurm account, or do some classes get course-specific
   accounts? `mpi.md` says "use `slist` to determine which queues are available to you".
   The Spark page carries unresolved author TODO comments about Spark accounts and about
   which partitions accept interactive versus batch jobs.
6. **QOS × partition matrix.** The guide does not say which QOS each partition accepts (for
   example, `long` or `debug` on `gpu` or `spark-*`). It gives no Spark or GPU time limits
   and no way to request a MIG slice on `scholar-h`/`scholar-i`.
7. **Template changes needed for Scholar (generator/template owner):**
   - a null `os` branch;
   - `long` and `debug` QOS branches, or a data-driven QOS description;
   - a conditional `-A standby` prohibition;
   - `slist` wording without "balances";
   - `policies.md` wording without "allocation"/"charged";
   - a conditional `purgelist`;
   - a per-topic notes slot (filesystems: home exclusive to Scholar, `/class`; lmod: Spark
     `modtree/spark`; policies: teaching context).
8. **Defects in the Scholar guide** (do not copy them into context):
   - "Gautschi" appears in `accounts.md` (*Thinlinc Web Client*, *Gateway / OnDemand*),
     `run_jobs/index.md`, `run_jobs/simple_job.md` and `run_jobs/apptainer_example.md`.
   - "20 cores per node" appears in `submit_script.md`, `interactive_jobs.md`,
     `multiple_node.md` and `mpi.md`. It contradicts `overview.md`: `scholar-a` has 128
     cores and `scholar-b` has 64.
   - `gateway/jobs.md` says new jobs default to the "standby queue", but Scholar has no
     standby.
   - `scholar-spark.md` shows `-P spark-batch`; the partition flag is lowercase `-p`.
   - `submit_script.md` has `-nodes=1`, which should be `--nodes=1`.
9. **Teaching-context policy.** The guide has no academic-integrity or course-use rule for AI
   agents. Should the Scholar context carry one, and from which source? Do not invent one.
