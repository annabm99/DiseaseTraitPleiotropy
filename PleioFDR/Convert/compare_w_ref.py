# Libraries
import pandas as pd
import sys
import os

# Check the number of command-line arguments
if len(sys.argv) != 4:
    print("Usage: python script.py <input_file> <output_directory> <output_format>")
    sys.exit(1)

# Import variables
InputFile = sys.argv[1].rstrip()
RefFile = "/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/RefFiles/9545380.ref"
OutputDir = sys.argv[2].rstrip()
OutputFmt = sys.argv[3].rstrip()

# Check if the input file exists
if not os.path.isfile(InputFile):
    print("Error: Input file '{}' not found.".format(InputFile))
    sys.exit(1)

# Open sumstats and reference file
try:
    sumstats = pd.read_csv(InputFile,  compression='gzip', sep='\t', index_col=False, error_bad_lines=False, low_memory=False)
    ref=pd.read_csv(RefFile, sep='\t', index_col=False,  error_bad_lines=False, low_memory=False)

    print ("Number of initial rows ", len(sumstats))

    # Merge files by the variant column
    sumstats_filt = sumstats[sumstats['SNP'].isin(ref['SNP'])]

    # Remove duplicated SNPs
    sumstats_filt = sumstats_filt.drop_duplicates(subset=['SNP'])

    print ("Number of final rows: ", len(sumstats_filt))
        
    # Output merged file in csv format and compressed
    output_path = os.path.join(OutputDir, OutputFmt)
    sumstats_filt.to_csv(output_path, index=None, compression='gzip', sep='\t')
    print("Merged file saved to:", output_path)

    # Ouptut merged file in csv format and compressed
    # sumstats_filt.to_csv('{}/{}'.format(OutputDir, OutputFmt), index=None, compression='gzip', sep='\t')

except Exception as e:
    print("Error:", str(e))
    sys.exit(1)