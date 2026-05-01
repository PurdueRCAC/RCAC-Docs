library(devtools)
library(phylostratr)
library(reshape2)
library(taxizedb)
library(dplyr)
library(readr)
library(magrittr)
library(knitr)
library(ggtree)

setwd("/work/mash-covid/genespace/rstudio/r_4.3.1/helixer_panand_ps/zHelix")
focal_taxid <- "4577"

strata <-
    # Get stratified relatives represented in UniProt
    uniprot_strata(focal_taxid, from = 2) %>%
    # Select a diverse subset of 5 or fewer representatives from each stratum.
    strata_apply(f = diverse_subtree, n = 5, weights = uniprot_weight_by_ref()) %>%
    # Use a prebuilt set of prokaryotic species
    use_recommended_prokaryotes() %>%
    # Add yeast and human proteomes
    add_taxa(c("4932", "9606")) %>%
    # Download proteomes, storing the filenames
    uniprot_fill_strata()
strata <- prune(strata, "469616", type = "name")
strata <- prune(strata, "68525", type = "name")
strata <- prune(strata, "257005", type = "name")
results <- strata_blast(strata, blast_args = list(nthreads = 8)) %>%
    strata_besthits() %>%
    merge_besthits()
phylostrata <- stratify(results)
write.csv(phylostrata, "phylostrata_table.csv")
tabled <- table(stratify(results)$mrca_name)
write.csv(tabled, "phylostrata_stats.csv")
results <- strata_blast(strata, blast_args = list(nthreads = 8)) %>%
    strata_besthits() %>%
    merge_besthits()
phylostrata <- stratify(results)
write.csv(phylostrata, "phylostrata_table.csv")
tabled <- table(stratify(results)$mrca_name)
write.csv(tabled, "phylostrata_stats.csv")
