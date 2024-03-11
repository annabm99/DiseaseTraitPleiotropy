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

### STEP 2: Grab interest columns for LDSC and rename
print ('... Extracting interest columns ...')
sumstats = sumstats[["rs_id_all", "effect_allele", "other_allele", "p_value", "all_total", "beta", "standard_error"]]

print(sumstats.iloc[:2])

# STEP 3: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["SNP", "A1", "A2", "PVAL", "N", "BETA", "SE_BETA"]

print(sumstats.iloc[:2])

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")