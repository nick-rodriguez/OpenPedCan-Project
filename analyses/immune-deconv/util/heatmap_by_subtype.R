# Create a heatmap from `molecular_subtype` of immunedeconv output.
# Modified from https://github.com/rokitalab/OpenPedCan-Project/blob/dev/analyses/immune-deconv/util/heatmap_by_group.R
# Assumes deconv data is filtered for a single `cancer_group`. 

# load libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(pheatmap)
})

# function to create heatmap of average immune scores per cell type per cancer and gtex group 
heatmap_by_subtype <- function(deconv_output, annot_colors, output_file) {
  
  # create a generalized group column
  deconv_output <- deconv_output %>%
    mutate(group = ifelse(cohort == "GTEx", gtex_group, cancer_group))
  
  # create labels: count of samples per group
  deconv_output <- deconv_output %>%
    group_by(group, cell_type) %>%
    unique() %>%
    mutate(label = n()) %>%
    mutate(label = molecular_subtype)

  # calculate mean scores per cell type per histology
  deconv_output <- deconv_output %>%
    filter(!cell_type %in% c("microenvironment score", "stroma score", "immune score")) %>%
    group_by(cell_type, label) %>%
    dplyr::summarise(mean = mean(fraction))

  # convert into matrix of cell type vs histology
  deconv_output <- deconv_output %>%
    spread(key = label, value = mean) %>%
    column_to_rownames('cell_type')

  # heatmap of average immune scores per cell type per cancer and gtex group
  deconv_output %>%
    t() %>%
    pheatmap(scale = "column", angle_col = 45,
             main = "Average Immune scores",
             annotation_row = NA, annotation_colors = annot_colors,
             annotation_legend = T, cellwidth = 14, cellheight = 10,
             filename = output_file)
}