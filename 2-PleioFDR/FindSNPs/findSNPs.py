import sys
import os
import pandas as pd

# Check if required arguments are provided
if len(sys.argv) != 4:
        print("Error: Invalid number of arguments.")
        print("Usage: python script.py PleiofdrFilePath RefFile OutDir")
        sys.exit(1)

# Load inputs
print("Loading data...")
PleiofdrFilePath=sys.argv[1].rstrip()
RefFile=sys.argv[2].rstrip()
OutDir=sys.argv[3].rstrip()

# Load conjfdr results
try:
    df = pd.read_csv(PleiofdrFilePath, sep=",")
except Exception as e:
    print(f"Error loading Pleiofdr file: {e}")
    sys.exit(1)

# Load the reference file
try:
    ref = pd.read_csv(RefFile, sep="\t")
except Exception as e:
    print(f"Error loading reference file: {e}")
    sys.exit(1)

# Remove empty columns from the conjfdr dataframe
df = df.drop(['snpid', 'geneid', 'A1', 'A2'], axis=1)

# Get the phenotype codes
file = os.path.basename(PleiofdrFilePath)
parts = file.split("_")
phen1, phen2 = [part for part in parts if any(c.isupper() for c in part)]

# Check if phen1 and phen2 were retrieved correctly
if not phen1 or not phen2:
    print ("Could not find phenotype codes in the file name.")
    sys.exit(1)

print(f'First phenotype: {phen1}, Second phenotype: {phen2}')

# Change column names
df.columns=('NUM', 'CHR', 'BP', f'ZSCORE_{phen1}', f'ZSCORE_{phen2}', 'CONJFDR', 'PRUNE', 'MIN_CONJFDR', f'PVAL_{phen1}', f'PVAL_{phen2}', )

# Merge the data with the reference file
print("Merging with reference...")
try:
    df_merge = pd.merge(df, ref, on=['CHR', 'BP'])
except Exception as e:
    print(f"Error merging data with reference file: {e}")
    sys.exit(1)

# Get phenotype names and their directory
try:
    path_parts = PleiofdrFilePath.split(os.sep) # Split the path into components
    out_path = os.sep.join(path_parts[9:11]) # Grab the part of the path for output
except Exception as e:
    print(f"Error processing file path: {e}")
    sys.exit(1)

print("Saving the generated files...")

# Save the dataframe with rsids
try:
    df_merge.to_csv(f'{OutDir}{out_path}-sigificant.csv', index=False, sep='\t')
except Exception as e:
    print(f"Error saving significant data: {e}")
    sys.exit(1)

# Save rsid list
try:
    df_merge['SNP'].to_csv(f'{OutDir}{out_path}-SNPs.csv', index=False, header=False, sep='\n')
except Exception as e:
    print(f"Error saving SNP list: {e}")
    sys.exit(1)

print(f"Meged dataframe saved at: {os.path.join(OutDir, f'{out_path}-significant.csv')}")
print(f"rsID list saved at: {os.path.join(OutDir, f'{out_path}-SNPs.csv')}")