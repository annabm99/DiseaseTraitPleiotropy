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

# STEP 1: Calculate total N (N_Cases + N_Control)
print("... Calculating N total ...")
    # Convert both N columns to numeric
sumstats["N_case"] = pd.to_numeric(sumstats['N_case'], errors="coerce")
sumstats["N_control"] = pd.to_numeric(sumstats['N_control'], errors="coerce")
    # Calculate N total to new column
sumstats[["N_total"]] = sumstats["N_case"] + sumstats["N_control"]

print(sumstats.iloc[:2])

# STEP 2: Grab interest columns for LDSC
print ('... Extracting interest columns ...')
sumstats = sumstats[["chr_pos_(b36)", "SNP", "reference_allele", "other_allele", "pvalue", "N_total", "log_odds", "log_odds_se"]]

print(sumstats.iloc[:2])

# STEP 3: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["CHRPOS", "SNP", "A1", "A2", "PVAL", "N", "logOR", "SE"]

print(sumstats.iloc[:2])

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")