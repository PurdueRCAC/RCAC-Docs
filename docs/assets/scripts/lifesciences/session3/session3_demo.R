# =============================================================================
# Genomics Exchange Session 3: R Skills for Biological Data
# Instructor: Arun Seetharam, RCAC
# Date: February 24, 2026
#
# Demo: Working with RNA-seq results from a maize drought stress experiment
# Environment: RStudio via Open OnDemand on RCAC clusters
# =============================================================================

# --- PART 0: Setup -----------------------------------------------------------
# If you don't have tidyverse installed, run this once:
# install.packages("tidyverse")

library(tidyverse)

# Set your working directory to where the demo data lives
# On RCAC, this might be:
# setwd("/scratch/negishi/<username>/genomics_exchange/session3")

# --- PART 1: Reading data into R ---------------------------------------------
# The most common task: getting your data from a file into R

# read_tsv() reads tab-separated files (most bioinformatics output)
deseq <- read_tsv("deseq2_results.tsv")

# First things first: what did we just load?
deseq              # prints a tibble (tidyverse's improved data.frame)
dim(deseq)         # rows x columns
colnames(deseq)    # column names
str(deseq)         # structure: types of each column
summary(deseq)     # quick stats for numeric columns

# Read the other files we'll need
samples <- read_tsv("sample_manifest.tsv")
counts  <- read_tsv("counts_matrix.tsv")
genes   <- read_tsv("gene_annotations.tsv")

# Quick sanity check: do our gene IDs match across files?
# This is something you should ALWAYS do when combining data
all(deseq$gene_id %in% genes$gene_id)   # TRUE = all match
all(deseq$gene_id %in% counts$gene_id)  # TRUE = all match


# --- PART 2: Filtering with dplyr --------------------------------------------
# Goal: Find significantly differentially expressed genes

# filter() keeps rows that match a condition
sig_genes <- deseq %>%
  filter(padj < 0.05)

nrow(sig_genes)  # how many significant genes?

# Multiple conditions: significant AND strong effect
sig_strong <- deseq %>%
  filter(padj < 0.05, abs(log2FoldChange) > 1)

nrow(sig_strong)

# Common mistake: using & vs , (both work, but , is cleaner in dplyr)
# Also common: filtering on pvalue instead of padj -- always use padj!


# --- PART 3: Adding new columns with mutate() --------------------------------
# Goal: Classify genes by their expression change

deseq <- deseq %>%
  mutate(
    direction = case_when(
      padj < 0.05 & log2FoldChange > 1  ~ "up",
      padj < 0.05 & log2FoldChange < -1 ~ "down",
      TRUE                               ~ "ns"
    )
  )

# Check the result
table(deseq$direction)

# Add a column for -log10(padj) -- useful for volcano plots later (Session 4!)
deseq <- deseq %>%
  mutate(neg_log10_padj = -log10(padj))


# --- PART 4: Summarizing with group_by + summarize ---------------------------
# Goal: How many genes are up vs down? What's the average fold change?

deseq %>%
  group_by(direction) %>%
  summarize(
    n_genes       = n(),
    mean_log2FC   = mean(log2FoldChange),
    median_log2FC = median(log2FoldChange),
    mean_baseMean = mean(baseMean)
  )

# Key insight: genes going DOWN tend to be more highly expressed (photosynthesis,
# housekeeping genes getting suppressed under drought)


# --- PART 5: Joining tables ---------------------------------------------------
# Goal: Add gene names and descriptions to our DESeq2 results
# This is one of the most common tasks in bioinformatics data wrangling

annotated <- deseq %>%
  left_join(genes, by = "gene_id")

# left_join keeps ALL rows from the left table (deseq) and adds matching
# columns from the right table (genes). Unmatched rows get NA.

# Check: did everything join correctly?
annotated %>%
  filter(is.na(gene_name))  # should be 0 rows if all genes have annotations

