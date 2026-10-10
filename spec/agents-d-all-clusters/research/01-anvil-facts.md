# 01 — Anvil facts for `anvil.yml` and template breakage audit

Source: the public Anvil user guide in this repo (`docs/userguides/anvil/`), the software
catalog (`docs/software/apps_md/`), and the MkDocs macros in `main.py` that render shared
snippets into the Anvil pages. Every value below cites file + heading. Where the docs are
silent or contradict each other, it says so. Nothing here was checked on a live system.

## Summary

- Anvil is an NSF ACCESS (and NAIRR) resource that RCAC operates. Support goes through the
  ACCESS Help Desk, not `rcac-help@purdue.edu`. Usernames start with `x-`.
- Login host `anvil.rcac.purdue.edu`; Rocky Linux 8.10; Slurm; Lmod.
- Storage has three tiers: `$HOME` (ZFS, 25 GB, snapshots), `$SCRATCH` (GPFS, mount
  `/anvil/scratch`, 100 TB / 1M files, 30-day purge, no backup, no warning emails) and
  `$PROJECT` = `$WORK` (GPFS, `/anvil/projects`, 5 TB / 1M files, snapshots, per allocation).
  There is no `$RCAC_SCRATCH`, no `findscratch` and no `purgelist`. Data Depot is not available.
  Fortress can be reached only by SFTP or Globus (no `hsi`/`htar`). Anvil Object Storage (S3)
  is available on request.
- `-A` and `-p` are mandatory. Accounts are listed with `mybalance`, partitions with
  `showpartitions`. Partitions: `debug`, `gpu-debug`, `wholenode`, `wide`, `shared` (default),
  `highmem`, `gpu`, `ai`. No QOS is documented for users to request. The FAQ states there are
  no `standby`, `partner` or owner queues.
- Helper commands documented: `myquota`, `mybalance`, `userinfo`, `showpartitions`,
  `sfeatures`, `sinteractive`, `flost`, `jobsu`, `seff`, `jobinfo`, `jobscript`, `wait_time`.
- Software comes in two Lmod trees: `modtree/cpu` (the default) and `modtree/gpu`. GCC and
  OpenMPI are loaded at login. The catalog default is `gcc/11.2.0` with `openmpi/4.0.6`.
- Containers: the docs say "Singularity is supported" and say nothing about bind mounts.
- The templates break in many places. The worst are `slist`, `$RCAC_SCRATCH`/`findscratch`/
  `purgelist`, the QOS requirement and empty QOS section, Fortress `hsi`/`htar`, and
  `rcac-help@purdue.edu`. The data model also has no way to describe `$PROJECT`.

## Proposed anvil.yml values

