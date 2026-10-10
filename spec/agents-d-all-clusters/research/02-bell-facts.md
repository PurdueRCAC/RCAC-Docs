# 02 — Bell facts for `bell.yml` and template audit

Source: `docs/userguides/bell/**` plus the shared snippets and `main.py` macros those pages
render (a snippet counts as a Bell fact only when a Bell page includes it). All paths below are
relative to the repo root.

## Summary

- Most of the schema is confirmed for Bell: login host `bell.rcac.purdue.edu`, Rocky Linux 8,
  `/scratch/bell`, GPFS home with the 7-day/4-week/3-month snapshot schedule, Depot and
  Fortress, GCC 14.2.0 + OpenMPI 5.0.5, QOS `normal` and `standby` (standby max 4 h), and four
  partitions `cpu`, `highmem`, `gpu`, `multigpu`.
- The Bell guide confirms these: `slist`, `sfeatures`, `findscratch`, `$RCAC_SCRATCH`,
  `myquota`, `sinteractive`, `hsi`/`htar`, the `-A` + `-p` rule, Apptainer and its
  overlay paths. It adds one tool, `showpartitions`.
- **Scratch purge age is contradictory.** The Bell scratch page says 60 days. Three other
  site pages and the `scratch_purge()` macro say 30 days on Bell. Leave `purge_days` null.
  The template cannot render null yet (see audit).
- **`purgelist` is not stated for Bell.** The snippet that documents it is not rendered on any
  Bell page.
- **Bell GPUs are AMD (MI50; the multigpu node is MI50 or MI60 depending on the page).** No
  NVIDIA/CUDA. ROCm containers are provided via `module load rocmcontainers`.
- The multigpu node's specs contradict across pages (CPU, core count, GPU model, memory).
  Describe it without the contested numbers.
- Bell's own pages say it retires in 2026. A workshop page says Fall 2026. Today is 2026-10-09:
  confirm Bell is still in service before publishing context for it.

## Proposed `bell.yml`

