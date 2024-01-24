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

print(f"Original columns: \n + {sumstats.iloc[:2]}")

### STEP 1: Filter for  rows containing rs... (SNP ids), and leave only the ID (they are separated by : from the rest)
sumstats = sumstats[sumstats["rs_id_all"].str.startswith('rs')]
sumstats["rs_id_all"] = sumstats["rs_id_all"].str.split(":").str[0]

### STEP 2: Compute the Z score (Beta/SE) because these summary statistics do not give this value in the sumstats
print("... Computing Z scores from Beta ...")
    # Convert log(OR) and SE columns to numeric
sumstats["beta"] = pd.to_numeric(sumstats['beta'], errors="coerce")
sumstats["standard_error"] = pd.to_numeric(sumstats['standard_error'], errors="coerce")
    # Compute Z score (new column)
sumstats["Z"] = sumstats['beta']/sumstats['standard_error']

print(sumstats.iloc[:2])

### STEP 3: Grab interest columns for LDSC and rename
print ('... Extracting interest columns ...')
sumstats = sumstats[["chromosome", "base_pair_location", "rs_id_all", "effect_allele", "other_allele", "p_value", "all_total", "Z"]]

print(sumstats.iloc[:2])

# Note: BETA is based on the effect allele, which will be assigned as A1
print('... Renaming columns ....')
sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "Z"]

print(sumstats.iloc[:2])

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")