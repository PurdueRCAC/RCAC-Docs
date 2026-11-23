# Research 06: per-cluster job-script headers and the validation envelope

- **Cycle:** workflow-automation (PLAN step)
- **Serves:** R7 (tier-1 job script), R13 (build), R15 (HPC accuracy); GOAL gate 2026-11-22
  (one worked script per example, `#SBATCH` and module lines in per-cluster content tabs, shared
  body, validation on one or two clusters).
- **Date:** 2026-11-22
- **Sources:** this repository's cluster user guides, the generated software catalog, the
  generated per-cluster agent-context snippets (`docs/snippets/agentic-ai/<cluster>/agents.d/`),
  the HyperShell repository (`pyproject.toml`, `docs/install.rst`, `docs/cli/*.rst`,
  `docs/_include/*.rst`, git tags), and PyPI. Cluster facts from a check on the login nodes
  (2026-11-22) are labelled as such. Nothing here was re-derived on a cluster.

## 1. Which clusters get a tab

### Evidence

| Cluster | Catalog row (`docs/software/apps_md/hypershell.md`) | Login-node check 2026-11-22 | User guide in nav | Notes |
|---|---|---|---|---|
| Anvil | 2.0.2, 2.2.0, 2.4.0, 2.5.1, 2.6.0, 2.6.2, 2.6.5, 2.7.0 (D) | 2.0.2 through 2.7.0 | yes (`mkdocs.yml:101`) | also an old `hyper-shell/2.0.2` module (`docs/software/apps_md/hyper-shell.md`) |
| Gautschi | develop, 2.5.2, 2.6.5, 2.7.0 (D) | develop, 2.5.2, 2.6.5, 2.7.0 | yes (`mkdocs.yml:136`) | only cluster with a `develop` build |
| Negishi | 2.0.2, 2.1.0, 2.4.0, 2.5.1, 2.5.2, 2.6.0, 2.6.2, 2.6.5, 2.7.0 (D) | not checked | yes (`mkdocs.yml:160`) | AMD MI210 GPUs, no NVIDIA |
| Gilbreth | 2.5.2 (D) only | not checked | yes (`mkdocs.yml:148`) | GPU-only cluster |
| Scholar | 2.7.0 (D) | not checked | yes (`mkdocs.yml:172`) | instructional cluster, `-A scholar` |
| Hammer | no row | not checked | yes (`mkdocs.yml:207`) | no HyperShell in catalog; exclude |
| **Bell** | **no row** | not checked | **no** | see below |

**Bell is not a documented cluster on this site.** There is no `docs/userguides/bell/` directory,
no Bell entry in `mkdocs.yml` `nav:` (a grep for "bell" in `mkdocs.yml` returns nothing), and no
Bell row in the HyperShell (or any) catalog page. Bell appears only in legacy example output in
shared snippets (`docs/snippets/examples/slurm/*.md`, e.g. `bell-a010.rcac.purdue.edu`), in Life
Sciences guides that name it in passing (`docs/lifesciences/guides/nextflow.md:21`,
`hpc-orientation.md:35`), and in a commented-out workshop table that reads
`|Bell | Limited (AMD) | Yes | | Reties Fall 2026|` (`docs/workshops/hpc_exchange/week2/clusters.md:80`).
A Bell tab would have no user guide to link, no partition/QOS documentation to cite, and no
catalog version to state, so it cannot meet R15.

**Gilbreth version conflict.** The generated catalog says Gilbreth carries only `hypershell/2.5.2
(D)`. The Gilbreth software page (`docs/userguides/gilbreth/software.md:32-61`) shows
2.5.2/2.6.5/2.7.0 with `module load hypershell/2.7.0`, but that block is byte-identical to the
Gautschi and Scholar software pages (an illustrative template, not Gilbreth output). Trust the
catalog until a live check says otherwise. Implication for the version admonition: on Gilbreth
the default module is four minor releases behind the 2.9.0 the guide documents, so the
admonition must (a) tell readers module versions differ by cluster, (b) show `hs --version` as
the check, and (c) lean on the per-feature minimum-version notes (R6). Every 2.9.0-only feature
(relay, zones, `--restart FILE` de-duplication, `--repeat`/`--update`, `--from-json`,
`--advertise`; see `docs/cli/cluster.rst:18-110` in the HyperShell repository) is unavailable
from today's modules on every cluster (all top out at 2.7.0 or below).

