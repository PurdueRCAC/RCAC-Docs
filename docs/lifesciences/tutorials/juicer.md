---
title: Juicer on Negishi cluster
tags:
  - Life Sciences
  - Tutorials
---

# Juicer on Negishi cluster

<div class="grid cards" markdown>

-   :material-check-circle: **Prerequisites**

    ---

    - Hi-C paired-end FASTQ files
    - Know your reference genome
    - Know the restriction enzyme used
    - RCAC HPC account (_Negishi_ or _Bell_)

-   :material-information: **Objective**

    ---

    Generate `.hic` contact maps using Juicer Hi-C processing pipeline on the Negishi Cluster

</div>

Juicer is a pipeline for analyzing Hi-C data, including alignment, filtering, deduplication, and generation of `.hic` contact matrices. On Negishi, Juicer runs using a Singularity container with all required dependencies pre-installed (BWA, SAMtools, Java, etc.).

!!! warning
    The Negishi cluster does not have GPUs. HiCCUPS (loop calling) is configured to run on CPUs in this installation. Arrowhead and other CPU-based steps will still run normally (provided if you provide motifs). There are better/faster alternatives like [`mustache`](https://github.com/ay-lab/mustache), which you can run on the `.hic` files post Juicer.


## Reference Genomes

Pre-built reference genomes are available in:

```bash
/depot/itap/datasets/juicer/2.0.1
```

Currently, `hg19` is the only genome available (we will add more genomes upon request). The reference directory contains:


* Reference FASTA (`genome.fa`)
* BWA index files (`.bwt`, `.pac`, `ann`, `amb` and `sa`.)
* Chromosome sizes file (`chrom.sizes`)
* Restriction enzyme site positions (e.g., `hg19_MboI.txt`)

!!! note
    Please send a request to `rcac-help` if you need a different genome along with the version, enzyme and source of the genome. Include `bioinformatics support: juicer reference genome` in the subject line.



## How to run Juicer?

Juicer is deployed as a biocontainer on the Negishi cluster. To run Juicer, follow these steps.

Organize your data in a directory structure like this:

```bash
cd $RCAC_SCRATCH
mkdir -p juicer_run/fastq
cp /path/to/your/fastq/files/* juicer_run/fastq/
```

Your directory structure should look like this:

```text
juicer_run
└── fastq
    ├── HIC003_S2_L001_R1_001.fastq.gz
    └── HIC003_S2_L001_R2_001.fastq.gz
```


The juicer pipeline works by creating a series of batch jobs and submitting them all at once using job dependencies. The main script is very light weight and has to be run on the login node.

Load the module

```bash
module load biocontainers
module load juicer/2.0.1
```

You can run Juicer using the `juicer.sh` script.


```bash
juicer.sh -d $RCAC_SCRATCH/juicer_run \
   -g hg19 \
   -A testpbs \
   -q testpbs -Q 2:00:00 \
   -l testpbs -L 8:00:00 \
```

The arguments to the script are:
* `-q`: Queue name for alignments (e.g., `testpbs`)
* `-Q`: Walltime for alignments (e.g., `2:00:00`)
* `-l`: Queue name for the rest of the pipeline (e.g., `testpbs`)
* `-L`: Walltime for the rest of the pipeline (e.g., `8:00:00`)
* `-A`: Account name (e.g., `testpbs`)

Here the default arguments are used for the rest of the pipeline.

* `-g`: Genome ID (`hg19`)
* `-z`: Genome FASTA file (`${JUICER_DIR}/references/Homo_sapiens_assembly19.fasta`)
* `-y`: Restriction sites (`${JUICER_DIR}/restriction_site/hg19_MboI.txt`)
* `-D`: Juicer scripts (default: `${JUICER_DIR}` or `/depot/itap/datasets/juicer/2.0.1`)
* `-s`: Restriction enzyme (`MboI`)


When this command is run, it will create a series of jobs in the specified queue.


??? note "How does the stdout look like for successful run? [click to show answer]"

    ```
    (-: Looking for fastq files...fastq files exist
    (-: Aligning files matching /scratch/negishi/aseethar/juicedir/fastq/*_R*.fastq*
     in queue testpbs to genome /depot/itap/datasets/juicer/2.0.1/references/Homo_sapiens_assembly19.fasta with no fragment delimited maps.
    (-: Created /scratch/negishi/aseethar/juicedir/splits and /scratch/negishi/aseethar/juicedir/aligned.
    (-: Starting job to launch other jobs once splitting is complete
    (-: Finished adding all jobs... Now is a good time to get that cup of coffee... Last job id 23947729
    ```


You can check the jobs running using `squeue` command

```bash
squeue --me
```

It looks something like this:

```
JOBID      NAME                 ST USER      ACCOUNT  NODES CPUS  TIME_LIMIT  TIME_LEFT  NODELIST(REASON)
23947729   a1747060292_prep_don PD aseethar  testpbs  1     1     20:00:00    20:00:00   (Dependency)
23947728   a1747060292_arrowhea PD aseethar  testpbs  1     1     2:00:00     2:00:00    (Dependency)
23947727   a1747060292_hiccups_ PD aseethar  testpbs  1     1     2:00:00     2:00:00    (Dependency)
23947726   a1747060292_hic30    PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947725   a1747060292_hic      PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947724   a1747060292_stats30  PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947723   a1747060292_stats    PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947722   a1747060292_bamrm    PD aseethar  testpbs  1     8     2:00:00     2:00:00    (Dependency)
23947721   a1747060292_prestats PD aseethar  testpbs  1     8     2:00:00     2:00:00    (Dependency)
23947720   a1747060292_merged30 PD aseethar  testpbs  1     8     2:00:00     2:00:00    (Dependency)
23947719   a1747060292_merged1  PD aseethar  testpbs  1     8     2:00:00     2:00:00    (Dependency)
23947718   a1747060292_dupcheck PD aseethar  testpbs  1     1     2:00:00     2:00:00    (Dependency)
23947717   a1747060292_post_ded PD aseethar  testpbs  1     1     1:40:00     1:40:00    (Dependency)
23947716   a1747060292_dedup    PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947714   a1747060292_fragmerg PD aseethar  testpbs  1     8     8:00:00     8:00:00    (Dependency)
23947713   a1747060292_check    PD aseethar  testpbs  1     1     2:00:00     2:00:00    (Dependency)
23947712   a1747060292_mergesor PD aseethar  testpbs  1     8     8:00:00     8:00:00    (Dependency)
23947711   a1747060292_merge_HI PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947710   a1747060292_merge_HI PD aseethar  testpbs  1     1     8:00:00     8:00:00    (Dependency)
23947709   a1747060292_align1_H PD aseethar  testpbs  1     8     2:00:00     2:00:00    (Pending)
23947708   a1747060292_HIC003_S PD aseethar  testpbs  1     1     2:00:00     2:00:00    (Pending)
23947707   a1747060292_cmd      PD aseethar  testpbs  1     1     2:00        2:00       (Pending)
23947715   a1747060292_dedup_gu PD aseethar  testpbs  1     1     10:00       10:00      (JobHeldUser)
```

## Juicer arguments

The full list of arguments for `juicer.sh` is:

### Input/path arguments

| Option                     | Description                                                                        |
| -------------------------- | ---------------------------------------------------------------------------------- |
| `-g genomeID`              | Genome ID (e.g., `hg19`, `mm10`) defined internally or via `-z`                    |
| `-d topDir`                | Top-level working directory. Must contain `fastq/`; creates `splits/`, `aligned/`  |
| `-z reference-genome`      | Path to genome FASTA file; BWA index files must be in the same directory           |
| `-p chrom.sizes`           | Path to chrom.sizes file (can also use genome name like `hg38`)                    |
| `-y restriction-site-file` | File with positions of restriction sites (e.g., from `generate_site_positions.py`) |
| `-D juicerDir`             | Path to Juicer scripts directory (default: `/depot/itap/datasets/juicer/2.0.1`)    |

### Cluster-specific options

| Option               | Description                                                            |
| -------------------- | ---------------------------------------------------------------------- |
| `-q queue`           | SLURM queue for alignment jobs (default: `standby`)                    |
| `-l long queue`      | SLURM queue for long jobs such as `.hic` creation (default: `standby`) |
| `-Q queue time`      | Time limit for short jobs (e.g., `-Q 4:00` for 4 hours)                |
| `-L long queue time` | Time limit for long jobs (e.g., `-L 168:00` for one week)              |
| `-A account`         | SLURM account name for job submission                                  |

### Experiment-specific options

| Option        | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `-s site`     | Restriction enzyme (e.g., `MboI`, `HindIII`)                 |
| `-a about`    | Free-text experiment description (enclosed in single quotes) |
| `-i sample`   | Sample name, added to `SM:` in read group                    |
| `-k library`  | Library name, added to `LB:` in read group                   |
| `-b ligation` | Ligation junction sequence (used in counting)                |

### Performance options

| Option          | Description                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| `-t threads`    | Number of threads for BWA alignment                                         |
| `-T threadsHic` | Number of threads for `.hic` file creation                                  |
| `-C chunk size` | Number of lines per split file (default: 90,000,000; must be multiple of 4) |
| `-w wobble`     | Wobble distance for deduplication (default: 4)                              |

### Stage options
| Option     | Description                                                                                        |
| ---------- | -------------------------------------------------------------------------------------------------- |
| `-S stage` | Start from a given stage: `chimeric`, `merge`, `dedup`, `afterdedup`, `final`, `postproc`, `early` |

### Boolean options

| Flag           | Description                                                      |
| -------------- | ---------------------------------------------------------------- |
| `-j`           | Use only exact duplicates during deduplication (disables wobble) |
| `-e`           | Exit early before `.hic` file creation                           |
| `-f`           | Include fragment-delimited maps in `.hic` output                 |
| `-u`           | Use single-end mode for alignment                                |
| `-m`           | Process methylation + Hi-C library                               |
| `--assembly`   | Early exit after deduplication (for 3D-DNA input)                |
| `--cleanup`    | Remove intermediate files if pipeline completes                  |
| `--qc_apa`     | Run APA-based QC                                                 |
| `--qc`         | Downsample to 1 kb, skip annotation                              |
| `--in-situ`    | Limit to 1 kb map resolution (no annotation)                     |
| `-h`, `--help` | Display usage help and exit                                      |



## Output

Upon completion, the main output file is:

```
inter_30.hic
```

You can visualize this file using [Juicebox](https://github.com/aidenlab/Juicebox).


The other output files in `aligned/` include:

```text
aligned/
├── header
├── inter.hic
├── inter.txt
├── inter_30.hic
├── inter_30.txt
├── inter_30_contact_domains
├── inter_30_hists.m
├── inter_30_loops
│   ├── fdr_thresholds_10000
│   ├── fdr_thresholds_25000
│   └── fdr_thresholds_5000
├── inter_hists.m
├── merged1.txt
├── merged30.txt
└── merged_dedup.bam
```
