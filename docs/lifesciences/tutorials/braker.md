---
title: Gene prediction using BRAKER3
tags:
  - Life Sciences
  - Annotation
  - Tutorials
---

# Gene prediction using BRAKER3

BRAKER3 is a pipeline that combines GeneMark-ET and AUGUSTUS to predict genes in eukaryotic genomes. This pipeline is particularly useful for annotating newly sequenced genomes. The flexibility of BRAKER3 allows users to provide various input datasets for improving gene prediction accuracy. In this example, we will use various scenarios to predict genes in a Maize genome using BRAKER3. Following are the scenarios we will cover:

| Input Type                | Case 1  | Case 2 | Case 3 | Case 4 | Case 5 | Case 6 | Case 7 | Case 8 |
|---------------------------|---------|--------|--------|--------|--------|--------|--------|--------|
| Genome                    | ✔️      | ✔️     | ✔️     | ✔️     | ✔️     | ✔️     | ✔️     | ✔️   |
| RNA-Seq                   | ❌      | ✔️^*     | ✔️     | ❌     | ✔️     | ❌     | ❌     | ✔️   |
| Iso-Seq                   | ❌      | ❌     | ❌     | ❌     | ❌     | ❌     | ✔️     | ✔️   |
| Conserved proteins        | ❌      | ❌     | ❌     | ✔️     | ✔️     | ❌     | ✔️     | ✔️   |
| Pretrained species model  | ❌      | ❌     | ❌     | ❌     | ❌     | ✔️     | ❌     | ❌   |

minimal RNA-Seq data (one library/one tissue)


## Installation

We will use the `apptainer` tool to build a Singularity container for BRAKER3. The Singularity container will contain all the necessary dependencies and tools required to run BRAKER3. To build the Singularity container, run the following command:

```bash
apptainer build --fakeroot braker3.sif docker://teambraker/braker3:latest
```

This will create a Singularity container named `braker3.sif` with BRAKER3 installed.

## Setting up BRAKER3

Before running BRAKER3, we need to set up:

1. `GeneMark-ES/ET/EP/ETP` license key
2. The `AUGUSTUS_CONFIG_PATH` configuration path

