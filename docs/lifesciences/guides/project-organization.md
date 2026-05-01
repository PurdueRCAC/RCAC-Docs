---
title: Project organization for bioinformatics on HPC
tags:
  - Life Sciences
  - Genomics Exchange
  - Guides
---

A well-organized project is the difference between finishing a paper in a week and spending a week just finding your files.
This guide gives you a concrete, opinionated system for structuring bioinformatics projects on RCAC clusters.
Follow it from day one and you will save yourself hours of confusion later.

## Why this matters

Three problems kill bioinformatics projects:

1. **Reproducibility**: You re-run an analysis six months later and get different results because you cannot remember which parameters, software versions, or reference genome you used.
2. **Collaboration**: A labmate asks to see your variant calls. You send them a path to a directory with 400 files and no explanation.
3. **Quota and storage**: Your pipeline crashes at 3 AM because scratch filled up with intermediate BAMs nobody cleaned.

A standard directory layout, consistent naming, and a few habits solve all three. The rest of this guide shows you exactly how.

## Recommended directory structure

Use this layout for every new project. The numbered prefixes force a logical reading order and sort correctly in `ls`.

```text
20250505_AirwayStudy_RNAseq/
├── 00_meta/
│   ├── README.md
│   ├── sample_manifest.tsv
│   ├── methods.md
│   └── software_versions.txt
├── 01_data/
│   ├── raw/    # Read-only! Never modify these files.
│   │   ├── sample_A_R1.fastq.gz
│   │   ├── sample_A_R2.fastq.gz
│   │   ├── genome.fa
│   │   └── annotation.gff3
│   └── processed/
│       └── sample_A_R1_trimmed.fastq.gz
├── 02_scripts/
│   ├── 01_qc-fastqc.sh
│   ├── 02_trim-fastp.sh
│   ├── 03_align-star.sh
│   ├── 04_count-featurecounts.sh
│   └── 05_de-deseq2.R
├── 03_analysis/
│   ├── a_fastqc/
│   ├── b_trimming/
│   ├── c_alignment/
│   └── d_counts/
├── 04_results/
│   ├── figures/
│   ├── tables/
│   └── multiqc_report.html
└── 99_logs/
    ├── 01_qc_12345.out
    └── 01_qc_12345.err
```

| Directory | Purpose |
|:----------|:--------|
| `00_meta/` | Project documentation: README, sample manifest, methods notes, software versions. The first place anyone should look. |
| `01_data/raw/` | Untouched input files from sequencing or collaborators. Treat as **read-only**. |
| `01_data/processed/` | Cleaned or reformatted data (trimmed reads, filtered VCFs used as inputs to later steps). |
| `02_scripts/` | All analysis code. Numbered in execution order so the pipeline is self-documenting. |
| `03_analysis/` | Working outputs from each pipeline step. Use lettered subdirectories to separate stages. Create a new version folder (e.g., `c_alignment.v2/`) when re-running with different parameters rather than overwriting. |
| `04_results/` | Publication-ready figures, summary tables, and reports. Only final, polished outputs go here. |
| `99_logs/` | SLURM stdout/stderr logs. Essential for debugging and documenting resource usage. |

Create this structure in one command:

```bash
PROJECT="20250505_AirwayStudy_RNAseq"
mkdir -p ${PROJECT}/{00_meta,01_data/{raw,processed},02_scripts,03_analysis,04_results/{figures,tables},99_logs}
```

!!! tip
    Name the top-level directory as `YYYYMMDD_ProjectID_AnalysisType`. The ISO date prefix sorts projects chronologically in `ls` and removes any ambiguity about when work started.

## RCAC storage tiers and what goes where

RCAC provides several storage tiers. Using them correctly prevents quota crashes and data loss.

| Location | Path | Capacity | Persistence | Best for |
|:---------|:-----|:---------|:------------|:---------|
| **Home** | `$HOME` | ~25 GB | Backed up, permanent | Scripts, configs, small logs, `.bashrc` |
| **Scratch** | `$RCAC_SCRATCH` | ~100 TB (shared) | **Purged** after inactivity | Active analysis, intermediates, temp files |
| **Depot** | `/depot/<group>/` | Group allocation | Permanent | Raw data, final results, shared references, archived projects |

### Practical rules