### Recommended tab list

**Anvil, Gautschi, Negishi, Gilbreth, Scholar** (five tabs), with two scoping rules:

- **Gilbreth appears only in GPU examples.** Every Gilbreth partition is a GPU partition
  (`a10`, `a30`, `a100-40gb`, `a100-80gb`, `training`; `docs/userguides/gilbreth/run_jobs/queues.md:36-125`),
  and the site's own cluster table calls it "Not for CPU workloads"
  (`docs/workshops/hpc_exchange/week2/clusters.md:82`, commented out). A CPU-only tier-1 example
  should either omit the Gilbreth tab or carry a one-line tab note pointing to the GPU page.
- **Negishi is omitted from NVIDIA-specific GPU multiplexing (MPS/MIG) examples.** Its `gpu`
  partition is 3x AMD MI210 per node (`docs/userguides/negishi/run_jobs/queues.md:70-81`). A
  plain "many tasks per GPU" example that does not depend on NVIDIA tooling may keep it.
- Bell: drop, with the evidence above recorded in PLAN. Hammer: no HyperShell; drop.

Tab order: match the FAQ precedent (`docs/faqs.md:90` onward uses `=== "Anvil"` first), then
alphabetical, or GOAL order minus Bell (Anvil, Gautschi, Negishi, Gilbreth, Scholar). Content tabs
are already enabled (`mkdocs.yml:940-941`, `pymdownx.tabbed` with `alternate_style: true`).

## 2. Per-cluster `#SBATCH` conventions

### Common to all five

- Slurm everywhere. Account flag on the site: both `-A` and `--account=` are documented on every
  guide. Placeholders in use: `myallocation` (Anvil `jobs.md:192`, Gautschi `directives.md:26`,
  Negishi `directives.md:25`, shared uv snippet `docs/snippets/examples/apps/python/uv.md:169`),
  `accountname` (Gilbreth throughout), `myLabAccount` (Gautschi/Negishi
  `creating_the_submission_script.md`). **Recommend `myallocation` everywhere except Scholar**,
  where the documented account is literally `scholar` (`docs/userguides/scholar/run_jobs/queues.md:18`).
