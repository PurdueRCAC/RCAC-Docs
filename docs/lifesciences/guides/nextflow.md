---
title: Nextflow and nf-core on Negishi
tags:
  - Life Sciences
  - Nextflow
  - Guides
---

# Nextflow and nf-core on Negishi

[Nextflow](https://www.nextflow.io/) is a workflow manager that lets you describe
complex data analysis pipelines in a portable, reproducible way. [nf-core](https://nf-co.re/)
is a community-curated collection of production-grade Nextflow pipelines for
genomics, transcriptomics, epigenomics, and more, including `rnaseq`, `sarek`,
`ampliseq`, `mag`, `atacseq`, and many others.

This guide walks you through installing Nextflow, installing the `nf-core` tools,
configuring both for SLURM and Apptainer/Singularity on **Negishi**, and launching
your first pipeline. The same steps work on Bell, Gautschi, and Gilbreth with
minor edits to partition names and resource ceilings.

## Quick start

If you have used Nextflow before and just want the commands:

```bash
# Nextflow
module --force purge
module load openjdk
mkdir -p ~/bin && cd ~/bin
curl -s https://get.nextflow.io | bash
chmod +x nextflow
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# nf-core tools (via the conda module; Negishi's system python3 is 3.6, too old)
module load conda
conda create -n nf-core -c bioconda -c conda-forge nf-core -y
conda activate nf-core
```

Then copy the [minimal Negishi config](#a-minimal-working-config-for-negishi)
below, edit the two `REQUIRED` lines, and launch a pipeline from a compute node:

```bash
nextflow run nf-core/demo -profile test,singularity -c my_negishi.config --outdir results
```

Read on for the step-by-step version.

## Installing Nextflow

Nextflow is a single self-contained JAR wrapped in a small shell script. You
only need Java 17 or newer to run it.

1. **Check your `java` version**

    ```bash
    module --force purge
    module load openjdk
    java -version
    ```

    You need Java 17 or newer. If `openjdk` is not available or reports an
    older version, see the [FAQ below](#faqs) for installing Java via SDKMAN.

2. **Download the Nextflow launcher**

    ```bash
    mkdir -p ~/bin
    cd ~/bin
    curl -s https://get.nextflow.io | bash
    ```

    This downloads the `nextflow` launcher into `~/bin/`.

3. **Make it executable and add it to your `PATH`**

    ```bash
    chmod +x ~/bin/nextflow
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    source ~/.bashrc
    ```

4. **Verify the installation**

    ```bash
    nextflow -version
    ```

!!! tip
    To update Nextflow in the future, run `nextflow self-update`. Nextflow also
    writes per-user state (pipeline cache, work directories for plugins) under
    `~/.nextflow/`. If your home directory is tight on quota, set
    `export NXF_HOME=$RCAC_SCRATCH/.nextflow` in your `~/.bashrc` to move it to scratch.

## Installing nf-core tools

The `nf-core` Python package gives you a command-line tool for discovering,
downloading, linting, and launching nf-core pipelines. It is separate from
Nextflow itself. You do not strictly need it to run a pipeline, but it makes
the common tasks much easier.

nf-core tools requires **Python 3.8 or newer**. Negishi's system `python3` is
3.6.8 (too old), but loading the `conda` module gives you conda itself plus a
recent Python (3.12). Use it to create a dedicated conda environment for
nf-core tools.

1. **Load the `conda` module**

    ```bash
    module --force purge
    module load conda
    ```

    Verify that you have a recent Python on `PATH`:

    ```bash
    python3 --version
    ```

2. **Create a dedicated environment for nf-core tools**

    ```bash
    conda create -n nf-core -c bioconda -c conda-forge nf-core -y
    ```

    This pulls `nf-core` from the bioconda channel and resolves all its
    Python dependencies in one shot.

3. **Activate the environment and verify**

    ```bash
    conda activate nf-core
    nf-core --version
    nf-core pipelines list
    ```

    `nf-core pipelines list` prints every released nf-core pipeline with its
    latest version and a short description.

??? note "Example `nf-core pipelines list` output (click to expand)"

    ```text
                                              ,--./,-.
              ___     __   __   __   ___     /,-._.--~\
        |\ | |__  __ /  ` /  \ |__) |__         }  {
        | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                              `._,._,'

        nf-core/tools version 3.5.2 - https://nf-co.re


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ Pipeline Name             ┃ Stars ┃ Latest Release ┃       Released ┃ Last Pulled ┃ Have latest release? ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
    │ differentialabundance     │    91 │          1.5.0 │    2 years ago │           - │ -                    │
    │ taxprofiler               │   184 │          1.2.6 │   2 months ago │           - │ -                    │
    │ ...                       │   ... │            ... │            ... │         ... │ ...                  │
    └───────────────────────────┴───────┴────────────────┴────────────────┴─────────────┴──────────────────────┘
    ```

!!! note
    In a new shell, reload the module and then reactivate the environment:
    `module load conda && conda activate nf-core`. You do **not** need the
    environment active to run a pipeline with `nextflow run nf-core/<pipeline>`;
    it is only required for the `nf-core` CLI itself.

!!! tip
    By default, conda writes environments to `$HOME/.conda/envs/`, which can
    quickly exhaust your home quota. Point `envs_dirs` at scratch **before**
    creating the environment:

    ```bash
    mkdir -p $RCAC_SCRATCH/conda_envs
    conda config --add envs_dirs $RCAC_SCRATCH/conda_envs
    ```

## A minimal working config for Negishi

Nextflow reads a config file (`-c`) to learn how to submit jobs, where to cache
containers, and how much CPU, memory, and walltime to request for each process.
nf-core pipelines tag every process with standardized labels
(`process_single`, `process_low`, `process_medium`, `process_high`,
`process_long`, `process_high_memory`). Your job is to map those labels to
sensible Negishi resource requests.

The block below is a starting `my_negishi.config` that handles SLURM
submission, container setup, and defaults for all standard nf-core process
labels. Save it next to your launch script and pass it with `-c my_negishi.config`.

Before first use, edit the two lines marked `REQUIRED`:

- `config_profile_contact`: your Purdue email.
- `clusterOptions`: your SLURM account. Run `slist` on Negishi to see the
  accounts you belong to.

```groovy title="my_negishi.config"
// my_negishi.config
// Minimal working Nextflow config for nf-core pipelines on RCAC Negishi.
// Usage:  nextflow run nf-core/<pipeline> -profile singularity -c my_negishi.config ...
//
// Before first use, edit the two lines marked REQUIRED below.

params {
    config_profile_description = 'RCAC Negishi (Purdue University)'
    config_profile_contact     = 'your.email@purdue.edu'              // REQUIRED
    config_profile_url         = 'https://www.rcac.purdue.edu/compute/negishi'

    // Ceilings nf-core pipelines clamp resource requests against.
    // cpu partition: 128 cores / 257 GB per node.
    max_cpus   = 128
    max_memory = '250.GB'
    max_time   = '14.d'
}

// Container runtime. apptainer/singularity are on PATH on Negishi; no module load needed.
singularity {
    enabled    = true
    autoMounts = true
    cacheDir   = "${System.getenv('RCAC_SCRATCH')}/.singularity_cache"
}

// SLURM scheduler settings.
executor {
    name            = 'slurm'
    queueSize       = 100          // max concurrent SLURM jobs from this run
    submitRateLimit = '10 sec'     // throttle submissions to be kind to the scheduler
    pollInterval    = '30 sec'
}

// Per-process defaults and resource tiers.
process {
    executor       = 'slurm'
    queue          = 'cpu'
    clusterOptions = '-A YOUR_ACCOUNT'   // REQUIRED: run `slist` to see your accounts
    scratch        = true                // stage task work on node-local $TMPDIR

    // Retry once on common transient failures, then stop.
    errorStrategy = { task.exitStatus in [104,134,137,139,140,143,247] ? 'retry' : 'finish' }
    maxRetries    = 1

    // nf-core standard process labels mapped to Negishi tiers.
    withLabel:process_single {
        cpus   = 1
        memory = 4.GB
        time   = 4.h
    }
    withLabel:process_low {
        cpus   = 2
        memory = 12.GB
        time   = 6.h
    }
    withLabel:process_medium {
        cpus   = 8
        memory = 48.GB
        time   = 12.h
    }
    withLabel:process_high {
        cpus   = 32
        memory = 200.GB
        time   = 1.d
    }
    withLabel:process_long {
        time   = 7.d
    }
    // Sends the job to the highmem partition (1 TB nodes, 1-day walltime cap).
    withLabel:process_high_memory {
        queue  = 'highmem'
        cpus   = 32
        memory = 900.GB
        time   = 1.d
    }
}

// Run reports for post-hoc resource audit. Remove if you do not want them.
timeline { enabled = true; file = "${params.outdir}/pipeline_info/timeline.html" }
report   { enabled = true; file = "${params.outdir}/pipeline_info/report.html"   }
trace    { enabled = true; file = "${params.outdir}/pipeline_info/trace.txt"     }
dag      { enabled = true; file = "${params.outdir}/pipeline_info/dag.html"      }
```

!!! note
    The `process_high_memory` label routes jobs to the `highmem` partition
    (1 TB nodes, 1-day walltime cap). This is handled automatically by pipelines
    that tag memory-hungry steps with the standard nf-core labels; you do not need
    to edit the pipeline to take advantage of it.

!!! warning
    Negishi GPUs are AMD and are not currently useful for most bioinformatics
    pipelines, which assume CUDA. Do not expect nf-core GPU-tagged processes to run.

## Running your first pipeline

A good smoke test is [`nf-core/demo`](https://nf-co.re/demo), a tiny pipeline
that only exercises FastQC and MultiQC on a handful of small FASTQ files. It
finishes in a few minutes and confirms that SLURM submission, Apptainer, and
your config are all wired up correctly.

The Nextflow "head" process is long-running; it stays alive for the entire
pipeline, submitting and monitoring child jobs. **Do not run it on a login
node.** Submit it as its own low-resource SLURM job.

```bash title="run_demo.sh"
#!/bin/bash
#SBATCH --job-name=nf-demo
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=1-00:00:00
#SBATCH -A <account-name>
#SBATCH -p <partition-name>
#SBATCH -o nf-demo-%j.out
#SBATCH -e nf-demo-%j.err

module --force purge
module load openjdk

# Keep the Nextflow JVM small; the real work happens in child SLURM jobs.
export NXF_OPTS='-Xms1g -Xmx4g'

# Cache Singularity images in scratch so repeat runs do not re-download.
export NXF_SINGULARITY_CACHEDIR="${RCAC_SCRATCH}/.singularity_cache"

nextflow run nf-core/demo \
    -profile test,singularity \
    -c my_negishi.config \
    --outdir "${RCAC_SCRATCH}/nf-demo-results"
```

Submit it from the directory containing `my_negishi.config`:

```bash
sbatch run_demo.sh
```

When the run finishes, you should see a directory structure like this under
`$RCAC_SCRATCH/nf-demo-results/`:

```text
nf-demo-results/
├── fastqc/
│   ├── SAMPLE1_PE/
│   │   ├── SAMPLE1_PE_1_fastqc.html
│   │   └── SAMPLE1_PE_2_fastqc.html
│   ├── SAMPLE2_PE/
│   │   ├── SAMPLE2_PE_1_fastqc.html
│   │   └── SAMPLE2_PE_2_fastqc.html
│   └── SAMPLE3_SE/
│       ├── SAMPLE3_SE_1_fastqc.html
│       └── SAMPLE3_SE_2_fastqc.html
├── fq/
│   ├── SAMPLE1_PE/
│   │   ├── SAMPLE1_PE_sample1_R1.fastq.gz
│   │   └── SAMPLE1_PE_sample1_R2.fastq.gz
│   ├── SAMPLE2_PE/
│   │   ├── SAMPLE2_PE_sample2_R1.fastq.gz
│   │   └── SAMPLE2_PE_sample2_R2.fastq.gz
│   └── SAMPLE3_SE/
│       ├── SAMPLE3_SE_sample1_R1.fastq.gz
│       └── SAMPLE3_SE_sample2_R1.fastq.gz
├── multiqc/
│   ├── multiqc_data/
│   ├── multiqc_plots/
│   │   ├── pdf/
│   │   ├── png/
│   │   └── svg/
│   └── multiqc_report.html
└── pipeline_info/
    ├── dag.html
    ├── nf_core_demo_software_mqc_versions.yml
    ├── params_2026-04-09_14-36-38.json
    ├── report.html
    ├── timeline.html
    └── trace.txt
```

Open `multiqc_report.html` in a browser to confirm the run produced real output.

!!! tip
    Once the demo runs cleanly, swap `nf-core/demo` for a real pipeline and drop
    the `test` profile. For example:
    `nextflow run nf-core/rnaseq -profile singularity -c my_negishi.config --input samplesheet.csv --outdir ${RCAC_SCRATCH}/rnaseq --genome GRCh38`.
    Every nf-core pipeline documents its required parameters on its page at
    [nf-co.re/pipelines](https://nf-co.re/pipelines).

## Best practices

- **Run Nextflow from scratch, not home.** The `work/` directory Nextflow
  creates holds intermediate files for every task and can grow to hundreds of
  gigabytes. Launch from `$RCAC_SCRATCH/<project>/` so it lands on scratch.
- **Reuse the image cache.** Setting `NXF_SINGULARITY_CACHEDIR` (or
  `singularity.cacheDir` in the config) to a stable path in scratch means
  subsequent runs reuse the downloaded container images instead of re-pulling.
- **Use `-resume`.** If a run fails partway through, add `-resume` to your
  next `nextflow run` command and it will pick up from the last successful
  task instead of restarting from scratch.
- **Clean up `work/` when done.** Once you have copied the final results out,
  `rm -rf work/ .nextflow*` inside the launch directory. It is disposable.
- **Pin pipeline versions** with `-r <tag>` (e.g. `-r 3.14.0`) so reruns are
  reproducible.

## FAQs

??? note "What is the difference between Nextflow and nf-core? [click to expand]"

    **Nextflow** is the workflow engine: the language and runtime that execute
    pipelines. **nf-core** is a community project that publishes a curated set of
    production-quality Nextflow pipelines (and a Python CLI for working with them).
    You install Nextflow to run any Nextflow pipeline; you install nf-core tools
    in addition if you want the discovery, download, and linting helpers.

??? note "Can I launch pipelines directly from a login node? [click to expand]"

    No. The Nextflow head process runs for as long as the pipeline runs (hours or
    days), and login nodes are for short interactive work only. Always submit
    `nextflow run` from inside an `sbatch` script (as shown in the run_demo.sh
    example above) or from an `sinteractive` session on a compute node.

??? note "How do I use a different cluster (Bell, Gautschi, Gilbreth)? [click to expand]"

    Copy `my_negishi.config` to `my_<cluster>.config` and edit:

    - `config_profile_description` / `config_profile_url`: cluster name and URL.
    - `max_cpus`, `max_memory`, `max_time`: match the target cluster's largest
      compute node and walltime limits.
    - `process.queue`: default partition on that cluster.
    - `process.withLabel:process_high_memory { queue = ... }`: the cluster's
      high-memory partition name (if any).

    Everything else (SLURM executor, Apptainer, retry logic, label tiers) transfers
    unchanged.

??? note "What to do when `java` is not available? [click to expand]"

    If the `java` version you need is not available as a module, install it with
    SDKMAN:

    1. **Install SDKMAN**

        ```bash
        cd $HOME
        curl -s https://get.sdkman.io | bash
        ```

    2. **Load SDKMAN**

        ```bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        ```

    3. **Install Java 17**

        ```bash
        sdk install java 17.0.8-tem
        ```

    4. **Verify Java installation**

        ```bash
        java -version
        ```

??? note "Pipeline fails with 'Failed to pull singularity image'. What now? [click to expand]"

    This is almost always a transient network or cache issue. Check:

    1. `NXF_SINGULARITY_CACHEDIR` (or `singularity.cacheDir`) points to a directory
       you can write to. Scratch is a safe choice.
    2. You are on a compute node with outbound network access (all Negishi
       compute nodes have it by default).
    3. Disk quota on scratch has not been exceeded.

    Then rerun with `-resume` to continue from where it failed without losing
    completed tasks.