# Now we can see gene names with our stats
annotated %>%
  filter(direction == "up") %>%
  select(gene_id, gene_name, log2FoldChange, padj, description) %>%
  arrange(desc(log2FoldChange))

# The drought-upregulated genes make biological sense:
# dreb2a, lea3, rd29a, dhn1 -- classic drought response genes


# --- PART 6: Reshaping data (wide <-> long) -----------------------------------
# Goal: Convert our count matrix from wide to long format

# Wide format: one column per sample (how tools output it)
counts

# Long format: one row per gene-sample combination (what ggplot and many
# analyses need)
counts_long <- counts %>%
  pivot_longer(
    cols      = starts_with("SRR"),  # columns to reshape
    names_to  = "sample_id",         # new column for old column names
    values_to = "count"              # new column for the values
  )

head(counts_long, 12)

# Now join sample metadata to the long counts
counts_annotated <- counts_long %>%
  left_join(samples, by = "sample_id")

# Calculate mean expression per gene per condition
mean_expression <- counts_annotated %>%
  group_by(gene_id, condition) %>%
  summarize(
    mean_count = mean(count),
    sd_count   = sd(count),
    .groups    = "drop"
  )

head(mean_expression)


# --- PART 7: Putting it all together ------------------------------------------
# Goal: Create a clean, annotated results table ready for export

final_results <- deseq %>%
  left_join(genes, by = "gene_id") %>%
  filter(padj < 0.05) %>%
  select(
    gene_id, gene_name, chromosome, description,
    baseMean, log2FoldChange, padj, direction
  ) %>%
  arrange(padj)

# Export as TSV (tab-separated, clean for downstream tools)
write_tsv(final_results, "significant_genes_annotated.tsv")

# Quick summary to report
cat("Significant genes (padj < 0.05):", nrow(final_results), "\n")
cat("  Upregulated:", sum(final_results$direction == "up"), "\n")
cat("  Downregulated:", sum(final_results$direction == "down"), "\n")


# --- PART 8: A quick visualization --------------------------------------------
# Goal: Make a simple barplot of up/down/ns gene counts
# This is a preview of Session 4 -- just enough to see your results visually

# Summarize counts per direction
direction_counts <- deseq %>%
  count(direction) %>%
  mutate(direction = factor(direction, levels = c("up", "down", "ns")))

# A simple ggplot barplot
ggplot(direction_counts, aes(x = direction, y = n, fill = direction)) +
  geom_col() +
  scale_fill_manual(values = c("up" = "#D73027", "down" = "#4575B4", "ns" = "grey70")) +
  labs(
    title = "Differentially expressed genes (drought vs. control)",
    x     = "Direction",
    y     = "Number of genes"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save the plot
ggsave("deg_barplot.png", width = 6, height = 4, dpi = 150)

# That's the basic pattern: data frame -> ggplot() -> aes() -> geom_*()
# Session 4 will go deep on volcano plots, heatmaps, and publication styling.


# --- PART 9: Bonus -- useful patterns for bioinformatics ----------------------

# Pattern 1: Reading BLAST tabular output (outfmt 6)
# blast_cols <- c("qseqid", "sseqid", "pident", "length", "mismatch",
#                 "gapopen", "qstart", "qend", "sstart", "send",
#                 "evalue", "bitscore")
# blast <- read_tsv("blast_results.txt", col_names = blast_cols)

# Pattern 2: Batch-reading multiple files
# files <- list.files(pattern = "*.tsv")
# all_data <- map_dfr(files, read_tsv, .id = "source_file")

# Pattern 3: Quick value counts (like Python's value_counts)
# deseq %>% count(direction, sort = TRUE)

# Pattern 4: Filtering with string matching
# genes %>% filter(str_detect(description, "transcription factor"))


# =============================================================================
# Session 3 complete!
# Next session (March 10): Publication quality plots for genomics
# We'll use ggplot2 to make volcano plots, heatmaps, and more from this data.
# =============================================================================