```yaml
cluster: anvil
title: Anvil
login_host: anvil.rcac.purdue.edu
  # getting-started.md "SSH": "standard SSH connections ... to `anvil.rcac.purdue.edu`"
  # main.py slurm_general_overview (rendered at top of jobs.md): "<username>@anvil.rcac.purdue.edu ... lands you on a login node"
  # 8 login nodes: architecture.md "Login Nodes"; overview.md "Anvil Specifications"
os: Rocky Linux 8.10
  # architecture.md "Compute Nodes" table, row "Operating System": Rocky Linux 8.10 (CPU, GPU, AI)
  # CONFLICT: overview.md "Anvil Specifications" says "Anvil nodes run CentOS 8 (Rocky Linux)". Prefer architecture.md.
scratch_path: /anvil/scratch
  # file_management.md "File Systems" table: mount point /anvil/scratch, "User scratch"
  # env var is $SCRATCH (file_management.md "File Systems"; getting-started.md "My Data Locations")
  # NOT STATED: whether $SCRATCH = /anvil/scratch/$USER. Template pattern `{{ scratch_path }}/$USER` is unverified: verify live.
  # PROPOSED NEW FIELD (template needs it): scratch_var: "$SCRATCH"

# Username shape (proposed new field, for unix.md):
# username_note: "Anvil usernames are the ACCESS username with an `x-` prefix (for example `x-doug`)."
  # getting-started.md "SSH" note; faqs.md "How is Anvil different than Purdue Community Clusters?" > "Accounts and Passwords"
  # (access.md "Joining an Existing Project" says the same, but access.md is `draft: true`)

filesystems:
  home:
    path: /home/$USER          # getting-started.md "SSH keys" step 4 shows `pwd` -> /home/x-anvilusername; file_management.md table mount /home
    tech: ZFS                  # architecture.md "Storage" table; file_management.md "File Systems" table ("Anvil ZFS")
    quota: 25 GB, no file-count limit   # architecture.md "Storage" table and "Home"
    snapshots: "nightly snapshots kept 7 days, weekly for 3 weeks, monthly for 2 months (recover with `flost`)"
      # file_management.md "File Systems" footnote "Full schedule"; "Lost File Recovery"; "Recovering Lost Files on Anvil with flost"
      # recovery runs on service host zfs.anvil.rcac.purdue.edu (flost output example, same section)
      # objectstorage/concepts.md "Storage Comparison" labels $HOME as "NFS"; read as transport, tech is ZFS per two other pages.
  scratch:
    tech: GPFS
      # architecture.md "Storage" table; file_management.md "File Systems" ("$SCRATCH is a high-performance, internally resilient GPFS parallel file system")
      # CONFLICT: architecture.md "Anvil Ceph" says "Ceph complements the Lustre-based storage tiers". Two other places say GPFS; prefer GPFS.
    purge_days: 30
      # architecture.md "Scratch" warning "Scratch storage gets deleted after 30 days!"; file_management.md table; faqs.md "Storage and Filesystems"; policies.md "Scratch File Purging" (main.py scratch_purge rewrites 60 -> 30 for anvil)
    purge_basis: CONFLICTING in docs:
      # file_management.md table: "Files older than 30-day (access time) will be purged"
      # architecture.md "Scratch": "not been modified or touched in 30 days"
      # faqs.md: "Files not accessed for 30 days are deleted instantly and automatically"
      # policies.md "Scratch File Purging" (rendered macro): "last access time and content modification time ... Changing file metadata ... does not protect"
    purge_notes:
      - "No warning emails before purge."              # faqs.md "Storage and Filesystems" warning
      - "Purge cannot be cancelled or overridden."      # architecture.md "Scratch"
      - "Circumventing purge is prohibited."            # file_management.md "File Systems"; policies.md "Scratch File Purging" > Acceptable Use
      - "No backups or snapshots; deleted files are unrecoverable."  # architecture.md "Scratch has no backup!"; file_management.md
    quota: 100 TB, 1 million files   # architecture.md "Storage"; file_management.md table; getting-started.md "My Data Locations"
  project:            # PROPOSED NEW KEY: the templates have no slot for this tier
    path: /anvil/projects            # file_management.md "File Systems" table
    vars: ["$PROJECT", "$WORK"]      # file_management.md "File Systems": "$PROJECT and $WORK variables refer to the same location"
    tech: GPFS                       # architecture.md "Storage"; file_management.md table
    quota: 5 TB, 1 million files (more on request)   # architecture.md "Storage"; getting-started.md "My Data Locations"
    snapshots: same full schedule as home; browse /anvil/projects/.snapshots   # file_management.md table + "Recovering Lost Files on Anvil with flost"
    shared_by: all users of the allocation (read/write); one per allocation   # file_management.md "File Systems"
    lifetime: "Not purged while allocation is active. Removed 90 days after allocation expiration."  # file_management.md table
    use: shared group data and software installs; not for active job output  # architecture.md "Project"; file_management.md table
  datasets: /anvil/datasets (common data sets, weekly snapshots)   # file_management.md table
  depot: false
    # faqs.md "Storage and Filesystems": "Purdue Data Depot is not available on Anvil, but every allocation receives a dedicated project space ($PROJECT)"
  fortress: false   # SEE NOTE: set false so the template does not emit hsi/htar
    # faqs.md "Storage and Filesystems": "Purdue Fortress is available on Anvil, but direct HSI and HTAR are currently not supported. You can transfer files between Anvil and Fortress using ... SFTP, Globus."
    # i.e. Fortress is reachable only as a remote transfer target, not as a mounted/hsi archive.
  object_storage:     # PROPOSED NEW KEY (optional)
    name: Anvil Object Storage (S3-compatible)
    endpoint: https://s3.anvil.rcac.purdue.edu   # objectstorage/access.md
    access: "by request via ACCESS (or NAIRR) ticket; credentials from `mykeys` on a login node"   # objectstorage/access.md "Request Process"; objectstorage/acl.md
    tools: rclone, s3cmd, boto3                  # objectstorage/getting-started.md; objectstorage/concepts.md "Storage Comparison"
  quota_command: myquota
    # architecture.md "Storage"; file_management.md "Useful tools"; getting-started.md "Helpful Tools"
  node_local_tmp: NOT STATED in Anvil docs (only `MinTmpDiskNode=0` in a scontrol example): verify live

toolchain:
  compiler: GCC 11.2.0
    # docs/software/apps_md/gcc.md: ANVIL versions "8.4.1, 10.2.0, 11.2.0 (D), 13.3.0, 14.2.0"
    # jobs.md "Running VASP on Anvil": `module load gcc/11.2.0 openmpi/4.1.6`
    # main.py module_system (rendered in anvil-software.md "Module system"): "a default compiler (GCC), MPI libraries (OpenMPI) ... are automatically loaded"
    # NOTE: anvil-software.md "Compiling, performance, and optimization on Anvil" contains an unrendered `${resource.compiler}` placeholder (doc bug), so it does not name the compiler.
  mpi: OpenMPI
    # docs/software/apps_md/openmpi.md: ANVIL default "4.0.6 (D)"; jobs.md VASP example uses openmpi/4.1.6
    # anvil-software.md: GNU, Intel, AOCC compilers; OpenMPI, Intel MPI, MVAPICH2; PGI on GPU nodes
  arch_flag: "-march=znver3 (GCC >= 11.2, Clang, AOCC) on AMD Milan nodes"   # anvil-software.md item 3
  module_trees:       # PROPOSED NEW KEY: lmod.md needs it
    cpu: "modtree/cpu (loaded by default at login)"
    gpu: "modtree/gpu (GPU software stack; required to see GPU modules)"
    # faqs.md "Software Stack" and "I cannot find the module I need on Anvil"; jobs.md GPU-VASP example
  extra_trees: ["biocontainers", "ngc (GPU nodes)"]
    # faqs.md "I cannot find the module I need on Anvil" (biocontainers); docs/software/ngc_catalog.md "Getting Started" lists Anvil
  python: "`module load conda` (also `anaconda` and `python` modules); use virtual environments; keep large envs in $PROJECT, not $HOME"
    # jobs.md "Python on Anvil cluster" -> snippets/apps/python.md (`module load conda`)
    # docs/software/apps_md/conda.md, anaconda.md, python.md list ANVIL versions
    # anvil-software.md (two Python distributions; "Users are recommended to use virtual environments")
    # getting-started.md "My Data Locations" tip "Storage etiquette"; architecture.md "Home" tip

scheduler:
  standby_max_hours: null   # no standby on Anvil (faqs.md "Partitions and Node Types")
  account_required: true    # jobs.md "Job Submission Script" warning "Mandatory SBATCH fields"; getting-started.md "Submitting your first job"; faqs.md "Partitions and Node Types" note
  partition_required: true  # same three sources
  default_partition: shared # jobs.md "Anvil Queues (Partitions)" note "Default Partition"; faqs.md
  default_time: "30 minutes"   # jobs.md "Submitting a Job" > "Job Defaults"
  default_nodes: 1             # same
  account_discovery: mybalance # jobs.md "Mandatory SBATCH fields": "Run `$ mybalance` to see allocation accounts"; also `userinfo <username>` (getting-started.md "Helpful Tools")
  account_example: "cda123456" # getting-started.md "Submitting your first job" (example only; naming scheme NOT STATED)
  partition_discovery: showpartitions   # jobs.md "Anvil Queues (Partitions)"; getting-started.md "Helpful Tools"
  max_job_cores: 7168          # jobs.md "Other important queue considerations"
  gpu_limits: "max 12 GPUs in use per user, 32 per allocation"   # jobs.md "GPU and AI Queues" warning
  allocation_types: "CPU, GPU and AI credits are separate; a job's account must hold credits for that queue type"
    # jobs.md "Anvil Queues" note; jobs.md "Job Accounting" "CPU vs. GPU charges"; faqs.md "Partitions and Node Types"
    # NOT STATED: how a GPU/AI account name differs from a CPU one. Verify live with `mybalance`.
  charging:
    - "1 SU = 1 core-hour (with <= ~2 GB memory) on CPU nodes"    # jobs.md "Job Accounting" > "CPU Nodes"
    - "Shared partitions charge max(cores, memory fraction)"     # same
    - "wholenode and wide are node-exclusive: charged 128 cores even for 1-core jobs"  # jobs.md "Charges for Whole-Node Partitions"; "CPU Nodes"
    - "highmem charged 4 SU per core"                             # jobs.md "CPU Nodes"; partition table charging factor 4
    - "GPU nodes: 1 SU = 1 GPU-hour (<= ~120 GB memory)"         # jobs.md "GPU Nodes"
    - "Default memory per core ~1896 MB; requesting --mem-per-cpu=2G can allocate extra cores and raise charges"  # jobs.md "Charges are based on resource request"
    - "Filesystem storage is not charged"                        # jobs.md "Filesystem"

qos: []
  # No user-selectable QOS is documented anywhere in docs/userguides/anvil/.
  # faqs.md "Partitions and Node Types": "There are no `standby`, `partner` or `owner`-type queues on Anvil. All jobs in all partitions are prioritized equally."
  # jobs.md "Checking Job Status" scontrol example shows `QOS=normal`. That is example output, not an instruction. Whether users may pass `-q`: verify live.

partitions:   # jobs.md "Anvil Queues (Partitions)" table (max nodes / cores / duration / running jobs / charging)
  - name: debug
    use: "Testing and debugging (CPU)"
    notes: "up to 2 nodes / 256 cores; max 2 h; 1 running, 2 queued per user"
  - name: gpu-debug
    use: "Testing and debugging (GPU)"
    notes: "1 node, up to 2 GPUs; max 30 min; 1 running, 2 queued per user"
  - name: wholenode
    use: "Multi-node CPU jobs (128-core nodes)"
    notes: "node-exclusive (charged 128 cores/node); up to 16 nodes; max 96 h"
  - name: wide
    use: "Large multi-node CPU jobs"
    notes: "node-exclusive; up to 56 nodes / 7,168 cores; max 12 h; 5 running per user"
  - name: shared
    use: "Single-node CPU jobs that share a node; the default partition"
    notes: "1 node, up to 128 cores; max 96 h; up to 1,280 cores running per user"
  - name: highmem
    use: "Large-memory jobs (1 TB nodes)"
    notes: "1 node; max 48 h; charged 4 SU per core; 2 running, 4 queued per user"
  - name: gpu
    use: "GPU jobs (4x NVIDIA A100 40 GB per node)"
    notes: "max 48 h; needs GPU credits; max 12 GPUs per user"
  - name: ai
    use: "AI jobs (4x NVIDIA H100 80 GB per node)"
    notes: "max 48 h; needs AI credits; max 12 GPUs per user"
  # Node hardware: overview.md "Anvil Specifications"; architecture.md "Compute Nodes"; jobs.md `sfeatures` example (A100/H100 GRES gpu:4).
  # EXCLUDED pending verification: `standard`, `benchmarking`, `profiling`, `azure`. They appear in the jobs.md `showpartitions`
  # example output, and getting-started.md "Submitting your first job" even uses `-p standard`, but the partition table does not list them.
  # GPU request flag: jobs.md GPU-VASP example uses `--gpus-per-node=1` with `-p gpu`. The docs state no rule that GPUs must be requested explicitly.

anti_patterns:   # rendered in slurm.md "Prohibitions"; several are storage/software and need a non-Slurm slot (see Open questions)
  - "**Do NOT** request a `standby`, `partner`, or owner queue or QOS. None exist on Anvil, and all partitions have equal priority."   # faqs.md "Partitions and Node Types"
  - "**Do NOT** omit `-A` or `-p`. Without them the job goes to `shared` and may be charged to an unintended default account."   # jobs.md "Mandatory SBATCH fields"; getting-started.md "--account" warning
  - "**Do NOT** send small or single-core jobs to `wholenode` or `wide`. Those partitions are node-exclusive and charge all 128 cores. Use `shared`."   # jobs.md "Charges for Whole-Node Partitions"
  - "**Do NOT** use `highmem` unless the job needs more than a standard node's memory. It is charged 4 SU per core."   # jobs.md "CPU Nodes"
  - "**Do NOT** charge `gpu` or `ai` jobs to a CPU-only account. Check `mybalance` for an account with credits for that queue type."   # jobs.md "Anvil Queues" note; faqs.md
  - "**Do NOT** request `--mem-per-cpu=2G`. The default is about 1896 MB per core, and 2G can allocate extra cores and raise the charge."   # jobs.md "Charges are based on resource request"
  - "**Do NOT** look for GPU software without `module load modtree/gpu`. The CPU tree is loaded by default."   # faqs.md "Software Stack"
  - "**Do NOT** use `/depot`, Data Depot, `hsi`, or `htar` on Anvil. Shared group data goes in `$PROJECT`. Reach Fortress only by SFTP or Globus."   # faqs.md "Storage and Filesystems"
  - "**Do NOT** keep the only copy of anything in `$SCRATCH`. Files are purged after 30 days with no warning email, and the purge cannot be overridden."   # faqs.md; architecture.md "Scratch"
  - "**Do NOT** put conda or virtual environments or large files in `$HOME` (25 GB). Use `$PROJECT`."   # getting-started.md "Storage etiquette"; architecture.md "Home" tip
  - "**Do NOT** run `mykeys` or print its output. It returns the user's S3 access and secret keys."   # objectstorage/acl.md; objectstorage/access.md
  - "**Do NOT** add `module load` lines to `~/.bashrc` or other shell profiles."   # main.py module_system (anvil-software.md "Module system")
```

