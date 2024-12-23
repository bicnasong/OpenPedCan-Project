# Author: Bicna Song
# script to analyze immune cell distribution across medulloblastoma subtypes using quanTIseq results

# load required libraries
library(optparse)
library(tidyverse)
library(readr)
library(ggpubr)

# parse parameters
option_list <- list(
  make_option(c("--output_dir"), type = "character", 
              help = "output directory"),
  make_option(c("--quantiseq_output"), type = "character",
              help = "quantiseq output file (.rds)")
)

opt <- parse_args(OptionParser(option_list = option_list))
output_dir <- opt$output_dir
quantiseq_output <- opt$quantiseq_output

# create output directory
dir.create(output_dir, showWarnings = F, recursive = T)

# ------------------------------
# Data Preparation
# ------------------------------
# Description: Read the quantiseq output and prepare the data by filtering for medulloblastoma
# subtypes, removing "uncharacterized cell", and reordering molecular subtypes.

# read quantiseq output 
quantiseq_output <- readRDS(quantiseq_output)

# filter and prepare data
filtered_results <- quantiseq_output %>%
  filter(
    molecular_subtype %in% c("MB, WNT", "MB, SHH", "MB, Group3", "MB, Group4"),
    cell_type != "uncharacterized cell"
  ) %>%
  mutate(
    molecular_subtype = factor(
      molecular_subtype,
      levels = c("MB, WNT", "MB, SHH", "MB, Group3", "MB, Group4")
    )
  )

# ------------------------------
# 1. Plot Proportions
# ------------------------------
# Description: Calculate and visualize the proportion of each immune cell type
# across medulloblastoma subtypes as stacked bar plots.

# calculate proportions of immune cell types across subtypes
proportion_data <- filtered_results %>%
  group_by(molecular_subtype, cell_type) %>%
  summarize(mean_fraction = mean(fraction, na.rm = TRUE), .groups = "drop")

# generate the bar plot for proportions
proportion_plot <- ggplot(proportion_data, aes(x = molecular_subtype, y = mean_fraction, fill = cell_type)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(
    title = "Proportion of Immune Cell Types Across Medulloblastoma Subtypes",
    x = "Molecular Subtype",
    y = "Proportion",
    fill = "Immune Cell Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save the plot
print("Writing output to file for proportion plot...")
file_name <- file.path(output_dir, paste0("proportion_immune_cell_types.pdf"))
ggsave(file_name, proportion_plot, width = 10, height = 6)
print("Done!")

# ------------------------------
# 2. Bar Plot with ANOVA P-Values
# ------------------------------
# Description: Create bar plots for all immune cell types across subtypes and
# annotate the plots with ANOVA p-values to test for overall differences.

bar_plot <- ggplot(filtered_results, aes(x = cell_type, y = fraction, fill = molecular_subtype)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  stat_compare_means(
    method = "anova",
    label = "p.format",
    aes(group = molecular_subtype),
    label.y.npc = "top"
  ) +
  labs(
    title = "Immune Cell Distribution Across Medulloblastoma Subtypes",
    x = "Immune Cell Type",
    y = "Fraction",
    fill = "Molecular Subtype"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save the plot
print("Writing output to file for bar plot...")
file_name <- file.path(output_dir, paste0("barplot_with_anova.pdf"))
ggsave(file_name, bar_plot, width = 12, height = 6)
print("Done!")

# ------------------------------
# 3. Pairwise Comparisons for All Immune Cell Types
# ------------------------------
# Description: Perform pairwise comparisons for all immune cell types in the data
# and save individual boxplots for each cell type.

# get the unique immune cell types
immune_cell_types <- unique(filtered_results$cell_type)

# loop through each immune cell type
for (immune_type in immune_cell_types) {
  
  # filter data for the specific immune cell type
  filtered_immune_data <- filtered_results %>%
    filter(cell_type == immune_type)
  
  # generate the boxplot with pairwise t-tests
  pairwise_plot <- ggplot(filtered_immune_data, aes(x = molecular_subtype, y = fraction, fill = molecular_subtype)) +
    geom_boxplot(outlier.shape = NA) + 
    geom_jitter(width = 0.2, alpha = 0.5) + 
    stat_compare_means(
      method = "t.test", 
      label = "p.signif", 
      comparisons = list(
        c("MB, WNT", "MB, SHH"),       # compare WNT vs SHH
        c("MB, WNT", "MB, Group3"),    # compare WNT vs Group3
        c("MB, WNT", "MB, Group4"),    # compare WNT vs Group4
        c("MB, SHH", "MB, Group3"),    # compare SHH vs Group3
        c("MB, SHH", "MB, Group4"),    # compare SHH vs Group4
        c("MB, Group3", "MB, Group4")  # compare Group3 vs Group4
      )
    ) +
    labs(
      title = paste("Distribution of", immune_type, "Across Subtypes"),
      x = "Molecular Subtype",
      y = "Fraction of Immune Cells"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none" # Remove legend for simplicity
    )
  
  # save the plot for the current immune cell type
  print("Writing output to file for pairwise comparisons...")
  file_name <- file.path(output_dir, paste0("immune_cell_distribution_", gsub(" ", "_", immune_type), ".pdf"))
  ggsave(file_name, pairwise_plot, width = 8, height = 6)
  print("Done!")
}