```yaml
# Agentic-AI context data model for Bell.
# Edit this file (not docs/snippets/agentic-ai/bell/**) and re-run
# tools/generate_agent_context.py. Facts verified against docs/userguides/bell/.
cluster: bell
title: Bell
# accounts.md -> accounts_md_snippet() (main.py), "SSH Client Software":
#   `ssh username@bell.rcac.purdue.edu`
login_host: bell.rcac.purdue.edu
# overview.md, "Bell Specifications": "Bell nodes run Rocky Linux 8"
os: Rocky Linux 8
# storage/scratch_space.md -> snippets/scratch_space.md (`findscratch` -> /scratch/bell/myusername);
# storage/environment_variables.md -> RCAC_SCRATCH = /scratch/bell/myusername
scratch_path: /scratch/bell

filesystems:
  home:
    # storage/home_directory.md -> snippets/home_directory.md: "physically resides on a GPFS storage system"
    tech: GPFS
    # storage/recover.md, "Lost File Recovery": nightly for 7 days, weekly for 4 weeks, monthly for 3 months
    snapshots: nightly snapshots kept for 7 days, weekly for 4 weeks, and monthly for 3 months (recoverable)
  scratch:
    # snippets/scratch_space.md, "Performance": only "high-performance, large-capacity parallel
    # filesystem"; technology not stated -> null.
    tech: null
    # CONTRADICTORY. storage/scratch_space.md (rendered on Bell) says 60 days.
    # These say 30 days on Bell: workshops/hpc_exchange/week4/storage-transfer.md,
    # workshops/genomics_exchange/fall2026/session2/index.md,
    # lifesciences/guides/globus-scheduled-transfers.md, and main.py scratch_purge()
    # (which maps bell -> 30 days but is not called by any Bell page).
    # Leave null; the template needs a null branch (see audit row F4).
    purge_days: null
  # storage.md, "Storage Options" lists depot; faqs.md "My SSH connection hangs" names the
  # `depot` filesystem on front-ends; gateway/files.md links Data Depot.
  depot: true
  # storage/long_term_storage.md (Fortress); faqs.md "Can I access Fortress from Bell?" -> Yes,
  # via HSI, HTAR or Globus (not mounted).
  fortress: true

# overview.md, "Bell Specifications": recommended "GCC 14.2.0" and "OpenMPI 5.0.5".
# Consistent with software.md -> module_system(): default GCC + OpenMPI loaded at login.
toolchain:
  compiler: GCC 14.2.0
  mpi: OpenMPI 5.0.5

scheduler:
  # run_jobs/slurm/queues.md, "CPU Partition" and "Quality of Service (QOS)": standby up to four hours
  standby_max_hours: 4

# run_jobs/slurm/queues.md, "Quality of Service (QOS)": every user and account has `normal`, `standby`.
qos:
  - normal
  - standby

# run_jobs/slurm/queues.md, "Partitions" + "Job Submission Matrix"; names also in
# run_jobs/slurm/submit_script.md `showpartitions` output (the aggregate `bell-nodes` row is
# not a submission target in any example, so it is omitted).
partitions:
  - name: cpu
    use: "CPU jobs (128-core nodes, 256 GB)"
    notes: "QOS `normal` or `standby`; up to 2 weeks (`standby` max 4 h)"
  - name: highmem
    use: "Large-memory jobs (1 TB nodes)"
    notes: "QOS `normal` only; up to 24 h; job must use more than 64 of 128 cores"
  - name: gpu
    # queues.md "GPU Partition" and overview.md agree: 2x AMD MI50 per node, 128 cores.
    use: "AMD GPU jobs (2× MI50 per node)"
    notes: "QOS `normal` only; up to 24 h; at most 2 GPUs at once; request cores proportional to GPUs used"
  - name: multigpu
    # Specs contradict: overview.md says 6x MI50, 48 cores, 384 GB; queues.md "Multi-GPU
    # Partition" says 6x MI60, 96 cores, 354 GB; submit_script.md showpartitions says 48 cores,
    # 353 GB. Only "single node, six AMD GPUs" is consistent.
    use: "Multi-GPU jobs (one node, 6 AMD GPUs)"
    notes: "QOS `normal` only; up to 24 h; request cores proportional to GPUs used"

anti_patterns:
  # Other clusters' names (gautschi.yml, gilbreth.yml); Bell set is queues.md "Partitions".
  - "**Do NOT** assume `ai`/`smallgpu`/`a10`/`a30`/`a100-*`/`training` partitions or a `preemptible`/`training` QOS. Those belong to other RCAC clusters. Bell's partitions are `cpu`, `highmem`, `gpu` and `multigpu`, and its QOS are `normal` and `standby`."
  # overview.md "Bell Specifications"; faqs.md "How is Bell different..."; run_jobs/examples/apps/rocmcontainers.md
  - "**Do NOT** build or run CUDA/NVIDIA code for Bell GPU jobs. Bell's GPUs are AMD; use ROCm software (for example `module load rocmcontainers`)."
  # queues.md "Table Summary of Changes"
  - "**Do NOT** use the old `-A highmem`, `-A gpu`, `-A multigpu` or `-A standby` syntax. These are partitions (`-p`) or a QOS (`-q standby`), not accounts."
  # faqs.md "Why cannot I use --mem=0 when submitting jobs?"
  - "**Do NOT** request unlimited memory with `--mem=0`; set an explicit value (use `--exclusive` for a whole node)."
  # run_jobs/examples/slurm/{batch,directives,mpi,multiple,interactive}.md show `-A accountname` with no `-p`
  - "**Do NOT** copy the generic Bell example scripts that pass only `-A`. Add the partition (`-p cpu`, etc.) as `queues.md` requires."
```

## Template audit

Status key: **OK** = confirmed for Bell (cite) · **EQUIV** = Bell has a different equivalent ·
**VERIFY** = not stated in the Bell docs, verify live · **CONFLICT** = docs disagree.

