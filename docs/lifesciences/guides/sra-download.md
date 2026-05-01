---
title: Downloading SRA Data
tags:
  - Life Sciences
  - Guides
---

The NCBI Sequence Read Archive (SRA) is the largest publicly available repository of high-throughput sequencing data.
This guide walks you through downloading FASTQ files from SRA on RCAC clusters using the SRA Toolkit.

## Quick Start

If you're familiar with HPC (Negishi/Gautschi/Bell) and just need the commands:

```bash
module load sra-tools
prefetch SRR12345678
fasterq-dump SRR12345678 --split-files -e 8 -p
```

For detailed instructions and best practices, continue reading below.

## Understanding SRA Downloads

Before downloading, it's important to understand the two-step workflow:

1. **`prefetch`**  Downloads the compressed `.sra` file from NCBI to your local cache
2. **`fasterq-dump`** - Converts the `.sra` file to FASTQ format

!!! tip
    Always use `prefetch` before `fasterq-dump`. Direct downloads with `fasterq-dump` alone are slower and prone to network failures.

## Step-by-Step Guide

1.  **Load the SRA Toolkit module**

    ```bash
    module load biocontainers
    module load sra-tools
    ```

    Verify the installation:

    ```bash
    prefetch --version
    fasterq-dump --version
    ```

2.  **Configure your cache directory (first time only)**

    By default, SRA Toolkit caches files in your home directory, which has limited space.
    Configure it to use scratch space instead:

    ```bash
    mkdir -p $RCAC_SCRATCH/ncbi
    vdb-config --prefetch-to-user-repo
    vdb-config -s /repository/user/main/public/root=$RCAC_SCRATCH/ncbi
    ```

