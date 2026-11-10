---
title: "Script to Pipeline: Turning Your Scripts into a Nextflow Workflow"
tags:
  - Life Sciences
  - Nextflow
  - Genomics Exchange
  - Guides
search:
  boost: 1
---

# Script to Pipeline: Turning Your Scripts into a Nextflow Workflow

This is the companion guide to [Genomics Exchange Fall 2026, Session 5](../../workshops/genomics_exchange/fall2026/session5/index.md) ("Script to pipeline", November 10, 2026). It walks through converting a working shell script into a small Nextflow workflow that runs many samples in parallel on Negishi and that a collaborator can run unchanged with their own samplesheet.

The complete workflow is in the [rcac-bioinformatics/script-to-pipeline](https://github.com/rcac-bioinformatics/script-to-pipeline) repository (tag `v1.0.0`).

<div class="grid cards" markdown>

-   :material-check-circle:{ .lg .middle } **Prerequisites**

    ---

    - An RCAC account with access to Negishi and a SLURM account to charge
    - Familiarity with Nextflow channels, processes, and `-profile` ([Session 3, Nextflow fundamentals](../../workshops/genomics_exchange/fall2026/session3/index.md))
    - Experience running an nf-core pipeline on a cluster ([Session 4, Running nf-core pipelines on clusters](../../workshops/genomics_exchange/fall2026/session4/index.md))
    - A shell, R, or Python analysis you already run by hand

-   :material-information:{ .lg .middle } **Objectives**

    ---

    - Break an existing script into Nextflow processes without rewriting the commands
    - Connect processes with channels and run many samples in parallel with one command
    - Change tool options and inputs through configuration, not code
    - Package the software with containers or modules and hand the workflow to a collaborator

</div>

## When to write your own workflow

If an nf-core pipeline already does your analysis, use it; that was [Session 4](../../workshops/genomics_exchange/fall2026/session4/index.md). Write your own workflow when your analysis does not match an existing pipeline, when you have a sequence of scripts you run on every new batch of samples, or when someone else needs to run your analysis and get the same result.

The aim is not to rewrite your analysis. The commands you trust stay the same; Nextflow takes over the parts you currently do by hand: looping over samples, submitting jobs, waiting for them, noticing failures, and rerunning only what changed.

## The example analysis

The session uses a small variant-calling analysis on *Escherichia coli* clones from the Lenski Long-Term Evolution Experiment (population Ara-3, Tenaillon et al. 2016, BioProject PRJNA294072), mapped to the REL606 reference (GenBank CP000819.1). Each sample is subsampled to 300,000 read pairs, so the whole run takes a few minutes.

| Step | Tool | Runs | Pattern |
|---|---|---|---|
| Index the reference | `bwa index`, `samtools faidx` | once | singleton, output reused |
| Map and sort each sample | `bwa mem`, `samtools sort` | once per sample | fan-out |
| Call variants jointly | `bcftools mpileup`, `bcftools call` | once, needs every BAM | fan-in |
| Count variants per sample | a Python script | once | your own script |

The data is staged on Negishi under `/depot/workshop/data/script-to-pipeline/`.

## The starting point: a linear script

Most analyses start as one script with a loop. This one works, and for six small samples it finishes in one job:

```bash title="variant_calling.sh (core)"
module --force purge
module load biocontainers bwa/0.7.17 samtools/1.17 bcftools/1.17

for SAMPLE in $SAMPLES; do
    bwa mem -t 4 \
        -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}" \
        "$OUT/index/genome.fa" "$DATA/reads/${SAMPLE}_R1.fastq.gz" "$DATA/reads/${SAMPLE}_R2.fastq.gz" \
        | samtools sort -@ 4 -o "$OUT/bam/${SAMPLE}.bam" -
    samtools index "$OUT/bam/${SAMPLE}.bam"
done

ls "$OUT"/bam/*.bam | sort > "$OUT/vcf/bam_list.txt"
bcftools mpileup --min-MQ 20 --annotate FORMAT/AD,FORMAT/DP \
    -f "$OUT/index/genome.fa" -b "$OUT/vcf/bam_list.txt" -Ou \
    | bcftools call --ploidy 1 --multiallelic-caller --variants-only -Oz -o "$OUT/vcf/joint.vcf.gz"
```

Its limits appear as the project grows: samples run one after another, and a failure in sample 5 means restarting from the top.

## Doing it in plain SLURM

The usual next step is one script per step, submitted per sample or as a job array, chained with dependencies:

```bash title="submit_arrays.sh (excerpt)"
N=$(grep -c . samples.txt)
IDX=$(sbatch --parsable 01_index.sh)
ALN=$(sbatch --parsable --dependency=afterok:"$IDX" --array=1-"$N" 02_align.sh)
CALL=$(sbatch --parsable --dependency=afterok:"$ALN" 03_call.sh)
sbatch --dependency=afterok:"$CALL" 04_summarize.sh
```

This is a real improvement, and if you already work this way you are most of the way to a workflow. What it still leaves to you:

- If one array task fails, the dependent job stays `PENDING` with reason `DependencyNeverSatisfied`, and nothing tells you.
- Recovering means finding the failed task, resubmitting it, cancelling the stuck jobs, and resubmitting them with new job IDs.
- Changing one option downstream means deciding by hand which steps to rerun.
- The next project means editing paths, sample lists, and file-name patterns in every script.

!!! warning "Partial outputs look like real outputs"
    If `bwa mem` dies partway through a sample, `samtools sort` still reaches the end of its input and writes a valid BAM containing only some of the reads. The job fails, but the file is there. Nextflow marks the task as failed and does not pass or publish its outputs.

## From script to process

A process is your commands plus a declaration of what they read and what they write. The conversion has three steps:

1. Copy the commands into a `script:` block.
2. Declare the files the commands read as `input:` and the files they write as `output:`.
3. Replace hardcoded file names with the input variables, and thread counts with `task.cpus`.

Here is the align step after conversion. The commands are the same lines as in the loop above:

```groovy title="modules/bwa_mem.nf"
process BWA_MEM {
    tag "${sample}"
    publishDir "${params.outdir}/bam", mode: 'copy'
    container 'quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0'  // bwa 0.7.17, samtools 1.16.1

    input:
    tuple val(sample), path(reads)
    path index

    output:
    tuple val(sample), path("${sample}.bam"), path("${sample}.bam.bai"), emit: bam

    script:
    def args  = task.ext.args  ?: ''   // extra bwa mem options
    def args2 = task.ext.args2 ?: ''   // extra samtools sort options
    """
    bwa mem -t ${task.cpus} ${args} \\
        -R "@RG\\tID:${sample}\\tSM:${sample}" \\
        index/genome.fa ${reads[0]} ${reads[1]} \\
        | samtools sort -@ ${task.cpus} ${args2} -o ${sample}.bam -
    samtools index ${sample}.bam
    """
}
```

Three things to notice:

- **The loop is gone.** A process handles one sample; the channel decides how many samples there are.
- **Backslashes are doubled** inside the triple-quoted script (`\\` for a line continuation, `\\t` for a tab), because Groovy reads the string before Bash does. `${...}` is filled in by Nextflow; use `\$` for a Bash variable.
- **No paths.** The task runs in its own work directory, and Nextflow links the declared inputs into it.

Your own R or Python scripts do not need converting at all. Put them in the workflow's `bin/` directory, make them executable with a shebang line, and call them by name; Nextflow puts `bin/` on the `PATH` of every task:

```groovy title="modules/summarize.nf"
process SUMMARIZE {
    publishDir "${params.outdir}/summary", mode: 'copy'
    container 'docker.io/library/python:3.12-slim'

    input:
    path vcf
    val min_qual

    output:
    path 'variant_summary.tsv', emit: tsv

    script:
    """
    summarize_variants.py --vcf ${vcf} --min-qual ${min_qual} --out variant_summary.tsv
    """
}
```

## Connecting processes with channels

The workflow block wires the processes together. Three patterns cover most analyses:

```groovy title="main.nf"
include { BWA_INDEX     } from './modules/bwa_index.nf'
include { BWA_MEM       } from './modules/bwa_mem.nf'
include { BCFTOOLS_CALL } from './modules/bcftools_call.nf'
include { SUMMARIZE     } from './modules/summarize.nf'

workflow {
    if( !params.input ) {
        error("Missing --input <samplesheet.csv> (columns: sample,fastq_1,fastq_2)")
    }
    if( !params.fasta ) {
        error("Missing --fasta <reference.fasta>")
    }

    // The samplesheet replaces the for-loop: one row per sample becomes
    // one item in the channel, [ sample, [ R1, R2 ] ]
    reads_ch = channel.fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            tuple(row.sample, [ file(row.fastq_1, checkIfExists: true), file(row.fastq_2, checkIfExists: true) ])
        }

    // Singleton: runs once, output reused by every downstream task
    BWA_INDEX( file(params.fasta, checkIfExists: true) )

    // Fan-out: one task per sample, all submitted in parallel
    BWA_MEM( reads_ch, BWA_INDEX.out.index )

    // Fan-in: collect() waits until every BAM exists, then emits one list
    bams_ch = BWA_MEM.out.bam
        .map { sample, bam, bai -> [ bam, bai ] }
        .collect()
    BCFTOOLS_CALL( bams_ch, BWA_INDEX.out.index )

    // Your own script, unchanged, as the last step
    SUMMARIZE( BCFTOOLS_CALL.out.vcf, params.min_qual )
}
```

| Pattern | Where | What it replaces |
|---|---|---|
| Fan-out | `reads_ch` into `BWA_MEM` | the `for` loop, or a job array |
| Singleton | `BWA_INDEX` called with a single file, so its output is a value channel reused by every task | copying the index path into every script |
| Fan-in | `.collect()` before `BCFTOOLS_CALL` | watching `squeue`, or `--dependency=afterok` |

The samplesheet is a plain CSV with one row per sample. The first two of the six rows in `project_a.csv`:

```csv title="project_a.csv (first two rows)"
sample,fastq_1,fastq_2
g00500,/depot/workshop/data/script-to-pipeline/reads/g00500_R1.fastq.gz,/depot/workshop/data/script-to-pipeline/reads/g00500_R2.fastq.gz
g02000,/depot/workshop/data/script-to-pipeline/reads/g02000_R1.fastq.gz,/depot/workshop/data/script-to-pipeline/reads/g02000_R2.fastq.gz
```

!!! tip "Use absolute paths in samplesheets"
    Relative paths are resolved from the directory you launch Nextflow in, not from the samplesheet's location. Absolute paths make a samplesheet usable from anywhere.

## Configuration: what, where, and how

Keeping three kinds of settings out of the `.nf` files is what lets the same code run on a new project or a new cluster.

| Setting | Lives in | Changed with |
|---|---|---|
| What data to run on | `params` in `nextflow.config` | `--input`, `--fasta`, `--outdir`, `--min_qual` on the command line |
| Where tasks run | the nf-core `purdue_negishi` profile | `-profile purdue_negishi --cluster_account <account-name>` |
| How each tool behaves | `ext.args` in `conf/modules.config` | editing that file, or `-c my.config` |

The workflow does not define its own cluster settings. It loads the nf-core institutional configs and uses the [purdue_negishi profile](https://nf-co.re/configs/purdue_negishi/), the same profile nf-core pipelines use on Negishi. That profile sets the SLURM executor, routes tasks to the right partition, charges the account you pass with `--cluster_account`, and enables Apptainer.

```groovy title="nextflow.config (excerpt)"
params {
    custom_config_version = 'master'
    custom_config_base    = "https://raw.githubusercontent.com/nf-core/configs/${params.custom_config_version}"
}

process {
    cpus = 1
    time = '30m'
    withName: 'BWA_MEM'       { cpus = 4 }
    withName: 'BCFTOOLS_CALL' { cpus = 2 }
}

// Load the nf-core institutional profiles, including purdue_negishi
includeConfig "${params.custom_config_base}/nfcore_custom.config"
```

Tool options use the same `ext.args` convention as nf-core modules: `ext.args` goes to the first tool in a process, `ext.args2` to the second.

```groovy title="conf/modules.config"
process {
    withName: 'BWA_MEM' {
        ext.args  = ''                      // bwa mem
        ext.args2 = ''                      // samtools sort
    }
    withName: 'BCFTOOLS_CALL' {
        ext.args  = '--min-MQ 20 --annotate FORMAT/AD,FORMAT/DP'          // bcftools mpileup
        ext.args2 = '--ploidy 1 --multiallelic-caller --variants-only'    // bcftools call (E. coli is haploid)
    }
}
```

## Containers or modules

Each process names a pinned container image, and with `-profile purdue_negishi` Nextflow pulls it with Apptainer and runs the task inside it. Containers are what make the workflow portable: a collaborator on another cluster gets the same tool versions.

| Tool | Version | Image |
|---|---|---|
| bwa | 0.7.17-r1188 | `quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0` |
| samtools | 1.16.1 | same image |
| bcftools | 1.21 | `quay.io/biocontainers/bcftools:1.21--h3a4d415_1` |
| Python | 3.12 | `docker.io/library/python:3.12-slim` |

Containers are not required. A process can load environment modules instead with the Nextflow `module` directive, which is convenient on campus but ties the workflow to RCAC module names. This workflow uses containers so it runs the same everywhere.

## Running on Negishi

```bash
module --force purge
module load nextflow/26.04.2

mkdir -p $RCAC_SCRATCH/ge5 && cd $RCAC_SCRATCH/ge5

nextflow run rcac-bioinformatics/script-to-pipeline -r v1.0.0 \
    -profile purdue_negishi \
    --cluster_account <account-name> \
    --input /depot/workshop/data/script-to-pipeline/samplesheets/project_a.csv \
    --fasta /depot/workshop/data/script-to-pipeline/reference/ecoli_rel606.fasta \
    --outdir results \
    -w $RCAC_SCRATCH/ge5/work
```

Run `slist` to see the SLURM accounts you can charge. Apptainer is available on Negishi without loading a module, and the `purdue_negishi` profile caches the container images under `$RCAC_SCRATCH/.apptainer/cache`, so each image is pulled once and reused by later runs.

!!! danger "Purge modules before launching Nextflow"
    Start with `module --force purge`. The sticky XALT module sets `LD_PRELOAD`, SLURM passes your environment to every job Nextflow submits, and that `LD_PRELOAD` breaks programs inside containers. A plain `module purge` does not remove sticky modules.

While it runs, `squeue -u $USER` shows the jobs Nextflow submitted: one index job, then six `BWA_MEM` jobs at once, then the calling and summary jobs. Results land in:

```
results/
├── bam/             <sample>.bam, <sample>.bam.bai
├── vcf/             joint.vcf.gz, joint.vcf.gz.csi
├── summary/         variant_summary.tsv
└── pipeline_info/   timeline.html, report.html
```

Open `results/pipeline_info/timeline.html` in a browser to see the six alignment tasks running side by side.

!!! tip "Where the Nextflow process runs"
    The Nextflow head process only submits and watches jobs, so for short runs it can run on a front-end inside `tmux` or `screen`. For long workflows, put the same `nextflow run` command in a 1-core `sbatch` job with a time limit longer than the whole workflow.

## Resuming and changing options

Nextflow caches every task by its inputs and its script. Add `-resume` and anything whose inputs and commands are unchanged is reused.

To change a tool option for one run, write the override in a small config file:

```groovy title="stricter_mapq.config"
process {
    withName: 'BCFTOOLS_CALL' {
        ext.args = '--min-MQ 30 --annotate FORMAT/AD,FORMAT/DP'
    }
}
```

```bash
nextflow run rcac-bioinformatics/script-to-pipeline -r v1.0.0 \
    -profile purdue_negishi --cluster_account <account-name> \
    --input /depot/workshop/data/script-to-pipeline/samplesheets/project_a.csv \
    --fasta /depot/workshop/data/script-to-pipeline/reference/ecoli_rel606.fasta \
    -w $RCAC_SCRATCH/ge5/work \
    -c stricter_mapq.config -resume
```

`BWA_INDEX` and all six `BWA_MEM` tasks are reported as cached; only `BCFTOOLS_CALL` and `SUMMARIZE` run again, because only the calling command changed. Changing a parameter such as `--min_qual 50` reruns only `SUMMARIZE`.

!!! warning "Resume needs the same launch directory"
    Nextflow records each run in `.nextflow/` in the directory you launched from, and keeps task outputs in the work directory (`-w`). Run the `-resume` command from the same launch directory with the same `-w`, and do not delete the work directory until you no longer need to resume.

## Handing it to a collaborator

A collaborator needs four things from you: the code in a Git repository, a version tag, pinned software (the container images), and a README that names the inputs. With those, they run your exact workflow with their own samplesheet:

```bash
nextflow run rcac-bioinformatics/script-to-pipeline -r v1.0.0 \
    -profile purdue_negishi \
    --cluster_account <account-name> \
    --input their_samples.csv \
    --fasta /depot/workshop/data/script-to-pipeline/reference/ecoli_rel606.fasta \
    --outdir results_their_project
```

Nextflow downloads the tagged version from GitHub; nobody edits a script. If their organism is diploid, they pass a config file that changes `ext.args2` for `BCFTOOLS_CALL`, still without touching the code. On another cluster they use that cluster's nf-core institutional profile, if one exists, or write their own, and keep everything else.

## Adapting it to your own scripts

1. **List your steps** and mark each as once, per sample, or needs all samples. That gives you singletons, fan-out, and fan-in.
2. **Make one process per step.** Paste the commands, declare inputs and outputs, and replace file names with variables. Keep processes small enough that rerunning one is cheap.
3. **Write a samplesheet** with one row per sample and the columns your first step needs.
4. **Move tool options to `ext.args`** and project-level choices to `params`.
5. **Pin your software** with a container per process.
6. **Test on two or three samples** with a short samplesheet, then run the full set.
7. **Commit, tag, and write the README** before you hand it over.

!!! tip "Check syntax before you submit anything"
    `nextflow lint main.nf` checks your scripts against the strict syntax that Nextflow 26.04 uses by default, without running anything.

## Troubleshooting

!!! note "A task failed: where to look"
    Nextflow prints the failing process, its exit status, and its work directory. In that directory, `.command.sh` is the exact script that ran, `.command.err` and `.command.out` hold its output, and `.command.run` is the SLURM wrapper. Fix the cause, then rerun the same command with `-resume`.

!!! note "Jobs stay pending"
    `squeue -u $USER` shows the reason. Check that `--cluster_account` is a SLURM account you can charge (`slist` lists yours).

!!! warning "Image pulls are slow or time out"
    The first run pulls each image once into the cache that the `purdue_negishi` profile sets, `$RCAC_SCRATCH/.apptainer/cache`. Later runs reuse it. If pulls time out, rerun the same command with `-resume`; images that finished downloading are not pulled again.

## Related guides

- [Nextflow and nf-core on Negishi](nextflow.md): installing Nextflow and running nf-core pipelines.
- [Reproducible Bioinformatics Using Nextflow](nextflow-gautschi.md): Nextflow fundamentals on Gautschi.
- [Reproducible Genomics on RCAC](reproducibility.md): the Session 1 companion guide.
- [Session 6: nf-core on Open OnDemand](../../workshops/genomics_exchange/fall2026/session6/index.md): launching nf-core pipelines from a web form, the next session in the series.

[Back to Life Sciences](../index.md){ .md-button }
