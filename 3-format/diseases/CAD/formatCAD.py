#!/bin/python

print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd

InputPath = sys.argv[1].rstrip()
OutputDir = sys.argv[2].rstrip()

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

print(f"Original columns: \n {sumstats.iloc[:2]}")

# Note: OR is based on the reference allele, so it does not have to be modified
# STEP 1: Compute the Z score (log(OR)/SE) because these summary statistics do not give this value in the sumstats
print("... Computing Z scores from odds ratio ...")
    # Convert log(OR) and SE columns to numeric
sumstats["log_odds"] = pd.to_numeric(sumstats["log_odds"], errors="coerce")
sumstats["log_odds_se"] = pd.to_numeric(sumstats["log_odds_se"], errors="coerce")
    # Compute Z score (new column)
sumstats["Z"] = sumstats['log_odds']/sumstats['log_odds_se']

# STEP 2: Calculate total N (N_Cases + N_Control)
print("... Calculating N total ...")
    # Convert both N columns to numeric
sumstats["N_case"] = pd.to_numeric(sumstats['N_case'], errors="coerce")
sumstats["N_control"] = pd.to_numeric(sumstats['N_control'], errors="coerce")
    # Calculate N total to new column
sumstats[["N_total"]] = sumstats["N_case"] + sumstats["N_control"]

# STEP 3: Separate chromosome and base pair as two columns
print("... Separating chr and pos to two different columns ...")
sumstats[["chr", "pos"]] = sumstats["chr_pos_(b36)"].str.split(":", expand=True)

print(sumstats.iloc[:2])

# STEP 3: Grab interest columns for LDSC
print ('... Extracting interest columns ...')
sumstats = sumstats[["chr", "pos", "SNP", "reference_allele", "other_allele", "pvalue", "N_total", "Z"]]

print(sumstats.iloc[:2])

# STEP 4: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "Z"]

print(sumstats.iloc[:2])

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")