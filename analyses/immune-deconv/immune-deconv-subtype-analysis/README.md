## Immune Cell Distribution Across Medulloblastoma Subtypes

**Module authors:** Bicna Song ([@bicnasong](https://github.com/bicnasong))

### Description

The goal of this analysis is to explore and compare immune cell type distributions across medulloblastoma subtypes (WNT, SHH, Group3, Group4) using **quanTIseq** output data. This analysis evaluates immune cell type proportions, overall subtype differences, and pairwise comparisons for each immune cell type.

Three primary analyses were conducted:
	1.	**Proportions of Immune Cell Types**: Visualize the relative contribution of each immune cell type across medulloblastoma subtypes using stacked bar plots.
	2.	**Subtype Differences Using ANOVA**: Test for significant overall differences in immune cell distributions across subtypes using ANOVA and display results on bar plots.
	3.	**Pairwise Comparisons for Each Immune Cell Type**: Perform pairwise t-tests for each immune cell type across all medulloblastoma subtypes and generate detailed boxplots.

### Method selection

The method **quanTIseq** was used for immune cell deconvolution. This method provides absolute scores that are interpretable as cell fractions, allowing comparisons both across samples and immune cell types.

The analysis focuses on medulloblastoma subtypes and excludes:
	•	Non-medulloblastoma subtypes.
	•	The immune cell type "uncharacterized cell" to ensure clean and interpretable results.
	
### Analysis scripts

#### 02-immune-deconv-subtype-analysis.R

**Inputs**

	1.	quantiseq_output.rds: Immune cell deconvolution results from the quantiseq method.
	2.	Predefined medulloblastoma subtypes:
	•	"MB, WNT", "MB, SHH", "MB, Group3", "MB, Group4"
	
**Function**

This script performs the following:
	1.	Filters for medulloblastoma subtypes and removes "uncharacterized cell".
	2.	Reorders subtypes for consistent visual representation.
	3.	Conducts three analyses:
	•	**Proportions**: Calculates the relative proportion of immune cell types across subtypes and visualizes the results as stacked bar plots.
	•	**ANOVA Bar Plot**: Tests for overall subtype differences using ANOVA and annotates the p-values on a bar plot.
	•	**Pairwise Comparisons**: Generates pairwise t-tests for each immune cell type across subtypes, producing boxplots annotated with significance levels.	

**Outputs**

	1.	Proportion Plot:
	•	File: plots/proportion_immune_cell_types.pdf
	•	Visualization: Stacked bar plot showing proportions of immune cell types across subtypes.
	2.	Bar Plot with ANOVA P-Values:
	•	File: plots/barplot_with_anova.pdf
	•	Visualization: Bar plot of immune cell fractions annotated with ANOVA p-values for subtype differences.
	3.	Pairwise Comparison Plots:
	•	Files: plots/immune_cell_distribution_<immune_cell_type>.pdf
	•	Visualization: Boxplots for each immune cell type, showing pairwise t-test results across subtypes.
	
**Output Example**

```
plots/
├── proportion_immune_cell_types.pdf
├── barplot_with_anova.pdf
├── immune_cell_distribution_Monocyte.pdf
├── immune_cell_distribution_Neutrophil.pdf
└── immune_cell_distribution_B_cell.pdf
```

### Running the analysis

To execute the analysis, ensure the required input file (quantiseq_output.rds) is in place. Then run the following script:

```
bash run-immune-deconv-subtype-analysis.sh
```

