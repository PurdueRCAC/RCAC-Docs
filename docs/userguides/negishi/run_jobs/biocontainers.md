---
tags:
  - Negishi
authors:
  - jin456
  - remender
  - hkashgar
resource: Negishi
search:
  boost: 2
---
# BioContainers Collection

What is BioContainers?
----------------------

The BioContainers project came from the idea of using the containers-based technologies such as [Docker](https://www.docker.com) or [rkt](https://github.com/rkt/rkt) for bioinformatics software. Having a common and controllable environment for running software could help to deal with some of the current problems during software development and distribution. BioContainers is a community-driven project that provides the infrastructure and basic guidelines to create, manage and distribute bioinformatics containers with a special focus on omics fields such as proteomics, genomics, transcriptomics and metabolomics. . For more information, please visit [BioContainers project](https://biocontainers.pro).

### Getting Started

Users can download bioinformatic containers from the [BioContainers.pro](https://biocontainers.pro) and run them directly using Singularity instructions from the corresponding container’s catalog page.

Brief Singularity guide and examples are available at the [Negishi Singularity user guide](apptainer.md) page. Detailed Singularity user guide is available at: [sylabs.io/guides/3.8/user-guide](https://sylabs.io/guides/3.8/user-guide/)

In addition, a subset of pre-downloaded biocontainers wrapped into convenient software modules are provided. These modules wrap underlying complexity and provide the same commands that are expected from non-containerized versions of each application.

On Negishi, type the command below to see the lists of biocontainers we deployed.

```
module load biocontainers
module avail

------------ BioContainers collection modules -------------
      bamtools/2.5.1 
      beast2/2.6.3
      bedtools/2.30.0 
      blast/2.11.0
      bowtie2/2.4.2
      bwa/0.7.17 
      cufflinks/2.2.1
      deeptools/3.5.1
      fastqc/0.11.9
      faststructure/1.0
      htseq/0.13.5
[....]
```

### Example

This example demonstrates how to run BLASTP with the `blast` module. This `blast` module is a biocontainer wrapper for [NCBI BLAST](https://blast.ncbi.nlm.nih.gov).

```
module load biocontainers
module load blast
blastp -query query.fasta -db nr -out output.txt -outfmt 6 -evalue 0.01
```

To run a job in batch mode, first prepare a job script that specifies the BioContainer modules you want to launch and the resources required to run it. Then, use the `sbatch` command to submit your job script to Slurm. The following example shows the job script to use [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) in bioinformatic analysis.

```
#!/bin/bash

#SBATCH -A myqueuename
#SBATCH -o bowtie2_%j.txt
#SBATCH -e bowtie2_%j.err
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:30:00
#SBATCH --job-name bowtie2

# Load the Bowtie module
module load biocontainers
module load bowtie2

# Indexing a reference genome
bowtie2-build  ref.fasta ref

# Aligning paired-end reads
bowtie2 -p 8 -x ref -1  reads_1.fq -2 reads_2.fq -S align.sam
```

To help users get started, we provided detailed user guides for each containerized bioinformatics module on the [ReadTheDocs platform](https://biocontainer-doc.readthedocs.io/en/latest/)

![RCAC Biocontainers one ReadTheDocs](../../../../assets/images/userguides/examples/biocontainers.png)

[**Back to the Running Jobs section**](index.md)
