library(data.table)
library(tidyverse)
setwd("C:/Users/Arun/Desktop/B73/cds_assesments/")

nam <- fread("NAM.v5_cds.info")
helixer <- fread("helixer_cds.info")

status_colors <- c("Helixer" = "#d79c3b", "NAM.v5" = "#a3c857")

nam <- nam %>%
  rename(
    transcript.id = V1,
    length = V2,
    gc = V3,
    start = V4,
    stop = V5
  ) %>%
  mutate(primary = if_else(grepl("_T001$", transcript.id), "yes", "no"), source = "NAM.v5")

helixer <- helixer %>%
  rename(
    transcript.id = V1,
    length = V2,
    gc = V3,
    start = V4,
    stop = V5
  ) %>%
  mutate(primary = "yes", source = "Helixer")


myData <- rbind(nam, helixer)

myData.primary <- myData %>%
  filter(primary == "yes")


ggplot(myData.primary, aes(x = length, fill = source, color = source)) +
  geom_histogram(binwidth = 100) +
  labs(title = "Distribution of CDS Lengths", x = "CDS length", y = "# of transcripts (primary only)") +
  scale_fill_manual(values = status_colors) +
  scale_colour_manual(values = status_colors) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 1),
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
    legend.key = element_blank()
  ) +
  facet_grid( ~ source)
ggsave("cds-length.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)


ggplot(myData.primary, aes(x = gc, fill = source, color = source)) +
  geom_density(alpha = 0.2) +
  labs(title = "Density of GC Content", x = "GC Content", y = "Density") +
  scale_fill_manual(values = status_colors) +
  scale_colour_manual(values = status_colors) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  scale_x_continuous(labels = scales::percent_format()) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 1),
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
    legend.key = element_blank()
  )
ggsave("gc-content.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)


# Define valid start and stop codons
valid_start <- "ATG"
valid_stop <- c("TAA", "TAG", "TGA")

# Classify each transcript based on start and stop codon validity
myData.primary <- myData.primary %>%
  mutate(
    start_valid = start == valid_start,
    stop_valid = stop %in% valid_stop,
    codon_status = case_when(
      start_valid & stop_valid ~ "Both valid",
      start_valid & !stop_valid ~ "Start valid",!start_valid &
        stop_valid ~ "Stop valid",
      TRUE ~ "None valid"
    )
  )

# Calculate proportions for each category
proportions <- myData.primary %>%
  group_by(source, codon_status) %>%
  summarise(count = n()) %>%
  mutate(proportion = count / sum(count))


frameColors <- c(
  "Both valid" = "#73a542",
  "Start valid" = "#9453b2",
  "Stop valid" = "#ca5752",
  "None valid" = "#93b2b9"
)



ggplot(proportions,
       aes(x = codon_status, y = proportion, fill = codon_status)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, NA),
    labels = scales::percent_format()
  ) +
  labs(title = "% transcrpts with valid start/stop codons", x = "codon type", y = "percent transcripts") +
  scale_fill_manual(values = frameColors) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 1),
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
    legend.position = "none",
    legend.key = element_blank()
  ) +
  facet_grid( ~ source)
ggsave("codon-type.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 300)

