---
title: R Skills for Biological Data
tags:
  - Life Sciences
  - R
  - Genomics Exchange
  - Guides
---

# R Skills for Biological Data

This guide accompanies **Genomics Exchange Session 3** (February 24, 2026). It covers the essential R skills you need to work with common bioinformatics output files: reading data, filtering, reshaping, joining tables, and exporting clean results.

We will work through a simulated maize (*Zea mays*) drought stress RNA-seq experiment to learn each concept with realistic biological data. By the end, you will be able to load DESeq2 results, annotate them with gene metadata, filter for significant genes, and export publication-ready tables.

<div class="grid cards" markdown>

-   :material-check-circle: **Prerequisites**

    ---

    - Basic R familiarity (you know what a `data.frame` is)
    - Access to RStudio on Negishi via [Open OnDemand](https://ondemand.rcac.purdue.edu)
    - An active RCAC cluster account with a compute allocation

-   :material-information: **What you will learn**

    ---

    - Read TSV/CSV files with `readr`
    - Filter, mutate, and summarize with `dplyr`
    - Join multiple tables by shared keys
    - Reshape data between wide and long formats with `tidyr`
    - Export clean annotated results

</div>

## Setup

1. **Launch RStudio on RCAC**

    Go to [gateway.negishi.rcac.purdue.edu](https://gateway.negishi.rcac.purdue.edu), select **Interactive Apps > RStudio Server**, choose your allocation, and request 1 core, 4 GB memory, and 2 hours. Once the session starts, click **Connect to RStudio**.

    !!! warning
        Always run RStudio through Open OnDemand on a compute node. Do not run R sessions directly on login nodes -- they are shared resources and intensive computation will be terminated.

2. **Download the demo data**

    In the RStudio **Terminal** tab (not the R console), run:

    ```bash
    mkdir -p $RCAC_SCRATCH/genomics_exchange/session3
    cd $RCAC_SCRATCH/genomics_exchange/session3
    wget https://rcac-bioinformatics.github.io/assets/session3/deseq2_results.tsv
    wget https://rcac-bioinformatics.github.io/assets/session3/sample_manifest.tsv
    wget https://rcac-bioinformatics.github.io/assets/session3/counts_matrix.tsv
    wget https://rcac-bioinformatics.github.io/assets/session3/gene_annotations.tsv
    wget https://rcac-bioinformatics.github.io/assets/session3/session3_demo.R
    ```

    !!! tip
        On Gautschi, replace `$RCAC_SCRATCH` with `/scratch/gautschi/${USER}` if the environment variable is not set.

3. **Set your working directory in R**

    Switch to the R console and run:

    ```r
    setwd(paste0("/scratch/negishi/", Sys.getenv("USER"), "/genomics_exchange/session3"))
    ```

    Or if you prefer to type the path directly, replace `boilerid` with your Purdue username:

    ```r
    setwd("/scratch/negishi/boilerid/genomics_exchange/session3")
    ```

4. **Install and load tidyverse**

    If you have not installed tidyverse before, run this once (it takes a few minutes):

    ```r
    install.packages("tidyverse")
    ```

    Then load it for the current session:

    ```r
    library(tidyverse)
    ```

    !!! note
        `tidyverse` is a collection of R packages (`dplyr`, `readr`, `tidyr`, `ggplot2`, `stringr`, `purrr`, `tibble`, `forcats`) that share a consistent design philosophy. Loading `tidyverse` loads all of them at once.

## The demo dataset

We are working with a simulated maize (*Zea mays*) drought stress RNA-seq experiment. The experiment compares leaf tissue under drought stress vs. well-watered control conditions, with 3 biological replicates per condition.

| File | Contents | Rows |
|------|----------|------|
| `deseq2_results.tsv` | DESeq2 differential expression results | 30 genes |
| `sample_manifest.tsv` | Sample metadata (condition, replicate) | 6 samples |
| `counts_matrix.tsv` | Raw count matrix (genes x samples) | 30 genes x 6 samples |
| `gene_annotations.tsv` | Gene names, coordinates, functional descriptions | 30 genes |

These four files represent the typical outputs you will encounter after running an RNA-seq differential expression pipeline. In real analyses, you will often need to combine information across files like these to produce annotated, filtered results.

## Part 1: Reading data into R

The most common bioinformatics file format is tab-separated values (TSV). Use `read_tsv()` from the `readr` package (loaded with tidyverse):

```r
deseq <- read_tsv("deseq2_results.tsv")
```

### Inspect what you loaded

Always check your data immediately after reading. This catches file-format surprises (wrong delimiter, missing headers, garbled encoding) before they propagate into your analysis:

```r
deseq              # print the tibble (shows first 10 rows and column types)
dim(deseq)         # 30 rows, 7 columns
colnames(deseq)    # column names
str(deseq)         # data types for each column
summary(deseq)     # numeric summaries (min, max, median, mean, NAs)
```

!!! warning
    `read_tsv()` is not the same as base R's `read.table()`. The tidyverse version is faster, guesses column types better, and returns a **tibble** instead of a plain `data.frame`. Prefer `read_tsv()` for TSV files and `read_csv()` for CSV files.

### Common file-reading functions

| Function | Delimiter | Use for |
|----------|-----------|---------|
| `read_tsv()` | Tab | Most bioinformatics outputs (DESeq2, BLAST, BED, etc.) |
| `read_csv()` | Comma | Spreadsheet exports, metadata tables |
| `read_delim()` | Any | Custom delimiters (specify with `delim = `) |
| `read_fwf()` | Fixed-width | Legacy formats, some alignment outputs |

### Load all four files

```r
samples <- read_tsv("sample_manifest.tsv")
counts  <- read_tsv("counts_matrix.tsv")
genes   <- read_tsv("gene_annotations.tsv")
```

### Sanity check: do gene IDs match?

Before combining data from different files, always verify that identifiers are consistent:

```r
all(deseq$gene_id %in% genes$gene_id)    # should be TRUE
all(deseq$gene_id %in% counts$gene_id)   # should be TRUE
```

If these return `FALSE`, you have mismatched IDs and need to investigate before proceeding. Common causes include ID version suffixes (e.g., `ENSG00000123456.5` vs. `ENSG00000123456`) or different naming conventions between tools.

## Part 2: Filtering rows

`filter()` keeps rows matching your conditions. This is how you extract significant genes from DESeq2 output:

```r
# Significant genes (adjusted p-value < 0.05)
sig_genes <- deseq %>%
  filter(padj < 0.05)

nrow(sig_genes)
```

### Multiple conditions

You can combine conditions with commas (which act as AND) or use `|` for OR:

```r
# Significant AND strong effect (|log2FC| > 1)
sig_strong <- deseq %>%
  filter(padj < 0.05, abs(log2FoldChange) > 1)

nrow(sig_strong)
```

```r
# Genes that are either highly significant OR have very strong fold change
interesting <- deseq %>%
  filter(padj < 0.001 | abs(log2FoldChange) > 3)
```

!!! danger
    Always filter on `padj` (adjusted p-value), **not** `pvalue`. Raw p-values are not corrected for multiple testing and will give you false positives. This is one of the most common mistakes in differential expression analysis.

### Selecting columns

Use `select()` to keep only the columns you need. This makes your tibbles easier to read and reduces clutter:

```r
deseq %>%
  filter(padj < 0.05) %>%
  select(gene_id, log2FoldChange, padj)
```

You can also drop columns with `-`:

```r
deseq %>% select(-stat, -lfcSE)
```

### Sorting rows

Use `arrange()` to sort. Use `desc()` for descending order:

```r
# Most significant genes first
deseq %>%
  filter(padj < 0.05) %>%
  arrange(padj)

# Largest fold changes first
deseq %>%
  arrange(desc(abs(log2FoldChange)))
```

## Part 3: Adding columns with mutate

`mutate()` creates new columns or modifies existing ones:

```r
deseq <- deseq %>%
  mutate(
    direction = case_when(
      padj < 0.05 & log2FoldChange > 1  ~ "up",
      padj < 0.05 & log2FoldChange < -1 ~ "down",
      TRUE                               ~ "ns"
    )
  )

table(deseq$direction)
```

`case_when()` is the tidyverse equivalent of nested `ifelse()` statements. It evaluates conditions top to bottom and assigns the first match. The `TRUE ~ "ns"` line is the default case for anything that did not match the earlier conditions.

### Transformed p-values for plotting

```r
deseq <- deseq %>%
  mutate(neg_log10_padj = -log10(padj))
```

This `-log10(padj)` transformation is used for volcano plots -- highly significant genes get large positive values, making them easy to spot. We will use this in Session 4 for visualization.

### Useful mutate patterns

```r
# Log-transform expression values (common for heatmaps)
counts_log <- counts %>%
  mutate(across(starts_with("SRR"), ~ log2(.x + 1)))

# Clean up gene IDs (remove version suffix)
genes %>%
  mutate(gene_id_clean = str_remove(gene_id, "\\.\\d+$"))
```

## Part 4: Summarizing by group

`group_by()` + `summarize()` is the R equivalent of SQL's `GROUP BY`. Use it to compute summary statistics per category:

```r
deseq %>%
  group_by(direction) %>%
  summarize(
    n_genes       = n(),
    mean_log2FC   = mean(log2FoldChange),
    median_log2FC = median(log2FoldChange),
    mean_baseMean = mean(baseMean)
  )
```

This tells you how many genes went up vs. down and their average effect sizes.

### Counting per group (shortcut)

For simple counts, `count()` is a shortcut for `group_by() + summarize(n = n())`:

```r
deseq %>% count(direction, sort = TRUE)
```

### Summarize across multiple columns

```r
# Get mean expression per condition from the counts matrix
counts %>%
  summarize(across(starts_with("SRR"), mean))
```

## Part 5: Joining tables

Joining is how you combine data from multiple files using a shared key (usually gene IDs or sample IDs). This is one of the most important data wrangling operations in bioinformatics, where data about the same genes or samples often lives in separate files.

### left_join: add annotations to results

```r
annotated <- deseq %>%
  left_join(genes, by = "gene_id")
```

`left_join()` keeps **all rows** from the left table (`deseq`) and adds matching columns from the right table (`genes`). Genes without a match get `NA` in the new columns.

### Verify the join

Always check that your join worked as expected:

```r
# Any genes missing annotations?
annotated %>%
  filter(is.na(gene_name))   # should return 0 rows

# Did we gain or lose rows? (should match original)
nrow(annotated) == nrow(deseq)
```

!!! warning
    If `nrow(annotated) > nrow(deseq)` after a join, you likely have **duplicate keys** in the right table. Each duplicate creates an extra row. Investigate with `genes %>% count(gene_id) %>% filter(n > 1)`.

### View annotated results

```r
annotated %>%
  filter(direction == "up") %>%
  select(gene_id, gene_name, log2FoldChange, padj, description) %>%
  arrange(desc(log2FoldChange))
```

!!! tip
    The upregulated genes in this dataset (`dreb2a`, `lea3`, `rd29a`, `dhn1`) are classic drought-responsive genes. When your results make biological sense, that is a good sign your analysis is working correctly.

### Which join to use?

| Join | Keeps | Use when |
|------|-------|----------|
| `left_join(a, b)` | All rows from `a` | Adding annotations to your results |
| `inner_join(a, b)` | Only matching rows | Keeping only genes present in both tables |
| `full_join(a, b)` | All rows from both | Merging two complete datasets |
| `anti_join(a, b)` | Rows in `a` not in `b` | Finding genes missing from annotations |

### Practical example: anti_join

`anti_join()` is particularly useful for quality control -- finding what is missing:

```r
# Which genes in our results have no annotation?
missing_annot <- deseq %>%
  anti_join(genes, by = "gene_id")

nrow(missing_annot)
```

## Part 6: Reshaping data (wide to long)

Many bioinformatics tools output **wide** format (one column per sample). Many R analysis and plotting functions need **long** format (one row per observation).

### Wide format (input)

```text
gene_id          SRR001  SRR002  SRR003  SRR004  SRR005  SRR006
Zm00001eb000010    2345    2567    2123     512     489     534
```

### Convert to long format

```r
counts_long <- counts %>%
  pivot_longer(
    cols      = starts_with("SRR"),
    names_to  = "sample_id",
    values_to = "count"
  )

head(counts_long, 12)
```

### Long format (output)

```text
gene_id          sample_id  count
Zm00001eb000010  SRR001      2345
Zm00001eb000010  SRR002      2567
Zm00001eb000010  SRR003      2123
...
```

### Convert back to wide format

Sometimes you need to go the other direction. Use `pivot_wider()`:

```r
counts_wide <- counts_long %>%
  pivot_wider(
    names_from  = "sample_id",
    values_from = "count"
  )
```

This round-trip (`pivot_longer` then `pivot_wider`) should give you back the original table.

### Join sample metadata to long counts

Now that the count data is long, you can join it with sample information:

```r
counts_annotated <- counts_long %>%
  left_join(samples, by = "sample_id")
```

### Compute per-condition means

```r
mean_expression <- counts_annotated %>%
  group_by(gene_id, condition) %>%
  summarize(
    mean_count = mean(count),
    sd_count   = sd(count),
    .groups    = "drop"
  )
```

!!! note
    The `.groups = "drop"` argument prevents `summarize()` from keeping the grouping structure. Without it, the result stays grouped and subsequent operations may behave unexpectedly. Always include this argument or call `ungroup()` afterward.

## Part 7: Export clean results

### Build a final annotated results table

Combine everything you have learned -- join, filter, select, and arrange -- into one pipeline:

```r
final_results <- deseq %>%
  left_join(genes, by = "gene_id") %>%
  filter(padj < 0.05) %>%
  select(
    gene_id, gene_name, chromosome, description,
    baseMean, log2FoldChange, padj, direction
  ) %>%
  arrange(padj)
```

### Write to file

```r
write_tsv(final_results, "significant_genes_annotated.tsv")
```

!!! tip
    Use `write_tsv()` for tab-separated output (preferred for bioinformatics tools and downstream pipelines), `write_csv()` for comma-separated (preferred when opening in Excel). Avoid `write.table()` unless you need specific quoting behavior.

### Quick summary

```r
cat("Significant genes (padj < 0.05):", nrow(final_results), "\n")
cat("  Upregulated:", sum(final_results$direction == "up"), "\n")
cat("  Downregulated:", sum(final_results$direction == "down"), "\n")
```

## Part 8: Quick exploratory plots

Before exporting final results, it is good practice to visualize your data as a sanity check. Since `ggplot2` is loaded with tidyverse, you can create informative plots with just a few lines. These are exploratory plots for your own understanding -- we will cover publication-quality figures in Session 4.

!!! note
    `ggplot2` follows a grammar of graphics: you start with `ggplot(data, aes(...))` to define the data and aesthetic mappings (which columns map to x, y, color, etc.), then add layers with `+` (e.g., `geom_point()`, `geom_bar()`). Every ggplot has this same structure.

### Bar plot: gene counts by direction

A quick way to see how many genes are up, down, or not significant:

```r
ggplot(deseq, aes(x = direction, fill = direction)) +
  geom_bar() +
  scale_fill_manual(values = c("down" = "steelblue", "ns" = "grey70", "up" = "firebrick")) +
  labs(x = "Direction", y = "Number of genes",
       title = "DESeq2 results summary") +
  theme_minimal() +
  theme(legend.position = "none")
```

### Volcano plot (quick version)

The volcano plot is the most common visualization in differential expression analysis. It shows statistical significance (-log10 p-value) vs. biological effect size (log2 fold change):

```r
ggplot(deseq, aes(x = log2FoldChange, y = neg_log10_padj, color = direction)) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_manual(values = c("down" = "steelblue", "ns" = "grey70", "up" = "firebrick")) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey40") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "grey40") +
  labs(x = "log2 Fold Change", y = "-log10(adjusted p-value)",
       title = "Volcano plot: drought vs. control") +
  theme_minimal()
```

The dashed lines mark your significance thresholds: padj = 0.05 (horizontal) and |log2FC| = 1 (vertical). Genes in the upper corners are both statistically significant and biologically meaningful.

### Boxplot: expression by condition

Using the long-format counts from Part 6, you can compare expression levels between conditions for specific genes:

```r
# Pick a few interesting genes to visualize
genes_to_plot <- c("Zm00001eb000010", "Zm00001eb000050", "Zm00001eb000120")

counts_annotated %>%
  filter(gene_id %in% genes_to_plot) %>%
  ggplot(aes(x = condition, y = count, fill = condition)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, size = 1.5, alpha = 0.7) +
  facet_wrap(~ gene_id, scales = "free_y") +
  scale_fill_manual(values = c("control" = "steelblue", "drought" = "firebrick")) +
  labs(x = "Condition", y = "Raw count",
       title = "Expression by condition for selected genes") +
  theme_minimal() +
  theme(legend.position = "none")
```

!!! tip
    `facet_wrap(~ gene_id, scales = "free_y")` creates a separate panel per gene, each with its own y-axis scale. This is essential when genes have very different expression levels -- without `scales = "free_y"`, lowly expressed genes would be squashed flat.

### Saving plots

Save any plot to a file with `ggsave()`. It automatically detects the format from the file extension:

```r
# Save the last plot you displayed
ggsave("volcano_plot.png", width = 8, height = 6, dpi = 150)

# Save a specific plot object
p <- ggplot(deseq, aes(x = log2FoldChange, y = neg_log10_padj)) + geom_point()
ggsave("my_plot.pdf", plot = p, width = 8, height = 6)
```

!!! tip
    Use `dpi = 150` for quick checks and `dpi = 300` for publication figures. PNG is good for slides and web; PDF is better for papers since it produces vector graphics that scale without pixelation.

## Useful patterns for bioinformatics

These patterns come up repeatedly when working with bioinformatics data in R.

### Reading BLAST tabular output

BLAST `-outfmt 6` has no header. You need to supply column names:

```r
blast_cols <- c("qseqid", "sseqid", "pident", "length", "mismatch",
                "gapopen", "qstart", "qend", "sstart", "send",
                "evalue", "bitscore")

blast <- read_tsv("blast_results.txt", col_names = blast_cols)
```

### Reading a GFF/GTF file

GFF3 files are tab-separated with 9 fixed columns. The ninth column contains key-value attributes:

```r
gff_cols <- c("seqid", "source", "type", "start", "end",
              "score", "strand", "phase", "attributes")

gff <- read_tsv("annotations.gff3", comment = "#", col_names = gff_cols)

# Extract gene IDs from attributes column
gff <- gff %>%
  filter(type == "gene") %>%
  mutate(gene_id = str_extract(attributes, "(?<=ID=)[^;]+"))
```

### Batch-reading multiple files

When you have multiple output files (e.g., one per sample), load them all at once:

```r
files <- list.files(pattern = "*.tsv")
all_data <- map_dfr(files, read_tsv, .id = "source_file")
```

### String matching in filter

```r
# Find genes with "transcription factor" in description
genes %>% filter(str_detect(description, "transcription factor"))

# Case-insensitive search
genes %>% filter(str_detect(description, regex("kinase", ignore_case = TRUE)))
```

### Handling NA values

Missing values are common in bioinformatics (genes with low counts get `NA` in p-values):

```r
# Count NAs per column
deseq %>% summarize(across(everything(), ~ sum(is.na(.x))))

# Remove rows with NA in padj
deseq %>% filter(!is.na(padj))

# Replace NA with a value
deseq %>% mutate(padj = replace_na(padj, 1))
```

## Cheat sheet

| Task | Code |
|------|------|
| Read TSV | `read_tsv("file.tsv")` |
| Read CSV | `read_csv("file.csv")` |
| Filter rows | `df %>% filter(padj < 0.05)` |
| Select columns | `df %>% select(gene_id, padj)` |
| Sort rows | `df %>% arrange(padj)` |
| Add column | `df %>% mutate(new_col = ...)` |
| Summarize | `df %>% group_by(x) %>% summarize(n = n())` |
| Count values | `df %>% count(column, sort = TRUE)` |
| Join tables | `df %>% left_join(other, by = "key")` |
| Find missing | `df %>% anti_join(other, by = "key")` |
| Wide to long | `df %>% pivot_longer(cols, names_to, values_to)` |
| Long to wide | `df %>% pivot_wider(names_from, values_from)` |
| Write TSV | `write_tsv(df, "output.tsv")` |
| Write CSV | `write_csv(df, "output.csv")` |

## Troubleshooting

??? note "Error: could not find function 'read_tsv'"

    You have not loaded the tidyverse. Run `library(tidyverse)` first. If you get an error about the package not being installed, run `install.packages("tidyverse")`.

??? note "Column types look wrong after reading a file"

    By default, `read_tsv()` guesses column types from the first 1000 rows. If your file has unusual values, specify types explicitly:

    ```r
    deseq <- read_tsv("deseq2_results.tsv", col_types = cols(
      gene_id        = col_character(),
      baseMean       = col_double(),
      log2FoldChange = col_double(),
      padj           = col_double()
    ))
    ```

??? note "join added extra rows to my table"

    This means there are duplicate keys in the table you are joining. Diagnose with:

    ```r
    genes %>% count(gene_id) %>% filter(n > 1)
    ```

    Fix by deduplicating first: `genes %>% distinct(gene_id, .keep_all = TRUE)`.

??? note "Warning: 'NAs introduced by coercion'"

    This occurs when R tries to convert non-numeric text to a number. Common causes:
    - A column has "NA", "N/A", or "-" as missing value markers. Specify them at read time:

    ```r
    read_tsv("file.tsv", na = c("", "NA", "N/A", "-", "."))
    ```

??? note "My pipe chain is giving unexpected results"

    Debug by running your pipeline one step at a time. Place your cursor at the end of each line and run up to that point:

    ```r
    deseq %>%
      filter(padj < 0.05)           # run up to here first
      # %>% select(gene_id, padj)   # then add this line
      # %>% arrange(padj)           # then this
    ```

    This makes it easy to see exactly where the result diverges from your expectation.

## FAQs

??? note "When should I use tidyverse vs. base R?"

    Either is valid. Tidyverse has a gentler learning curve for data wrangling and produces more readable code through the pipe (`%>%`) syntax. Base R is perfectly fine and sometimes faster for simple operations. Use whichever you are comfortable with -- the important thing is producing correct results, not which dialect you use.

??? note "What is the pipe operator and why use it?"

    The pipe `%>%` (from `magrittr`, loaded with tidyverse) takes the result of the left side and passes it as the first argument to the right side. It lets you chain operations in a readable top-to-bottom flow:

    ```r
    # With pipe (reads naturally left to right, top to bottom)
    deseq %>% filter(padj < 0.05) %>% arrange(padj)

    # Without pipe (nested, reads inside-out)
    arrange(filter(deseq, padj < 0.05), padj)
    ```

    R 4.1+ also has a native pipe `|>` that works similarly.

??? note "How do I save my R session to resume later?"

    Save your workspace before closing RStudio:

    ```r
    save.image(file = "session3_workspace.RData")
    ```

    To resume:

    ```r
    load("session3_workspace.RData")
    ```

    This restores all your variables. However, you still need to reload packages with `library(tidyverse)`.

??? note "Can I use these skills for other organisms?"

    Yes. Everything in this guide works with any tabular bioinformatics data, regardless of organism. The functions (`read_tsv`, `filter`, `left_join`, etc.) operate on the structure of the data, not its biological content. You will use the exact same patterns for human, *Arabidopsis*, or any other species.

## Next session

**Session 4 (March 10): Publication-quality plots for genomics.** We will build on the ggplot2 basics from Part 8 and create polished volcano plots, heatmaps, MA plots, and multi-panel figures ready for journal submission.

## Resources

- [R for Data Science (2e)](https://r4ds.hadley.nz/) -- free online textbook, the definitive tidyverse reference
- [dplyr cheat sheet (PDF)](https://rstudio.github.io/cheatsheets/data-transformation.pdf) -- print this and keep it next to your keyboard
- [tidyr cheat sheet (PDF)](https://rstudio.github.io/cheatsheets/tidyr.pdf) -- pivot, reshape, and tidy data reference
- [Genomics Exchange Discord](https://discord.gg/zEF2nzhXdC) -- ask questions between sessions
