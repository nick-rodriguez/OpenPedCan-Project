#!/bin/bash
# Module author: Komal S. Rathi, updated Kelsey Keith
# 2022-07

# This script generates a heatmap for medulloblastoma sutypes. 

set -e
set -o pipefail

# This script should always run as if it were being called from
# the directory it lives in.
script_directory="$(perl -e 'use File::Basename;
  use Cwd "abs_path";
  print dirname(abs_path(@ARGV[0]));' -- "$0")"
cd "$script_directory" || exit

### 
# generate deconvolution output
echo "Heatmap MB Subtypes"
Rscript --vanilla immune-deconv-mb-subtypes.R \
--xcell_output_path 'results/xcell_output.rds' \
--output_heatmap_path 'results/heatmap_mb_subtypes.png'
