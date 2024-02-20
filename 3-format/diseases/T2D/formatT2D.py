#!/bin/python

print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd

InputPath = sys.argv[1].rstrip()
print(f"Input path is {InputPath}")
MergeFile = sys.argv[2].rstrip()
print(f"Merge file is {MergeFile}")
OutputDir = sys.argv[3].rstrip()
print(f"Output directory is {OutputDir}")

N = 69033 # total N of the experiment

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
variantsMerge = pd.read_csv(MergeFile, sep="\t", compression="gzip", index_col=False, error_bad_lines=False, low_memory=False)

print(f"Original columns: \n + {sumstats.iloc[:2]}")

## STEP 1: MERGE WITH VARIANTS FILE
# 1.1. Remove unwanted part of the variant column in merge file (after :)
# Assign this to a new column with the same name as in sumstats dataframe
print("... Merging with variants file ...")
variantsMerge["SNP"] = variantsMerge["variant"].str.rsplit(":", 2).str[0]
print(variantsMerge.iloc[:2])
# 1.2. Merge with sumstats
sumstats= sumstats.merge(variantsMerge, on='SNP')

print(sumstats.iloc[:2])

## STEP 2: Add a new column with N_total
print("... Adding N_total column ...")
sumstats["N_total"] = N

## STEP 3: Compute the Z score (BETA/SE) because these summary statistics do not give this value in the sumstats
# Note: beta is based on the effect allele (EA), which will be assigned as A1
print("... Computing Z scores from beta ...")
    # Convert log(OR) and SE columns to numeric
sumstats["Beta"] = pd.to_numeric(sumstats["Beta"], errors="coerce")
sumstats["SE"] = pd.to_numeric(sumstats["SE"], errors="coerce")
    # Compute Z score (new column)
sumstats["Z"] = sumstats['Beta']/sumstats['SE']

print(sumstats.iloc[:2])

## STEP 3: Grab interest columns for LDSC and rename them
# Note: the chr and bp columns do not exist
print ('... Extracting interest columns ...')
sumstats = sumstats[["Chr", "Pos", "rsid", "EA", "NEA", "Pvalue", "N_total", "Z"]]

print('... Renaming columns ....')
sumstats.columns=["CHR", "POS", "SNP", "A1", "A2", "PVAL", "N", "Z"]

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")
