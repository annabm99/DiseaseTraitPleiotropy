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
    out_path = os.sep.join(FilePath.split(os.sep)[-2:]) # Grab the final part of the path
    no_suffix = "-".join(out_path.split("-", 2)[:2])

    positive_file_path = os.path.join(OutDir, f"/{phen2}/{no_suffix}-positive.csv")
    negative_file_path = os.path.join(OutDir, f"/{phen2}/{no_suffix}-negative.csv")
    
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
