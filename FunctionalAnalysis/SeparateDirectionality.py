import sys
import os
import pandas as pd

try:

    # Import data
    if len(sys.argv) < 3:
        raise ValueError("USAGE: directionality.py <FilePath> <OutDir>")

    FilePath=sys.argv[1].rstrip()
    OutDir=sys.argv[2].rstrip()

    if not os.path.exists(FilePath):
        raise FileNotFoundError(f"The file '{FilePath}' does not exist.")
    
    print("Arguments imported correctly")

    df=pd.read_csv(FilePath, sep='\t')

    # Get Phenotype Codes
    file = os.path.basename(FilePath)
    parts = file.split("_")
    phen1, phen2 = [part for part in parts if any(c.isupper() for c in part)]

    # Check if phen1 and phen2 were retrieved correctly
    if not phen1 or not phen2:
        raise ValueError("Could not find phenotyp codes in the file name.")

    print(f'First phenotype: {phen1}, Second phenotype: {phen2}')

    # Multiply Z score columns
    print("Multiplying z-score columns...")
    df['Z_PROD'] = df[f'ZSCORE_{phen1}'] * df[f'ZSCORE_{phen2}']

    # Separate the DataFrame into two DataFrames
    df_positive = df[df['col'] < 0]
    df_negative = df[df['col'] > 0]

    # Write report
    print("Writing report...")
    report = f"Positive (synergistic) pleiotropies: {positive_count}\n"
    report += f"Negative (antagonistic) pleiotropies: {negative_count}\n"
    report += f"Total pleiotropies: {positive_count + negative_count}\n"

    # Save report to a file in the output directory
    out_path = os.sep.join(FilePath.split(os.sep)[-2:]) # Grab the final part of the path
    no_suffix = "-".join(out_path.split("-", 2)[:2])
    report_path = os.path.join(OutDir, f"{no_suffix}-directionality.txt")
    with open(report_path, "w") as report_file:
        report_file.write(report)
        print(f"Report written to: {report_path}")

# Catch exceptions and exit with non-zero status indicating an error
except ValueError as ve:
    print("ValueError:", ve)
    sys.exit(1)
except FileNotFoundError as fe:
    print("FileNotFoundError:", fe)
    sys.exit(1)
except Exception as e:
    print("An error occurred:", e)
    sys.exit(1)