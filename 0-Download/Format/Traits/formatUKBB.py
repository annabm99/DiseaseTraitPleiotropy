print("____ PYTHON RUNNING ____")

import pandas as pd
import sys

# Check if the correct number of command-line arguments are provided
if len(sys.argv) != 4:
    print("Usage: python script.py <input_file> <name> <output_directory>")
    sys.exit(1)

try:
    InputFile = sys.argv[1].rstrip()
    Name = sys.argv[2].rstrip()
    OutputDir = sys.argv[3].rstrip()
    
    print("Input file: " + InputFile + "\nName: " + Name + "\nOutput directory: " + OutputDir)

    # Read the input file
    SumStats = pd.read_csv(InputFile, sep='\t', index_col=False, compression="gzip", error_bad_lines=False, low_memory=False)
    
    # Display first two rows of SumStats and selected columns
    print(SumStats.iloc[:2])
    print(SumStats[["beta"]].iloc[:2])

    # STEP 1: Grab interest columns for LDSC
    print ('... Extracting interest columns ...')
    SumStats = SumStats[["chr", "pos", "rsid", "alt", "ref", "n_complete_samples", "pval", "beta", "se", "info"]]
            # Note: The Neale Lab calculates beta scores based on the alternative allele. So alt column has to be A1.
    print(SumStats.iloc[:2])

    # STEP 2: Rename columns so LDSC can understand the input
    print('... Renaming columns ....')
    SumStats.columns=["CHR", "BP", "SNP", "A1", "A2", "N",  "PVAL", "BETA", "SE", "INFO"]

    print(SumStats.iloc[:2])

    # Write formatted data to output file
    output_path = "{}/{}-formatted.gz".format(OutputDir, Name)
    SumStats.to_csv(output_path, index=None, compression='gzip', sep='\t')

    print("Script execution completed successfully.")
    print("Output file saved at:", output_path)

except Exception as e:
    print("Error:", e)
    print("Script execution failed.")