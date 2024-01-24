print("____ PYTHON RUNNING ____")

import pandas as pd
import sys

InputFile = sys.argv[1].rstrip()
Name=sys.argv[2].rstrip()
OutputDir = sys.argv[3].rstrip()

print ("Input file: " + InputFile + "\nName: " + Name + "\nOutput directory: " + OutputDir)

sumstats = pd.read_csv(InputFile, sep='\t', index_col=False, low_memory=False) # add compression='gzip', error_bad_lines=False

print(sumstats.iloc[:2])
print(sumstats[["beta"]].iloc[:2])

# STEP 1: Invert sign for BETA because Neale Lab calculates it based on the alternative allele
print("... Inverting BETA for reference allele ...")
sumstats["beta"] = pd.to_numeric(sumstats["beta"], errors="coerce") # Convert to numeric
sumstats[["beta"]]=sumstats[["beta"]].mul(-1) # Multiply by -1

print(sumstats[["beta"]].iloc[:2])

# STEP 2: Compute the Z score (BETA/SE) because Neale Lab does not give this value in the sumstats
print ('... Computing Z score from BETA and SE ...')
sumstats["se"] = pd.to_numeric(sumstats['se'], errors="coerce") # Convert to numeric
sumstats["Z"] = sumstats['beta']/sumstats['se'] # Divide and assign to new column Z

print(sumstats.iloc[:2])

# STEP 3: Grab interest columns for LDSC
print ('... Extracting interest columns ...')
sumstats = sumstats[["chr", "pos", "rsid", "ref", "alt", "pval", "n_complete_samples", "Z"]]

print(sumstats.iloc[:2])

# STEP 4: Rename columns so LDSC can understand the input
print('... Renaming columns ....')

sumstats.columns=["CHR", "BP", "SNP", "A1", "A2", "PVAL", "N", "Z"]

print(sumstats.iloc[:2])

sumstats.to_csv(f'{OutputDir}/{Name}-formatted.gz', index=None, compression='gzip', sep='\t')
