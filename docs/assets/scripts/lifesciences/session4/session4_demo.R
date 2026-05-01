# ============================================================
# Genomics Exchange Session 4
# Publication-Quality Plots for Genomics
# ============================================================
# Instructor: Arun Seetharam, RCAC
# Date:       March 10, 2026
# ============================================================
#
# This script accompanies Session 4 of the Genomics Exchange.
# We build on the Session 3 maize drought RNA-seq dataset to
# create five publication-ready figures using ggplot2.
#
# Structure: Each section shows a "quick" version first
# (the default ggplot output), then a polished version
# with proper labels, themes, colors, and export settings.
#
# Comments marked [TYPE] = short commands to type live
# Comments marked [PASTE] = longer blocks to paste from script
# ============================================================


# ============================================================
# SETUP
# ============================================================

# On headless HPC sessions (no X11), ggsave() needs cairo
# for PNG rendering. Set this BEFORE loading ggplot2.
options(bitmapType = "cairo")

# Install packages if needed (run once, then comment out)
# install.packages(c("tidyverse", "ggrepel", "pheatmap",
#                     "viridis", "RColorBrewer", "scales"))

# [TYPE] Load packages
library(tidyverse)
library(ggrepel)
library(pheatmap)
library(viridis)
library(RColorBrewer)
library(scales)

# Set a global theme so every plot starts with a clean look.
# base_size controls the default font size for all text elements.
# [TYPE]
theme_set(theme_minimal(base_size = 14))


# ============================================================
# LOAD DATA
# ============================================================

# We reuse the Session 3 dataset. Read directly from the web,
# or change base_url to a local path if you downloaded the files.
# [PASTE]
base_url <- "https://rcac-bioinformatics.github.io/assets/session3"

deseq   <- read_tsv(file.path(base_url, "deseq2_results.tsv"))
samples <- read_tsv(file.path(base_url, "sample_manifest.tsv"))
counts  <- read_tsv(file.path(base_url, "counts_matrix.tsv"))
genes   <- read_tsv(file.path(base_url, "gene_annotations.tsv"))

# If you downloaded Session 4 files to your working directory:
enrichment <- read_tsv("fake_enrichment.tsv")

# --- Prepare the DESeq2 results (same as Session 3) ---
# [PASTE]
deseq <- deseq %>%
  mutate(
    direction = case_when(
      padj < 0.05 & log2FoldChange > 1  ~ "Up",
      padj < 0.05 & log2FoldChange < -1 ~ "Down",
      TRUE                               ~ "NS"
    ),
    neg_log10_padj = -log10(padj)
  ) %>%
  left_join(genes, by = "gene_id")

# Quick check
table(deseq$direction)

# Define a consistent color palette for up/down/NS
# These colors are distinguishable under common color vision deficiencies
direction_colors <- c("Down" = "#2166AC", "NS" = "grey70", "Up" = "#B2182B")


# ============================================================
# SECTION 1: VOLCANO PLOT
# ============================================================
# The volcano plot is the signature figure of differential
# expression analysis. X-axis = effect size, Y-axis = significance.
# Genes in the upper corners are both significant and large-effect.

# --- Quick version [TYPE] ---
ggplot(deseq, aes(x = log2FoldChange, y = neg_log10_padj)) +
  geom_point()

# That works, but it is not publication-ready.
# Problems: no color coding, no gene labels, default theme,
# no threshold lines, generic axis labels.

# --- Publication version [PASTE] ---

# Identify top genes to label (most significant)
top_genes <- deseq %>%
  filter(padj < 0.05) %>%
  arrange(padj) %>%
  slice_head(n = 8)

