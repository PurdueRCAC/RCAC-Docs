---
title: Reproducible Genomics on RCAC
tags:
  - Life Sciences
  - Genomics Exchange
  - Guides
search:
  boost: 1
---

# Reproducible Genomics on RCAC

Reproducibility is four separate problems, not one. An analysis can be rerun only if the code, the software environment, the input data, and the way the job ran are all known. A gap in any one layer changes the result, usually without an error message.

This guide is a checklist. Each layer lists what goes wrong and what to do about it. For the worked demo and discussion, see [Genomics Exchange Fall 2026, Session 1](../../workshops/genomics_exchange/fall2026/session1/index.md).

| Layer | The question it answers | Where the answer should live |
|---|---|---|
| Code | What did I run? | Git history |
| Environment | What software ran it? | Job log |
| Data | What went in? | Checksum file and project README |
| Compute | How did it run? | Job log and Slurm script |

## Code: what you wrote

**What goes wrong**

- A hard-coded absolute path does not error. Copy the project and the script keeps reading the original FASTQ or reference, then reports a plausible result for the wrong input.
- Scripts are edited after the run, so nothing records which version produced the results.
- A "small tweak" breaks a working script and there is no way back.

**What to do**

- Use paths relative to the script or project root. Make the script fail loudly when an input is missing.
- Put scripts under Git, even without GitHub. Commit before every run, then note the commit hash in the job log with `git rev-parse --short HEAD`.
- Experiment on a branch. Reset to the last good commit when a change goes wrong.
- Set random seeds wherever a method uses them. In single-cell work, UMAP layouts differ run to run without a seed, so set one at the top of the R or Python session, and again in the UMAP call if the tool takes its own.

## Environment: what you loaded

**What goes wrong**

- `module load samtools` without a version floats to whatever is newest after a deployment. Today that is samtools 1.22.1 on Gautschi. Last year it was not.
- Software sets and versions differ across Gautschi, Negishi, and Gilbreth. Gilbreth is GPU focused, so its core tools, Python, and Perl track a different schedule. A script that works on one cluster can fail or return different results on another.
- Modules left loaded from a previous session leak into the current one.

**What to do**

- Check what exists, then pin the exact version:

    ```bash
    module purge
    module load biocontainers
    module spider samtools          # lists every version on this cluster
    module load samtools/1.22.1
    ```

- Record the environment in every job: `module list` and each tool's `--version` at the top of the Slurm script, so the log carries the answer.
- For containers, pin the image tag or digest, never `latest`.
- Treat a new cluster as a new environment. Re-check versions first.

## Data: what went in

**What goes wrong**

- Reference genomes and annotations change or disappear. When revisions arrive a year later, the download URL returns a new build or nothing at all.
- A transfer or re-download truncates or corrupts a file without complaint, and the pipeline still produces output.
- A "raw" file is edited in place and nobody remembers.

**What to do**

- Record the URL, version or release, and download date for every external file in your project README.
- Keep the exact reference file you used inside the project, in a read-only raw-data directory, and back it up to Depot or Fortress.
- Checksum every input once, then compare after every transfer, re-download, or move:

    ```bash
    md5sum 01_data/raw/*.fastq.gz 01_data/raw/*.fa > 00_meta/checksums.md5
    md5sum -c 00_meta/checksums.md5      # OK on every line, or stop
    ```

- Record filtering criteria and reapply them. Thresholds are context dependent: a mitochondrial cutoff of 10 percent suits one experiment and discards most cells in the next, so the number comes from the plot. Write down the value and why, and reuse it when you rerun.

## Compute: how it ran

**What goes wrong**

- Parallel jobs fail silently. In a scatter by chromosome, one chunk dies partway and leaves a partial file. A merge step that counts output files as completed chunks then reports too few variants.
- Chunk boundaries overlap. Mixing 0-based and 1-based coordinates gives each chunk one shared base, and the merge reports too many variants.
- Thread count changes output order, and for some tools the result itself.
- The resource request that produced the result is lost.

**What to do**

- Check each chunk's exit status, not whether its output file exists. Keep intermediate files until the merged result is validated.
- Validate boundaries before merging: adjacent chunks must sum to the reference length with no overlap.
- Record thread count and the full Slurm request in the job log. Compare results only across runs with the same settings.
- Put provenance in the job script so every log answers all four layers:

    ```bash
    #!/bin/bash
    # FILENAME: provenance.sub
    #SBATCH --job-name=bioc-probe
    #SBATCH --account=<account-name> --partition=cpu
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=04:00:00
    #SBATCH --output=bioc-probe-%j.out

    module purge
    module load biocontainers samtools/1.22.1

    echo "commit: $(git rev-parse --short HEAD)"
    echo "threads: ${SLURM_CPUS_PER_TASK}"
    module list 2>&1
    samtools --version | head -1
    md5sum -c 00_meta/checksums.md5 || exit 1
    ```

## Related guides

- [Project Organization](project-organization.md): the directory layout assumed above.
- [Running Bioinformatics on RCAC](running-bioinformatics.md): modules, containers, and conda.
- [Nextflow and nf-core](nextflow.md): pipelines that manage the compute layer for you.
- [Session 2: Data Management for Biologists](../../workshops/genomics_exchange/fall2026/session2/index.md): the next session in the series.

[Back to Life Sciences](../index.md){ .md-button }
