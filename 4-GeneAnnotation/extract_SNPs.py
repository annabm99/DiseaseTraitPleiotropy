import pandas as pd
import os
import sys

try: 
    # Check if the correct number of arguments are provided
    if len(sys.argv) < 3:
        raise ValueError("Usage: python script.py <InputFile> <OutDir>")
    InputFile=sys.argv[1].rstrip()
    OutDir = sys.argv[2].rstrip()

    # Check if input file exists
    if not os.path.exists(InputFile):
        raise FileNotFoundError(f"The file '{InputFile}' does not exist.")

    # Read the DataFrame
    df = pd.read_csv(InputFile)

    # Extract the SNP column
    print("Extracting rsid column...")
    rsIDs = df["SNP"].tolist()

    # Get output file name
    # Get the filename (last part of the path)
    # Last part of file path
    out_path = os.sep.join(InputFile.split(os.sep)[-2:]) # Grab the final part of the path
    no_suffix = out_path.split(".")[0]

    # Create output file path
    outfile = os.path.join(OutDir, f"{no_suffix}IDs.txt")

    # Save the SNP data to the output file
    print(f"Writing rsIDs to output file...")
    with open(outfile, "w") as f:
        for rsID in rsIDs:
            f.write("%s\n" % rsID)

    print(f"Successfully wrote rsIDs to {outfile}.")

# Error catching
except ValueError as ve:
    print("ValueError:", ve)
    sys.exit(1)
except FileNotFoundError as fe:
    print("FileNotFoundError:", fe)
    sys.exit(1)
except Exception as e:
    print("An error occurred:", e)
    sys.exit(1)