Other user-visible facts that may be useful in the templates:

- Helper commands documented on Anvil: `myquota`, `mybalance`, `userinfo <username>`,
  `showpartitions`, `flost` (getting-started.md "Helpful Tools"); `seff <jobid>`, `jobsu <jobid>`
  (getting-started.md "Checking Your Balance"); `sfeatures`, `sinteractive`, `wait_time -j <id>`,
  `jobinfo <jobid>`, `jobscript <jobid>` (jobs.md "Anvil Queues (Partitions)", "Interactive jobs",
  "Checking Job Status"); `mykeys` (objectstorage/acl.md; sensitive, see anti-patterns).
- Login and interactive access: SSH with keys only, no passwords (getting-started.md "SSH";
  faqs.md "My password is not working"). Open OnDemand at `ondemand.anvil.rcac.purdue.edu` and
  ThinLinc at `desktop.anvil.rcac.purdue.edu` (getting-started.md "OnDemand", "ThinLinc").
  Connections through third-party VPNs or from outside the US are blocked (faqs.md "Port 22/Port
  60 connection errors").
- Maintenance: a job will not start if its time limit would overlap a scheduled maintenance
  window (faqs.md "My job is Squeued but won't run").
- Support: ACCESS Help Desk `https://support.access-ci.org/help-ticket`. NAIRR users use
  `https://nairrpilot.org/open-support-request` (faqs.md "Anvil Resources"; faqs.md "Support"
  bullet: "all support requests have to go through ACCESS channels rather than RCAC ones").
  The policies.md software section links `https://support.access-ci.org/open-a-ticket`.
- Policies: policies.md "Acceptable Purdue IT Research Resource Use" renders
  `snippets/resourceuse.md`. For Anvil the `resource_use` macro drops only the credential-standards
  line, so the Anvil page does cite Purdue Policy V.4.1 (Acceptable Use) and V.1.6 (Remote
  Access). Allocations are governed by ACCESS allocation policies (faqs.md "Resource Allocations";
  access.md "What else should I know?").
- Software installs: if only your lab uses a package, install it privately in home or in the
  allocation project space (policies.md "Software Installation Request Policy").

## Template breakage audit

Line numbers refer to `tools/agent_context/templates/agents.d/*.md.j2` as they stand in this
worktree. "OK" means the claim holds on Anvil as rendered with the values above.

| Template:line | Current text / assumption | Anvil verdict | Anvil equivalent / action | Citation |
|---|---|---|---|---|
| unix:3 | runs `{{ os }}` | OK | `Rocky Linux 8.10` | architecture.md "Compute Nodes" |
| unix:9-11 | `{{ login_host }}` puts you on "one of several shared front-end nodes" | OK | `anvil.rcac.purdue.edu`, 8 login nodes | getting-started.md "SSH"; architecture.md "Login Nodes" |
| unix:13-15 | no heavy work on login nodes | OK | same rule | getting-started.md "Helpful Tips"; jobs.md overview warning |
| unix:22 | "Install software into user space" | Partly OK | add "home or allocation project space (`$PROJECT`)" | policies.md "Software Installation Request Policy" |
| unix:30 | `myquota` | OK | exists | file_management.md "Useful tools" |
| unix:31 | `slist` for accounts and balances | WRONG | `mybalance` (and `userinfo <username>`) | jobs.md "Mandatory SBATCH fields"; getting-started.md "Helpful Tools" |
| unix:32 | `sfeatures` | OK | exists on Anvil | jobs.md "Anvil Queues (Partitions)" |
| unix:33 | `module avail` / `module list` | OK, incomplete | add `showpartitions`; mention `modtree/gpu` | jobs.md; faqs.md "Software Stack" |
| unix (missing) | n/a | Gap | Usernames are `x-<ACCESS username>`. Do not assume a Purdue career account name. | getting-started.md "SSH"; faqs.md "Accounts and Passwords" |
| filesystems:8 | Home `/home/$USER` (`$HOME`) | OK | `/home/x-…` | getting-started.md "SSH keys"; file_management.md table |
| filesystems:10 | `{{ home.tech }}, with {{ home.snapshots }}` | OK with value | ZFS; nightly 7 d / weekly 3 wk / monthly 2 mo | file_management.md "Lost File Recovery" |
| filesystems:11-12 | home is "medium-performance" | Not stated | Docs give only the 25 GB limit. Drop "medium-performance" or verify live. | architecture.md "Home" |
| filesystems:15 | Scratch `{{ scratch_path }}/$USER` (`$RCAC_SCRATCH`) | WRONG var; path unverified | `$SCRATCH` under `/anvil/scratch`. Per-user subdir not stated: verify live. Template needs a `scratch_var` field. | file_management.md "File Systems" |
| filesystems:17 | `{{ scratch.tech }}` | OK with value | GPFS | architecture.md "Storage"; file_management.md |
| filesystems:19 | "Point writable files at `$RCAC_SCRATCH`" | WRONG | `$SCRATCH` | file_management.md |
| filesystems:19 | "Find the path with `findscratch`" | WRONG | No equivalent documented: omit, or `echo $SCRATCH` | (absent from all Anvil pages) |
| filesystems:20-21 | purge after N days by atime + content mtime; metadata touch doesn't protect | OK on days; basis conflicts | 30 days. Basis is stated four ways (see purge_basis). Add: no warning emails, cannot be overridden, circumvention prohibited. | faqs.md; architecture.md "Scratch"; file_management.md; policies.md "Scratch File Purging" |
| filesystems:21-22 | `purgelist` | WRONG | No equivalent: omit (the `scratch_purge` macro strips `purgelist` for Anvil on purpose) | main.py `scratch_purge`; policies.md |
| filesystems:23-29 | "move to Data Depot / Fortress" or else "durable project or archive storage" | WRONG / vague | Name `$PROJECT` and transfer off-system (Globus/SFTP to home institution or Fortress) | faqs.md "Storage and Filesystems"; architecture.md "Scratch" |
| filesystems:31-34 | node-local `/tmp` ephemeral per node | Not stated | verify live, or omit | (absent; only `MinTmpDiskNode=0` in a jobs.md example) |
| filesystems:37-46 | Long-term section: Data Depot (GPFS `/depot`); Fortress via `hsi`/`htar` | WRONG if `fortress: true` | Depot: not available. Fortress: SFTP/Globus only, no `hsi`/`htar`. Set both false and add a Project section (template change). | faqs.md "Storage and Filesystems" |
| filesystems (missing) | No Project tier at all | Gap (major) | `$PROJECT`=`$WORK`, `/anvil/projects`, GPFS, 5 TB / 1M files, snapshots, shared per allocation, removed 90 d after allocation expires | file_management.md "File Systems"; architecture.md "Project" |
| filesystems (missing) | no file-count limits | Gap | scratch and project: 1 million files | architecture.md "Storage" |
| filesystems (missing) | no recovery tool | Gap | `flost -w <dir>`; snapshots at `/home/.zfs/snapshot` and `/anvil/projects/.snapshots` | file_management.md "Recovering Lost Files on Anvil with flost" |
| filesystems (missing) | Object storage | Gap (optional) | Anvil Object Storage (S3), by request | objectstorage/access.md |
| filesystems:51-53 | `myquota` | OK | exists | file_management.md "Useful tools" |
| filesystems:54-55 | env vars `$HOME`, `$RCAC_SCRATCH` | WRONG | `$HOME`, `$SCRATCH`, `$PROJECT` (`$WORK`) | file_management.md "File Systems" |
| lmod:3-12 | Lmod; avail/spider/load/list/purge | OK | same | anvil-software.md "Module system" (main.py `module_system`) |
| lmod:14-15 | same modules in job scripts | OK | docs also say: no `module load` in shell profiles | main.py `module_system` |
| lmod:20 | toolchain sentence | OK with value | GCC 11.2.0 with OpenMPI; both loaded at login | apps_md/gcc.md; apps_md/openmpi.md; main.py `module_system` |
| lmod:24 | `module load rcac` (else branch) | WRONG if reached | No `rcac` module documented on Anvil: omit. Not reached when `toolchain` is set. | (absent from Anvil pages and catalog) |
| lmod:32-34 | verify with `module spider` | Partly OK | `module spider` hides modules behind `modtree/gpu`, `biocontainers`, `ngc`. Load the tree first. | faqs.md "I cannot find the module I need on Anvil" |
| lmod:35-36 | "prefer the `anaconda` modules" | Partly OK | `anaconda` exists, but the Anvil Python example uses `module load conda`. Recommend conda or anaconda plus virtual environments stored in `$PROJECT`. | apps_md/anaconda.md, conda.md; snippets/apps/python.md; anvil-software.md |
| lmod (missing) | CPU vs GPU stacks | Gap (major) | `modtree/cpu` default, `modtree/gpu` for GPU work | faqs.md "Software Stack" |
| slurm:8-11 | needs "resources, account, QOS, partition"; MUST set `-A` and `-p`; "also set the QOS (`-q`)" | `-A`/`-p` OK; QOS WRONG | `-A` and `-p` are mandatory. No QOS is documented: drop the QOS requirement and the "four things" framing. | jobs.md "Mandatory SBATCH fields"; faqs.md "Partitions and Node Types" |
| slurm:13-14 | discover accounts with `slist` | WRONG | `mybalance` | jobs.md "Mandatory SBATCH fields" |
| slurm:15 | memory proportional to cores | OK, imprecise | default ~1896 MB/core; shared jobs charged max(cores, memory fraction) | jobs.md "Job Accounting" |
| slurm:17-23 | partition table from data | OK with data | see `partitions` above | jobs.md "Anvil Queues (Partitions)" |
| slurm:25-41 | "QOS and charging" section, filled only from `qos` | BREAKS (empty heading when `qos: []`) | Needs a charging block: SUs, node-exclusive charge, highmem 4x, GPU SU, separate CPU/GPU/AI credits, GPU caps | jobs.md "Job Accounting"; "GPU and AI Queues" |
| slurm:31-33 | standby QOS, not charged | N/A | No standby on Anvil (renders only if listed) | faqs.md |
| slurm:35-36 | preemptible text hard-codes "`ai` partition only" | WRONG if reached | Anvil has an `ai` partition but no preemptible QOS. Keep it out of `qos`. Template should not hard-code the Gautschi partition. | faqs.md |
| slurm:45-47 | sbatch, squeue, scontrol, scancel, `sinteractive`, srun | OK | all documented. Could add `showpartitions`, `mybalance`, `jobinfo`, `jobscript`, `jobsu`, `seff`, `wait_time`. | jobs.md "Interactive jobs", "Checking Job Status"; getting-started.md |
| slurm:54-55 | "Do NOT write `-A standby`" (unconditional) | Misleading | Refers to a QOS Anvil lacks. Make conditional on `'standby' in qos`. For Anvil, say there is no standby/partner/owner queue. | faqs.md |
| slurm:58 | "valid sets are listed above" | Risky | `showpartitions` output in the docs shows `standard`, `benchmarking`, `profiling`, `azure` beyond the table. Either verify and add them, or say "run `showpartitions`". | jobs.md "Anvil Queues (Partitions)" |
| slurm:59 | "always set `--time`" | OK | default 30 min if omitted | jobs.md "Job Defaults" |
| policies:4 | "charged to their allocation" | OK | SUs against ACCESS/NAIRR allocation | jobs.md "Job Accounting" |
| policies:8-9 | "Purdue IT's Acceptable Use Policy and RCAC's resource policies" | Partly OK | The Anvil policies page does cite Purdue Policy V.4.1 and V.1.6. Add ACCESS allocation policies (and NAIRR where applicable). | policies.md "Acceptable Purdue IT Research Resource Use" (main.py `resource_use`); faqs.md "Resource Allocations" |
| policies:13-15 | sensitive data needs "prior approval" | Not stated | Anvil docs give no approval process. Keep the prohibition, drop "prior approval", or verify. | (absent) |
| policies:26-28 | watch balances with `slist` | WRONG | `mybalance` | jobs.md "Job Accounting" tip |
| policies:37-40 | "uses Apptainer"; auto-mounts `/home` and `/scratch` (writable) | Not stated / path wrong | Docs say only "Singularity is supported" (NGC containers on GPU nodes). No bind-mount statement for Anvil, and scratch is `/anvil/scratch`, not `/scratch`. Keep the "not a sandbox" warning without naming paths, or verify live (command name `apptainer` vs `singularity`, default binds). | anvil-software.md "Compiling, performance, and optimization on Anvil" (last para); ngc_catalog.md "Getting Started" |
| policies:44-45 | report to `rcac-help@purdue.edu` | WRONG | ACCESS Help Desk `https://support.access-ci.org/help-ticket`. NAIRR: `https://nairrpilot.org/open-support-request` | faqs.md "Anvil Resources"; faqs.md "Support" |
| policies (missing) | credentials | Gap | `mykeys` prints S3 secret keys: treat as off-limits | objectstorage/acl.md |
| generator `_assemble_agents_md` | "assembled agent context for Purdue RCAC's **Anvil** cluster" | Acceptable | Anvil is an NSF ACCESS resource operated by RCAC. Optional wording tweak. | overview.md "Overview"; faqs.md "How is Anvil different…" |
| generator / StrictUndefined | `{% if toolchain %}`, `filesystems.depot`, `'normal' in qos`, `anti_patterns` | Data-model constraint | Every key the templates touch must exist in `anvil.yml` (null/false/[] allowed), or StrictUndefined raises | tools/generate_agent_context.py |

## Open questions

1. **Undocumented partitions.** The jobs.md `showpartitions` example and the getting-started.md
   sample script (`-p standard`) show a `standard` partition that the partition table omits. The
   same output lists `benchmarking`, `profiling` and `azure`. Are any of these user-facing? Verify
   live. Until then, leave them out (R1).
2. **QOS.** Can or should users pass `-q` at all on Anvil? The docs never mention it. The only
   trace is `QOS=normal` in a scontrol example.
3. **Account naming.** How are CPU, GPU and AI allocation accounts named (one account per type,
   or a suffix)? The docs show only the example `cda123456` and say to use `mybalance`. Verify live.
4. **Scratch layout.** Is `$SCRATCH` = `/anvil/scratch/$USER`? The docs give the mount point
   and the variable, not the per-user path.
5. **Purge basis.** Is the 30-day purge keyed on access time only, or on access + content
   modification? Four pages disagree (see `purge_basis`).
6. **Scratch filesystem technology.** GPFS (architecture table, file_management.md,
   objectstorage/concepts.md) vs "Lustre-based storage tiers" (architecture.md "Anvil Ceph").
   GPFS is proposed. The Ceph sentence looks like a doc error.
7. **OS string.** Rocky Linux 8.10 (architecture.md) vs "CentOS 8 (Rocky Linux)"
   (overview.md). Rocky Linux 8.10 is proposed.
8. **Containers.** Is the command `apptainer` or `singularity`, and which paths are auto-bound
   (e.g. `/home`, `/anvil`)? The Anvil docs are silent. Verify live or keep the warning generic.
9. **Node-local `/tmp`.** Not documented for Anvil.
10. **Fortress.** The FAQ says Fortress is "available" via SFTP/Globus only. The current boolean
    `filesystems.fortress` cannot express "reachable but no `hsi`/`htar`". Proposed: set
    `fortress: false` and add a field such as `archive_note`.
11. **Template/data-model changes the Anvil values need** (for the plan): `scratch_var`; a
    `project` filesystem block; Anvil charging text when `qos` is empty; `modtree` guidance; a
    configurable support contact and policy line; a conditional `-A standby` prohibition; a
    container-binds field (or generic wording); per-topic anti-patterns (storage and software
    warnings currently render only under slurm.md); conditional or replaced `slist`, `findscratch`,
    `purgelist` and `$RCAC_SCRATCH` lines; and an accounts command (`mybalance` vs `slist`) as data.
12. **Doc bugs seen in passing** (not in scope, worth an issue): anvil-software.md renders a
    literal `${resource.compiler}`; access.md is `draft: true` but is linked from the Anvil index
    and the nav. The getting-started.md OnDemand links use `https://$ondemand.anvil...`, which is a
    broken URL.
