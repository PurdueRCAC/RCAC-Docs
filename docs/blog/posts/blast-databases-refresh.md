---
date:
  created: 2026-11-10

categories:
  - Life Sciences
  - Announcements

title: "Refreshed Shared BLAST Databases, Updated Monthly"

slug: blast-databases-refresh

tags:
  - Life Sciences
  - BLAST
  - Bioinformatics
  - Datasets

authors:
  - aseethar
---

# Refreshed Shared BLAST Databases, Updated Monthly

The shared BLAST databases at `/depot/datasets/bioinformatics/blast/latest` have been refreshed and
are now updated monthly. They are available on all RCAC clusters that mount `/depot`. `latest` is a
symlink to the current snapshot, `week-45-2026`, published November 9, 2026.

<!-- more -->

## Quick start

```bash
module load biocontainers blast/2.13.0
export BLASTDB=/depot/datasets/bioinformatics/blast/latest
column -t $BLASTDB/MANIFEST.tsv    # databases and their versions
```

With `BLASTDB` set, pass a database by name, for example `-db core_nt`. `BLASTDB` also lets BLAST
find `taxdb`, so the `sscinames` and `scomnames` fields work in `-outfmt`. The databases are in BLAST
v5 format and work with the `blast/2.13.0` biocontainer module. For more on loading biocontainer
modules, see [Running Bioinformatics on RCAC](../../lifesciences/guides/running-bioinformatics.md).

## Available databases

| Type | Databases |
|------|-----------|
| Nucleotide | `core_nt`, `nt`, `env_nt`, `refseq_rna`, `human_genome` (GCF_000001405.39), `mouse_genome` (GCF_000001635.27), `mito`, `Betacoronavirus`, `16S_ribosomal_RNA`, `18S_fungal_sequences`, `28S_fungal_sequences`, `ITS_RefSeq_Fungi`, `ITS_eukaryote_sequences`, `LSU_eukaryote_rRNA`, `LSU_prokaryote_rRNA`, `SSU_eukaryote_rRNA`, `UniVec`, `UniVec_Core` |
| Protein | `nr`, `env_nr`, `refseq_protein`, `swissprot` (NCBI), `pdbaa`, `landmark`, `uniprot_sprot`, `uniref90`, `uniref50` |
| Taxonomy | `taxdb` |

- `core_nt` is the recommended general nucleotide database: `nt` without most eukaryotic chromosome
  sequences. It holds 132,327,666 sequences (NCBI build October 24, 2026).
- `uniprot_sprot`, `uniref90`, and `uniref50` are from UniProt release 2026_04.

!!! tip "Pick a database that matches your program"
    `nr` is a protein database, for `blastp` and `blastx`. For `blastn`, use `core_nt` or `nt`.

## What's new since the 2024 copy

- `core_nt`, `refseq_rna`, `refseq_protein`, `swissprot`, and `pdbaa`
- `taxdb`, so taxonomy names appear in tabular output
- UniProt sets: `uniprot_sprot`, `uniref90`, and `uniref50`
- `UniVec` and `UniVec_Core`
- Monthly updates with version manifests

## Example: taxonomic screening of contigs

This job screens assembled contigs, or any unknown sequences, against `core_nt` and keeps the top hit
for each query.

!!! important
    Run BLAST searches as Slurm jobs on compute nodes, not on login nodes. For job script basics, see
    [HPC Orientation for Biologists](../../lifesciences/guides/hpc-orientation.md).

```bash title="blast_screen.sh"
#!/bin/bash
#SBATCH --job-name=blast_screen
#SBATCH --account=<account-name>
#SBATCH --partition=<partition-name>
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32          # illustrative; scale cores to your query size
#SBATCH --time=12:00:00             # illustrative; scale to your query size
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

module --force purge
module load biocontainers blast/2.13.0

export BLASTDB=/depot/datasets/bioinformatics/blast/latest
echo "BLAST snapshot: $(readlink ${BLASTDB})"

blastn -task megablast \
    -query contigs.fasta \
    -db core_nt \
    -outfmt "6 qseqid sacc pident length evalue bitscore staxids sscinames" \
    -max_target_seqs 5 \
    -evalue 1e-10 \
    -num_threads ${SLURM_CPUS_PER_TASK} \
    -out contigs_vs_core_nt.tsv

# Keep the top hit for each query
awk '!seen[$1]++' contigs_vs_core_nt.tsv > contigs_top_hit.tsv
```

Submit it with `sbatch blast_screen.sh`. To annotate predicted proteins as well, add a `blastp`
search against `uniprot_sprot`:

```bash
blastp -query proteins.faa -db uniprot_sprot \
    -outfmt "6 qseqid sacc pident length evalue bitscore stitle" \
    -max_target_seqs 5 -evalue 1e-5 -num_threads ${SLURM_CPUS_PER_TASK} \
    -out proteins_vs_sprot.tsv
```

## Using the ncbi/blast container image

!!! warning "Set `APPTAINERENV_BLASTDB` inside the `ncbi/blast` image"
    The `ncbi/blast` container image sets its own `BLASTDB`, which overrides the one you export.
    When you run that image, set `APPTAINERENV_BLASTDB` instead:

    ```bash
    export APPTAINERENV_BLASTDB=/depot/datasets/bioinformatics/blast/latest
    ```

## Updates and reproducibility

- The databases are refreshed monthly, on the first Saturday.
- Each refresh creates a dated snapshot named `week-WW-YYYY`. `latest` is switched to the new
  snapshot only after every database passes `blastdbcheck`.
- The current and previous snapshots are kept; older ones are removed. To keep a snapshot longer,
  request a hold through a ticket.
- Each snapshot has a `MANIFEST.tsv` (database, source, upstream version, and sequence and letter
  counts) and a `SNAPSHOT_INFO` file.

For reproducibility, record the snapshot name and the versions of the databases you used in your
methods:

```bash
readlink /depot/datasets/bioinformatics/blast/latest    # snapshot name, e.g. week-45-2026
column -t /depot/datasets/bioinformatics/blast/latest/MANIFEST.tsv
```

See [Reproducible Genomics](../../lifesciences/guides/reproducibility.md) for more on recording
software and data versions. Other shared datasets are listed under
[RCAC Datasets](../../datasets/index.md).

## Getting help

For questions about the databases, or to request a database, submit a ticket through the Purdue
Service Portal.

[Submit a ticket to RCAC](https://service.purdue.edu/TDClient/32/Purdue/Requests/TicketRequests/NewForm?ID=WT~8y8Nl8Ks_&RequestorType=ServiceOffering){ .md-button }