volcano <- ggplot(deseq, aes(x = log2FoldChange, y = neg_log10_padj,
                              color = direction)) +
  geom_point(size = 2, alpha = 0.8) +
  # Threshold lines
  geom_hline(yintercept = -log10(0.05), linetype = "dashed",
             color = "grey40", linewidth = 0.5) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed",
             color = "grey40", linewidth = 0.5) +
  # Label top genes (ggrepel avoids overlapping text)
  geom_text_repel(
    data = top_genes,
    aes(label = gene_name),
    size = 3.5,
    max.overlaps = 15,
    box.padding = 0.5,
    segment.color = "grey50",
    color = "black"
  ) +
  scale_color_manual(values = direction_colors, name = "Direction") +
  labs(
    x = expression(log[2]~"Fold Change"),
    y = expression(-log[10]~"(adjusted p-value)"),
    title = "Differential expression: drought vs. control",
    subtitle = "Maize leaf tissue RNA-seq"
  ) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

volcano

# --- Export ---
# PNG for slides (300 DPI is standard for print-quality)
ggsave("volcano_plot.png", volcano,
       width = 7, height = 6, dpi = 300, units = "in")

# PDF for journal submission (vector graphics, scales perfectly)
ggsave("volcano_plot.pdf", volcano,
       width = 7, height = 6, units = "in")


# ============================================================
# SECTION 2: MA PLOT
# ============================================================
# The MA plot shows mean expression (x) vs. fold change (y).
# It reveals whether fold changes depend on expression level.
# Highly expressed genes tend to have more reliable estimates.

# --- Quick version [TYPE] ---
ggplot(deseq, aes(x = baseMean, y = log2FoldChange)) +
  geom_point()

# Problems: x-axis is heavily right-skewed (a few genes dominate),
# no color, no reference line at zero.

# --- Publication version [PASTE] ---

ma_plot <- ggplot(deseq, aes(x = baseMean, y = log2FoldChange,
                              color = direction)) +
  geom_point(size = 2, alpha = 0.8) +
  geom_hline(yintercept = 0, linetype = "solid",
             color = "grey30", linewidth = 0.5) +
  # Log10 x-axis to spread out the skewed distribution
  scale_x_log10(
    labels = label_comma(),
    breaks = c(10, 100, 1000, 10000)
  ) +
  scale_color_manual(values = direction_colors, name = "Direction") +
  # Label a few notable outliers
  geom_text_repel(
    data = deseq %>% filter(abs(log2FoldChange) > 3),
    aes(label = gene_name),
    size = 3.5,
    color = "black",
    max.overlaps = 10
  ) +
  labs(
    x = "Mean normalized counts (log scale)",
    y = expression(log[2]~"Fold Change"),
    title = "MA plot: expression level vs. fold change"
  ) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

ma_plot

# --- Export ---
ggsave("ma_plot.png", ma_plot,
       width = 7, height = 5, dpi = 300, units = "in")
ggsave("ma_plot.pdf", ma_plot,
       width = 7, height = 5, units = "in")


# ============================================================
# SECTION 3: HEATMAP
# ============================================================
# Heatmaps show expression patterns across genes and samples.
# We use pheatmap (pretty heatmap) for its annotation features.
# Rows = genes, columns = samples, color = scaled expression.

# --- Prepare the count matrix ---

# Select significant DE genes
sig_genes <- deseq %>%
  filter(padj < 0.05) %>%
  arrange(padj) %>%
  pull(gene_id)

# Extract counts for significant genes, set gene_id as rownames
# [PASTE]
count_matrix <- counts %>%
  filter(gene_id %in% sig_genes) %>%
  column_to_rownames("gene_id") %>%
  as.matrix()

# Replace gene IDs with gene names for readability
gene_name_lookup <- deseq %>%
  filter(gene_id %in% sig_genes) %>%
  select(gene_id, gene_name) %>%
  deframe()

rownames(count_matrix) <- gene_name_lookup[rownames(count_matrix)]

# Scale rows (z-score) so we see relative changes, not absolute levels
# [TYPE]
count_scaled <- t(scale(t(count_matrix)))

# --- Quick version [TYPE] ---
pheatmap(count_scaled)

# That works but uses default colors, no sample annotations,
# and the default clustering may not group conditions well.

# --- Publication version [PASTE] ---

# Create sample annotation data frame for the column sidebar
sample_annot <- samples %>%
  select(sample_id, condition) %>%
  column_to_rownames("sample_id")

