#!/bin/python

print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd
import numpy
from scipy.stats import norm

InputPath = sys.argv[1].rstrip()
print(f"Input path is {InputPath}")
OutputDir = sys.argv[2].rstrip()
print(f"Output directory is {OutputDir}")

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

print(f"Original columns: \n + {sumstats.iloc[:2]}")


## STEP 1: CALCULATE N_TOTAL
print("... Calculating N_total for each SNP ...")
    # Convert both N columns to numeric
sumstats["N_CASES"] = pd.to_numeric(sumstats['N_CASES'], errors="coerce")
sumstats["N_CONTROLS"] = pd.to_numeric(sumstats['N_CONTROLS'], errors="coerce")
    # Calculate N total to new column
sumstats[["N_TOTAL"]] = sumstats["N_CASES"] + sumstats["N_CONTROLS"]

## STEP 2: Compute the Z score (LOGOR/SE) because these summary statistics do not give this value in the sumstats
# Note: beta is based on the risk allele, which will be assigned as A1
# Note: we don't have the standard error (SE), so it will be calculated from the confidence limit (CL = logOR-logORL95) because CL = SE * 1.96

    # Convert OR  columns to numeric
# sumstats["OR"] = pd.to_numeric(sumstats["OR"], errors="coerce")
# sumstats["OR_95L"] = pd.to_numeric(sumstats["OR_95L"], errors="coerce")
    # Calculate logarithms
# sumstats["logOR"] = numpy.log(sumstats["OR"])
# sumstats["logOR_95L"] = numpy.log(sumstats["OR_95L"])

    # Calculate SE (SE = (logOR - logOR95L)/1.96)
# print("... Computing SE ...")
# sumstats["SE"] = (sumstats["logOR"]-sumstats["logOR_95L"])/1.96

    # Compute Z score from OR and SE (Z = log(OR)/SE)
# print("... Computing Z scores ...")
# sumstats["Z"] = sumstats["logOR"]/ sumstats['SE']

# print(sumstats.iloc[:2])

## TEST TO SEE IF Z IS CORRECT: Calculate p-value from Z
# sumstats["P_test"] = (1 - norm.cdf(abs(sumstats["Z"]))) * 2
# print(sumstats[["P_VALUE", "P_test"]].iloc[:10])

## STEP 2: Grab interest columns for LDSC and rename them
print ('... Extracting interest columns ...')
sumstats = sumstats[["CHROMOSOME", "POSITION", "SNP", "RISK_ALLELE", "OTHER_ALLELE", "P_VALUE", "N_TOTAL", "OR", "OR_95L", "OR_95U"]]

# STEP 3: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "OR", "ORL95", "ORU95"]

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")