- `standby` is a QOS (`-q standby`), never an account, on Gautschi, Negishi, Gilbreth
  (queues pages; agent snippets' Prohibitions). Several older example pages still show
  `#SBATCH -A standby` (Gautschi `mpi_jobs.md:94`, Gilbreth `mpi_jobs.md:94`, Negishi
  `mpi_jobs.md:29,81`) and Gautschi pages still show `--partition=a10`, a Gilbreth partition
  (Gautschi `gpu_jobs.md:41`, `openmp_jobs.md:49`, `mpi_jobs.md:32`, `gaussian_example.md:118`;
  the Gautschi agent snippet says "Do NOT use `--partition=a10`"). **Do not mirror those pages.**
- Always set `--time` (every agent snippet's Prohibitions).

### Per-cluster facts

| | Anvil | Gautschi | Negishi | Gilbreth | Scholar |
|---|---|---|---|---|---|
| Account | `-A myallocation` (find with `mybalance`) | `-A myallocation` (`slist`) | `-A myallocation` (`slist`) | `-A myallocation` (`slist`) | `-A scholar` |
| CPU multi-node partition | `wholenode` (node-exclusive, ≤16 nodes, 96 h); `wide` (≤56 nodes, 12 h); `debug` (≤2 nodes, 2 h) | `cpu` | `cpu` | n/a (GPU only) | `cpu` |
| QOS | none exist (snippet: "Do NOT request a `standby` … QOS") | `normal` (default, ≤2 weeks) / `standby` (≤4 h, not charged) | `normal` (≤2 weeks) / `standby` (≤4 h) | `normal` / `standby` (≤4 h); `training` for `training` partition | `normal` (default, ≤4 h) / `long` (≤3 days) / `debug` (≤2 nodes, 30 min) |
| Cores per CPU node | 128 (`overview.md:33`) | 192 (`overview.md:22`, `queues.md:54`) | 128 (`overview.md:27`) | n/a | 128 (`scholar-a`, 4 nodes) and 64 (`scholar-b`, 3 nodes) in the same `cpu` partition (`overview.md:34-35`) |
| Single-GPU partition | `gpu` (4x A100 40 GB, 128 cores/node, 48 h) or `ai` (4x H100, 96 cores/node, 48 h); `gpu-debug` (≤2 GPUs, 30 min) | `ai` (8x H100, 112 cores/node; `normal` ≤4 days since 2026-11-02, `preemptible`, `burst`) or `smallgpu` (2x L40S, 128 cores/node, 24 h) | `gpu` (3x MI210, 32 cores/node, 24 h) | `a10`, `a30`, `a100-40gb`, `a100-80gb` (type chosen by partition; count with `--gpus-per-node`) | `gpu` (V100, A30, A30 MIG slices, A40) |
| GPU request form on site | `--gpus-per-node=1` (`jobs.md:467`) | `--gpus-per-node=8` (`examples/example_distributed.md:46`) | per queues page, request cores proportional to GPUs | `--gpus-per-node=1` (`directives.md:24`); snippet forbids `--gres` type strings | `--gres=gpu:1` or `--gpus-per-node=1` (`gpu.md:44-46`) |
| Module prerequisite | `modtree/cpu` loaded at login; GPU jobs need `module load modtree/gpu` (`faqs.md:104`, `jobs.md:475-477`) | none documented | none documented | none documented | none for x86 nodes; `modtree/spark` only on `spark-*` (aarch64) nodes |
| Shebang on site | `#!/bin/sh -l` (`jobs.md:116,189`) | `#!/bin/bash` (`creating_the_submission_script.md:16`) | `#!/bin/bash` / `#!/bin/sh -l` | `#!/bin/sh -l` (`submit_script.md:72`) / `#!/bin/bash` | `#!/bin/sh -l` (`submit_script.md:55`) |

Conflict to record: Gautschi's agent snippet (`docs/snippets/agentic-ai/gautschi/agents.d/slurm.md:23`)
says `ai` runs "up to 2 weeks"; the queues page (`docs/userguides/gautschi/run_jobs/queues.md:78,90`)
says limits changed 2026-11-02 and `normal` jobs run "up to 4 days". The queues page is newer;
cite it.

### Gold-standard headers on the site (verbatim)

**Anvil**, template (`docs/userguides/anvil/jobs.md:116-125`):

```bash
#!/bin/sh -l

#SBATCH -A <account>
#SBATCH -p <partition>
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --job-name example-job
#SBATCH -t 01:30:00  # 1 hour 30 minutes
```

Anvil multi-node form (`jobs.md:189-197`): `#SBATCH -A myallocation`, `#SBATCH -p queue-name # the default queue is "shared" queue`, `#SBATCH --nodes=2`, `#SBATCH --ntasks=1`, `#SBATCH --time=1:30:00`, `#SBATCH --job-name myjobname`.
Anvil GPU (`jobs.md:461-479`): `#SBATCH -A myallocation`, `--nodes=1`, `--ntasks=1`, `--gpus-per-node=1`, `--time=1:30:00`, `-p gpu`, then `module --force purge` / `module load modtree/gpu` / `module purge` / `module load vasp/6.3.0-gpu`.

**Gautschi**, CPU (`docs/userguides/gautschi/run_jobs/creating_the_submission_script.md:16-24`):

```bash
#!/bin/bash
# FILENAME:  myjobsubmissionfile

#SBATCH --account=myLabAccount
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
```

Gautschi multi-node, command-line form (`multiple_node.md:22`):
`sbatch --nodes=2 --ntasks=384 --time=00:10:00 -A myallocation -p queue-name myjobsubmissionfile.sub`.
Gautschi GPU (`examples/example_distributed.md:43-53`): `--nodes=1`, `--ntasks-per-node=1`,
`--gpus-per-node=8`, `--cpus-per-task=14`, `--time=00:20:00`, `--constraint=H`, `--partition=ai`,
`--qos=normal`, `--account=rcac #Change to your account!` (real account name; do not copy).

**Negishi**, CPU (`docs/userguides/negishi/run_jobs/submit_script.md:100-106`):

```bash
#SBATCH --account=accountname
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname
```

**Gilbreth**, GPU (`docs/userguides/gilbreth/run_jobs/directives.md:21-24`):

```bash
#!/bin/bash
#SBATCH -A accountname --partition=a30 --qos=standby
#SBATCH --nodes=1 --gpus-per-node=1 --time=00:01:00 --mem=20G
```

and `submit_script.md:72-79`: `#!/bin/sh -l`, `#SBATCH -A accountname`, `#SBATCH --partition=a10`,
`#SBATCH --nodes=1 --gpus-per-node=1 --mem=8G`, `#SBATCH --time=1:30:00`, `#SBATCH --job-name myjobname`.

**Scholar**, CPU (`docs/userguides/scholar/run_jobs/submit_script.md:55-59`):

```bash
#!/bin/sh -l
#SBATCH --partition=cpu
#SBATCH --nodes=1
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname
```

This example omits the account, but the queues page says "All jobs submitted to Scholar should
utilize the `scholar` queue" (`queues.md:18-20`) and the agent snippet says to set both `-A` and
`-p`. Scholar tabs should carry `-A scholar`.

### Proposed tab headers (proposal built from the above; validate before publish)

CPU multi-node (tier 1), two nodes, whole nodes:

| Cluster | Lines |
|---|---|
| Anvil | `-A myallocation`, `-p wholenode`, `--nodes=2`, `--ntasks-per-node=128`, `--time=…` (≤96 h) |
| Gautschi | `-A myallocation`, `-p cpu`, `-q normal`, `--nodes=2`, `--ntasks-per-node=192`, `--time=…` (≤14 days; `-q standby` ≤4 h) |
| Negishi | `-A myallocation`, `-p cpu`, `-q normal`, `--nodes=2`, `--ntasks-per-node=128`, `--time=…` |
| Scholar | `-A scholar`, `-p cpu`, `-q normal`, `--nodes=2`, `--ntasks-per-node=64` (fits both `scholar-a` and `scholar-b`; or `--constraint` for A nodes, feature name to confirm with `sfeatures`), `--time=` ≤`4:00:00` (or `-q long` ≤3 days) |
| Gilbreth | omit, or tab note "Gilbreth is a GPU cluster; see the GPU page" |

Caution for the body designers: `--ntasks-per-node` interacts with how `hsx` launches clients
(`--launcher=srun`, `--mpi`, `--ssh`; `docs/_include/cluster_help.rst:19-27` in the HyperShell
repository). With `--ntasks-per-node=192`, a bare `srun` launcher starts 192 clients per node.
Header and launcher must be designed together, and validation must confirm one client per node
with the intended `-N` executors (see section 6).

Single-node, single-GPU (GPU multiplexing):

| Cluster | Lines |
|---|---|
| Anvil | `-A myallocation`, `-p gpu`, `--nodes=1`, `--gpus-per-node=1`, `--ntasks-per-node=32` (128 cores / 4 GPUs), `--time=…` (≤48 h); module lines `module load modtree/gpu` then `module load hypershell` |
| Gautschi | `-A myallocation`, `-p smallgpu`, `--nodes=1`, `--gpus-per-node=1`, `--ntasks-per-node=64` (128 cores / 2 GPUs, per `queues.md:146`), `--time=` ≤24 h; or `-p ai`, `-q normal`, `--gpus-per-node=1`, `--ntasks-per-node=14` (112 / 8) |
| Gilbreth | `-A myallocation`, `-p a100-80gb` (or `a30`, `a10`), `-q normal`, `--nodes=1`, `--gpus-per-node=1`, cores proportional to the node type (e.g. K nodes 64 cores / 2 GPUs; `overview.md:37-46`), `--time=…` |
| Scholar | `-A scholar`, `-p gpu`, `-q normal`, `--nodes=1`, `--gpus-per-node=1`, `--time=` ≤4 h |
| Negishi | only if the example is vendor-neutral: `-A myallocation`, `-p gpu`, `--nodes=1`, `--ntasks-per-node=10` (32 cores / 3 GPUs), `--time=` ≤24 h; GPU request flag form for MI210 to confirm live |

## 3. Module lines per cluster

- **GOAL gate:** pages suggest `module load hypershell` with no pinned version. The catalog page
  says the same and adds: "Run `module spider hypershell` beforehand to check if this version
  requires any prerequisite modules" (`docs/software/apps_md/hypershell.md`).
- **Anvil:** `modtree/cpu` is loaded at login ("The CPU stack is loaded by default when you login
  to the system", `docs/userguides/anvil/faqs.md:104`); GPU software needs `module load modtree/gpu`
  (`faqs.md:217`, `jobs.md:476`). Two risks to check live: (1) whether `hypershell` is visible
  under `modtree/gpu` at all (the catalog does not split CPU/GPU trees); (2) the site's Anvil
  template does `module purge` (`jobs.md:199`); if a body ever purges, it must reload
  `modtree/cpu` before `module load hypershell`. Recommend the Anvil CPU tab carries just
  `module load hypershell` (stack already present via the login-shell shebang) and the Anvil GPU
  tab carries `module load modtree/gpu` + `module load hypershell`, pending the live check.
- **Gautschi, Negishi, Gilbreth, Scholar:** no prerequisite documented; the `module spider
  hypershell` output shown on their software pages lists versions only, with no "must load
  first" line (`docs/userguides/gautschi/software.md:35-55`). Scholar `spark-*` nodes are aarch64
  with their own tree (`modtree/spark`); HyperShell examples should not target them.
- **Default (D) versions:** 2.7.0 on Anvil, Gautschi, Negishi, Scholar; 2.5.2 on Gilbreth.

## 4. Login nodes

| Cluster | Documented login host | Front ends (overview) | Notes |
|---|---|---|---|
| Anvil | `anvil.rcac.purdue.edu` (`getting-started.md:47-50`) | 8 nodes, 32 cores, 512 GB (`overview.md:35-37`) | prompts show `login03.anvil`, `login04.anvil` (`file_management.md:41`, `getting-started.md:121`); `sfeatures` lists `login[00-07]` (`jobs.md:100`) |
| Gautschi | `gautschi.rcac.purdue.edu` (front matter; agent snippet `unix.md:10`) | 8 nodes, 192 cores, 768 GB (`overview.md:26-28`) | `login00.gautschi.rcac.purdue.edu` resolves (GOAL, checked 2026-11-22) but is **not named anywhere on this site** |
| Negishi | `negishi.rcac.purdue.edu` (macro `main.py:591`) | 8 nodes, 128 cores, 512 GB (`overview.md:31-33`) | a blog prompt shows `login00.negishi` (`docs/blog/posts/slurm_fairshare.md:111`) |
| Gilbreth | `gilbreth.rcac.purdue.edu` (`gateway/cluster_tools.md:18`) | 4 nodes with 1 A30 each (`overview.md:29-31`) | |
| Scholar | `scholar.rcac.purdue.edu` (`accounts.md:43`) | 3 CPU + 3 GPU (V100) (`overview.md:25-28`) | |

The generic pattern `login00.cluster.rcac.purdue.edu` appears only in a workshop illustration
(`docs/workshops/hpc_exchange/week2/what-is-a-cluster.md:46`).

**What the site says about processes on login nodes (verbatim):**

- "Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end login
  host. All users share the front-end hosts, and running anything but the smallest test job will
  negatively impact everyone's ability to use Gautschi. Always use SLURM to submit your work as a
  job." (`docs/userguides/gautschi/run_jobs/index.md:17`; same text for Gilbreth `run_jobs/index.md:17`)
- "Running jobs on login node is against RCAC policy. All users share the login nodes, and
  running anything but the smallest test job will negatively impact everyone's ability to use the
  cluster." (`docs/faqs.md:84-85`)
- "They are for **editing, compiling, submitting jobs, and light pre- and post-processing only**
  … **Do NOT start unbounded background processes or retry loops.**"
  (`docs/snippets/agentic-ai/gautschi/agents.d/unix.md:10-18`)
- Anvil: "do not run jobs on the login nodes and do not stress the filesystem."
  (`docs/userguides/anvil/policies.md:24`)
- The front-end use policy link: <https://www.rcac.purdue.edu/policies/frontenduse>
  (`docs/userguides/gautschi/gateway/cluster_tools.md:18`).

Nothing on the site addresses a persistent, low-CPU coordinator (a relay or server) on a login
node. Tier 3 (`hs submit` on a login node) fits "submitting jobs"; tier 4's relay on login00 is a
long-lived process. PLAN should state why it is acceptable (light, bounded, on the designated
login00) and, ideally, get an RCAC-side confirmation that login00 is the sanctioned host for
it; otherwise the page appears to contradict "Do NOT start unbounded background processes".

## 5. Getting a HyperShell 2.9.0 build for validation

**Release status (2026-11-22).** 2.9.0 final is **not released**.

- HyperShell repository: `develop` at `version = "2.9.0a8"`, `requires-python = ">=3.11"`
  (`pyproject.toml:3,29`); latest tags `2.9.0a8` (2026-11-13), `2.9.0a7`, `2.8.7` (2026-11-11).
  `develop` has commits after `2.9.0a8` (latest 2026-11-22, an `hs update`/`hs client` fix), so
  behaviour may still move before final.
- PyPI (`https://pypi.org/pypi/hypershell/json`, read 2026-11-22): latest stable **2.8.7**
  (2026-11-12); pre-releases 2.9.0a1 through **2.9.0a8** (2026-11-14); `requires_python >=3.11`.
- `docs/install.rst` (HyperShell repository): recommends `uv tool install hypershell`; supports
  CPython 3.11–3.14, not 3.15; extras `postgres`, `postgres-system`, `postgres-c`, `uuid7`,
  `zstd`, `cron`. **The TimescaleDB provider requires the `uuid7` extra on every host that submits
  tasks** (versionchanged 2.9.0, PR 71), which matters for tier 4 and its relay host.

Consequence for the guide: it documents a pre-release. Option names and behaviours cited from
2.9.0a8 docs could change before 2.9.0 final; PLAN should pin the reference build and re-check
at final release.

**Routes.**

- **(a) Gautschi `hypershell/develop` module.** Exists (login-node check 2026-11-22); what it
  carries is unknown. Must be checked live with `module load hypershell/develop && hs --version`.
  Usable only if it reports ≥ `2.9.0a8`. Gautschi only.
- **(b) User-space install via the `uv` module.** The catalog lists `uv` 0.7.0 and 0.8.0 (D) on
  Anvil, Gautschi, Gilbreth, Negishi and Scholar (`docs/software/apps_md/uv.md`); the site's uv
  page (`docs/snippets/examples/apps/python/uv.md`, included from
  `docs/userguides/gautschi/run_jobs/examples/python_uv.md`) documents `module load uv`, then
  `uv tool install <tool>`; tool environments live on scratch, a record in
  `~/.local/share/uvm`, and batch jobs auto-repair purge damage (`UVM_REPAIR=1`). The module sets
  `UV_PYTHON_PREFERENCE=only-managed`, so uv fetches its own Python (pin `--python 3.13` to stay
  inside 3.11–3.14). Command: `module load uv` then
  `uv tool install 'hypershell[postgres,uuid7]==2.9.0a8' --python 3.13` (the extras only needed
  for tier 4). Works identically on Gautschi and Anvil, and pins an exact version.
- **(c) Fallback:** `python3 -m venv` (from the `conda` module's Python ≥3.11) then
  `pip install 'hypershell==2.9.0a8'`. `pip install --user` is not recommended (home `~/.local`
  mixing, older system Python).

**Recommendation:** route (b), pinned to `2.9.0a8` (or whatever pre-release is current when the
foreman runs), on Gautschi; same command on Anvil for the second cluster. Fallback to (a) if the
`develop` module reports ≥ 2.9.0a8, then (c). Record `hs --version` in the validation log.

One wrinkle for R15: the validation job loads `uv` (or the user-space tool), while the published
tabs say `module load hypershell`. Split the evidence: a **module-line check** per tab (does
`module load hypershell` succeed and what does `hs --version` print, on each cluster) and a
**behaviour check** of the shared body with the 2.9.0 build. Confirm whether a `uv tool install`
command is on `PATH` inside a batch job without `module load uv` (uv-manager keeps the tool
launchers under `$UVM_DATA`; PATH handling is not stated on the site page).

## 6. Validation envelope inputs (for the foreman)

Step subagents never touch clusters; the foreman runs these. Placeholders: `myallocation` is the
foreman's real allocation at run time, never written into the repository.

| Tier | Cluster | Nodes / GPUs | Partition / QOS | Walltime | What it checks |
|---|---|---|---|---|---|
| Module lines | all five | login node only | — | — | `module load hypershell` (and Anvil `modtree/gpu` + `hypershell`) succeeds; `hs --version`; `module spider hypershell` prerequisites |
| T1 job script | Gautschi | 2 nodes | `-p cpu -q standby` (not charged) or `-q normal` if standby waits | 00:15:00 | exact tab header + shared body; job exit 0; one client per node with intended executor count; `hs list --count` equals task count; `hs list --failed` lists only the deliberately failing tasks (e.g. ~5% `exit 1`) |
| T1 rerun | Gautschi | same | same | 00:15:00 | `scancel` the first run mid-flight, resubmit unchanged: only unfinished tasks run (count via `hs list --succeeded --count` before/after); confirm whether **failed** tasks rerun under `--restart` alone (docs say `--restart` reverts tasks "scheduled but not completed"; failed tasks are retried via `-r/--max-retries`, `docs/_include/cluster_help.rst:132-147`); R7's wording "picks up only unfinished or failed work" depends on this result |
| T1 second cluster | Anvil | 2 nodes | `-p wholenode` (exact tab header; ~2×128 core-h per hour, so 15 min ≈ 64 SU) or `-p debug` (≤2 nodes, 2 h, 1 running) | 00:15:00 | same as Gautschi; confirms `#!/bin/sh -l` + `modtree/cpu` path |
| T2 extreme scale | Gautschi | 2 nodes (options exercised, not scale) | `cpu`, `standby` | 00:15:00 | every tier-2 option parses and runs on 2.9.0a8; no scale claim is validated live, so tier-2 numbers must be sourced from HyperShell docs |
| T3 on-cluster pipeline | Gautschi | login node + 1–2 client jobs | `cpu`, `standby` | 00:15:00 | `hs config`/`hs initdb`/`hs submit` phases on a login node; helper script's `sbatch` calls succeed; clients reach the server; `hs wait` returns; `hs list --remaining --count` is 0; zones/groups if used |
| T4 capstone | Geddes pod + Gautschi login00 + 1 client job | 1 node | `cpu`, `standby` | 00:15:00 | Rancher steps produce server + TimescaleDB pod; compute nodes reach the LoadBalancer name `<service>.<namespace>.geddes.rcac.purdue.edu` (`docs/userguides/geddes/examples/database.md:48`); relay on login00 launches clients; second-cluster route |
| GPU multiplexing | Gautschi | 1 L40S | `-p smallgpu` (normal, ≤24 h) | 00:10:00 | N tasks share one GPU; `CUDA_VISIBLE_DEVICES` seen by each task; all exit 0 |
| Job array baseline | Gautschi | 1 core × small array | `cpu`, `standby` | 00:05:00 | the landscape page's array example runs; `MaxArraySize` value |

**Needs live confirmation (collected across the guide):**

1. `hypershell` module versions on Negishi, Gilbreth (catalog 2.5.2 vs software page 2.7.0) and
   Scholar; what `hypershell/develop` on Gautschi carries.
2. Whether `hypershell` is visible under Anvil `modtree/gpu`.
3. Partition and QOS names as seen by `showpartitions`/`sinfo` on each cluster, especially Anvil
   (`wholenode` vs legacy `standard`), Gautschi `smallgpu`/`ai` limits after 2026-11-02, Scholar
   `gpu` and `long`/`debug` QOS.
4. MIG/MPS: Scholar H-MIG and I-MIG nodes (A30 6 GB slices, `overview.md:38-39`); the site does
   not document how to request a MIG slice (gres name via `sfeatures`/`scontrol show node`).
   Whether `nvidia-cuda-mps-control` is usable on Gautschi, Anvil, Gilbreth GPU nodes (not
   documented on the site). Negishi MI210 request flag form.
5. Scholar `cpu` node feature names for `--constraint` (A vs B nodes).
6. `login00.<cluster>.rcac.purdue.edu` for clusters other than Gautschi; whether login00 is the
   sanctioned host for a persistent relay.
7. Whether `sbatch` (and `squeue`/`scancel`) is reachable from Gautschi login00, and how a second
   cluster's scheduler is reached from there (ssh to that cluster's front end, or Slurm
   multi-cluster `-M`).
8. Slurm array limit: `scontrol show config | grep -i MaxArraySize` (and `MaxJobCount`,
   `MaxSubmitJobs` per-user limits) on Gautschi and Anvil, for the job-array baseline page.
9. Network reachability from compute nodes (and login00) of Gautschi and the second cluster to a
   Geddes LoadBalancer service on the HyperShell server port and the database port.
10. Whether a `uv tool install` launcher is on `PATH` in a batch job without `module load uv`.
11. Whether `--restart` alone reruns failed tasks (section 6, T1 rerun).

## Recommendations for PLAN

1. **Tabs:** Anvil, Gautschi, Negishi, Gilbreth, Scholar. Drop Bell (no guide, no nav entry, no
   catalog row; retiring per a workshop note) and record the evidence. Gilbreth only in GPU
   examples; Negishi out of NVIDIA MPS/MIG examples.
2. **Placeholders:** `myallocation` for every account except Scholar's literal `scholar`; every
   tab sets `-A`, `-p`, `--time`, and `-q` where the cluster has QOS (not Anvil).
3. **Mirror** the queues pages and agent-context snippets, not the stale example pages
   (`-A standby`, `--partition=a10` on Gautschi).
4. **Module lines:** `module load hypershell` in every tab; Anvil GPU tab adds
   `module load modtree/gpu` first (pending live check).
5. **Version admonition:** say module versions differ by cluster (Gilbreth 2.5.2, others 2.7.0
   today), show `hs --version`, keep per-feature minimum versions; note 2.9.0 is in pre-release
   (2.9.0a8 on PyPI; stable is 2.8.7) and decide with the human whether the admonition names a
   user-space install (`module load uv`, `uv tool install hypershell`) as the interim route.
6. **Validation build:** `module load uv` + `uv tool install 'hypershell==2.9.0a8'` on Gautschi,
   same on Anvil; fallback the Gautschi `develop` module if it reports ≥ 2.9.0a8. Split module-line
   checks (every tab, login node) from behaviour checks (shared body, Gautschi + Anvil).
7. **Cheapest envelope:** Gautschi `cpu` + `standby` (not charged, ≤4 h) for tiers 1–4, Gautschi
   `smallgpu` for GPU multiplexing, Anvil `wholenode` 2 nodes × 15 min for the second-cluster
   tier-1 run.
8. **Resolve before drafting tier 1:** whether `--restart` reruns failed tasks (R7 wording), and
   how the launcher pairs with `--ntasks-per-node` so the header and body agree.
9. **Login-node policy:** tier 4 should justify the persistent relay on login00 against the
   site's "Do NOT start unbounded background processes" rule, or carry an RCAC-confirmed note.
