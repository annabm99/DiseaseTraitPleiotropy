print("____ PYTHON RUNNING ____")

import pandas as pd
import sys

InputFile = sys.argv[1].rstrip()
Name=sys.argv[2].rstrip()
OutputDir = sys.argv[3].rstrip()

print ("Input file: " + InputFile + "\nName: " + Name + "\nOutput directory: " + OutputDir)

SumStats = pd.read_csv(InputFile, sep='\t', index_col=False, compression="gzip", error_bad_lines=False, low_memory=False)
print(SumStats.iloc[:2])
print(SumStats[["beta"]].iloc[:2])

# STEP 1: Invert sign for BETA because Neale Lab calculates it based on the alternative allele
#sumstats["beta"] = pd.to_numeric(sumstats["beta"], errors="coerce") # Convert to numeric
#sumstats[["beta"]]=sumstats[["beta"]].mul(-1) # Multiply by -1

#print(sumstats[["beta"]].iloc[:2])

# STEP 1: Grab interest columns for LDSC
print ('... Extracting interest columns ...')
SumStats = SumStats[["rsid", "ref", "alt", "n_complete_samples", "pval", "beta", "se"]]

print(SumStats.iloc[:2])

# STEP 2: Rename columns so LDSC can understand the input
print('... Renaming columns ....')

SumStats.columns=["ID", "A1", "A2", "N",  "PVAL", "BETA", "SE"]

print(SumStats.iloc[:2])

SumStats.to_csv(f'{OutputDir}/{Name}-formatted.gz', index=None, compression='gzip', sep='\t')
