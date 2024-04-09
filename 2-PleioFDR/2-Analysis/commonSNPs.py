import pandas as pd
import sys
import os

def process_dataframes(df1, df2):
    
    print("Processing dataframes \nInitial number of lines: {} {}".format(len(df1), len(df2)))

    # Remove duplicate SNPs in both dataframes
    print("Removing duplicates...")
    df1_unique = df1.drop_duplicates(subset=['SNP'])
    df2_unique = df2.drop_duplicates(subset=['SNP'])
    print("Number of lines after removing duplicates: {} {}".format(len(df1_unique), len(df2_unique)))

    # Intersect the two SNP columns to obtain common SNPs
    common_snps = set(df1_unique['SNP']).intersection(set(df2_unique['SNP']))

    # If no common SNPs, exit the program with an error
    if len(common_snps) == 0:
        print("Error: No common SNPs found. Exiting program.")
        exit(1)
    
    print("Number of common SNPs: {}".format(len(common_snps)))

    # Filter dataframes to include only rows with common SNPs
    common_df1 = df1_unique[df1_unique['SNP'].isin(common_snps)]
    common_df2 = df2_unique[df2_unique['SNP'].isin(common_snps)]
    print("Final number of lines: {} {}".format(len(common_df1), len(common_df2)))
    return common_df1, common_df2

if len(sys.argv) != 6:
    print("Usage: python commonsSNPs.py <df1_file> <df2_file> <phenotype_1> <phenotype_2> <output_dir>")
    sys.exit(1)

File1 = sys.argv[1].rstrip()
File2 = sys.argv[2].rstrip()
Phen1 = sys.argv[3].rstrip()
Phen2 = sys.argv[4].rstrip()
OutDir= sys.argv[5].rstrip()

# Check if the input files exist
if not os.path.exists(File1) or not os.path.exists(File2):
    print("Error: Input files not found.")
    sys.exit(1)

# Read dataframes from files
try:
    df1 = pd.read_csv(File1, sep='\t')
    df2 = pd.read_csv(File2, sep='\t')
except pd.errors.EmptyDataError:
    print("Error: Empty DataFrame(s) detected.")
    sys.exit(1)
except pd.errors.ParserError:
    print("Error: Unable to parse input files.")
    sys.exit(1)

print("{0} dataframe: {1} \n {2} dataframe: {3}".format(Phen1, df1.head(), Phen2, df2.head()))

# Process dataframes
common_df1, common_df2 = process_dataframes(df1, df2)

print("Finished processing the dataframes for common SNPs")

# Save common dataframes to separate files
try:
    common_df1.to_csv(os.path.join(OutDir, Phen1 + '-common.csv'), sep='\t', index=False)
    common_df2.to_csv(os.path.join(OutDir, Phen2 + '-common.csv'), sep='\t', index=False)
    print("Common SNP files saved successfully: ")
    print("File 1: {}".format(os.path.join(OutDir, Phen1 + '-common.csv')))
    print("File 2: {}".format(os.path.join(OutDir, Phen2 + '-common.csv')))
    
except IOError as e:
    print("Error writing output files:", e)
    sys.exit(1)