- **Raw sequencing data** goes on Depot (or Scratch with a backup on Depot). Never keep the only copy on Scratch.
- **Intermediate files** (BAMs, unsorted SAMs, temp indexes) go on Scratch. They are regenerable; treat them as disposable.
- **Scripts, configs, and READMEs** go in `$HOME` or Depot. They are small and irreplaceable.
- **Final results** (figures, summary tables, reports) go on Depot.

### Symlink strategy

Keep a unified project tree on Scratch for active work, but symlink to Depot for raw data and long-term storage:

```bash
# Project lives on scratch for fast I/O during analysis
cd $RCAC_SCRATCH
mkdir -p 20250505_AirwayStudy_RNAseq/01_data

# Symlink raw data from depot (no copying, no duplication)
ln -s /depot/mylab/data/airway_fastqs $RCAC_SCRATCH/20250505_AirwayStudy_RNAseq/01_data/raw
```

!!! warning
    Scratch is **purged** after a period of inactivity. Never store your only copy of anything on Scratch. Run `myquota` regularly to monitor usage across all filesystems.

## File and directory naming conventions

Bad file names are the most common source of silent errors in bioinformatics pipelines. Follow these rules without exception.

### Do this

- Use **lowercase** with **underscores** or **hyphens**: `sample_A_R1.fastq.gz`
- Use **ISO 8601 dates** (`YYYYMMDD` or `YYYY-MM-DD`): `20250505_results.tsv`
- Include the **sample ID** and **data type** in the filename: `sampleA_aligned.bam`
- Number scripts in execution order: `01_qc-fastqc.sh`, `02_trim-fastp.sh`
- Name SLURM logs with the script name and job ID: `01_qc_%j.out` (SLURM expands `%j` to the job ID)

### Do not do this

| Bad | Why | Better |
|:----|:----|:-------|
| `final_FINAL_v2 (copy).bam` | Ambiguous, spaces, no versioning scheme | `sampleA_aligned.v2.bam` |
| `data 2025.fastq` | Spaces break shell scripts | `data_20250505.fastq` |
| `results.txt` | What results? From which step? | `deseq2_differential_expression.tsv` |
| `Bob's analysis/` | Apostrophes and spaces cause quoting nightmares | `bobs_analysis/` |
| `03/15/2025_run` | Ambiguous date format (US vs EU) | `20250315_run` |

!!! note
    If you work with sample IDs from a sequencing core, keep their original identifiers in a `sample_manifest.tsv` and use short, consistent aliases (e.g., `sampleA`, `sampleB`) in filenames. Map between the two in your manifest.

## README and metadata practices

Every project gets a `README.md` in `00_meta/`. Write it on day one and update it as the project evolves. Here is a template you can copy directly:

````markdown
# Project: Airway Epithelial RNA-seq

**Date started:** 2025-05-05
**PI:** Dr. Jane Smith
**Analyst:** Your Name
**Cluster:** Negishi

## Goal
Identify differentially expressed genes between treated and control
airway epithelial cells using bulk RNA-seq (3 replicates per condition).

## Samples
See `sample_manifest.tsv` for full details.
- 6 samples total (3 treated, 3 control)
- Paired-end 150 bp, Illumina NovaSeq
- Raw data location: /depot/mylab/data/airway_fastqs/

## Pipeline
1. QC: FastQC v0.12.1 + MultiQC v1.14
2. Trimming: fastp v0.23.4
3. Alignment: STAR v2.7.11a (GRCh38 + Gencode v44)
4. Counting: featureCounts (Subread v2.0.6)
5. DE analysis: DESeq2 v1.40.2 (R 4.3.1)

## Software versions
See `software_versions.txt` for complete `module list` output.

## Key results
- 1,247 DEGs (padj < 0.05, |log2FC| > 1)
- Results in `04_results/tables/deseq2_results.tsv`
- Volcano plot in `04_results/figures/volcano_plot.pdf`
````

### Recording software versions

Capture exact versions at the start of every project. Future you will thank present you.

```bash
# Save loaded modules
module list 2>&1 | tee 00_meta/software_versions.txt

# Save conda environment (if using conda)
conda env export > 00_meta/conda_environment.yml

# Record container SIF provenance
apptainer inspect --labels mytools.sif >> 00_meta/software_versions.txt
```

!!! tip
    Add `module list` and version-printing commands (e.g., `samtools --version`) to the top of every SLURM script. The output goes straight into your log files, giving you an automatic record per run.

## Managing large intermediate files

