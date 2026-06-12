---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 3
---

# Quick Start Guide

Gautschi is a Community Cluster optimized for tightly-coupled science and engineering applications, equipped with CPU and GPU compute nodes connected by 400 Gbps NDR Infiniband. This guide walks you through everything you need to run your first job.

---

## 1. Get Access

Gautschi access is purchased in resource units by a PI or research group. Contact your PI or group manager to confirm you have been added to an allocation.

Once added, your Gautschi account is created automatically using your Purdue career account credentials — no separate account setup is needed.

[:octicons-arrow-right-24: Accounts and access details](accounts.md)

---

## 2. Connect to Gautschi

=== "SSH (Terminal)"
    ```bash
    ssh username@gautschi.rcac.purdue.edu
    ```
    Replace `username` with your Purdue career account username. You will be placed on a **login node** — use it only for editing files, compiling code, and submitting jobs. Never run computations directly on the login node. For password-free login, please setup your SSH Keys following the link below.

    [:octicons-arrow-right-24: SSH keys](accounts.md#ssh-keys)

=== "ThinLinc (GUI)"
    For graphical applications, connect via ThinLinc at:

    [**`https://desktop.gautschi.rcac.purdue.edu`**](https://desktop.gautschi.rcac.purdue.edu)

    or with ThinLinc client. Log in with your Purdue career account. ThinLinc provides a full desktop environment with an application menu for launching GUI software through interactive jobs.

    [:octicons-arrow-right-24: ThinLinc setup](accounts.md#thinlinc)

=== "Gateway (Web Browser)"
    Gateway (Open OnDemand) lets you manage files, submit jobs, and launch interactive applications entirely in a browser — no software to install.

    [**`https://gateway.gautschi.rcac.purdue.edu`**](https://gateway.gautschi.rcac.purdue.edu)

    Log in with your Purdue career account and Duo MFA.

    [:octicons-arrow-right-24: Gateway documentation](gateway.md)

---

## 3. Understand Your Storage

| Location | Path | Backed up? | Notes |
|---|---|---|---|
| Home directory | `$HOME` | Yes | Default landing directory; limited quota |
| Scratch space | `$RCAC_SCRATCH` | **No** | High-performance temporary storage; old files are purged |
| Long-term storage | `/depot/mylab` | Yes | Shared lab storage; must be purchased separately |

!!! warning
    Do not use scratch for long-term storage. Files not accessed within the purge window are permanently deleted without notice.

[:octicons-arrow-right-24: Full storage documentation](storage.md)

---

## 4. Load Software

Gautschi uses the **Lmod module system** to manage software. Key commands:

```bash
module avail <app>          # browse available software
module spider <app>         # search for an app and see load instructions
module load <app>           # load an app into your environment
module list                 # show currently loaded modules
module purge                # unload all modules
```

Example:
```bash
module spider matlab        # find available matlab versions
module load matlab/R2024a   # load a specific version
```

[:octicons-arrow-right-24: Full software documentation](software.md) · [:octicons-arrow-right-24: Software catalog](../../software/index.md)

---

## 5. Run a Job

All computations on Gautschi must be submitted through the **Slurm** scheduler. Create a submission script and submit it with `sbatch`.

**Minimal example — `hello.sub`:**
```bash
#!/bin/bash

#SBATCH -A myallocation       # your allocation account
#SBATCH -p cpu                # partition (cpu, ai, highmem, smallgpu)
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00       # max wall time (HH:MM:SS)

hostname
echo "Hello from Gautschi"
```

**Submit and monitor:**
```bash
sbatch hello.sub              # submit job; returns a job ID
squeue -u $USER               # check your job status
```

Output is written to `slurm-<jobid>.out` in the directory where you ran `sbatch`.

**Check your allocations:**
```bash
slist                         # view your accounts and available resources
```

[:octicons-arrow-right-24: Queues and partitions](run_jobs/queues.md) · [:octicons-arrow-right-24: Run jobs documentation](run_jobs/index.md)

---

## 6. Get Help

| Resource | Details |
|---|---|
| Email support | [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) |
| Outages & maintenance | [www.rcac.purdue.edu/news/outages-and-maintenance](https://www.rcac.purdue.edu/news/outages-and-maintenance) |
| Frequently asked questions | [Gautschi FAQs](faqs.md) |
