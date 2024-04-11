import sys
import os
import pandas as pd

try:

    # Import data
    if len(sys.argv) < 3:
        raise ValueError("USAGE: separate_directionality.py <FilePath> <OutDir>")

    FilePath = sys.argv[1].rstrip()
    OutDir = sys.argv[2].rstrip()

    if not os.path.exists(FilePath):
        raise FileNotFoundError(f"The file '{FilePath}' does not exist.")
    
    print("Arguments imported correctly")

    df = pd.read_csv(FilePath, sep='\t')

    # Get Phenotype Codes
    file = os.path.basename(FilePath)
    parts = file.split("_")
    phen1, phen2 = [part for part in parts if any(c.isupper() for c in part)]

    # Check if phen1 and phen2 were retrieved correctly
    if not phen1 or not phen2:
        raise ValueError("Could not find phenotype codes in the file name.")

    print(f'First phenotype: {phen1}, Second phenotype: {phen2}')

    # Multiply Z score columns
    print("Multiplying z-score columns...")
    df['Z_PROD'] = df[f'ZSCORE_{phen1}'] * df[f'ZSCORE_{phen2}']

    # Split dataframe based on directionality
    positive_df = df[df['Z_PROD'] > 0]
    negative_df = df[df['Z_PROD'] < 0]

    # Save positive and negative datasets, in separate directories for each trait (phen2)

    # Select a name for the outputs
    out_path = os.sep.join(FilePath.split(os.sep)[-2:]) # Grab the final part of the path
    basename = os.path.basename(FilePath)
    prefix = basename.split("-")[0]

    # Check if the output directory exists, if not create it
    out_dir_compl = os.path.join(OutDir, phen2)

    if not os.path.exists(out_dir_compl):
        # Create the directory if it doesn't exist
        os.makedirs(out_dir_compl)
        print(f"Directory {out_dir_compl} created.")

    # Save files to this directory
    positive_file_path = os.path.join(out_dir_compl, f"{prefix}-positive.csv")
    negative_file_path = os.path.join(out_dir_compl, f"{prefix}-negative.csv")
    
    positive_df.to_csv(positive_file_path, index=False)
    negative_df.to_csv(negative_file_path, index=False)
    
    print(f"Positive dataset saved to: {positive_file_path}")
    print(f"Negative dataset saved to: {negative_file_path}")

except ValueError as ve:
    print("ValueError:", ve)
    sys.exit(1)
except FileNotFoundError as fe:
    print("FileNotFoundError:", fe)
    sys.exit(1)
except Exception as e:
    print("An error occurred:", e)
    sys.exit(1)
