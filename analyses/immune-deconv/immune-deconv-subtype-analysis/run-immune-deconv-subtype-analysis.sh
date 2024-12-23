#!/bin/bash
# Module author: Bicna Song
# 2024-12

# This script runs the steps to analyze immune cell distribution across medulloblastoma subtypes using quanTIseq results. 

set -e
set -o pipefail

# This script should always run as if it were being called from
# the directory it lives in.
script_directory="$(perl -e 'use File::Basename;
  use Cwd "abs_path";
  print dirname(abs_path(@ARGV[0]));' -- "$0")"
cd "$script_directory" || exit

echo "analyze immune cell distribution..."
Rscript --vanilla 02-immune-deconv-subtype-analysis.R \
--output_dir 'plots' \
--quantiseq_output '../results/quantiseq_output.rds'

