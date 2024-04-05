# print ("    PYTHON SCRIPT RUNNING   ")

# # Libraries
# import sys
# import pandas as pd

# # Input variables
# InputPath = sys.argv[1].rstrip()
# print(f"Input path is {InputPath}")
# RefPath = sys.argv[2].rstrip()
# print(f"Reference path is {RefPath}")
# PhenName = sys.argv[3].rstrip()
# print(f"Phenotype is {PhenName}")
# OutputDir = sys.argv[4].rstrip()
# print(f"Output directory for ref alleles is {OutputDir}")

# # Read both files
# SumStats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
# RefSNPS = pd.read_csv(RefPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

# print(f"Sumstats dataframe: {SumStats.head()}")
# print(f"Reference dataframe: {RefSNPS.head()}")

# # Create an empty output dataframe
# OutSumstats = pd.DataFrame()

# # Iterate through each unique value in the ID column
# ids = SumStats['ID']
# print(f"There are {len(ids)} ids")

# # All possible names of the effect column:
# possible_effect_col = ['BETA', 'OR', 'EFFECT', "logOR"]
# # Grab the name assigned in this dataframe
# for p in possible_effect_col:
#     if p in SumStats.columns:
#         effect_col = p
#         break

# print (f"Effect column is {effect_col}")

# print("... Iterations starting now ...")

# for id in ids:
#     # Get the rows with the same ID value
#     row_input = SumStats[SumStats['ID'] == id]
#     row_reference = RefSNPS[RefSNPS['SNP'] == id]

#     # Skip line if ID is not present in the reference panel (row_reference is empty)
#     if row_reference.empty:
#         continue
#     # Check if the A1 and A2 values match
#     if (row_reference['A1'].values == row_input['A1'].values).all() and (row_reference['A2'].values == row_input['A2'].values).all():
#         # If alleles match, append the whole row to output_df
#         OutSumstats = pd.concat([OutSumstats, row_input], ignore_index=True)
#     else:
#         # If allele values do not match, check if they are inverted
#         if (row_reference['A1'].values == row_input['A2'].values).all() and (row_reference['A2'].values == row_input['A1'].values).all(): 
#             # Save the new A1 and A2 alleles, and invert effect size
#             new_A1 = str(row_input['A2'].values[0])
#             new_A2 = str(row_input['A1'].values[0])
#             new_EFFECT = row_input[effect_col].values[0]*-1
#             # Append row to output_df
#             OutSumstats = pd.concat([OutSumstats, row_input], ignore_index=True)
#             # Change values
#             OutSumstats.loc[OutSumstats['ID'] == id, 'A1'] = new_A1
#             OutSumstats.loc[OutSumstats['ID'] == id, 'A2'] = new_A2
#             OutSumstats.loc[OutSumstats['ID'] == id, effect_col] = new_EFFECT

# print("... Iterations done ....")
# # Save output dataframe to a csv file
# OutSumstats.to_csv(f'{OutputDir}/{PhenName}-allelesref.gz', index=None, compression='gzip', sep='\t')

print("PYTHON RUNNING")

# Libraries
import sys
import pandas as pd

def main():
    # Input variables
    InputPath, RefPath, PhenName, OutputDir = map(str.strip, sys.argv[1:5])
    print(f"Input path is {InputPath}")
    print(f"Reference path is {RefPath}")
    print(f"Phenotype is {PhenName}")
    print(f"Output directory for ref alleles is {OutputDir}")

    # Read both files
    SumStats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
    RefSNPS = pd.read_csv(RefPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

    print(f"Sumstats dataframe: {SumStats.head()}")
    print(f"Reference dataframe: {RefSNPS.head()}")

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

    print("... Iterations starting now ...")

    for id in SumStats[rsid_col].unique():
        # Get the rows with the same ID value
        row_input = SumStats[SumStats[rsid_col] == id]
        row_reference = RefSNPS[RefSNPS['SNP'] == id]

        # Skip line if ID is not present in the reference panel (row_reference is empty)
        if row_reference.empty:
            continue

        # Check if the A1 and A2 values match
        if (row_reference['A1'].values == row_input['A1'].values).all() and (row_reference['A2'].values == row_input['A2'].values).all():
            # If alleles match, append the whole row to output_df
            OutSumstats = pd.concat([OutSumstats, row_input], ignore_index=True)
        else:
            # If allele values do not match, check if they are inverted
            if (row_reference['A1'].values == row_input['A2'].values).all() and (row_reference['A2'].values == row_input['A1'].values).all():
                # Save the new A1 and A2 alleles, and invert effect size
                new_A1, new_A2 = map(str, row_input[['A2', 'A1']].values[0])
                new_EFFECT = row_input[effect_col].values[0] * -1
                # Append row to output_df
                OutSumstats = pd.concat([OutSumstats, row_input], ignore_index=True)
                # Change values
                mask = OutSumstats[rsid_col] == id
                OutSumstats.loc[mask, ['A1', 'A2']] = new_A1, new_A2
                OutSumstats.loc[mask, effect_col] = new_EFFECT

    print("... Iterations done ....")
    
    # Rename rsid column to ID so all datasets are the same
    OutSumstats = OutSumstats.rename(columns={rsid_col: 'ID'})

    # Save output dataframe to a csv file
    OutSumstats.to_csv(f'{OutputDir}/{PhenName}-allelesref.gz', index=None, compression='gzip', sep='\t')

if __name__ == "__main__":
    main()
