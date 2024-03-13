
print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd

InputPath = sys.argv[1].rstrip()
RefPath = sys.argv[2].rstrip()
OutputDir = sys.argv[3].rstrip()

N = 446696 # total N of the experiment

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep=" ", index_col=False, error_bad_lines=False, low_memory=False)
ref = pd.read_csv(RefPath, sep=" ", index_col=False, error_bad_lines=False, low_memory=False)

print(f"Original columns: \n {sumstats.iloc[:2]}")

## STEP 1: Add a new column with N_total
print("... Adding N_total column ...")
sumstats["N_total"] = N

## STEP 2: Merge with reference file with CHR and BP positions (from the rs column)
print ("... Merging through rsid column ...")
sumstats.rename(columns={'MarkerName': 'rsid'}, inplace=True)
sumstats= sumstats.merge(ref, on='rsid')

## STEP 3: Grab interest columns for LDSC and rename them
print ('... Extracting interest columns ...')
sumstats = sumstats[["chr", "pos", "rsid", "Allele1", "Allele2", "P-value", "N_total", "Effect", "StdErr"]]

# STEP 4: Rename columns so LDSC can understand the input
print('... Renaming columns ....')
sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "BETA", "SE"]

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")
