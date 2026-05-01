---
title: Running Bioinformatics Programs on RCAC
tags:
  - Life Sciences
  - HPC
  - Genomics Exchange
  - Guides
---

<div class="grid cards" markdown>

-   :material-check-circle: __Prerequisites__

    ---

    - RCAC cluster account ([apply here](https://www.rcac.purdue.edu/account/request))
    - Basic command-line familiarity (cd, ls, mkdir, nano/vim)
    - Access to Negishi, Gautschi, or Bell

-   :material-information: __What you will learn__

    ---

    - Find and load bioinformatics software via biocontainers
    - Understand how containerized wrappers work
    - Create and manage Conda environments
    - Write and submit SLURM batch jobs
    - Debug common failures

</div>

This guide covers the practical skills you need to run bioinformatics software on RCAC clusters.
RCAC deploys bioinformatics tools as **BioContainers** (pre-built Apptainer containers) accessed through the **Lmod module system**.
For tools not in the RCAC collection, you can use **Conda environments** or pull your own containers.
Most production work runs as batch jobs through the **SLURM** scheduler.

By the end of this guide you will be able to find any bioinformatics tool on RCAC, run it correctly, and submit efficient batch jobs.

## Getting a Terminal

You need a terminal session on the cluster before running any commands. There are two options:

=== "Open OnDemand (Browser)"

    1. Go to [gateway.negishi.rcac.purdue.edu](https://gateway.negishi.rcac.purdue.edu) and log in with your Purdue credentials.
        For other clusters, replace `negishi` with the cluster name (e.g., `gateway.gautschi.rcac.purdue.edu`, `gateway.bell.rcac.purdue.edu`, `gateway.gilbreth.rcac.purdue.edu`).
    2. Click **Clusters** in the top menu, then select the cluster shell (e.g., **Negishi Shell Access**).
    3. A terminal opens in your browser. You are on a **login node**.

=== "SSH (Terminal)"

    ```bash
    ssh <boilerid>@negishi.rcac.purdue.edu
    ```

    Replace `<boilerid>` with your Purdue career account username.
    On Gautschi, use `gautschi.rcac.purdue.edu`.

!!! warning
    Login nodes are shared. Do **not** run computationally intensive programs on login nodes.
    Use `sinteractive` for quick tests or `sbatch` for real work.

## Finding Software with Modules

RCAC uses the **Lmod** module system to manage software. Bioinformatics tools are deployed as pre-built [BioContainers](https://biocontainers.pro/) (Apptainer containers) and accessed through the `biocontainers` module.

### Searching for a tool

First, load the `biocontainers` module to make bioinformatics tools visible:

```bash
module --force purge
module load biocontainers
module spider samtools
```

`module spider` searches all modules, including those not yet visible. It shows available versions and any prerequisite modules.

To get loading instructions for a specific version:

```bash
module spider samtools/1.21
```

To list all available biocontainer modules:

```bash
module avail
```

### Loading a module

```bash
module --force purge
module load biocontainers samtools/1.21
```

The `biocontainers` module unlocks all bioinformatics software. You must load it before any tool module becomes visible.

!!! tip
    When you load `biocontainers`, you will see a message pointing to the user guides:

    ```
    User guides for each biocontainer module can be found in https://www.rcac.purdue.edu/knowledge/biocontainers
    ```

    This is a great resource for tool-specific documentation and examples.

Use `module --force purge` (not just `module purge`) to remove **sticky modules** like `xalt` that use a newer `glibc` and conflict with containerized tools. Here is what happens if you skip `--force`:

```bash
module load biocontainers bwa
bwa
```

```
/bin/sh: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found (required by /apps/external/apps/xalt3/xalt/xalt/lib64/libxalt_init.so)
/bin/sh: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /apps/external/apps/xalt3/xalt/xalt/lib64/libxalt_init.so)
```

The fix is to always start with `module --force purge`:

```bash
module --force purge
module load biocontainers bwa
bwa
```

After loading, run the tool as usual -- the output will appear as if the tool is installed natively.

Behind the scenes, RCAC creates **shell functions** that wrap each tool in an `apptainer`/`singularity` container call. When you type `bwa`, the function runs `singularity run <container.sif> bwa` for you.

### Understanding the wrapper

Because the tools are containerized, `which` and `type` will show the **shell function** that wraps the container call, not the actual executable:

```bash
which bwa
```

```
bwa ()
{
    /usr/bin/singularity run /apps/biocontainers/images/quay.io_biocontainers_bwa:0.7.17--h5bf99c6_8.sif env LANG=C.UTF-8 bwa "$@"
}
```

```bash
type bwa
```

```
bwa is a function
bwa ()
{
    /usr/bin/singularity run /apps/biocontainers/images/quay.io_biocontainers_bwa:0.7.17--h5bf99c6_8.sif env LANG=C.UTF-8 bwa "$@"
}
```

For most use cases this does not matter -- the function handles everything transparently. However, if a pipeline or workflow checks the executable path (e.g., `which bwa` to verify the installation), it will get the function definition instead of a file path. In that case, you may need to either:

- Write a custom wrapper script that satisfies the pipeline's path check
- Contact rcac-help@purdue.edu for assistance with pipeline-specific setups

### The `$BIOC_IMAGE_DIR` environment variable

Loading the `biocontainers` module sets the `$BIOC_IMAGE_DIR` environment variable, which points to the directory containing all container images:

```bash
echo $BIOC_IMAGE_DIR
# /apps/biocontainers/images
```

You can use this to run containers directly with `singularity run` or `apptainer exec` when you need more control (e.g., custom bind mounts, GPU flags, or piping between containerized tools):

```bash
singularity run ${BIOC_IMAGE_DIR}/quay.io_biocontainers_bwa:0.7.17--h5bf99c6_8.sif bwa mem ref.fa reads.fq
```

### Verifying the installation

```bash
module list
samtools --version
```

### Resetting your environment

```bash
module --force purge
```

Use `module --force purge` at the top of every SLURM script and whenever you hit a module conflict. The `--force` flag is important because it also removes sticky modules (like `xalt`) that a plain `module purge` would leave behind.

### Handling module conflicts

If you try to load two modules built with different compiler toolchains, Lmod will refuse with an error. The fix:

```bash
module --force purge
module load biocontainers samtools/1.21 bwa-mem2/2.2.1
```

Loading both in a single command lets Lmod resolve the dependency tree.

!!! tip
    **Always specify the version** in every `module load` command.
    `module load biocontainers samtools` may give you a different version tomorrow, and your collaborator may get yet another version.
    Explicit versions are essential for reproducibility.

## Pulling Custom Containers

All bioinformatics modules on RCAC are already containerized via BioContainers (see [Finding Software with Modules](#finding-software-with-modules) above). However, if a tool is not in the RCAC collection, you can pull your own container.

### When to pull a custom container

- The tool or version is not available via `module spider` after loading `biocontainers`
- You need a specific build variant or tag not deployed by RCAC
- You are developing or testing a custom pipeline image

### Pulling from a registry

If a tool is not in the biocontainers collection, pull it from a container registry:

```bash
cd ${RCAC_SCRATCH}
apptainer pull docker://quay.io/biocontainers/bwa:0.7.18--he4a0461_1
```

This creates a `.sif` file in the current directory. Run commands inside it with `apptainer exec`:

```bash
apptainer exec bwa_0.7.18--he4a0461_1.sif bwa
```

### Bind paths

RCAC auto-binds `/home`, `/scratch`, `/depot`, and `/tmp` into containers. For data in non-standard locations, bind manually:

```bash
apptainer exec --bind /my/custom/path container.sif <command>
```

## Conda Environments

Conda is useful for niche Python or R packages and tools with complex dependency trees that are not available as modules or containers.

### Creating an environment

```bash
module --force purge
module load conda
conda create -n multiqc_env -c bioconda -c conda-forge multiqc=1.25 -y
```

```bash
conda activate multiqc_env
multiqc --version
```

!!! danger
    **Never install packages into the base environment.**
    Always create a named environment with `conda create -n <name>`.
    Polluting the base environment causes hard-to-debug conflicts.

### Redirecting Conda storage

Conda environments are large (often 2--10 GB). Your Home directory is only ~25 GB.
Redirect Conda storage to Scratch by creating a `.condarc` file:

```yaml title="~/.condarc"
pkgs_dirs:
  - /scratch/negishi/${USER}/.conda/pkgs
envs_dirs:
  - /scratch/negishi/${USER}/.conda/envs
channels:
  - conda-forge
  - bioconda
  - defaults
auto_activate_base: false
```

Then create the directories:

```bash
mkdir -p /scratch/negishi/${USER}/.conda/pkgs
mkdir -p /scratch/negishi/${USER}/.conda/envs
```

!!! warning
    Scratch is purged after 60 days of inactivity. If your Conda environment sits untouched on Scratch, it will be deleted.
    For long-lived environments, consider using Depot storage instead.

## How Do I Find and Run Software X?

Use this decision table to pick the right method:

| Step | Action | Command |
|------|--------|---------|
| 1 | Load biocontainers | `module --force purge && module load biocontainers` |
| 2 | Search for the tool | `module spider <toolname>` |
| 3 | If found | `module load biocontainers <tool>/<version>` |
| 4 | If not, search Conda | `conda search -c bioconda <toolname>` |
| 5 | If found in Conda | `conda create -n <env> -c bioconda -c conda-forge <tool>=<ver>` |
| 6 | If not found anywhere | Pull a Docker/Apptainer container or build from source |

### Comparison: Biocontainers (Modules) vs Conda vs Custom Container

| | Biocontainers (Modules) | Conda | Custom Container |
|---|---|---|---|
| **Maintained by** | RCAC | You | You |
| **Install effort** | None | Medium | High |
| **Reproducibility** | Excellent (immutable image) | Fragile (solver can change) | Excellent |
| **Storage cost** | None | High (2--10 GB per env) | Medium (0.5--2 GB per image) |
| **Speed** | Near-native | Native | Near-native |
| **Updates** | RCAC manages | You manage | You manage |
| **Best for** | Most bioinformatics tools | Niche packages, R/Python envs | Full control, custom builds |

## Submitting SLURM Jobs

Login nodes are for editing files and submitting jobs. All computation should happen on **compute nodes** through SLURM.

### Interactive sessions

For quick testing, request an interactive session:

```bash
sinteractive -A <account-name> -n 4 -N 1 --time=1:00:00
```

This gives you a shell on a compute node where you can load modules and test commands. Type `exit` when done.

### Anatomy of a SLURM script

A SLURM batch script has three parts:

1. **Shebang**: `#!/bin/bash`
2. **`#SBATCH` directives**: resource requests parsed by SLURM (not executed by bash)
3. **Your commands**: module loads, tool invocations, file operations

### Example: BWA-MEM2 alignment

```bash title="slurm_bwa_align.sh"
#!/bin/bash
#SBATCH --job-name=bwa_align
#SBATCH --account=<account-name>
#SBATCH --partition=<partition-name>
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=04:00:00
#SBATCH --mem=32G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

module --force purge
module load biocontainers bwa-mem2/2.2.1 samtools/1.21

WORKDIR=/scratch/negishi/${USER}/alignment_project
REF=${WORKDIR}/ref/genome.fa
R1=${WORKDIR}/fastq/sample_R1.fastq.gz
R2=${WORKDIR}/fastq/sample_R2.fastq.gz
OUTDIR=${WORKDIR}/bam

mkdir -p ${OUTDIR}

bwa-mem2 mem \
    -t ${SLURM_CPUS_ON_NODE} \
    -R "@RG\tID:sample\tSM:sample\tPL:ILLUMINA\tLB:lib1" \
    ${REF} ${R1} ${R2} \
  | samtools sort -@ 4 -m 2G -o ${OUTDIR}/sample.sorted.bam -

samtools index ${OUTDIR}/sample.sorted.bam
samtools flagstat ${OUTDIR}/sample.sorted.bam
```

### Submitting and monitoring

```bash
sbatch slurm_bwa_align.sh
```

```bash
squeue -u ${USER}
```

```bash
scancel <jobid>
```

### SLURM Quick Reference

| Directive | Description | Typical value |
|-----------|-------------|---------------|
| `--account` | Allocation/account name | Check with `mybalance` |
| `--partition` | Queue/partition | Cluster-specific |
| `--nodes` | Number of nodes | `1` (almost always for bioinformatics) |
| `--ntasks` | Number of processes | `1` for single tools |
| `--cpus-per-task` | Threads per process | Match tool's `-t` flag (4--32) |
| `--time` | Wall clock limit | Start generous, tighten after `sacct` |
| `--mem` | Total memory | Check tool docs; start with 16--32G |
| `--job-name` | Name shown in `squeue` | Short, descriptive |
| `--output` | stdout file | `%x_%j.out` (name + job ID) |
| `--error` | stderr file | `%x_%j.err` |
| `--array` | Array job indices | `0-N` for batch processing |

### Array jobs

When running the same tool on multiple input files, use array jobs instead of submitting separate scripts.
Each array task gets a unique `SLURM_ARRAY_TASK_ID` (0, 1, 2, ...) that you use to select the input file.

```bash title="slurm_fastqc.sh"
#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --account=<account-name>
#SBATCH --partition=<partition-name>
#SBATCH --cpus-per-task=2
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --array=0-5
#SBATCH --output=fastqc_%A_%a.out
#SBATCH --error=fastqc_%A_%a.err

module --force purge
module load biocontainers fastqc/0.12.1

FASTQ_LIST=/scratch/negishi/${USER}/project/fastq_list.txt
OUTDIR=/scratch/negishi/${USER}/project/fastqc_results
mkdir -p ${OUTDIR}

FASTQ=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" ${FASTQ_LIST})

fastqc --outdir ${OUTDIR} --threads ${SLURM_CPUS_ON_NODE} --quiet ${FASTQ}
```

Create the file list first:

```bash
ls /scratch/negishi/${USER}/project/fastq/*.fastq.gz > fastq_list.txt
```

### Using Conda in SLURM

Conda requires shell initialization inside batch scripts. Without it, `conda activate` will fail:

```bash title="slurm_multiqc_conda.sh"
#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --account=<account-name>
#SBATCH --partition=<partition-name>
#SBATCH --cpus-per-task=2
#SBATCH --time=00:30:00
#SBATCH --mem=4G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

module --force purge
module load conda
eval "$(conda shell.bash hook)"
conda activate multiqc_env

multiqc /scratch/negishi/${USER}/project/fastqc_results \
    --outdir /scratch/negishi/${USER}/project/multiqc_output \
    --filename multiqc_report \
    --force

conda deactivate
```

The key line is `eval "$(conda shell.bash hook)"` -- this initializes Conda for the non-interactive bash shell that SLURM uses.

### Resource estimation

After a job completes, check what it actually used:

```bash
sacct -j <jobid> --format=JobID,JobName,MaxRSS,Elapsed,State,ExitCode
```

- **MaxRSS**: peak memory. Use this to right-size `--mem` next time.
- **Elapsed**: actual wall time. Use this to right-size `--time`.

Start generous, then tighten. Over-requesting wastes your allocation priority but under-requesting kills your job.

## Common Pitfalls

### "Command not found"

**Problem**: You run a tool and get `bash: samtools: command not found`.

**Diagnosis**: The module is not loaded, or you loaded `biocontainers` but forgot the tool module.

**Fix**:

```bash
module --force purge
module load biocontainers samtools/1.21
```

If `module spider` cannot find the tool after loading `biocontainers`, it may not be installed on this cluster. Try Conda or pull a custom container.

### SLURM job disappears with no output

**Problem**: Your job vanishes from `squeue` but produced no output files.

**Diagnosis**: Check the `.err` file and `sacct`:

```bash
cat <jobname>_<jobid>.err
sacct -j <jobid> --format=JobID,State,ExitCode,MaxRSS
```

**Common states**:

| State | Meaning |
|-------|---------|
| `COMPLETED` | Finished successfully (exit code 0:0) |
| `FAILED` | Your script had an error |
| `OUT_OF_MEMORY` | Exceeded `--mem` request |
| `TIMEOUT` | Exceeded `--time` request |
| `CANCELLED` | Manually cancelled or preempted |

### Out of memory (OOM)

**Problem**: `sacct` shows `OUT_OF_MEMORY`.

**Fix**: Increase `--mem`. Check `MaxRSS` of the failed job to see peak usage, then request 20--30% more.

### Scratch data disappeared

**Problem**: Your files on `/scratch` are gone.

**Diagnosis**: Scratch is purged after 60 days of inactivity. There is no warning and no recovery.

**Fix**: Move important results to Home or Depot promptly. For active projects, periodic access resets the clock.

### Module conflicts

**Problem**: `Lmod has detected the following error: ...` when loading modules.

**Fix**: Start fresh:

```bash
module --force purge
module load biocontainers <tool1>/<version> <tool2>/<version>
```

### Conda won't activate in SLURM

**Problem**: `CommandNotFoundError: Your shell has not been properly configured...`

**Fix**: Add shell initialization before `conda activate`:

```bash
module --force purge
module load conda
eval "$(conda shell.bash hook)"
conda activate myenv
```

### Wrong cluster, wrong paths

**Problem**: Script fails because `/scratch/negishi/` does not exist on Gautschi.

**Fix**: Use `${RCAC_SCRATCH}` instead of hardcoding the cluster name:

```bash
WORKDIR=${RCAC_SCRATCH}/my_project
```

This resolves to the correct path on any RCAC cluster.

## Debugging Workflow

When a job fails, follow these steps:

1. **Check the exit code**: `echo $?` (0 = success, non-zero = failure)
2. **Read the error log**: `cat <jobname>_<jobid>.err`
3. **Check job accounting**: `sacct -j <jobid> --format=JobID,State,ExitCode,MaxRSS,Elapsed`
4. **Reproduce interactively**: `sinteractive -A <account-name> -n 4 --time=1:00:00`, load modules, run the failing command
5. **Search the error message**: Google, Biostars, or the tool's GitHub Issues
6. **Ask for help**: Email rcac-help@purdue.edu with your job ID and the error message

## Conda Configuration Template

Copy this `.condarc` to your home directory to redirect Conda storage off of Home:

```yaml title="~/.condarc"
pkgs_dirs:
  - /scratch/negishi/${USER}/.conda/pkgs
envs_dirs:
  - /scratch/negishi/${USER}/.conda/envs
channels:
  - conda-forge
  - bioconda
  - defaults
auto_activate_base: false
```

!!! note
    On Gautschi, replace `/scratch/negishi/` with `/scratch/gautschi/` or use `${RCAC_SCRATCH}/.conda/`.

## Resources

- **RCAC Bioinformatics Tutorials**: [rcac-bioinformatics.github.io/guide/](https://rcac-bioinformatics.github.io/guide/)
- **RCAC Knowledge Base**: [www.rcac.purdue.edu/knowledge](https://www.rcac.purdue.edu/knowledge)
- **Open OnDemand**: [gateway.negishi.rcac.purdue.edu](https://gateway.negishi.rcac.purdue.edu) (replace `negishi` with your cluster name)
- **Discord**: [discord.gg/zEF2nzhXdC](https://discord.gg/zEF2nzhXdC)
- **Email**: rcac-help@purdue.edu (include "bioinformatics support" in the subject line)

## What's Next

**Session 6: QC for Genomics** -- April 7, 2026, 11:00 AM -- 12:00 PM ET

Topics: FastQC interpretation, fastp trimming, MultiQC aggregation, quality control strategies for different sequencing platforms.
