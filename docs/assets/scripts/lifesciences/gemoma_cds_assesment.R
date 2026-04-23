library(data.table)
library(PupillometryR)
library(tidyverse)
setwd("C:/Users/arnstrm/OneDrive - purdue.edu/computer_folders/Desktop/gemoma_chapter/cds_stats")

status_colors <- c("Helixer" = "#d79c3b", "NAM.v5" = "#a3c857")

status_colors <- c("B73.v5 (reference)" = "#d79c3b",
"B73.v5 primary only (reference)" = "#e28c23",
"Helixer" = "#a3c857",
"GeMoMa (merged)" ="#de396d")





readStats <- function(myFile = "", myName = "") {
  myDf <- fread(myFile)
  myDf <- myDf %>%
    rename(
      transcript.id = V1,
      length = V2,
      gc = V3,
      start = V4,
      stop = V5
    ) %>%
    mutate(primary = if_else(grepl("(_T001|\\.t1|\\.1)$", transcript.id), "yes", "no"), source = myName)
  return(myDf)

}

metadata <- fread("../metadata.tsv")
primary <- fread("primary.ids", header = FALSE)
primary_ids <- unique(primary$V1)


result_list <- list()


for (i in 1:nrow(metadata)) {
  file_name <- paste0(metadata$Prefix[i], "_info.tsv")
  my_name <- metadata$Name[i]
  type_name <- metadata$Type[i]
  if (file.exists(file_name)) {
    result_list[[type_name]] <- readStats(myFile = file_name, myName = my_name)
  } else {
    warning(paste("File not found:", file_name))
  }
}
result_list$merged[transcript.id %in% primary_ids, primary := "yes"]

# Custom order for Type
type_order <- c("Ref", "Ref.primary", "CNN", "merged")


combined_df <- dplyr::bind_rows(result_list, .id = "Type")

combined_df <- combined_df %>%
  mutate(Type = factor(Type, levels = type_order)) %>%
  arrange(Type) %>%
  mutate(source = factor(source, levels = unique(source)))


myData <- combined_df

myData.primary <- myData %>%
  filter(primary == "yes")


#stat_summary(fun = mean, geom = "point", shape = 16, size = 3, color = "red",
#             position = position_nudge(y = 0)) +  # Mean as red dot
#  stat_summary(fun = median, geom = "point", shape = 16, size = 3, color = "blue",
#               position = position_nudge(y = 0)) +
#  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +

ggplot(myData.primary, aes(x = source, y = length, fill = source)) +
  geom_flat_violin(position = position_nudge(x = 0.2, y = 0),
                   alpha = 0.5,
                   trim = FALSE)  +
  geom_point(
    aes(color = source),
    position = position_jitter(width = 0.15),
    size = 1,
    alpha = 0.25
  ) +
  geom_boxplot(width = 0.2,
               outlier.shape = NA,
               alpha = 0.5) +
  stat_summary(fun = mean, geom = "point", shape = 23) +
  labs(title = "Distribution of CDS Lengths", x = "Predictions", y = "CDS length (bp)") +
  scale_fill_manual(values = status_colors) +
  scale_color_manual(values = status_colors) +
  theme_minimal(base_size = 12) +
  scale_y_log10(expand = c(0, 0)) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.line.y = element_line(color = "black"),
    axis.ticks.y = element_line(color = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    plot.title = element_text(
      size = 18,
      vjust = 1,
      hjust = 0
    ),
    legend.text = element_text(size = 12),
    legend.title = element_blank(),
    legend.position = "none",
    legend.key = element_blank()
  )

ggsave("gemoma_cds-length.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 200)




ggplot(myData.primary, aes(x = source, y = gc, fill = source)) +
  geom_flat_violin(position = position_nudge(x = 0.2, y = 0),
                   alpha = 0.5,
                   trim = FALSE)  +
  geom_point(
    aes(color = source),
    position = position_jitter(width = 0.15),
    size = 1,
    alpha = 0.25
  ) +
  geom_boxplot(width = 0.2,
               outlier.shape = NA,
               alpha = 0.5) +
  stat_summary(fun = mean, geom = "point", shape = 23) +
  labs(title = "Distribution of GC%", x = "Predictions", y = "GC (%)") +
  scale_fill_manual(values = status_colors) +
  scale_color_manual(values = status_colors) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(labels = scales::percent_format(), expand = c(0, 0), limits = c(0, 1)) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.line.y = element_line(color = "black"),
    axis.ticks.y = element_line(color = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    plot.title = element_text(
      size = 18,
      vjust = 1,
      hjust = 0
    ),
    legend.text = element_text(size = 12),
    legend.title = element_blank(),
    legend.position = "none",
    legend.key = element_blank()
  )

ggsave("gemoma_cds-gc.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 200)



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
    legend.position = "none",
    legend.key = element_blank()
  )+
  facet_wrap( ~ source, ncol = 2)
ggsave("gemoma_gc-content.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 200)


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
  facet_wrap( ~ source, ncol = 2)
ggsave("gemoma_codon-type.png",
       width = 12,
       height = 9,
       units = "in",
       dpi = 200)

