#!/bin/python

# Libraries
import sys
import pandas as pd

# InputPath = sys.argv[1].rstrip()
# print(f"Input path is {InputPath}")
# RefPath = sys.argv[1].rstrip()
# print(f"Reference path is {RefPath}")
# OutputDir = sys.argv[2].rstrip()
# # print(f"Output directory is {OutputDir}")

# print ("... Inputs loaded ...")

# FileName = InputPath.split("/")[-1] # Last item in the path
# PhenName = FileName.split(".")[0] # First part of the file name

# print ("File name: " + FileName + "\nPhenotype: " + PhenName)

# Read both files
# SumStats = pd.read_csv(InputPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)
# RefSNPS = pd.read_csv(RefPath, sep="\t", index_col=False, error_bad_lines=False, low_memory=False)

#################################### CHATGTP ##########################################

# Sample dataframes with adjusted names and additional 'EFFECT' column in input_df
data_reference = {'ID': ['rs123', 'rs456', 'rs231', 'rs101'],
                  'A1': ['C', 'G', 'T', 'C']}
reference_df = pd.DataFrame(data_reference)

data_input = {'ID': ['rs123', 'rs231', 'rsABC', 'rs101'],
               'A1': ['C', 'X', 'A', 'T'],
               'A2': ['A', 'X', 'G', 'C'],
               'EFFECT': [-0.5, 0.8, -0.2, 0.9]}
input_df = pd.DataFrame(data_input)

# Create an empty output dataframe
output_df = pd.DataFrame(columns=['ID', 'A1', 'A2', 'EFFECT'])

# Iterate through each unique value in the ID column
ids = reference_df['ID']

for id in ids:
    # Get the rows with the same ID value
    row_reference = reference_df[reference_df['ID'] == id]
    row_input = input_df[input_df['ID'] == id]

    # Check if the 'A1' values match
    if row_reference['A1'].values == row_input['A1'].values:
        # If 'A1' values match, append the whole row to output_df
        print(f"A1 match: {row_reference['A1'].values}, {row_input['A1'].values}")
        output_df = pd.concat([output_df, row_input], ignore_index=True)
    else:
        # If 'A1' values do not match, check if the values in A1 and A2 match
        if row_reference['A1'].values == row_input['A2'].values:
            print(f"A1 from ref matches A2 from input: {row_reference['A1'].values}, {row_input['A2'].values}")
            print(f"A2 will be converted to A1 from input: {row_input['A1'].values}")
            # Append to output_df with A1 from reference_df and inverted EFFECT
            output_df = pd.concat([output_df, pd.DataFrame({'ID': [id], 'A1': row_reference['A1'].values,
                                                             'A2': row_input['A1'].values,
                                                             'EFFECT': [-1 * row_input['EFFECT'].values[0]]})],
                                  ignore_index=True)

# Print the resulting output_df
print(output_df)
