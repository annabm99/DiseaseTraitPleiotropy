
print (" ____ PYTHON RUNNING ___")

# Libraries
import sys
import pandas as pd

InputPath = sys.argv[1].rstrip()
OutputDir = sys.argv[2].rstrip()

N = 446696 # total N of the experiment

print ("... Inputs loaded ...")

FileName = InputPath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name

print ("File name: " + FileName + "\nPhenotype: " + PhenName)

sumstats = pd.read_csv(InputPath, sep=" ", index_col=False, error_bad_lines=False, low_memory=False)

print(f"Original columns: \n {sumstats.iloc[:2]}")

## STEP 1: Add a new column with N_total
print("... Adding N_total column ...")
sumstats["N_total"] = N

## STEP 2: Compute the Z score (log(OR)/SE) because these summary statistics do not give this value in the sumstats
# Note: effect is based on the reference allele, so it does not have to be modified
print("... Computing Z scores from effect size ...")
    # Convert log(OR) and SE columns to numeric
sumstats["Effect"] = pd.to_numeric(sumstats["Effect"], errors="coerce")
sumstats["StdErr"] = pd.to_numeric(sumstats["StdErr"], errors="coerce")
    # Compute Z score (new column)
sumstats["Z"] = sumstats['Effect']/sumstats['StdErr']

print(sumstats.iloc[:2])

## STEP 3: Grab interest columns for LDSC and rename them
# Note: the chr and bp columns do not exist
print ('... Extracting interest columns ...')
sumstats = sumstats[["MarkerName", "Allele1", "Allele2", "P-value", "N_total", "Z"]]

print('... Renaming columns ....')
sumstats.columns=["SNP", "A1", "A2", "PVAL", "N", "Z"]

# Save as csv separated by tab to output directory
sumstats.to_csv(f'{OutputDir}/{PhenName}-formatted.gz', index=None, compression='gzip', sep='\t')
print(f"File saved to {OutputDir}/{PhenName}-formatted.gz")
