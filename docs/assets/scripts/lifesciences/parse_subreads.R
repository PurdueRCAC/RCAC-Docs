library(data.table)
library(tidyverse)
setwd("C:/Users/Arun/Desktop/B73/test/")
helixer_str <- fread("helixer.str2.summary")
helixer_str_long <- pivot_longer(helixer_str,
                                 cols = B73_16DAP_embryo_MN01101:B73_V18_tassel_MN01062)
helixer_str_long$strand <- "stranded"
helixer_str_long$Annotation <- "helixer"

helixer_unstr <- fread("helixer.unstr.summary")
helixer_unstr_long <- pivot_longer(helixer_unstr,
                                   cols = B73_16DAP_embryo_MN01101:B73_V18_tassel_MN01062)
helixer_unstr_long$strand <- "unstranded"
helixer_unstr_long$Annotation <- "helixer"


nam.v5_str <- fread("v5.str2.summary")
nam.v5_str_long <- pivot_longer(nam.v5_str,
                                cols = B73_16DAP_embryo_MN01101:B73_V18_tassel_MN01062)
nam.v5_str_long$strand <- "stranded"
nam.v5_str_long$Annotation <- "NAM.v5"

nam.v5_unstr <- fread("v5.unstr.summary")
nam.v5_unstr_long <- pivot_longer(nam.v5_unstr,
                                  cols = B73_16DAP_embryo_MN01101:B73_V18_tassel_MN01062)
nam.v5_unstr_long$strand <- "unstranded"
nam.v5_unstr_long$Annotation <- "NAM.v5"


myData <- rbind(helixer_str_long,
                helixer_unstr_long,
                nam.v5_str_long,
                nam.v5_unstr_long)
colnames(myData) <- c("fragment",
                      "tissue",
                      "count",
                      "strand",
                      "annotation")


myData.filtered <- myData %>%
  filter(count  !=  0) %>%
  group_by(tissue, strand, annotation) %>%
  mutate(total = sum(count),
         percent = (count / total) * 100)

myData.filtered.assigned <- myData.filtered %>%
  filter(fragment  ==  "Assigned" &
           strand == "stranded")

myData.filtered.unassigned <- myData.filtered %>%
  filter(fragment  ==  "Unassigned_NoFeatures" &
           strand == "stranded")



status_colors <- c("helixer" = "#d79c3b", "NAM.v5" = "#a3c857")


ggplot(myData.filtered.assigned,
       aes(x = tissue, y = percent, fill = annotation)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Assigned Features", x = "Tissue", y = "Percentage (%)") +
  theme_minimal() +
  theme_minimal(base_size = 12) +
  scale_fill_manual(values = status_colors) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
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

ggsave("assigned.png",
       width = 12,
       height = 10,
       units = "in",
       dpi = 300)


ggplot(myData.filtered.unassigned,
       aes(x = tissue, y = percent, fill = annotation)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Unassigned Features",
       x = "Tissue",
       y = "Percentage (%)") +
  theme_minimal(base_size = 12) +
  scale_fill_manual(values = status_colors) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
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

ggsave("unassigned.png",
       width = 12,
       height = 10,
       units = "in",
       dpi = 300)
