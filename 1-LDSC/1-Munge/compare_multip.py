print("PYTHON RUNNING")

# Libraries
import sys
import pandas as pd
from multiprocessing import Pool

def process_id(id):
    # Get the rows with the same ID value
    row_input = SumStats[SumStats[rsid_col] == id]
    row_reference = RefSNPS[RefSNPS['SNP'] == id]

    # Skip line if ID is not present in the reference panel (row_reference is empty)
    if row_reference.empty:
        print(f"{id} not found")
        return pd.DataFrame()

    # Check if the A1 and A2 values match
    if (row_reference['A1'].values == row_input['A1'].values).all() and (row_reference['A2'].values == row_input['A2'].values).all():
        # If alleles match, return the whole row
        print(f"{id} matched perfectly: {row_input}, {row_reference}")
        return row_input
    else:
        # If allele values do not match, check if they are inverted
        if (row_reference['A1'].values == row_input['A2'].values).all() and (row_reference['A2'].values == row_input['A1'].values).all():
            print(f"{id} is inverted: {row_input}, {row_reference}")
            # Save the new A1 and A2 alleles, and invert effect size
            new_A1, new_A2 = map(str, row_input[['A2', 'A1']].values[0])
            new_EFFECT = row_input[effect_col].values[0] * -1
            # Change values
            row_input.loc[:, ['A1', 'A2']] = new_A1, new_A2
            row_input.loc[:, effect_col] = new_EFFECT
            return row_input
        else:
            return pd.DataFrame()

# Input variables
InputPath, RefPath, PhenName, OutputDir = map(str.strip, sys.argv[1:5])
print(f"Input path is {InputPath}")
print(f"Reference path is {RefPath}")
print(f"Phenotype is {PhenName}")
print(f"Output directory for ref alleles is {OutputDir}")

# Read both files
SumStats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
RefSNPS = pd.read_csv(RefPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

# Create a subset of 100 SNPs for testing
SumStats = SumStats.head(10000)

# Create an empty output dataframe
OutSumstats = pd.DataFrame()

# All possible names of the effect column:
possible_effect_col = ['BETA', 'OR', 'EFFECT', "logOR"]
# Grab the name assigned in this dataframe
effect_col = next((p for p in possible_effect_col if p in SumStats.columns), None)
if effect_col is not None:
    print(f"Effect column is {effect_col}")
else:
    # Exit with an error if the effect row is not present
    print("Effect column not found in SumStats")
    sys.exit(1)

# All possible names of the rsid column:
possible_rsid_col = ['ID', 'SNP']
# Grab the name assigned in this dataframe
rsid_col = next((p for p in possible_rsid_col if p in SumStats.columns), None)
if rsid_col is not None:
    print(f"Rsid column is {rsid_col}")
else:
    # Exit with an error if the effect row is not present
    print("Effect column not found in SumStats")
    sys.exit(1)

# List of unique IDs
unique_ids = SumStats[rsid_col].unique()

# Number of processes to use (adjust as needed)
num_processes = 2
print(f"Number of processes: {num_processes}, number of snps: {len(SumStats)}")

print("... Iterations starting now ...")
with Pool(num_processes) as pool:
    print(f"Pool is {pool}")
    result = pool.map(process_id, unique_ids)
    print(f"Result for pool {pool} is {result}")
    OutSumstats = pd.concat([df for df in result if not df.empty], ignore_index=True)
    print(f"Output dataframe is {OutSumstats}")

print("... Iterations done ....")

# Rename rsid column to ID so all datasets are the same
OutSumstats = OutSumstats.rename(columns={rsid_col: 'ID'})

# Save output dataframe to a csv file
OutSumstats.to_csv(f'{OutputDir}/{PhenName}-allelesref.gz', index=None, compression='gzip', sep='\t')