Bioinformatics pipelines generate enormous intermediate files. A single whole-genome alignment can produce a 50-100 GB unsorted BAM before you even start variant calling. Managing these files proactively prevents quota disasters.

### What to keep vs. delete

| File type | Keep? | Reason |
|:----------|:------|:-------|
| Raw FASTQ | **Always** | Irreplaceable input |
| Trimmed FASTQ | Delete after alignment | Regenerable from raw in minutes |
| Unsorted SAM/BAM | **Delete immediately** | Sort and index, then remove the unsorted version |
| Sorted, indexed BAM | Keep during project | Needed for downstream analysis |
| VCF/GFF3 (final) | **Always** | Primary results |
| Index files (`.bai`, `.fai`, `.idx`) | Regenerate as needed | Trivial to recreate |
| MultiQC reports | **Always** | Small, high-value summaries |

### Estimate disk usage before running a pipeline

```bash
# Check how much space your raw data occupies
du -sh 01_data/raw/

# Estimate total project size
du -sh --apparent-size */
```

A rough rule: expect 3-5x your raw data size in intermediates during active analysis. For 100 GB of FASTQ files, budget 300-500 GB of scratch space.

### Auto-clean intermediates in SLURM scripts

Add cleanup steps at the end of your job scripts so temporary files do not accumulate:

```bash
# At the end of an alignment script:
# Remove unsorted BAM after sorting is confirmed
if [ -f ${SAMPLE}.sorted.bam ]; then
    rm -f ${SAMPLE}.unsorted.bam
    echo "Cleaned up unsorted BAM"
fi
```

!!! warning
    Always use a conditional check (`if [ -f ... ]`) before deleting intermediates in automated scripts. If the upstream step failed silently, an unconditional `rm` destroys your only evidence of what went wrong.

### Find the biggest space consumers

```bash
# Top 10 largest files in your project
find . -type f -exec du -h {} + | sort -rh | head -20

# Find BAM files over 10 GB
find . -name "*.bam" -size +10G -exec ls -lh {} \;
```

## Archiving completed projects

When a project is published or shelved, clean it up and move it to Depot to free Scratch space.

### What to keep

- Raw data (if not already on Depot permanently)
- Final results (`04_results/`)
- Scripts and metadata (`00_meta/`, `02_scripts/`)
- Key analysis outputs (final BAMs, VCFs, count matrices)

### What to discard before archiving

- Unsorted/intermediate BAMs and SAMs
- Trimmed FASTQ files (regenerable from raw)
- Index files (`.bai`, `.fai`, `.tbi`): trivial to recreate
- Temporary directories, `.snakemake/`, `work/` (Nextflow)

### Create a manifest and tarball

```bash
cd $RCAC_SCRATCH

# Remove intermediates first
rm -rf 20250505_AirwayStudy_RNAseq/03_analysis/b_trimming
rm -rf 20250505_AirwayStudy_RNAseq/03_analysis/c_alignment/*.unsorted.bam

# Create a file listing for the archive
find 20250505_AirwayStudy_RNAseq -type f > 20250505_AirwayStudy_RNAseq/00_meta/archive_manifest.txt

# Create a compressed tarball
tar -czf 20250505_AirwayStudy_RNAseq.tar.gz 20250505_AirwayStudy_RNAseq/

# Verify the archive is intact before deleting originals
tar -tzf 20250505_AirwayStudy_RNAseq.tar.gz | wc -l

# Move to Depot
mv 20250505_AirwayStudy_RNAseq.tar.gz /depot/<group>/archives/
```

!!! tip
    Keep a copy of `archive_manifest.txt` outside the tarball at `/depot/<group>/archives/20250505_AirwayStudy_RNAseq_manifest.txt`. This lets you check what is inside an archive with `grep` without extracting the whole thing.

## Version control for scripts and configs

Use Git for your scripts and documentation. Do **not** use Git for data files.

### Initialize a repository for your project

```bash
cd 20250505_AirwayStudy_RNAseq
git init
git add 00_meta/ 02_scripts/
git commit -m "Initial project setup: README and QC script"
```

### A `.gitignore` for bioinformatics

Place this in your project root:

```text title=".gitignore"
# Data files (too large for Git)
*.fastq
*.fastq.gz
*.fq
*.fq.gz
*.bam
*.bai
*.sam
*.cram
*.sra
*.vcf.gz
*.bed
*.fa
*.fa.gz
*.fasta
*.gff3

# Directories
01_data/
03_analysis/
04_results/
99_logs/

# System files
.snakemake/
work/
.nextflow/
*.pyc
__pycache__/
.DS_Store
```