The license key for `GeneMark-ES/ET/EP/ETP` can be obtained from the [GeneMark website](http://exon.gatech.edu/GeneMark/license_download.cgi). Once downloaded, you need to place it in your home directory:

```bash
tar xf gm_key_64.gz
cp gm_key_64 ~/.gm_key
```

For the `AUGUSTUS_CONFIG_PATH`, we need to copy the `config` directory from the Singularity container to the scratch directory. This is required because BRAKER3 needs to write to the `config` directory, and the Singularity container is read-only. To copy the `config` directory, run the following command:

```bash
apptainer exec braker3.sif cp -r /opt/Augustus/config ${RCAC_SCRATCH}/braker/augustus_config
```


## Running BRAKER3

The paths to the following variables need to be set:

```bash
BRAKER_SIF="${RCAC_SCRATCH}/braker/braker3.sif"
AUGUSTUS_CONFIG_PATH="${RCAC_SCRATCH}/braker/augustus_config"
GENEMARK_PATH="/opt/ETP/bin/gmes"
genome="${RCAC_SCRATCH}/braker/Zm-B73-REFERENCE-NAM-5.0_softmasked.fa"
workdir=${PWD}/$(basename ${genome%.*})_braker
```


### Input datasets

=== "Case 1"

    **With genome only (no external evidence)**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | None                            |
    | Protein sequences         | None                            |
    | Long-read data            | None                            |
    | Pretrained species model  | None                            |

    ```bash
    mkdir -p ${workdir}
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --esmode \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c1 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 2"

    **with minimal RNA-Seq data (one library/one tissue)**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | RNAseq (single library)         |
    | Protein sequences         | None                            |
    | Long-read data            | None                            |
    | Pretrained species model  | None                            |

    ```bash
    mkdir -p ${workdir}
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --rnaseq_sets_ids=B73_V11_middle_MN01042 \
            --rnaseq_sets_dirs=${RCAC_SCRATCH}/RNAseq/ \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c2 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 3"

    **with exhaustive RNA-Seq data (11 tissues)**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | RNAseq (11 tissues)             |
    | Protein sequences         | None                            |
    | Long-read data            | None                            |
    | Pretrained species model  | None                            |

    ```bash
    rna_seq_sets_ids="B73_8DAS_root_MN01011,B73_8DAS_root_MN01012,B73_8DAS_shoot_MN01021,B73_8DAS_shoot_MN01022,B73_16DAP_embryo_MN01101,B73_16DAP_embryo_MN01102,B73_16DAP_endosperm_MN01091,B73_16DAP_endosperm_MN01092,,B73_R1_anther_MN01081,B73_R1_anther_MN01082,B73_R1_anther_MNA1081,B73_V11_base_MN01031,B73_V11_base_MN01032,B73_V11_middle_MN01041,B73_V11_middle_MN01042,B73_V11_middle_MN01043,B73_V11_tip_MN01051,B73_V11_tip_MN01052,B73_V18_ear_MN01071,B73_V18_ear_MN01072,B73_V18_tassel_MN01061,B73_V18_tassel_MN01062"
    mkdir -p ${workdir}
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --rnaseq_sets_ids=${rnaseq_sets_ids} \
            --rnaseq_sets_dirs=${RCAC_SCRATCH}/rnaseq/ \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c3 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 4"

    **with conserved protein sequences**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | None                            |
    | Protein sequences         | Viridiplantae protein sequences |
    | Long-read data            | None                            |
    | Pretrained species model  | None                            |

    Using the [orthodb-clades](https://github.com/tomasbruna/orthodb-clades) tool, we can download protein sequences for a specific clade. In this scenario, since we are using the Maize genome, we can download the `clade` specific `Viridiplantae.fa`  [OrthoDB v12](https://www.orthodb.org/) protein sets.

    ```bash
    git clone git@github.com:tomasbruna/orthodb-clades.git
    ml biocontainers
    ml snakemake
    snakemake --cores ${SLURM_CPUS_ON_NODE}
    ```

    When this is done, you should see a folder named `clade` with `Viridiplantae.fa` in the `orthodb-clades` directory. We will use this as one of the input datasets for BRAKER3. The following command will run BRAKER3 with the input genome and protein sequences:

    ```bash
    protein_sequences="${RCAC_SCRATCH}/braker/orthodb-clades/clade/Viridiplantae.fa"
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --species=Zm_$(date +"%Y%m%d").1a \
            --prot_seq=${proteins} \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c4 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 5"

    **with RNA-Seq and conserved protein sequences**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | RNAseq (11 tissues)             |
    | Protein sequences         | Viridiplantae protein sequences |
    | Long-read data            | None                            |
    | Pretrained species model  | None                            |

    ```bash
    mkdir -p ${workdir}
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --rnaseq_sets_ids=${rnaseq_sets_ids} \
            --rnaseq_sets_dirs=${RCAC_SCRATCH}/rnaseq/ \
            --prot_seq=${proteins} \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c5 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 6"

    **with pretrained species model ("Maize")**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | None                            |
    | Protein sequences         | None                            |
    | Long-read data            | None                            |
    | Pretrained species model  | "Maize"                         |

    ```bash
    mkdir -p ${workdir}
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --skipAllTraining \
            --genome=${genome} \
            --species=maize5 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 7"

    **with Iso-Seq and conserved protein sequences**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | None                            |
    | Protein sequences         | Viridiplantae protein sequences |
    | Long-read data            | Iso-Seq data                    |
    | Pretrained species model  | None                            |

    The IsoSeq data for maize (B73) was obtained from the publication [PMC7028979](https://pmc.ncbi.nlm.nih.gov/articles/PMC7028979/) and is available in the ENA BioProject [PRJEB32007](https://www.ebi.ac.uk/ena/browser/view/PRJEB32007).
    To proceed, you will need the original files listed in the `Submitted files: FTP` column of the BioProject page. We will download the data (`.bam` files) and process them using the `isoseq3` tool to demultiplex and map the reads to the B73 reference genome.
    The primers and adapters required for demultiplexing were sourced from the original publication (Supplementary Table 1).

    ```bash
    ml purge
    ml anaconda
    conda activate isoseq
    for input in *subreads.bam; do
    base=$(basename ${input} |sed 's/.subreads.bam//g')
    # convert subreads to ccs
    ccs ${input} ${base}.ccs.bam --skip-polish --min-passes 1
    # demultiplex
    lima ${base}.ccs.bam primer.fasta ${base}_lima.bam --isoseq --dump-clips
    done
    # move the files to separate directories
    for f in B73 Ki11 Ki11xB73 B73xKi11; do
    mkdir -p $f;
    mv *_${f}_* ./${f}/;
    done
    cd B73
    # merge the files
    ls *.bam > input.fofn
    ml purge
    ml biocontainers
    ml bamtools samtools
    bamtools merge -list input.fofn -out merged_B73.bam
    # convert bam to fastq
    samtools fastq --threads ${SLURM_CPUS_ON_NODE} -o merged_B73.fastq merged_B73.bam
    ml minimap2
    minimap2 \
            -t ${SLURM_CPUS_ON_NODE}\
            -ax splice:hq \
            -uf ${genome} \
            merged_B73.fastq > isoseq_B73.sam
    samtools view \
            -bS \
            --threads ${threads} \
            -o isoseq.bam \
            isoseq_b73.sam \
    samtools sort \
            --threads ${threads} \
            -o isoseq_sorted.bam \
            isoseq.bam
    ```

    We will need `isoseq_sorted.bam` (and `merged_B73.fastq`) for the **case 8** as well.
    For this **case 7**, we only need `isoseq_sorted.bam`. To setup BRAKER3 with the Iso-Seq data and conserved protein sequences:

    ```bash
    isoseq="${RCAC_SCRATCH}/isoseq/isoseq_sorted.bam"
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} braker.pl \
            --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} \
            --GENEMARK_PATH=${GENEMARK_PATH} \
            --prot_seq=${proteins} \
            --bam=${isoseq} \
            --genome=${genome} \
            --species=Zm_$(date +"%Y%m%d").c7 \
            --workingdir=${workdir} \
            --gff3 \
            --threads ${SLURM_CPUS_ON_NODE}
    ```

=== "Case 8"

    **with Iso-Seq, RNA-Seq and conserved protein sequences**

    | Input                     | Type                            |
    |---------------------------|---------------------------------|
    | Genome                    | B73.v5 (softmasked)             |
    | RNA-Seq data              | RNAseq (11 tissues)             |
    | Protein sequences         | Viridiplantae protein sequences |
    | Long-read data            | Iso-Seq data                    |
    | Pretrained species model  | None                            |

    To run this, you need to first run **case 3** (full-RNAseq data) [BRAKER-1] and **case 5** (conserved proteins data) [BRAKER-2]. You will also need the Iso-Seq BAM file generated in **case 7**.

    The steps are as follows:

    1. Run `BRAKER` using the spliced alignments of short-read RNA-seq (here **case 3** with full-RNAseq data).
    2. Run `BRAKER` using the conserved proteins data (here **case 5** with conserved proteins data).
    3. Run `GeneMarkS-T` protocol on the Iso-Seq data to predict protein-coding regions in the transcripts:
        - map the long reads to the genome using minimap2 (here **case 7** `isoseq_sorted.bam`)
        - collapse redundant isoforms
        - predict protein-coding regions using `GeneMarkS-T`
    4. Run the long read version of `TSEBRA` to combine the three gene sets using all extrinsic evidence

    Since we have already run **case 3** and **case 5**, we will proceed with the remaining steps.

    ```bash
    collapse_isoforms_by_sam.py \
            --input merged.fastq \
            --fq \
            -b isoseq_sorted.bam \
            -o isoseq_sorted \
            --dun-merge-5-shorter \
            --cpus ${SLURM_CPUS_ON_NODE}
    stringtie2fa.py \
            -g ${genome} \
            -f isoseq_sorted.collapsed.gff \
            -o cupcake.fa

    gmst.pl \
            --strand direct \
            cupcake.fa.mrna \
            --output gmst.out \
            --format GFF
    git clone https://github.com/Gaius-Augustus/BRAKER
    cd BRAKER && \
       git checkout long-reads && \
       cd ..
    BRAKER/scripts/gmst2globalCoords.py \
            -t isoseq_sorted.collapsed.gff \
            -p gmst.out \
            -o gmst.global.gtf \
            -g ${genome}
    ```

    We will need the `hintsfile.gff` and `augustus.hints.gtf` files from **case 3** and **case 5**.
    We will also need the `gmst.global.gtf` file generated from the `GeneMarkS-T` protocol.
    The following command will run `TSEBRA` to combine the three gene sets:

    ```bash
    ln -s ${RCAC_SCRATCH}/braker/case3/Augustus/augustus.hints.gtf braker1.augustus.hints.gtf
    ln -s ${RCAC_SCRATCH}/braker/case5/Augustus/augustus.hints.gtf braker2.augustus.hints.gtf
    ln -s ${RCAC_SCRATCH}/braker/case3/hintsfile.gff braker1.hintsfile.gff
    ln -s ${RCAC_SCRATCH}/braker/case5/hintsfile.gff braker2.hintsfile.gff
    ln -s ${RCAC_SCRATCH}/braker/case7/genemark_st/gmst.global.gtf
    git clone https://github.com/Gaius-Augustus/TSEBRA
    cd TSEBRA
    git checkout long-reads
    apptainer exec --bind ${RCAC_SCRATCH} ${BRAKER_SIF} ./TSEBRA/bin/tsebra.py \
            -g braker1.augustus.hints.gtf,braker2.augustus.hints.gtf \
            -e braker1.hintsfile.gff,braker2.hintsfile.gff \
            -l gmst.global.gtf \
            -c ./TSEBRA/config/long_reads.cfg \
            -o tsebra.gtf
    ml purge
    ml biocontainers
    ml cufflinks
    gffread tsebra.gtf \
            -g ${genome} \
            -y  tsebra_pep.fa \
            -x  tsebra_cds.fa
    ```




## Processing output



## Comparing and Evaluating

### A. BUSCO profiling

![Busco results](../../assets/images/lifesciences/braker_busco_figure.png)


### B. Reference comparison

#### With Isoforms

=== "Sn/Pr"

    ![Assigned features](../../assets/images/lifesciences/braker_mikado_compare_with_isoforms.png)

=== "Missed/Novel"

    ![Unassigned features](../../assets/images/lifesciences/braker_mikado_compare_with_isoforms_counts.png)

#### Without Isoforms

=== "Sn/Pr"

    ![Assigned features](../../assets/images/lifesciences/braker_mikado_compare_without_isoforms.png)

=== "Missed/Novel"

    ![Unassigned features](../../assets/images/lifesciences/braker_mikado_compare_without_isoforms_counts.png)


### C. Feature assignment

=== "Assigned features"

    ![Assigned features](../../assets/images/lifesciences/braker_assigned.png)

=== "Unassigned features"

    ![Unassigned features](../../assets/images/lifesciences/braker_unassigned.png)

### D. Functional annotation

=== "Pfam domains"

    ![Pfam Domains](../../assets/images/lifesciences/braker_pfam-domain.png)

=== "Functional annotation"

    ![Functional Annotation](../../assets/images/lifesciences/braker_gene-function.png)

=== "Percent Identity"

    ![Percent identity](../../assets/images/lifesciences/braker_pid.png)


### E. Phylostrata analysis

=== "Phylostrata counts"

    ![Assigned features](../../assets/images/lifesciences/braker_ps_counts.png)

=== "Phylostrata percentages"

    ![Unassigned features](../../assets/images/lifesciences/braker_ps_percent.png)

### F. GFF3 stats


![GFF3 stats](../../assets/images/lifesciences/braker_summary_stats.png)

### G. OMArk assessment

=== "Conserved Genes"

    ![braker consistency](../../assets/images/lifesciences/braker_consistency.png)

=== "Conserved HOGs"

    ![braker_conservedHOGs](../../assets/images/lifesciences/braker_conservedHOGs.png)

### H. CDS assessments

=== "GC distribution"

    ![braker_cds-gc](../../assets/images/lifesciences/braker_cds-gc.png)

=== "Length distribution"

    ![braker_cds-length](../../assets/images/lifesciences/braker_cds-length.png)

=== "GC content"

    ![braker_gc-content](../../assets/images/lifesciences/braker_gc-content.png)

=== "Codon type"

    ![braker_codon-type](../../assets/images/lifesciences/braker_codon-type.png)



## Conclusions





## References
