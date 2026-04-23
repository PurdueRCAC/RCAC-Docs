---
title: Reproducible Bioinformatics Using Nextflow
tags:
  - Life Sciences
  - Nextflow
  - Genomics Exchange
  - Guides
---

# Reproducible Bioinformatics Using Nextflow

<div class="grid cards" markdown>

-   :material-check-circle: **Prerequisites**

    ---

    - Active Gautschi cluster account with a SLURM allocation
    - Ability to SSH into `gautschi.rcac.purdue.edu` or use [Open OnDemand](https://gateway.gautschi.rcac.purdue.edu)
    - Familiarity with `sbatch`, `sinteractive`, and basic Linux commands
    - Completed [Session 5](running-bioinformatics.md) or equivalent experience

-   :material-information: **What you will learn**

    ---

    - Understand why workflow managers matter for reproducibility
    - Read and recognize the key parts of a Nextflow pipeline
    - Run nf-core pipelines on Gautschi using the `purdue_gautschi` institutional profile
    - Inspect execution artifacts: `work/` directories, reports, and trace files
    - Use `-resume` to restart failed or interrupted runs without losing progress

</div>

This guide accompanies **Genomics Exchange Session 7** (April 21, 2026). It walks you through running two nf-core pipelines on Gautschi using Nextflow 25.10.04, the `purdue_gautschi` institutional profile, and Apptainer containers. The goal is practical: by the end, you will have launched real pipelines on Gautschi and know how to do it again for your own data.

This is not a Nextflow programming tutorial. You will not write any pipeline code. Instead, you will learn to recognize what a pipeline does when you read one, and then focus on the operational skills that matter day to day: launching, monitoring, inspecting, resuming, and cleaning up.

For background on installing Nextflow manually and writing your own configs, see the [Nextflow and nf-core guide](nextflow.md).

## Why workflow managers

A bioinformatics analysis is rarely a single command. A typical project chains together quality control, trimming, alignment, quantification, and statistical analysis, each with its own software, parameters, and resource requirements. When you run these steps by hand or with a collection of shell scripts, three problems appear quickly:

1. **Reproducibility breaks down.** Six months later you rerun the analysis and get different results because a tool version changed, a parameter was different, or an intermediate file was overwritten.
2. **Resuming is painful.** A job fails at step 7 of 12. You have to figure out which steps completed, which need rerunning, and which inputs are still valid.
3. **Scaling is manual.** Moving from 3 samples to 300 means editing paths, managing job dependencies, and hoping nothing collides.

Workflow managers solve these problems by describing your analysis as a directed graph of tasks with explicit inputs, outputs, and software containers. The three most common in bioinformatics are Make (the oldest, general-purpose), Snakemake (Python-based, file-centric), and Nextflow (Groovy-based, dataflow-centric). All three can submit jobs to SLURM and run inside containers.

Nextflow is a strong choice when you want to use community-maintained pipelines rather than writing everything yourself. The [nf-core](https://nf-co.re/) project publishes over 100 production-grade Nextflow pipelines for genomics, transcriptomics, metagenomics, proteomics, and more. Each pipeline comes with test data, documentation, container definitions, and institutional config support. That last point is what makes Nextflow particularly convenient on RCAC clusters: someone has already written the configuration for your cluster.

!!! note
    Nextflow is overkill for a one-off, single-tool command. If your entire analysis is `fastp | bwa mem | samtools sort`, a shell script is fine. Workflow managers pay off when you have multi-step pipelines, multiple samples, or a need to reproduce the analysis later.

## Reading a Nextflow pipeline

Before you run anything, it helps to recognize the building blocks of a Nextflow pipeline. We will walk through the structure of `nf-core/hello`, the smallest nf-core pipeline, to build that vocabulary. You do not need to understand every line. The goal is to know what you are looking at when you open a `main.nf` file.

A Nextflow pipeline has four key concepts:

**Channels** are asynchronous queues that carry data between steps. Think of them as conveyor belts: one process places items on the belt, and the next process picks them up. Channels are what make Nextflow a dataflow language rather than a scripting language.

**Processes** are the individual tasks that do work. Each process has an `input` block (what it reads from channels), an `output` block (what it produces), and a `script` block (the shell commands to run). Nextflow wraps each process execution in its own directory under `work/` and can run multiple instances in parallel.

**Operators** transform channels. For example, `.map{}` transforms each item, `.collect()` gathers all items into a single list, and `.flatten()` does the reverse. You will see operators chained in pipeline code to reshape data between processes.

**The `workflow {}` block** ties everything together. It calls processes, connects their channels, and defines the execution order. In nf-core pipelines, the workflow block is usually in `main.nf` at the top level.

Here is a simplified sketch of what an nf-core pipeline looks like structurally:

```groovy
// Parameters with defaults (overridable from the command line)
params.greeting = "Hello"

// A process: takes input from a channel, runs a command, produces output
process SAY_HELLO {
    input:
    val(name)

    output:
    path("*.txt")

    script:
    """
    echo '${params.greeting}, ${name}!' > ${name}.txt
    """
}

// The workflow block: wires channels to processes
workflow {
    names_ch = Channel.of("world", "Nextflow", "nf-core")
    SAY_HELLO(names_ch)
}
```

In a real nf-core pipeline like `rnaseq` or `sarek`, the structure is identical but with dozens of processes, subworkflows organized into modules, and a `nextflow.config` file that defines parameters, profiles, and container images. The concepts scale without changing.

!!! tip
    You do not need to learn Groovy to use nf-core pipelines. Treat the pipeline code as read-only documentation: if something goes wrong, reading `main.nf` and the relevant process module tells you exactly which command was run and what it expected.

## Setting up on Gautschi

Gautschi provides Nextflow as a module. You do not need to install it yourself. Java is included as a module dependency.

1. **Start an interactive session**

    All Nextflow runs must happen on a compute node, not a login node. The Nextflow head process stays alive for the entire pipeline and submits child SLURM jobs on your behalf.

    ```bash
    sinteractive -A <your-account> -N 1 -n 2 -p cpu -t 2:00:00
    ```

    !!! warning
        Replace `<your-account>` with your SLURM allocation name throughout this guide. Run `slist` on a Gautschi login node to see your allocations.

2. **Create the working directory and load Nextflow**

    ```bash
    mkdir -p $RCAC_SCRATCH/nextflow-workshop
    cd $RCAC_SCRATCH/nextflow-workshop

    module purge
    module load nextflow/25.10.04
    ```

3. **Set environment variables**

    These tell Nextflow where to store its internal state, task work directories, and cached container images.

    ```bash
    export NXF_HOME=$RCAC_SCRATCH/nextflow-workshop/.nextflow
    export NXF_WORK=$RCAC_SCRATCH/nextflow-workshop/work
    export NXF_SINGULARITY_CACHEDIR=$RCAC_SCRATCH/nextflow-workshop/singularity-cache
    mkdir -p $NXF_SINGULARITY_CACHEDIR
    ```

    | Variable | Purpose |
    |:---------|:--------|
    | `NXF_HOME` | Nextflow metadata, plugin cache, and history. Defaults to `~/.nextflow`, which can exhaust home quota. |
    | `NXF_WORK` | Root of the `work/` tree where each task runs in its own hash-named directory. |
    | `NXF_SINGULARITY_CACHEDIR` | Shared location for downloaded container images. Prevents re-pulling on every run. |

!!! tip
    If the container cache is already warm (from a previous run or a shared location), pipeline startup is much faster. For this workshop, the instructor has pre-pulled the required images. On your own projects, the first run of a new pipeline will spend several minutes downloading containers.

## Hands-on 1: running a local hello pipeline

Before we use a published nf-core pipeline, we will run the exact code from the section above as a real Nextflow pipeline. This confirms that Nextflow is working and gives you a concrete feel for what happens when you type `nextflow run`.

Create a directory called `hello/` and save the following as `hello/main.nf`:

```groovy title="hello/main.nf"
params.greeting = "Hello"

process SAY_HELLO {
    debug true

    input:
    val(name)

    output:
    stdout

    script:
    """
    echo '${params.greeting}, ${name}!'
    """
}

workflow {
    Channel.of("world", "Nextflow", "nf-core") | SAY_HELLO
}
```

Or, if you cloned the workshop repository, the file is already at `rcac-nextflow-demo/hello/main.nf`.

Now run it:

```bash
nextflow run ./hello
```

Because `debug true` is set on the process, Nextflow prints each task's stdout directly to your terminal. You should see output like:

```text
N E X T F L O W  ~  version 25.10.04

Launching `./hello/main.nf` [friendly_name] DSL2 - revision: ...

executor >  local (3)
[0f/0ae10a] SAY_HELLO (1) | 3 of 3 ✔
Hello, world!
Hello, Nextflow!
Hello, nf-core!
```

This ran with the **local executor** (tasks ran as processes on this compute node, not as separate SLURM jobs). That is fine for a 3-task pipeline that takes one second. For real pipelines with dozens of tasks and heavy resource requirements, we use the SLURM executor via an institutional profile. That is what we do next.

Try changing the greeting parameter from the command line:

```bash
nextflow run ./hello --greeting "Howdy"
```

The `params.greeting` value is now "Howdy" and the output reflects it. This is how all Nextflow pipelines accept configuration: parameters defined in the pipeline code can be overridden with `--paramName value` on the command line.

!!! tip
    Look inside the `work/` directory that just appeared. Even for this trivial pipeline, Nextflow created a hash-named directory for each task containing `.command.sh`, `.command.log`, and `.exitcode`. The structure is identical whether you run locally or via SLURM.

## Hands-on 2: nf-core/demo

Now that the basic plumbing works, we will run a more realistic pipeline. `nf-core/demo` takes FASTQ files through FastQC (quality assessment), seqtk (subsampling), and MultiQC (report aggregation). With the built-in test data, it finishes in 5 to 8 minutes.

```bash
nextflow run nf-core/demo \
    -profile test,purdue_gautschi \
    --cluster_account <your-account> \
    -r 1.1.0 \
    --outdir results-demo
```

The flags:
- `-profile test,purdue_gautschi` loads built-in test data, the Gautschi institutional config (SLURM executor, partitions, iGenomes), and enables Apptainer containers.
- `--cluster_account` passes your allocation to SLURM child jobs.
- `-r 1.1.0` pins the pipeline to a specific release so the same version runs today as six months from now. Without `-r`, Nextflow pulls whatever the latest version is, which can silently break reproducibility.
- `--outdir` tells the pipeline where to place final results.

While you wait, watch the progress table. You will see tasks for `FASTQC`, `SEQTK_TRIM`, and `MULTIQC` appear and complete. Each task runs as a separate SLURM job.

When the pipeline finishes, inspect the results:

```bash
ls results-demo/
```

You should see directories for `fastqc/`, `fq/`, `multiqc/`, and `pipeline_info/`.

```text
results-demo/
├── fastqc/
│   ├── SAMPLE1_PE/
│   ├── SAMPLE2_PE/
│   └── SAMPLE3_SE/
├── fq/
│   ├── SAMPLE1_PE/
│   ├── SAMPLE2_PE/
│   └── SAMPLE3_SE/
├── multiqc/
│   ├── multiqc_plots/
│   ├── multiqc_data/
│   └── multiqc_report.html
└── pipeline_info/
    ├── execution_report_2026-04-20_21-06-52.html
    ├── execution_timeline_2026-04-20_21-06-52.html
    ├── execution_trace_2026-04-20_21-06-52.txt
    ├── nf_core_demo_software_mqc_versions.yml
    ├── params_2026-04-20_21-06-56.json
    └── pipeline_dag_2026-04-20_21-06-52.html
```

The `pipeline_info/` directory contains three files worth examining:

- **`execution_report.html`**: CPU, memory, and walltime usage per task. Shows whether your resource requests were right-sized.
- **`execution_timeline.html`**: Gantt chart of when each task started and finished. Useful for spotting bottlenecks.
- **`execution_trace.txt`**: Tab-delimited table with one row per task, including the actual peak memory and CPU usage.

### Testing resume

One of Nextflow's most valuable features is its ability to resume an interrupted run. To demonstrate this, kill the pipeline mid-run with `Ctrl+C`, then relaunch with `-resume`:

```bash
nextflow run nf-core/demo \
    -profile test,purdue_gautschi \
    --cluster_account <your-account> \
    -r 1.1.0 \
    --outdir results-demo \
    -resume
```

Nextflow checks the `work/` directory for tasks that already completed successfully and marks them as `[cached]`. Only the remaining tasks run. On a real project with hundreds of samples where a single task fails at hour 10, this saves you from starting over.

## Understanding what just happened

Every task Nextflow executes gets its own directory under `work/`, named with a hash derived from the task's inputs and script. This is how `-resume` works: if the hash matches, the output is reused.

Look inside the work directory:

```bash
ls work/
```

You will see two-character subdirectories like `a1/`, `b3/`, `f7/`. Each contains one or more hash-named directories. Pick one and look inside:

```bash
ls -la work/*/*/ | head -20
```

Every task directory contains:

| File | Purpose |
|:-----|:--------|
| `.command.sh` | The exact shell script Nextflow generated and ran |
| `.command.run` | The SLURM wrapper that submitted `.command.sh` |
| `.command.log` | Combined stdout and stderr from the task |
| `.exitcode` | The exit status (0 = success) |
| `.command.begin` | Timestamp when the task started |

Reading `.command.sh` is the single most useful debugging technique. It shows you exactly which command ran, with which parameters, in which container. When a task fails, start here.

```bash
cat work/*/*/.command.sh | head -20
```

!!! tip
    The `work/` directory can grow large on real projects. Once you have confirmed your results are correct and copied them to a permanent location, delete `work/` to reclaim disk space. See the [Cleanup](#cleanup) section below.

## The purdue_gautschi profile

The `purdue_gautschi` profile is an institutional configuration maintained in the [nf-core/configs](https://github.com/nf-core/configs) repository. When you pass `-profile purdue_gautschi`, Nextflow loads a config that handles three things you would otherwise have to configure yourself:

1. **SLURM integration.** The executor is set to `slurm`, the default queue is `cpu`, and the `--cluster_account` parameter is wired to SLURM's `-A` flag.
2. **Container runtime.** Apptainer (aliased as `singularity` on Gautschi) is enabled with `autoMounts = true`.
3. **Resource ceilings.** `max_cpus`, `max_memory`, and `max_time` are set to match the Gautschi CPU node specs (192 cores, 384 GB, 14 days), and the iGenomes mirror at `/depot/itap/datasets/igenomes` is configured so pipelines that use reference genomes do not re-download them.

You can layer your own config on top of the profile with `-c my_custom.config`. Settings in your file override the profile where they overlap. This is how the workshop overlay in the companion repository caps per-task resources to avoid monopolizing shared nodes.

!!! note
    The `purdue_gautschi` profile was merged in [nf-core/configs PR #1085](https://github.com/nf-core/configs/pull/1085) on April 14, 2026. It is automatically available to any Nextflow run that specifies `-profile purdue_gautschi` without downloading anything extra.

## Going further

### nf-core/fetchngs

If you have time remaining, try `nf-core/fetchngs`. It downloads FASTQ files from SRA/ENA given a list of accession IDs, and produces a samplesheet you can feed directly into other nf-core pipelines.

```bash
nextflow run nf-core/fetchngs \
    -profile purdue_gautschi \
    --cluster_account <your-account> \
    -r 1.12.0 \
    --input ids.csv \
    --download_method sratools \
    --outdir results-fetchngs
```

Where `ids.csv` is a single-column CSV with an `id` header and one SRA accession per row.

The `--download_method` parameter controls how FASTQ files are retrieved. Available options are `sratools` (uses `fasterq-dump` from the SRA Toolkit), `aspera` (uses the Aspera high-speed transfer client), and `ftp` (direct FTP download from ENA). The default is `ftp`, which can fail on some HPC networks due to passive-mode FTP restrictions. On Gautschi, use `sratools` for reliable downloads.

!!! warning
    `fetchngs` depends on the SRA servers being reachable and responsive. If downloads stall during the workshop, this is an SRA issue and not a configuration problem.

### nf-core tools

The `nf-core` Python package provides a CLI for discovering pipelines, downloading them for offline use, and generating launch commands. Install it in a conda environment:

```bash
module load conda
conda create -n nf-core -c bioconda -c conda-forge nf-core -y
conda activate nf-core
nf-core pipelines list
```

See the [Nextflow and nf-core guide](nextflow.md) for the full installation walkthrough.

### Offline use with nf-core download

On clusters with restricted network access, use `nf-core download` to bundle a pipeline, its containers, and its configs into a local directory:

```bash
nf-core pipelines download rnaseq -r 3.23.0 --outdir ./nf-core-rnaseq-3.23.0 --container-system singularity
```

Then run from the local copy instead of from GitHub.

## Troubleshooting

??? note "Pipeline fails with 'Please specify a valid account' or similar SLURM error"

    You forgot `--cluster_account <your-account>` or the account name is wrong. Run `slist` to check your allocations, then rerun the pipeline with the correct account and add `-resume` to skip completed tasks.

??? note "Error: 'scratch directory is not writable' or disk quota exceeded"

    Check your scratch usage with `myquota`. If scratch is full, delete old `work/` directories from previous runs. Nextflow's `work/` directory can consume hundreds of gigabytes on real projects.

??? note "Container pull hangs or times out on first run"

    Apptainer downloads container images from remote registries on the first run. On a slow network day, this can time out. Set `NXF_SINGULARITY_CACHEDIR` and rerun with `-resume`. Nextflow will retry the pull. If the problem persists, pre-pull the image manually:

    ```bash
    apptainer pull --dir $NXF_SINGULARITY_CACHEDIR docker://quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0
    ```

??? note "Java heap space error (OutOfMemoryError)"

    The Nextflow head process needs enough Java heap memory to manage the pipeline graph. Set `NXF_OPTS` before launching:

    ```bash
    export NXF_OPTS="-Xms1g -Xmx4g"
    ```

    This is already included in the setup steps above. If you still hit this error on a large pipeline, increase `-Xmx` to `8g` or higher.

??? note "Stale work directory causes unexpected behavior on resume"

    If you change pipeline parameters between runs but reuse the same `work/` directory, Nextflow may incorrectly cache tasks from the old run. Either delete the `work/` directory and start fresh, or use a new `--outdir` and `NXF_WORK` path for each distinct set of parameters.

??? note "nf-core version mismatch warning"

    If Nextflow prints a warning about minimum nf-core version requirements, check that you are using the correct Nextflow version (`module load nextflow/25.10.04`) and that you pinned the pipeline to a compatible release with `-r`. The `-r` flag prevents Nextflow from silently pulling a newer (possibly incompatible) version.

## Cleanup

The `work/` directory and container cache can consume significant disk space. Once you have finished inspecting results and saved anything you need:

```bash
rm -rf $RCAC_SCRATCH/nextflow-workshop/work
rm -rf $RCAC_SCRATCH/nextflow-workshop/.nextflow
```

!!! warning
    Do not delete the container cache (`NXF_SINGULARITY_CACHEDIR`) if you plan to rerun pipelines soon. Keeping it avoids re-downloading images that can be several gigabytes each.

To remove everything including cached images:

```bash
rm -rf $RCAC_SCRATCH/nextflow-workshop
```