# Define annotation colors
annot_colors <- list(
  condition = c("drought" = "#D53E4F", "control" = "#3288BD")
)

# Use a diverging blue-white-red palette (colorblind safe)
heatmap_colors <- colorRampPalette(
  rev(brewer.pal(9, "RdBu"))
)(100)

heatmap_obj <- pheatmap(
  count_scaled,
  color             = heatmap_colors,
  annotation_col    = sample_annot,
  annotation_colors = annot_colors,
  clustering_method  = "ward.D2",
  cluster_cols       = TRUE,
  cluster_rows       = TRUE,
  show_colnames      = TRUE,
  show_rownames      = TRUE,
  fontsize           = 11,
  fontsize_row       = 10,
  fontsize_col       = 10,
  border_color       = NA,
  main               = "Expression of DE genes (z-score scaled)",
  angle_col          = 45
)

# --- Export ---
# pheatmap returns a gtable object; save with its built-in method
# or wrap in ggsave-compatible approach
png("heatmap_de_genes.png", width = 7, height = 8,
    units = "in", res = 300, type = "cairo")
pheatmap(
  count_scaled,
  color             = heatmap_colors,
  annotation_col    = sample_annot,
  annotation_colors = annot_colors,
  clustering_method  = "ward.D2",
  cluster_cols       = TRUE,
  cluster_rows       = TRUE,
  show_colnames      = TRUE,
  show_rownames      = TRUE,
  fontsize           = 11,
  fontsize_row       = 10,
  fontsize_col       = 10,
  border_color       = NA,
  main               = "Expression of DE genes (z-score scaled)",
  angle_col          = 45
)
dev.off()

pdf("heatmap_de_genes.pdf", width = 7, height = 8)
pheatmap(
  count_scaled,
  color             = heatmap_colors,
  annotation_col    = sample_annot,
  annotation_colors = annot_colors,
  clustering_method  = "ward.D2",
  cluster_cols       = TRUE,
  cluster_rows       = TRUE,
  show_colnames      = TRUE,
  show_rownames      = TRUE,
  fontsize           = 11,
  fontsize_row       = 10,
  fontsize_col       = 10,
  border_color       = NA,
  main               = "Expression of DE genes (z-score scaled)",
  angle_col          = 45
)
dev.off()


# ============================================================
# SECTION 4: ENRICHMENT BAR PLOT
# ============================================================
# GO / functional enrichment bar plots summarize the biological
# themes among your DE genes. Here we use a small simulated
# enrichment result to demonstrate the figure type.

# Quick look at the data
# [TYPE]
enrichment

# --- Quick version [TYPE] ---
ggplot(enrichment, aes(x = term_name, y = fold_enrichment)) +
  geom_col()

# Problems: overlapping x labels, no color, no significance info,
# terms not ordered by effect size.

# --- Publication version [PASTE] ---

enrich_plot <- enrichment %>%
  # Reorder terms by fold enrichment (largest at top)
  mutate(term_name = fct_reorder(term_name, fold_enrichment)) %>%
  ggplot(aes(x = fold_enrichment, y = term_name,
             fill = category, size = gene_count)) +
  geom_point(shape = 21, color = "black", stroke = 0.5) +
  # Colorblind-safe palette for categories
  scale_fill_manual(
    values = c("BP" = "#1B9E77", "MF" = "#D95F02", "CC" = "#7570B3"),
    name = "Category",
    labels = c("BP" = "Biological Process",
               "MF" = "Molecular Function",
               "CC" = "Cellular Component")
  ) +
  scale_size_continuous(range = c(3, 10), name = "Gene count") +
  labs(
    x = "Fold enrichment",
    y = NULL,
    title = "GO enrichment of drought-responsive genes"
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    legend.position = "right"
  )

enrich_plot