3.  **Find your SRA accession numbers**

    SRA accessions typically start with:

    - **SRR** - Individual run (most common)
    - **SRP** - Study/Project
    - **SRX** - Experiment

    You can find accessions on [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra) or [ENA](https://www.ebi.ac.uk/ena).

4.  **Download the SRA file using prefetch**

    For a single accession:

    ```bash
    prefetch SRR12345678
    ```

    For multiple accessions from a file:

    ```bash
    prefetch --option-file accession_list.txt
    ```

    Where `accession_list.txt` contains one accession per line.

5.  **Convert to FASTQ using fasterq-dump**

    For paired-end data:

    ```bash
    fasterq-dump SRR12345678 --split-files -e 8 -p
    ```

    For single-end data:

    ```bash
    fasterq-dump SRR12345678 -e 8 -p
    ```

    Key options:

    - `--split-files` - Separates paired reads into `_1.fastq` and `_2.fastq`
    - `-e 8` - Use 8 threads (adjust based on your allocation)
    - `-p` - Show progress

6.  **Compress the FASTQ files**

    FASTQ files are large. Compress them to save space:

    ```bash
    pigz -p 8 *.fastq
    ```

## SLURM Batch Script

For large downloads, submit a batch job rather than running interactively.

=== "Single Accession"

    ```bash title="download_sra.sh"
    #!/bin/bash
    #SBATCH --job-name=sra_download
    #SBATCH --account=your_account
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=04:00:00
    #SBATCH --output=sra_%j.out
    #SBATCH --error=sra_%j.err

    # Load required modules
    module purge
    module load biocontainers
    module load sra-tools

    # Set variables
    SRR_ID="SRR12345678"
    OUTDIR="$RCAC_SCRATCH/fastq_files"
    THREADS=8

    # Create output directory
    mkdir -p ${OUTDIR}
    cd ${OUTDIR}

    # Step 1: Prefetch the SRA file
    echo "Starting prefetch for ${SRR_ID}..."
    prefetch ${SRR_ID}

    # Step 2: Convert to FASTQ
    echo "Converting to FASTQ..."
    fasterq-dump ${SRR_ID} --split-files -e ${THREADS} -p

    # Step 3: Compress FASTQ files
    echo "Compressing FASTQ files..."
    pigz -p ${THREADS} ${SRR_ID}*.fastq

    # Step 4: Clean up cache
    echo "Cleaning up..."
    rm -rf $RCAC_SCRATCH/ncbi/sra/${SRR_ID}.sra

    echo "Done! Files saved to ${OUTDIR}"
    ls -lh ${SRR_ID}*.fastq.gz
    ```

=== "Multiple Accessions"

    ```bash title="download_sra_batch.sh"
    #!/bin/bash
    #SBATCH --job-name=sra_batch
    #SBATCH --account=your_account
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=24:00:00
    #SBATCH --output=sra_batch_%j.out
    #SBATCH --error=sra_batch_%j.err

    # Load required modules
    module purge
    module load biocontainers
    module load sra-tools

    # Set variables
    ACCESSION_FILE="accession_list.txt"
    OUTDIR="$RCAC_SCRATCH/fastq_files"
    THREADS=8

    # Create output directory
    mkdir -p ${OUTDIR}
    cd ${OUTDIR}

    # Process each accession
    while read -r SRR_ID; do
        # Skip empty lines and comments
        [[ -z "$SRR_ID" || "$SRR_ID" =~ ^# ]] && continue

        echo "=========================================="
        echo "Processing: ${SRR_ID}"
        echo "=========================================="

        # Prefetch
        prefetch ${SRR_ID}

        # Convert to FASTQ
        fasterq-dump ${SRR_ID} --split-files -e ${THREADS} -p

        # Compress
        pigz -p ${THREADS} ${SRR_ID}*.fastq

        # Clean up cache
        rm -rf $RCAC_SCRATCH/ncbi/sra/${SRR_ID}.sra

        echo "Completed: ${SRR_ID}"

    done < ${ACCESSION_FILE}

    echo "All downloads complete!"
    ls -lh *.fastq.gz
    ```

=== "Array Job"

    ```bash title="download_sra_array.sh"
    #!/bin/bash
    #SBATCH --job-name=sra_array
    #SBATCH --account=your_account
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=04:00:00
    #SBATCH --array=1-10%5
    #SBATCH --output=sra_%A_%a.out
    #SBATCH --error=sra_%A_%a.err

    # Load required modules
    module purge
    module load biocontainers
    module load sra-tools

    # Set variables
    ACCESSION_FILE="accession_list.txt"
    OUTDIR="$RCAC_SCRATCH/fastq_files"
    THREADS=8

    # Get the SRR ID for this array task
    SRR_ID=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${ACCESSION_FILE})

    # Create output directory
    mkdir -p ${OUTDIR}
    cd ${OUTDIR}

    echo "Array task ${SLURM_ARRAY_TASK_ID}: Processing ${SRR_ID}"

    # Prefetch
    prefetch ${SRR_ID}

    # Convert to FASTQ
    fasterq-dump ${SRR_ID} --split-files -e ${THREADS} -p

    # Compress
    pigz -p ${THREADS} ${SRR_ID}*.fastq

    # Clean up cache
    rm -rf $RCAC_SCRATCH/ncbi/sra/${SRR_ID}.sra

    echo "Completed: ${SRR_ID}"
    ls -lh ${SRR_ID}*.fastq.gz
    ```

Submit the job with:

```bash
sbatch download_sra.sh
```

!!! note
    Replace `your_account` with your actual SLURM account. Find available accounts with `slist`.

## Verification Steps

After downloading, verify your files are complete and uncorrupted:

1.  **Check file sizes**

    FASTQ files should be reasonably sized (typically 1-50 GB for most runs):

    ```bash
    ls -lh *.fastq.gz
    ```

2.  **Count reads**

    Count the number of reads in each file:

    ```bash
    zcat SRR12345678_1.fastq.gz | echo $((`wc -l`/4))
    ```

    For paired-end data, both files should have the same read count.

3.  **Check file integrity**

    Verify gzip compression is intact:

    ```bash
    gzip -t SRR12345678_1.fastq.gz && echo "File OK" || echo "File corrupted"
    ```

4.  **Inspect first few reads**

    Ensure the FASTQ format looks correct:

    ```bash
    zcat SRR12345678_1.fastq.gz | head -12
    ```

    You should see blocks of 4 lines: header (@), sequence, separator (+), and quality scores.

5.  **Run FastQC (optional)**

    For comprehensive quality assessment:

    ```bash
    module load fastqc
    fastqc SRR12345678_1.fastq.gz SRR12345678_2.fastq.gz
    ```

## Expected Output

After successful download and conversion, you should have:

```text
fastq_files/
├── SRR12345678_1.fastq.gz (forward reads)
└── SRR12345678_2.fastq.gz (reverse reads)
```

Or for single-end data:

```text
fastq_files/
└── SRR12345678.fastq.gz
```

## Troubleshooting

??? note "Download fails with network timeout"
    Try these solutions:

    - Use `prefetch` with resume capability: it automatically resumes interrupted downloads
    - Download during off-peak hours
    - Check your network connection with `ping www.ncbi.nlm.nih.gov`

??? note "Disk quota exceeded error"
    - Ensure your cache is set to scratch: `vdb-config -s /repository/user/main/public/root=$RCAC_SCRATCH/ncbi`
    - Clean up old cached files: `rm -rf $RCAC_SCRATCH/ncbi/sra/*.sra`
    - Check your quota with `myquota`

??? note "fasterq-dump runs out of memory"
    - Request more memory in your SLURM script (`--mem=32G` or higher)
    - Reduce the number of threads (`-e 4` instead of `-e 8`)
    - Use the `--temp` flag to specify a temp directory on scratch

??? note "Files are empty or truncated"
    - Re-run `prefetch` to re-download the SRA file
    - Verify the accession number is correct
    - Check if the SRA record is still available on NCBI

## FAQs

??? note "How long do downloads typically take?"
    Download times vary based on file size and network conditions:

    - Small datasets (< 5 GB): 15-30 minutes
    - Medium datasets (5-20 GB): 1-3 hours
    - Large datasets (> 20 GB): 3+ hours

    The `prefetch` step is typically the bottleneck as it depends on network speed.

??? note "Can I download directly without prefetch?"
    Technically yes, but it's not recommended:

    ```bash
    # Not recommended - slower and less reliable
    fasterq-dump SRR12345678 --split-files -e 8
    ```

    Using `prefetch` first is faster, more reliable, and allows resuming interrupted downloads.

??? note "How do I download data from ENA instead?"
    ENA (European Nucleotide Archive) often has faster downloads. Use `wget` or `curl`:

    ```bash
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR123/008/SRR12345678/SRR12345678_1.fastq.gz
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR123/008/SRR12345678/SRR12345678_2.fastq.gz
    ```

    The exact URL structure varies. Find the correct URLs on the [ENA Browser](https://www.ebi.ac.uk/ena/browser/).

??? note "What's the difference between split-files and split-3?"
    - `--split-files`: Creates `_1.fastq` and `_2.fastq` for paired data
    - `--split-3`: Creates `_1.fastq`, `_2.fastq`, and an additional file for orphaned reads

    For most analyses, `--split-files` is sufficient.

## Additional Resources

- [NCBI SRA Toolkit Documentation](https://github.com/ncbi/sra-tools/wiki)
- [SRA Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/) - Find and download accession lists
- [ENA Browser](https://www.ebi.ac.uk/ena/browser/) - Alternative download source
