library(data.table)
library(tidyverse)
library(scales)
setwd("C:/Users/Arun/Desktop/B73/ps/")

helixer <- fread("helixer_ps.csv")
nam <- fread("NAM.v5_ps.csv")

nam$source <- "NAM.v5"
helixer$source <- "Helixer"

ps <- rbind(nam, helixer)

ps <- ps %>%
    rename(
        order = V1,
        strata = Var1,
        genes = Freq,
        source = source
    ) %>%
    group_by(source) %>%
    mutate(strata = factor(strata, levels = strata[order(order)]))

myStarta <- c(
    "Cellular Organisms",
    "Eukaryota",
    "Viridiplantae",
    "Streptophyta",
    "Embryophyta",
    "Liliopsida",
    "Poaceae",
    "Andropogoneae",
    "Species Specific"
)
ps.collapsed <- ps %>%
    group_by(source) %>%
    mutate(SppTotal = sum(genes)) %>%
    mutate(
        NewStrata =
            case_when(
                strata == "cellular organisms" ~ "Cellular Organisms",
                strata == "Eukaryota" ~ "Eukaryota",
                strata == "Viridiplantae" ~ "Viridiplantae",
                strata == "Streptophyta" ~ "Streptophyta",
                strata == "Streptophytina" ~ "Streptophyta",
                strata == "Embryophyta" ~ "Embryophyta",
                strata == "Tracheophyta" ~ "Embryophyta",
                strata == "Euphyllophyta" ~ "Embryophyta",
                strata == "Spermatophyta" ~ "Embryophyta",
                strata == "Magnoliopsida" ~ "Embryophyta",
                strata == "Mesangiospermae" ~ "Embryophyta",
                strata == "Liliopsida" ~ "Liliopsida",
                strata == "Petrosaviidae" ~ "Liliopsida",
                strata == "commelinids" ~ "Liliopsida",
                strata == "Poales" ~ "Liliopsida",
                strata == "Poaceae" ~ "Poaceae",
                strata == "PACMAD_clade" ~ "Poaceae",
                strata == "BOP_clade" ~ "Poaceae",
                strata == "Panicoideae" ~ "Poaceae",
                strata == "Andropogonodae" ~ "Poaceae",
                strata == "Andropogoneae" ~ "Andropogoneae",
                TRUE ~ "Species Specific"
            )
    ) %>%
    group_by(source, NewStrata) %>%
    mutate(GroupedGenes = sum(genes)) %>%
    mutate(Percentage = round(100 * GroupedGenes / SppTotal, 2)) %>%
    select("NewStrata", "GroupedGenes", "Percentage", "source") %>%
    distinct() %>%
    ungroup() %>%
    mutate(NewStrata = factor(NewStrata, levels = myStarta))

status_colors <- c("Helixer" = "#d79c3b", "NAM.v5" = "#a3c857")


ggplot(data = ps.collapsed, aes(x = NewStrata, y = Percentage, fill = source)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Genes in each strata (percent)", x = "", y = "Genes (%)") +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = status_colors) +
    scale_y_continuous(
        labels = scales::percent_format(scale = 1),
        expand = c(0, 0),
        limits = c(0, NA)
    ) +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), units = , "cm"),
        plot.title = element_text(
            size = 18,
            vjust = 0,
            hjust = 0
        ),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = "top",
        legend.key = element_blank()
    )

ggsave(
    "ps_percent.png",
    width = 12,
    height = 9,
    units = "in",
    dpi = 300
)



ggplot(data = ps.collapsed, aes(x = NewStrata, y = GroupedGenes, fill = source)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Genes in each strata (counts)", x = "", y = "Genes") +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = status_colors) +
    scale_y_continuous(
        labels = scales::comma,
        expand = c(0, 0),
        limits = c(0, NA)
    ) +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), units = , "cm"),
        plot.title = element_text(
            size = 18,
            vjust = 0,
            hjust = 0
        ),
        legend.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = "top",
        legend.key = element_blank()
    )


ggsave(
    "ps_counts.png",
    width = 12,
    height = 9,
    units = "in",
    dpi = 300
)