# Alternative: bar chart version (common in papers)
enrich_bar <- enrichment %>%
  mutate(
    term_name = fct_reorder(term_name, fold_enrichment),
    neg_log10_padj = -log10(padj)
  ) %>%
  ggplot(aes(x = fold_enrichment, y = term_name, fill = neg_log10_padj)) +
  geom_col(width = 0.7) +
  # Text labels showing gene count
  geom_text(aes(label = paste0("n=", gene_count)),
            hjust = -0.2, size = 3.5) +
  scale_fill_viridis_c(
    option = "plasma",
    name = expression(-log[10]~"(padj)"),
    direction = -1
  ) +
  # Extend x-axis to make room for labels
  scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    x = "Fold enrichment",
    y = NULL,
    title = "GO enrichment of drought-responsive genes"
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

enrich_bar

# --- Export ---
ggsave("enrichment_dotplot.png", enrich_plot,
       width = 8, height = 5, dpi = 300, units = "in")
ggsave("enrichment_dotplot.pdf", enrich_plot,
       width = 8, height = 5, units = "in")

ggsave("enrichment_barplot.png", enrich_bar,
       width = 8, height = 5, dpi = 300, units = "in")
ggsave("enrichment_barplot.pdf", enrich_bar,
       width = 8, height = 5, units = "in")


# ============================================================
# SECTION 5: BEFORE AND AFTER — UGLY TO PUBLICATION
# ============================================================
# This section demonstrates an iterative improvement workflow.
# We start with a ggplot that "works" but looks terrible,
# then fix one problem at a time until it is publication-ready.
#
# The plot: grouped bar chart of mean expression for top DE genes.

# --- Prepare data ---
# [PASTE]
top6 <- deseq %>%
  filter(direction != "NS") %>%
  arrange(padj) %>%
  slice_head(n = 6)

counts_long <- counts %>%
  pivot_longer(cols = starts_with("SRR"),
               names_to = "sample_id", values_to = "count") %>%
  left_join(samples, by = "sample_id") %>%
  left_join(genes, by = "gene_id")

plot_data <- counts_long %>%
  filter(gene_id %in% top6$gene_id) %>%
  group_by(gene_name, condition) %>%
  summarize(
    mean_count = mean(count),
    se_count   = sd(count) / sqrt(n()),
    .groups    = "drop"
  )


# --- STEP 1: The ugly default [TYPE] ---
# This is what you get if you just throw data at ggplot.
p_ugly <- ggplot(plot_data, aes(x = gene_name, y = mean_count,
                                 fill = condition)) +
  geom_col(position = "dodge")

p_ugly

# What is wrong?
# 1. Default grey background is distracting
# 2. Axis labels are variable names, not human-readable
# 3. Default fill colors are not colorblind-safe
# 4. No error bars (readers cannot assess variability)
# 5. Font is too small for a figure in a paper
# 6. No title or caption
# 7. Too much gridline clutter


# --- STEP 2: Fix the theme [TYPE] ---
p_step2 <- p_ugly +
  theme_minimal(base_size = 14)

p_step2


# --- STEP 3: Fix colors [TYPE] ---
p_step3 <- p_step2 +
  scale_fill_manual(values = c("control" = "#3288BD",
                                "drought" = "#D53E4F"),
                    name = "Condition")

p_step3