| # | Template / line | Claim | Status | Source / note |
|---|---|---|---|---|
| U1 | `unix.md.j2:3` | OS = `{{ os }}` | OK | `overview.md` "Bell Specifications": Rocky Linux 8 |
| U2 | `unix.md.j2:9` | `{{ login_host }}` lands on one of several shared front ends | OK | `accounts.md` (macro) `ssh username@bell.rcac.purdue.edu`; `overview.md` "Bell Front-Ends": 8 nodes |
| U3 | `unix.md.j2:13-15` | No heavy work on login nodes | OK | `run_jobs/index.md` "Running Jobs" `!!! important` |
| U4 | `unix.md.j2:21` | No `sudo`/root | VERIFY (wording) | Not stated explicitly in the Bell guide; the module system is the documented install path (`software.md`). Safe as a prohibition |
| U5 | `unix.md.j2:30` | `myquota` | OK | `storage/storage_quota.md` "Checking Quota"; `faqs.md` "/usr/bin/xauth…" |
| U6 | `unix.md.j2:31` | `slist` | OK | `run_jobs/slurm/queues.md` "Accounts"; `run_jobs/slurm/submit_script.md` |
| U7 | `unix.md.j2:32` | `sfeatures` | OK | `run_jobs/examples/slurm/specific.md` (snippet, Bell node names) |
| U8 | `unix.md.j2:33` | `module avail` / `module list` | OK | `software.md` "Find available apps"; module_system macro |
| U9 | (not in template) | `showpartitions` lists partitions | EQUIV / addition | `run_jobs/slurm/submit_script.md`: "To check the available partitions on Bell, you can use the `showpartitions`". Optional grounding command |
| F1 | `filesystems.md.j2:8-13` | Home `/home/$USER`, GPFS, snapshots | OK | `storage/home_directory.md` (snippet); `storage/recover.md` "Lost File Recovery" |
| F1a | (not in template) | Bell home is not shared with other RCAC clusters | Bell-specific gap | `faqs.md` "Does Bell have the same home directory as other clusters?" There is no slot for this in the template (see Open questions) |
| F2 | `filesystems.md.j2:15` | Scratch `/scratch/bell/$USER`, `$RCAC_SCRATCH` | OK | `storage/scratch_space.md`, `storage/environment_variables.md` |
| F3 | `filesystems.md.j2:19` | `findscratch` | OK | `storage/scratch_space.md` (snippet) |
| F4 | `filesystems.md.j2:20` | Purged after N days | CONFLICT | 60 days on `storage/scratch_space.md`; 30 days on Bell per workshops/lifesciences pages and `main.py` `scratch_purge()`. With `purge_days: null` the template renders "purged after None days". The template needs `{% if filesystems.scratch.purge_days %}…{% else %}purged after a period of inactivity; verify the current age live{% endif %}` |
| F5 | `filesystems.md.j2:20-21` | Purge by access + content-modification; metadata touch doesn't protect | Partly OK | access/modify criterion: `storage/scratch_space.md` danger box. "Metadata does not protect" is only in `snippets/scratchpurge.md`, which no Bell page renders: VERIFY (or rely on the linked policy) |
| F6 | `filesystems.md.j2:21-22` | `purgelist` | VERIFY | Documented only in `snippets/scratchpurge.md`, which no Bell page renders (Anvil's policies call it and strip it). The Bell guide has no mention. Omit for Bell or gate on a new flag |
| F7 | `filesystems.md.j2:24-25` | Move durable data to Depot or Fortress | OK | `storage.md` "Storage Options"; `storage/scratch_space.md` |
| F8 | `filesystems.md.j2:31-34` | `/tmp` node-local, ephemeral | OK | `storage/tmp_directory.md` (snippet) |
| F9 | `filesystems.md.j2:40-41` | Depot is GPFS, under `/depot` | OK (cross-guide) | `/depot` path: `run_jobs/examples/apps/apptainer.md` overlay list. GPFS: `userguides/depot/overview.md` ("globally available on all RCAC systems"), not the Bell guide |
| F10 | `filesystems.md.j2:44-45` | Fortress via `hsi`/`htar` | OK + caveat | `storage/hsi.md`, `storage/htar.md`, `faqs.md` "Can I access Fortress from Bell?". Caveat: Bell has its own home, so keytab errors can occur. The workaround (`fortresskey` on `data.rcac.purdue.edu`, copy `~/.private`) is in `faqs.md` "HSI/HTAR: Unable to authenticate…" |
| F11 | `filesystems.md.j2:51-55` | `myquota`; use `$HOME`, `$RCAC_SCRATCH` | OK | `storage/storage_quota.md`; `storage/environment_variables.md` |
| L1 | `lmod.md.j2:3` | Lmod, not system package manager | OK | `software.md` -> `module_system()` "uses **Lmod**" |
| L2 | `lmod.md.j2:8-12` | `module avail/spider/load/list/purge`, `(D)` default | OK | `software.md` (module_system macro; `(D)` in the `module avail` sample) |
| L3 | `lmod.md.j2:19-21` | Toolchain sentence | OK | `overview.md`: GCC 14.2.0 + OpenMPI 5.0.5. Renders "GCC 14.2.0 with OpenMPI 5.0.5" |
| L4 | `lmod.md.j2:24` | `module load rcac` | n/a / VERIFY | Renders only when `toolchain` is null, so it does not render for Bell. The Bell guide never mentions an `rcac` module |
| L5 | `lmod.md.j2:35-36` | "prefer the `anaconda` modules" | CONFLICT (naming) | `software.md` `module avail` sample lists `anaconda/2024.10-py312`, `anaconda/2025.06-py313 (D)`. `run_jobs/examples/apps/python.md` and `python/conda.md` say `module load conda` / `module spider conda`. Suggest template wording "the `conda`/`anaconda` modules (check with `module spider`)" |
| L6 | (module_system macro) | "Cuda on GPU-nodes" auto-loaded | Note | The generic macro text on `software.md` says this, which does not fit AMD GPUs. The template does not repeat it, so no action |
| S1 | `slurm.md.j2:8-11` | Four parts: resources, account, QOS, partition | OK | `run_jobs/slurm/queues.md` intro |
| S2 | `slurm.md.j2:9-10` | MUST set both `-A` and `-p` | OK | `queues.md` "Partitions" ("the desired partition must also be specified") and "Accounts" ("you must explicitly define the account") |
| S3 | `slurm.md.j2:11` | Also set QOS | OK (soft) | `submit_script.md` says specify QOS; `queues.md` note says `normal` is the default and need not be specified. "Also set" wording is compatible |
| S4 | `slurm.md.j2:11` | Always a time limit | OK | `submit_script.md` "General Information": default 30 min wall time |
| S5 | `slurm.md.j2:13` | `slist` for accounts/balances | OK | `queues.md` "Accounts" |
| S6 | `slurm.md.j2:15` | Memory proportional to cores | OK | `queues.md` each partition (~2 GB/core cpu, ~8 GB highmem, ~3 GB gpu, ~3.5 GB multigpu) |
| S7 | `slurm.md.j2:28` | `normal` default, charged | OK | `queues.md` "Quality of Service (QOS)" |
| S8 | `slurm.md.j2:31-32` | `standby` not charged, max 4 h, `-q standby` | OK | `queues.md` "CPU Partition" and QOS section. `cpu` partition only (highmem/gpu/multigpu accept `normal` only) |
| S9 | `slurm.md.j2:34-41` | `preemptible`, `training` blocks | n/a | Not in Bell `qos`, so they do not render. Correct |
| S10 | `slurm.md.j2:45-47` | `sbatch`, `squeue -u`, `scontrol show job`, `hold`/`release`, `scancel`, `srun` | OK | `submit_script.md`; `monitoring_job.md` (snippet); `holding_job.md` (snippet); `cancelling_job.md` (snippet); `examples/slurm/mpi.md` (`srun`/`mpiexec`) |
| S11 | `slurm.md.j2:46` | `sinteractive` | OK + caveat | `run_jobs/examples/slurm/interactive.md` (snippet). Its example passes only `-A`; whether `sinteractive` also needs `-p` is not stated: VERIFY |
| S12 | `slurm.md.j2:54-55` | `-A standby` is wrong | OK | `queues.md` "Table Summary of Changes" and QOS section ("replaces the previous `-A standby`") |
| S13 | `slurm.md.j2:58` | Valid partition/QOS sets listed above | OK | `queues.md`. Omit `bell-nodes` from `showpartitions` (aggregate row) |
| S14 | (not in template) | Standby jobs cannot get walltime extensions | Optional | `faqs.md` "Can I extend the walltime on a job?" |
| P1 | `policies.md.j2:8-9` | Purdue AUP and RCAC policies | OK (generic) | `faqs.md` "How is my Data Secured on Bell?" links RCAC policies |
| P2 | `policies.md.j2:13-15` | No sensitive/regulated data without approval | OK, Bell is more specific | `faqs.md` "How is my Data Secured on Bell?": L1/L2 only, not L3 (HIPAA), L4 (ITAR) or CUI. Template wording is compatible |
| P3 | `policies.md.j2:27-28` | `slist` for balances | OK | `queues.md` "Accounts" |
| P4 | `policies.md.j2:37` | Apptainer (not Docker) | OK / VERIFY (Docker) | `run_jobs/examples/apps/apptainer.md`. The guide never says Docker is unavailable, only that Apptainer is "like Docker but tuned for HPC" |
| P5 | `policies.md.j2:38` | Auto-mounts `/home`, `/depot`, `/scratch` | OK | `apptainer.md` "Purdue Cluster Specific Notes": `/home/$USER`, `/apps`, `/scratch`, `/depot`, plus `/etc/resolv.conf` and `/etc/hosts` |
| P6 | `policies.md.j2:38-39` | Those mounts are writable | VERIFY | The docs say the paths are "present and the same as outside the container". Writability is not stated |
| P7 | `policies.md.j2:45` | Report to rcac-help@purdue.edu | OK (site-wide) | Not in the Bell guide (links rcac.purdue.edu/help). Stated in `docs/agentic-ai/shared_context/index.md` |

## Open questions

1. **Is Bell still in service?** `overview.md` gives "Retires in 2026" for every node class.
   `workshops/hpc_exchange/week2/clusters.md` says "Fall 2026". Today is 2026-10-09. Confirm
   before shipping Bell context and adding a *Using AI Agents* chapter.
2. **Scratch purge age, 60 or 30 days?** Bell's scratch page says 60. Three site pages and the
   `scratch_purge()` macro say 30. Fix the source page and set `purge_days`, or keep null and
   add a null branch to `filesystems.md.j2`.
3. **Does `purgelist` exist on Bell?** Not documented on any Bell page. Verify live. Until then
   the template needs a way to omit it, e.g. a `filesystems.scratch.purgelist` flag. The Anvil
   research will likely need the same flag.
4. **Bell home is separate from other clusters' homes** (`faqs.md`). Does the filesystems
   template need a note for this (affects `hsi`/`htar` keytabs and copying dotfiles)? There is no
   schema slot for it today.
5. **Multigpu node specs** contradict across `overview.md`, `queues.md` and the
   `showpartitions` sample (MI50 vs MI60; 48 vs 96 cores; 384/354/353 GB). The proposed YAML
   avoids them. A doc fix is out of scope here.
6. **CPU partition size** contradicts too (448 Bell-A nodes in `overview.md`, 488 in
   `queues.md`, 480 in the `cpu` row of `showpartitions`). The YAML omits node counts.
7. **GPU partition job limit**: `queues.md` text says 8 jobs submitted at once. The Job
   Submission Matrix says 1 job per account. The YAML omits it.
8. **Python module name**: `conda` (python pages) vs `anaconda/*` (`software.md` listing). The
   template text should not name only `anaconda`.
9. **`sinteractive` and `-p`**: does `sinteractive` require a partition on Bell as `sbatch`
   does? Verify live.
10. **Apptainer mounts writable / Docker absent**: neither is stated in Bell docs. Same
    question as for the other clusters, so it belongs in the shared template, not `bell.yml`.
