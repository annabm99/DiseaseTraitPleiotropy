#!/bin/python

print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd

InputPath = sys.argv[1].rstrip()
RefPath=sys.argv[2].rstrip()
OutputDir = sys.argv[3].rstrip()

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
ref = pd.read_csv(RefPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

print("Original columns:\n" + str(sumstats.iloc[:2]))

### STEP 1: Filter for  rows containing rs... (SNP ids), and leave only the ID (they are separated by : from the rest)
sumstats = sumstats[sumstats["rs_id_all"].str.startswith('rs')]
sumstats["rs_id_all"] = sumstats["rs_id_all"].str.split(":").str[0]

### STEP 2: Grab interest columns for LDSC and rename
print ('... Extracting interest columns ...')
sumstats = sumstats[["chromosome", "base_pair_location", "rs_id_all", "effect_allele", "other_allele", "p_value", "all_total", "beta", "standard_error", "info_all"]]
sumstats= sumstats.merge(ref, on='variant')
print(sumstats.iloc[:2])

# STEP 3: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "BETA", "SE_BETA", "INFO"]

print(sumstats.iloc[:2])

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print("File saved to {}/{}-formatted.gz".format(OutputDir, PhenName))
