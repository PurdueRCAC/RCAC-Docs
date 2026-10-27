---
title: "Genomics Exchange Fall 2026 Session 3: Nextflow fundamentals (Oct 20, 2026)"
tags:
  - Genomics Exchange
  - Nextflow
  - Life Sciences
---

# Session 3: Nextflow fundamentals (Oct 20, 2026)

!!! info "Session details"
    - **Date:** Tuesday, October 20, 2026
    - **Time:** 11:00 AM – 12:00 PM EDT (10:00 – 11:00 AM CDT)
    - **Format:** 60 min interactive workshop, online (Microsoft Teams)
    - **Instructor:** Yucheng Zhang, Tufts University
    - **Register:** closed. 
    - **Recording:** [Teams Recording](https://purdue0-my.sharepoint.com/:v:/g/personal/aseethar_purdue_edu/IQCu0Qhq-fyUTruOLrbsfjcFAeMlOuirzJ_6SIbJ-vVhr4s?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbFZpZXciOiJTaGFyZURpYWxvZy1MaW5rIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXcifX0%3D&e=ftKxA4)
    - **Materials:** [Field guide](https://zhan4429.github.io/PurdueNfWorkshop/field-guide.html) · [GitHub repo](https://github.com/zhan4429/PurdueNfWorkshop)


## Session description

First of four sessions on Nextflow. Yucheng Zhang (Tufts) ran the same read-QC analysis (fastp, FastQC, MultiQC on 11 FASTQ files) three ways on Gautschi: a Bash loop in one Slurm job, a Nextflow workflow using the local executor inside one allocation, and the same workflow with the Slurm executor submitting each task as its own job. Along the way: processes, channels, and `publishDir`; how `-resume` reuses completed tasks; reading `nextflow log` and task work directories to troubleshoot; and cleaning up scratch with `nextflow clean`.

## Prerequisites

- An RCAC account with a Slurm allocation on Gautschi (run `slist` to find your account name)
- Comfortable with the shell and `sbatch` / `squeue`
- No Nextflow experience needed; the session builds from a Bash loop

## Running the materials on Gautschi

The guide's scripts need two Gautschi-specific changes to run as published (tested Oct 19, 2026, Nextflow 26.04.2):

1. Use `module --force purge` before `module load` in each launcher. xalt is a sticky module on Gautschi; plain `module purge` leaves it loaded and its `LD_PRELOAD` breaks the biocontainer images.
2. Add a `nextflow.config` in the workflow directory so Nextflow tasks can see the biocontainer tool wrappers:
   ```groovy
   process.beforeScript = 'module --force purge; module load biocontainers fastp fastqc multiqc; export -f fastp fastqc multiqc'
   ```
   Lmod defines these tools as shell functions, which the task shell does not inherit unless exported.

Replace `YOUR_ACCOUNT` in `hpc.config` with your allocation, and drop the `--mem` lines from the launchers; Gautschi allocates memory per core, so size jobs by `-c`.

## Next session

[Session 4: Running nf-core pipelines on clusters (Oct 27, 2026)](session-4.md)



[Back to Fall 2026](../index.md)
