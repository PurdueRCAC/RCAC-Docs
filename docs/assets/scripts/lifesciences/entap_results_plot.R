library(data.table)
library(tidyverse)
library(scales)
setwd("C:/Users/Arun/Desktop/B73/entap/")


helixer <- fread("helixer_entap_results.tsv")
b73.v5 <- fread("NAM.v5_entap_results.tsv")




myHelixer <- helixer %>%
  select(
    "Query Sequence",
    "Frame",
    "Percent Identical",
    "E Value",
    "Coverage",
    "Description",
    "Species",
    "Taxonomic Lineage",
    "Contaminant",
    "EggNOG Protein Domains"
  ) %>%
  mutate(frame_completeness = fct_na_value_to_level(Frame, level  = "Missing")) %>%
  mutate(gene_function = ifelse(is.na(Description), "Missing", "Present")) %>%
  mutate(pfam_domain = ifelse(is.na(`EggNOG Protein Domains`), "Missing", "Present")) %>%
  mutate(PID = ifelse(is.na(`Percent Identical`), -1, `Percent Identical`)) %>%
  mutate(query = `Query Sequence`) %>%
  mutate(source =  as.factor("helixer")) %>%
  mutate(evalue = ifelse(is.na(`E Value`), -1, `E Value`)) %>%
  mutate(myCoverage = ifelse(is.na(`Coverage`), -1, `Coverage`)) %>%
  select(
    "query",
    "frame_completeness",
    "PID",
    "evalue",
    "myCoverage",
    "gene_function",
    "pfam_domain",
    "source"
  )

myB73.v5 <- b73.v5 %>%
  select(
    "Query Sequence",
    "Frame",
    "Percent Identical",
    "E Value",
    "Coverage",
    "Description",
    "Species",
    "Taxonomic Lineage",
    "Contaminant",
    "EggNOG Protein Domains"
  ) %>%
  mutate(frame_completeness = fct_na_value_to_level(Frame, level = "Missing")) %>%
  mutate(gene_function = ifelse(is.na(Description), "Missing", "Present")) %>%
  mutate(pfam_domain = ifelse(is.na(`EggNOG Protein Domains`), "Missing", "Present")) %>%
  mutate(PID = ifelse(is.na(`Percent Identical`), -1, `Percent Identical`)) %>%
  mutate(query = `Query Sequence`) %>%
  mutate(source = as.factor("NAM.v5")) %>%
  mutate(evalue = ifelse(is.na(`E Value`), -1, `E Value`)) %>%
  mutate(myCoverage = ifelse(is.na(`Coverage`), -1, `Coverage`)) %>%
  select(
    "query",
    "frame_completeness",
    "PID",
    "evalue",
    "myCoverage",
    "gene_function",
    "pfam_domain",
    "source"
  )


entap <- rbind(myB73.v5, myHelixer)

myColors = c("Missing" = "#ca5752",
             "Present" = "#73a542")

status_colors <- c("helixer" = "#d79c3b",
                   "NAM.v5" = "#a3c857")

frameColors <- c(
  "Complete" = "#73a542",
  "Internal" = "#9453b2",
  "Missing" = "#ca5752",
  "Partial 3 Prime" = "#93b2b9",
  "Partial 5 Prime" = "#504140"
)

ggplot(entap, aes(x = PID, fill = source)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = status_colors) +
  labs(title = "Percent Identity", x = "Identity (%)", y = "Density") +
  theme_minimal(base_size = 12) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), units = , "cm"),
        plot.title = element_text(
          size = 18,
          vjust = 1,
          hjust = 0
        ),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = "top",
        legend.key = element_blank())

ggsave("pid.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)


ggplot(entap, aes(x = frame_completeness, fill = gene_function)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = myColors) +
  labs(title = "Frame Completeness with presence of gene function", x = "Frame Completeness", y = "Number of Genes") +
  theme_minimal(base_size = 12) +
  scale_y_continuous(
    expand = c(0, 0),
    breaks = seq(0, 34000, by = 2000),
    labels = label_number(scale = 1e-3, suffix = "K")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), units = "cm"),
        plot.title = element_text(
          size = 18,
          vjust = 1,
          hjust = 0
        ),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = "top",
        legend.key = element_blank()) +
  facet_grid(~source, axes = "all")

ggsave("gene-function.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)

ggplot(entap, aes(x = frame_completeness, fill = pfam_domain)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = myColors) +
  labs(title = "Frame Completeness with presence of pfam domains", x = "Frame Completeness", y = "Number of Genes") +
  theme_minimal(base_size = 12) +
  scale_y_continuous(
    expand = c(0, 0),
    breaks = seq(0, 34000, by = 2000),
    labels = label_number(scale = 1e-3, suffix = "K")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), units = "cm"),
        plot.title = element_text(
          size = 18,
          vjust = 1,
          hjust = 0
        ),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = "top",
        legend.key = element_blank()) +
  facet_grid(~source, axes = "all")



ggsave("pfam-domain.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)



