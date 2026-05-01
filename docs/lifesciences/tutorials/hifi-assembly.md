---
title: Genome assembly using HiFi reads
tags:
  - Life Sciences
  - Assembly
  - Tutorials
---

# Genome assembly using HiFi reads

A short guide to assemble genomes from long reads (PacBio HiFi) using [HiFiasm](https://github.com/chhylp123/hifiasm)


## 1. Installation

Manually installing `hifiasm` is easy. The instructions as listed in the [GitHub repository](https://github.com/chhylp123/hifiasm) are as follows:

```bash
git clone https://github.com/chhylp123/hifiasm
cd hifiasm && make
```

But in case if you have any problems, you can use the Singularity container. First, download the [recipe file from the GitHub gist](https://gist.github.com/aseetharam/6755b9eb93644d5d95485209447dbc71). Rename the file to `hifiasm_v0.20.0-r639.def` and build the container

```bash
singularity build hifiasm.sif hifiasm_v0.20.0-r639.def
```

This will create `hifiasm.sif` file in the current directory.


## 2. Download HiFi reads

To run HiFiasm, we need HiFi reads. We will download sample datasets from [PacBio website](https://www.pacb.com/connect/datasets/). For this specific tutorial, we will use the [PacBio HiFi data for maize B73 genome](https://downloads.pacbcloud.com/public/revio/2023Q1/maize-B73-rep1/).

```bash
wget https://downloads.pacbcloud.com/public/revio/2023Q1/maize-B73-rep1/m84006_221229_002525_s1.hifi_reads.bam
```

First step is to convert the HiFi reads in bam format to fasta (or fastq) format. We can use `samtools` for this.

!!! warning
    Be sure to run the computationally intensive steps on a compute node, not the login node. You can request an interactive session using `salloc` command.


```bash
ml biocontainers
ml samtools
samtools fasta \
    -threads ${SLURM_CPUS_ON_NODE} \
    m84006_221229_002525_s1.hifi_reads.bam > maize-hifi.fasta
```

Before proceeding, lets quickly check our input file (read depth and other stats).

```bash
ml biocontainers
ml seqkit
seqkit stats  \
    --all \
    --threads ${SLURM_CPUS_ON_NODE} \
    --out-file summary-stats.out \
    maize-hifi.fasta
```

This will generate a file `summary-stats.out` with the statistics of the input file.

**Table 1: Summary statistics of the input file `maize-hifi.fasta`**

| **Property**  | **Value**         |
|---------------|-------------------|
| file          | maize-hifi.fasta  |
| format        | FASTA             |
| type          | DNA               |
| num_seqs      | 5,142,754         |
| sum_len       | 70,099,174,236    |
| min_len       | 94                |
| avg_len       | 13,630.70         |
| max_len       | 55,776            |
| Q1            | 10,374            |
| Q2            | 13,501            |
| Q3            | 16,921            |
| sum_gap       | 0                 |
| N50           | 15,265            |
| Q20(%)        | 0                 |
| Q30(%)        | 0                 |
| GC(%)         | 45.62             |


So assuming 2,400Mb genome size for maize, our sequencing depth will be 70,099,174,236 bp / 2,400,000,000  = 29.2x.
Other stats reported are the number of sequences, minimum, maximum, and average length of the sequences, N50, and GC content. They all reaffirm the quality of the input file.

!!! note
    Running `fastqc` on the PacBio HiFi reads does not provide the required information as the reads are too long and the encoded quality scores are not the same as in short reads.

## 3. Run HiFiasm

Now we can run HiFiasm on the fasta file. Be sure to check the [documentation](https://hifiasm.readthedocs.io/en/latest/parameter-reference.html#parameter-reference) for all the options available.

First, we will run `hifiasm` with default suggested parameters.


```bash
singularity exec hifiasm.sif hifiasm \
    -t ${SLURM_CPUS_ON_NODE} \
    -o maize_B73_hifi.asm \
    maize-hifi.fasta
```

This will generate partially phased contigs with filenames `maize_B73_hifi.asm.bp.hap[12].p_ctg.gfa`. This pair of files can be thought to represent the two haplotypes in a diploid genome, though with occasional switch errors. The frequency of switches is determined by the heterozygosity of the input sample. Since B73 is an inbred, we can expect most of the genome to be identical to each other in these files.

The other files of importance are `.bp.p_ctg.gfa`, `.bp.p_utg.gfa` and `.bp.r_utg.gfa` (the counterparts of these files have an extension `.noseq.gfa` instead of `.gfa`, that contains no sequence and can be used for visualization using programs such as [`bandage`](https://rrwick.github.io/Bandage/)). These files represent the primary contigs, primary unitigs, and redundant unitigs, respectively. The files are usually not necessary and can be ignored for most purposes.


First, let's check the statistics of the output files. For this, we will need to convert the `.gfa` files to `.fasta` format.

```bash
for f in *.hap[12].p_ctg.gfa; do
    awk '/^S/{print ">"$2"\n"$3}' ${f} > ${f%.gfa}.fasta
done
```

Now we can check the statistics of the output files.

```bash
ml biocontainers
ml quast
quast.py \
    --fast \
    --threads ${SLURM_CPUS_ON_NODE} \
    -o maize_B73_hifi.asm.stats \
    *.hap[12].p_ctg.fasta
```

This will generate a folder `maize_B73_hifi.asm.stats` with the statistics of the output files.

**Table 2: Summary statistics of the assembled contigs**

| **Assembly**                  | **hap1.p_ctg**                       | **hap2.p_ctg**                       |
|-------------------------------|--------------------------------------|--------------------------------------|
| # contigs (>= 0 bp)           | 695                                  | 340                                  |
| # contigs (>= 1000 bp)        | 695                                  | 340                                  |
| # contigs (>= 5000 bp)        | 695                                  | 340                                  |
| # contigs (>= 10000 bp)       | 695                                  | 340                                  |
| # contigs (>= 25000 bp)       | 648                                  | 336                                  |
| # contigs (>= 50000 bp)       | 311                                  | 245                                  |
| Total length (>= 0 bp)        | 2,115,818,197                        | 2,146,055,694                        |
| Total length (>= 1000 bp)     | 2,115,818,197                        | 2,146,055,694                        |
| Total length (>= 5000 bp)     | 2,115,818,197                        | 2,146,055,694                        |
| Total length (>= 10000 bp)    | 2,115,818,197                        | 2,146,055,694                        |
| Total length (>= 25000 bp)    | 2,114,814,205                        | 2,145,970,005                        |
| Total length (>= 50000 bp)    | 2,102,601,706                        | 2,142,223,242                        |
| # contigs                     | 695                                  | 340                                  |
| Largest contig                | 230,900,369                          | 229,694,453                          |
| Total length                  | 2,115,818,197                        | 2,146,055,694                        |
| N50                           | 92,331,732                           | 156,748,501                          |
| N90                           | 8,066,869                            | 10,922,511                           |
| auN                           | 110,840,927.5                        | 131,176,388.9                        |
| L50                           | 7                                    | 6                                    |
| L90                           | 39                                   | 23                                   |
| # N's per 100 kbp             | 0.00                                 | 0.00                                 |


The statistics show that the assembly is of high quality with N50 of 92MB and 156MB for hap1 and hap2, respectively. The largest contig is 230MB and 229MB for hap1 and hap2, respectively, suggest that we probably have an entire chromosome in a single contig. The entire genome (2.1GB) is represented in 695 and 340 contigs for hap1 and hap2!


!!! note
    The `hifiasm` job was run on `negishi` cluster with 64 CPUs and 128Gb memory. The job took about ~3 hours to complete  (02:54:44). The reported memory usage was 68.47GB.

The batch error file reports various statistics that can be used to further optimize the assembly. Here are some of the important statistics:

**Table 3: Log file statistics from the HiFiasm assembler**

| Stage/Metric                         | EC Round 1                 | EC Round 2                 | EC Round 3                 | Final Statistics          |
|--------------------------------------|----------------------------|----------------------------|----------------------------|---------------------------|
| Total bases                          | 70,099,174,236             | 70,119,906,168             | 70,120,349,660             |                           |
| Corrected bases                      | 103,540,747                | 2,197,978                  | 542,087                    |                           |
| Distinct minimizers (k-mers)         | 21,419,636                 | 55,569,142                 | 52,995,420                 |                           |
| Total minimizers (k-mers)            | 1,933,199,140              | 1,922,092,195              | 1,921,066,641              |                           |
| Indexed positions                    | 1,900,001,047              | 1,919,860,458              | 1,919,551,332              |                           |
| Lowest minimizer count               | 120,083                    | 88,084                     | 85,356                     |                           |
| Highest minimizer count              | 2,173,728                  | 2,149,445                  | 2,149,330                  |                           |
| `peak_hom` coverage                  | 31                         | 30                         | 31                         |                           |
| `peak_het` coverage                  | -1                         | -1                         | -1                         |                           |
| Primary contig coverage range        | -                          | -                          | -                          | [25, infinity]            |
| Homozygous read coverage threshold   | -                          | -                          | -                          | 30                        |
| Purge duplication coverage threshold | -                          | -                          | -                          | 38                        |
| Total Overlaps                       | -                          | -                          | -                          | 319,716,290               |
| Strong Overlaps                      | -                          | -                          | -                          | 90,793,983                |
| Weak Overlaps                        | -                          | -                          | -                          | 228,922,307               |
| Exact Overlaps                       | -                          | -                          | -                          | 316,212,759               |
| Inexact Overlaps                     | -                          | -                          | -                          | 3,503,531                 |
| Overlaps without Large Indels        | -                          | -                          | -                          | 319,293,584               |
| Reverse Overlaps                     | -                          | -                          | -                          | 45,529,962                |
| Real Time (seconds)                  | -                          | -                          | -                          | 10,477.790                |
| CPU Time (seconds)                   | -                          | -                          | -                          | 479,529.220               |
| Peak Memory Usage (GB)               | -                          | -                          | -                          | 68.521                    |


Some key takeaways from the log file are:


- The total number of bases in the input file is **70,099,174,236**, corresponding to approximately **29.2x coverage** of the maize genome.
- The assembler made significant corrections in the first two rounds, correcting **103,540,747** and **2,197,978** bases, respectively, but only **542,087** in the third round. If the third round number is still too high, consider increasing the `-r` parameter (which sets the rounds of haplotype-aware error corrections, defaulting to 3).
- The counts of distinct minimizer k-mers illustrate how the complexity of the data evolves throughout the assembly process.
- The total number of overlaps, categorized by type (strong, weak, exact, and inexact), provides insights into the quality of the assembly.
- The `peak_hom` and `peak_het` values indicate the levels of heterozygosity, while the homozygous read coverage threshold reflects the value used for the `--hom-cov` parameter. This can serve as a starting point for fine-tuning this option in future runs.
- The purge duplication coverage threshold was automatically set to **38**. Depending on the observed heterozygosity level, you may want to adjust `--purge-max` value in subsequent assemblies.
- The peak memory usage of **68.521 GB** is a critical metric for assessing the computational resources required for the assembly process. This information can be used to optimize future runs based on the available resources.


## 4. Visualizing the assembly

To better understand how well the assembly is constructed, we can use the `noseq.gfa` files generated by `hifiasm` to visualize the assembly graph. We can use `bandage` for this purpose. These files are small and `bandage` can be run from your local machine. Get the required files and install `bandage` on your local machine.

!!! note
    this command should be run on your local machine. The source files should be adjusted accordingly.

```bash
rsync -avP negishi:/scratch/negishi/$USER/hifasm/maize_B73_hifi.asm.bp.hap[12].p_ctg.noseq.gfa ./
```

Now you can run `bandage` and open the `*noseq.gfa` files.


![Fig1](../../assets/images/lifesciences/hifiasm_hap1_bandage.png)

**Figure 1: Bandage visualization of the assembly graph (hap1). While most contigs are constructed from a single unitig, there are a few contigs that maybe joined from multiple unitigs. The largest contig appears to be made of multiple unitigs and terminal region may not be fully resolved.**

There are likely other contigs that may not be fully resolved but since we plan to use Optical Genome Mapping (OGM) data to scaffold the assembly, we can proceed with the current assembly. The OGM data will help resolve these regions and provide a more contiguous assembly.


![Fig2](../../assets/images/lifesciences/hifiasm_hap2_bandage.png)

**Figure 2: Bandage visualization of the assembly graph (hap2). Similar to hap1, most contigs are constructed from a single unitig, and largest contig may not be fully resolved.**

!!! warning
    If you are ending your analysis here, you may want to further break these regions into smaller contigs for better resolution.

## 5. Optimizing the assembly

After the first round of assembly, you will have the files `*.ec.bin`, `*.ovlp.source.bin`, and `*.ovlp.reverse.bin`. Save these files and try various options to see if you can improve the assembly. First, make a folder to move the `.gfa`, `.fasta`, and `.bed` files. These are the results from the first round of assembly. Second, adjust the parameters in the `hifiasm` command and run the assembler again. Third, move results to a new folder and compare the results of the first folder. You can re-run the assembly quickly and generate statistics for each of these folders and compare them to see if the changes improved the assembly.

The purge level option (`-l`) in `hifiasm` controls the level of purging of haplotigs. The default value is 3, which means it will purge all types of haplotigs in the most aggressive way. If you are running it against a diploid inbred line like B73, this might not be an ideal number. Here is how it alters the assembly at `-l 1` and `-l 2` and `-l 3`.

**Table 4: Summary statistics of the assembled contigs with different options**


=== "purge level 0"

    | Assembly                               | a_ctg | p_ctg  |
    |:---------------------------------------|-------:|--------:|
    | # contigs (>= 0 bp)                   |    837 |     710 |
    | # contigs (>= 10000 bp)               |    831 |     709 |
    | # contigs (>= 25000 bp)               |    680 |     663 |
    | # contigs (>= 50000 bp)               |     33 |     325 |
    | Total length (>= 0 bp) (mb)           |  28.14 |  2,235.42 |
    | Total length (>= 10000 bp) (mb)       |  28.09 |  2,235.41 |
    | Total length (>= 25000 bp) (mb)       |  25.02 |  2,234.42 |
    | Total length (>= 50000 bp) (mb)       |   2.37 |  2,222.08 |
    | # contigs                              |    837 |     710 |
    | Largest contig (mb)                   |   0.21 |   230.90 |
    | Total length (mb)                     |  28.14 |  2,235.42 |
    | N50 (mb)                               |   0.04 |  156.47 |
    | N90 (mb)                               |   0.02 |   20.84 |
    | auN (mb)                               |   0.04 |  140.18 |
    | L50                                    |    326 |       6 |
    | L90                                    |    693 |      18 |
    | # N's per 100 kbp                     |      0 |       0 |

=== "purge level 1"

    | Assembly                               | hap1.p_ctg | hap2.p_ctg |
    |:---------------------------------------|------------:|------------:|
    | # contigs (>= 0 bp)                   |         709 |         374 |
    | # contigs (>= 10000 bp)               |         708 |         374 |
    | # contigs (>= 25000 bp)               |         661 |         372 |
    | # contigs (>= 50000 bp)               |         319 |         301 |
    | Total length (>= 0 bp) (mb)           |     2,164.69 |    1,724.11 |
    | Total length (>= 10000 bp) (mb)       |     2,164.68 |    1,724.11 |
    | Total length (>= 25000 bp) (mb)       |     2,163.68 |    1,724.06 |
    | Total length (>= 50000 bp) (mb)       |     2,151.23 |    1,721.39 |
    | # contigs                              |         709 |         374 |
    | Largest contig (mb)                   |     230.90 |     228.81 |
    | Total length (mb)                     |     2,164.69 |    1,724.11 |
    | N50 (mb)                               |     152.60 |     39.08 |
    | N90 (mb)                               |       9.46 |      2.67 |
    | auN (mb)                               |     119.20 |     98.99 |
    | L50                                    |          6 |          6 |
    | L90                                    |         18 |         94 |
    | # N's per 100 kbp                     |          0 |          0 |

=== "purge level 2"

    | Assembly                               | hap1.p_ctg | hap2.p_ctg |
    |:---------------------------------------|------------:|------------:|
    | # contigs (>= 0 bp)                   |         702 |         291 |
    | # contigs (>= 10000 bp)               |         701 |         291 |
    | # contigs (>= 25000 bp)               |         654 |         287 |
    | # contigs (>= 50000 bp)               |         311 |         213 |
    | Total length (>= 0 bp) (mb)           |     2,164.74 |    2,164.57 |
    | Total length (>= 10000 bp) (mb)       |     2,164.73 |    2,164.57 |
    | Total length (>= 25000 bp) (mb)       |     2,163.73 |    2,164.49 |
    | Total length (>= 50000 bp) (mb)       |     2,151.27 |    2,161.38 |
    | # contigs                              |         702 |         291 |
    | Largest contig (mb)                   |     230.90 |     229.69 |
    | Total length (mb)                     |     2,164.74 |    2,164.57 |
    | N50 (mb)                               |     152.60 |     131.66 |
    | N90 (mb)                               |       9.46 |      17.33 |
    | auN (mb)                               |     119.19 |    128.48 |
    | L50                                    |          6 |          6 |
    | L90                                    |         30 |         23 |
    | # N's per 100 kbp                     |          0 |          0 |

=== "purge level 3 (default)"

    | Assembly                               | hap1.p_ctg | hap2.p_ctg |
    |:---------------------------------------|------------:|------------:|
    | # contigs (>= 0 bp)                   |         695 |         340 |
    | # contigs (>= 10000 bp)               |         695 |         340 |
    | # contigs (>= 25000 bp)               |         648 |         336 |
    | # contigs (>= 50000 bp)               |         311 |         245 |
    | Total length (>= 0 bp) (mb)           |     2,115.82 |    2,146.06 |
    | Total length (>= 10000 bp) (mb)       |     2,115.82 |    2,146.06 |
    | Total length (>= 25000 bp) (mb)       |     2,114.81 |    2,145.97 |
    | Total length (>= 50000 bp) (mb)       |     2,102.60 |    2,142.22 |
    | # contigs                              |         695 |         340 |
    | Largest contig (mb)                   |     230.90 |     229.69 |
    | Total length (mb)                     |     2,115.82 |    2,146.06 |
    | N50 (mb)                               |     92.33 |    156.75 |
    | N90 (mb)                               |      8.07 |      10.92 |
    | auN (mb)                               |     110.84 |    131.18 |
    | L50                                    |          7 |          6 |
    | L90                                    |         39 |         23 |
    | # N's per 100 kbp                     |          0 |          0 |


!!! note
    Option `-l 0` seems like a good option for maize B73 genome.  The primary assembly gave us a close to estimated size (2,235.42 Mb, estimated size ~2,300 Mb) genome, with N50 of 156.47 Mb. Though the number of contigs are higher, the assembly seems to be more contiguous.

## 6. Conclusion

In this tutorial, we have assembled the maize B73 genome using PacBio HiFi reads. The assembled contigs are of high quality and can be further scaffolded using Optical Genome Mapping data or Hi-C data. These contigs are purely based on the HiFi reads there could be unresolved or incorrect contigs. Using homology approaches, we can further validate the assembly and fix those regions.


## FAQs [click to expand]

??? note "1. What other options are available in `hifiasm` that affect the assembly?"

    There are several options available in `hifiasm` that can affect the assembly. The important assembly options are listed in the manual page [here](https://hifiasm.readthedocs.io/en/latest/parameter-reference.html#assembly-options).

??? note "2. Why did I get two haplotypes in the output?"

    The two haplotypes generated by `hifiasm` are controlled by level of purge duplication option `-l`. The default value is 3, which means it will purge all types of haplotigs in the most aggressive way. You can disable it using `-l 0` option or you can only purge heterozygous overlaps using `-l 1`.

??? note "3. I have too many small contigs/fragmented assembly, how can I reduce them?"

    You can use the `-n` option to remove unitigs with coverage less than the specified value. The default value is 3 and increasing it will remove unitigs with poor coverage and reduce the number of contigs.
    The manual also suggests raising `-D` or `-N` to improve the resolution of repetitive regions, but it may take longer time to run.

??? note "4. My assembly as shown in Bandage has a lot of bubbles/loops, how can I resolve them?"

    The bubbles/loops in the assembly graph can be resolved during the scaffolding step, using either Hi-C data or Optical Genome Mapping data. But you can also try `-u` to disable post-join step for contigs. This may result in more contigs and poor N50 but may help resolve the bubbles/loops. The manual also says to set smaller value for `--purge-max`, `-s` and `-O` to reduce misassemblies.

??? note "5. I've more questions! Where can I find more information?"

    See the [hifiasm FAQs](https://hifiasm.readthedocs.io/en/latest/faq.html/) for more information. If you have specific questions, you can ask the developers directly (via GitHub issues) or ask us for help!