# --- STEP 4: Add error bars, fix labels [PASTE] ---
p_step4 <- ggplot(plot_data, aes(x = gene_name, y = mean_count,
                                  fill = condition)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_errorbar(
    aes(ymin = mean_count - se_count, ymax = mean_count + se_count),
    position = position_dodge(width = 0.8),
    width = 0.25,
    linewidth = 0.5
  ) +
  scale_fill_manual(values = c("control" = "#3288BD",
                                "drought" = "#D53E4F"),
                    name = "Condition") +
  labs(
    x = NULL,
    y = "Mean normalized counts",
    title = "Expression of top DE genes",
    subtitle = "Drought vs. control (mean +/- SE, n = 3)"
  ) +
  theme_minimal(base_size = 14)

p_step4


# --- STEP 5: Final polish — remove chartjunk [PASTE] ---
p_final <- p_step4 +
  theme(
    # Remove minor gridlines
    panel.grid.minor   = element_blank(),
    # Remove vertical gridlines (not useful for bar charts)
    panel.grid.major.x = element_blank(),
    # Move legend inside the plot to save space
    legend.position    = c(0.85, 0.85),
    legend.background  = element_rect(fill = "white", color = NA),
    # Italic gene names on x-axis (gene symbols are italicized by convention)
    axis.text.x        = element_text(face = "italic", size = 12),
    # Ensure y-axis starts at zero (important for bar charts)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))

p_final

# Side-by-side comparison: save both
# [PASTE]
ggsave("barplot_ugly.png", p_ugly,
       width = 7, height = 5, dpi = 300, units = "in")
ggsave("barplot_final.png", p_final,
       width = 7, height = 5, dpi = 300, units = "in")
ggsave("barplot_final.pdf", p_final,
       width = 7, height = 5, units = "in")


# ============================================================
# BONUS: USEFUL TIPS
# ============================================================

# --- Tip 1: Check available palettes ---
# [TYPE]
display.brewer.all(colorblindFriendly = TRUE)

# --- Tip 2: Viridis palettes for continuous data ---
# [TYPE]
# scale_fill_viridis_c()    # continuous
# scale_fill_viridis_d()    # discrete
# Options: "magma", "inferno", "plasma", "viridis", "cividis", "turbo"

# --- Tip 3: Consistent figure sizing for multi-panel figures ---
# Most journals want figures between 80mm (single column) and
# 170mm (double column). At 300 DPI:
#   Single column: width = 3.15 in (80mm)
#   1.5 column:    width = 5.51 in (140mm)
#   Double column:  width = 6.69 in (170mm)

# --- Tip 4: Save all your plots at once ---
# If you named all your plot objects, you can export them in a loop:
# [PASTE]
plot_list <- list(
  volcano   = volcano,
  ma        = ma_plot,
  enrich_dot = enrich_plot,
  enrich_bar = enrich_bar,
  barplot    = p_final
)

for (name in names(plot_list)) {
  ggsave(
    filename = paste0(name, "_final.png"),
    plot     = plot_list[[name]],
    width    = 7,
    height   = 5.5,
    dpi      = 300,
    units    = "in"
  )
}

# --- Tip 5: Theme customization you can reuse across projects ---
# [PASTE]
theme_publication <- function(base_size = 14) {
  theme_minimal(base_size = base_size) %+replace%
    theme(
      panel.grid.minor    = element_blank(),
      panel.grid.major    = element_line(color = "grey92", linewidth = 0.4),
      axis.line           = element_line(color = "grey30", linewidth = 0.4),
      axis.ticks          = element_line(color = "grey30", linewidth = 0.3),
      strip.background    = element_rect(fill = "grey95", color = NA),
      strip.text          = element_text(face = "bold", size = base_size),
      legend.key          = element_rect(fill = "white", color = NA),
      plot.title          = element_text(face = "bold", hjust = 0,
                                         size = base_size + 2),
      plot.subtitle       = element_text(color = "grey40", hjust = 0,
                                          size = base_size),
      plot.title.position = "plot"
    )
}

# Apply it:
# theme_set(theme_publication())
# Now every plot you make starts with this theme.


# ============================================================
# SESSION SUMMARY
# ============================================================
#
# Files created in this session:
#   volcano_plot.png / .pdf     — Volcano plot
#   ma_plot.png / .pdf          — MA plot
#   heatmap_de_genes.png / .pdf — Heatmap
#   enrichment_dotplot.png / .pdf — Enrichment dot plot
#   enrichment_barplot.png / .pdf — Enrichment bar plot
#   barplot_ugly.png            — Before (ugly default)
#   barplot_final.png / .pdf    — After (publication-ready)
#
# Key takeaways:
#   1. Always export with explicit width, height, dpi
#   2. Use colorblind-safe palettes (viridis, RColorBrewer)
#   3. theme_minimal() + targeted customization beats theme_grey()
#   4. Label your axes with human-readable text
#   5. Remove chartjunk: unnecessary gridlines, borders, backgrounds
#   6. ggsave() for ggplot objects; png()/pdf() + dev.off() for pheatmap
#
# Next session: Session 5 (March 24) — Running bioinformatics
# programs on RCAC clusters
# ============================================================