### What to commit

- **Always:** SLURM scripts, R/Python analysis scripts, config files, READMEs, sample manifests, `environment.yml`
- **Never:** FASTQ, BAM, VCF, reference genomes, large CSVs, anything over ~50 MB

### Typical daily workflow

You do not need to be a Git expert. These commands handle 95% of bioinformatics version control:

```bash
# See what has changed
git status

# Stage the files you modified
git add 02_scripts/03_align-star.sh 00_meta/README.md

# Save a snapshot with a short message
git commit -m "Updated STAR alignment parameters for paired-end mode"

# Push to GitHub (if you have a remote set up)
git push origin main
```

Commit after every meaningful change; finishing a script, fixing a bug, changing parameters. Small, frequent commits are better than one giant commit at the end of the week.

### Push to a remote repository

```bash
# Create a private repo on GitHub first, then:
git remote add origin https://github.com/username/airway-rnaseq.git
git push -u origin main
```

After this initial setup, `git push` is all you need to sync future commits.

### Best practices for Git in bioinformatics

Use this as a quick reference:

- **Symlink results from previous steps** instead of copying them into new directories. This avoids duplicating large files and keeps your repo clean.
- **Do not commit large files** (FASTQ, BAM, SAM, VCF, reference genomes). They bloat the repository permanently; even deleting them later does not reclaim space in Git history.
- **Do not commit too many files at once** (e.g., hundreds of log files or analysis outputs). Large numbers of tracked files slow down every `git status`, `git add`, and `git push`.
- **Use `.gitignore` from the start.** Add it before your first commit so data files and logs never enter the history.
- **Write meaningful commit messages.** `"Updated script"` is useless six months later. `"Added fastp trimming step with --qualified_quality_phred 20"` tells you exactly what changed.
- **Commit only `00_meta/` and `02_scripts/`** by default. These are small, text-based, and irreplaceable. Everything else is either too large or regenerable.
- **Keep the repository small.** A bioinformatics project repo should be well under 100 MB. If `git` feels slow, run `git count-objects -vH` to check the repo size.
- **One project, one repository.** Do not put multiple unrelated projects in a single repo, and do not scatter one project's scripts across multiple repos.

!!! note
    If you have a small binary file that must be tracked (e.g., a 5 MB curated BED file), Git can handle it. But anything larger than ~50 MB belongs on Depot; document its path in your README instead of committing it.

## Quick-start checklist

Copy this checklist and run through it at the start of every new project.

1. **Create the project directory on Scratch**

    ```bash
    PROJECT="YYYYMMDD_ProjectName_AnalysisType"
    mkdir -p ${RCAC_SCRATCH}/${PROJECT}/{00_meta,01_data/{raw,processed},02_scripts,03_analysis,04_results/{figures,tables},99_logs}
    cd ${RCAC_SCRATCH}/${PROJECT}
    ```

2. **Symlink raw data from Depot (do not copy)**

    ```bash
    ln -s /depot/<group>/data/my_fastqs 01_data/raw
    ```

3. **Write the README**

    Create `00_meta/README.md` with: project name, date, PI, goal, sample summary, and pipeline overview.

4. **Create a sample manifest**

    Create `00_meta/sample_manifest.tsv` mapping sample IDs to filenames, conditions, and any metadata.

5. **Initialize Git**

    ```bash
    git init
    cp /path/to/your/template/.gitignore .
    git add 00_meta/ 02_scripts/
    git commit -m "Initial project setup"
    ```

6. **Record software versions**

    ```bash
    module list 2>&1 > 00_meta/software_versions.txt
    ```

7. **Write your first script in `02_scripts/`**

    Name it `01_qc-fastqc.sh`. Point SLURM logs to `99_logs/`:

    ```bash
    #SBATCH --output=99_logs/01_qc_%j.out
    #SBATCH --error=99_logs/01_qc_%j.err
    ```

8. **Check quota before starting**

    ```bash
    myquota
    ```

That is the entire setup. It takes five minutes at the start of a project and saves days of confusion later. The key principle is simple: **keep your raw data safe, keep your scripts under version control, and keep your results organized**; so anyone, including future you, can understand and reproduce your work.
