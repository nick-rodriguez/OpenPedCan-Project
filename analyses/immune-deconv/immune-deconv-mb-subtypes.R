# Load Libraries
suppressPackageStartupMessages({
  library(optparse)
  library(tidyverse)
})
source("util/heatmap_by_subtype.R")

# parse parameters
option_list <- list(
  make_option(c("--xcell_output_path"), type = "character",
              help = "path to xCell output"),
  make_option(c("--output_heatmap_path"), type = "character",)
  )

opt <- parse_args(OptionParser(option_list = option_list))
xcell_output_path <- opt$xcell_output_path
output_heatmap_path <- opt$output_heatmap_path

# Read in the output of 01-immune-deconv.R 
xcell_output <- readRDS(xcell_output_path)

# Select Medulloblastoma samples 
mb <- xcell_output %>% filter(cancer_group == 'Medulloblastoma')

# Make heatmap
heatmap_by_subtype(mb, annot_colors = NA, output_file = output_heatmap_path)

