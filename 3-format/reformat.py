#!/bin/python

# Libraries
import pandas as pd
import sys

# Import variables from reformat.sh script

inputFile = sys.argv[1]
inputFile=inputFile.rstrip()

variantsFile = sys.argv[2]
variantsFile=variantsFile.rstrip()

output_dir = sys.argv[3]
output_dir=output_dir.rstrip()

trait_code = sys.argv[4]
trait_code=trait_code.rstrip()

# Open original sumstats and variants file
sumstats = pd.read_csv(inputFile,  compression='gzip', sep='\t', index_col=False, error_bad_lines=False, low_memory=False)
variants=pd.read_csv(variantsFile, compression='gzip', sep='\t', index_col=False,  error_bad_lines=False, low_memory=False)

# Merge files by the variant column
sumstats= sumstats.merge(variants, on='variant')

# Ouptut merged file in csv format and compressed
sumstats.to_csv(f'{output_dir}/{trait_code}.gz', index=None, compression='gzip', sep='\t')