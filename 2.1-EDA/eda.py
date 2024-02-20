
print ("____ PYTHON RUNNING ____")

import sys
import pandas as pd
import gwaslab as gl

print("Reading input arguments...")
FilePath = sys.argv[1].rstrip()
OutputDir = sys.argv[2].rstrip()

FileName = FilePath.split("/")[-1] # Last item in the path
PhenName = FileName.split(".")[0] # First part of the file name
print("FILE NAME IS " + FileName)
print("PHENOTYPE IS " + PhenName)

# Read summary statistics as dataframe
print("Importing summary statistics...")
sumstats=pd.read_csv(FilePath, sep="\t", index_col=False, low_memory=False) # add: compression = "gzip", error_bad_lines=False

# Convert MAF column to numeric
sumstats["MAF"] = pd.to_numeric(sumstats["MAF"], errors="coerce")

print("Calculating reference allele frequencies...")
# Create a new empty column for reference allele frequency
sumstats["ref_freq"] = pd.Series(dtype='float')

# If minor allele matches reference allele, assign the same frequency in the new column
# Otherwise calculate reference allele frequency by doing 1-MAF
for i in sumstats.index:
    if sumstats["minor"][i] == sumstats["ref"][i]:
        sumstats["ref_freq"][i] = sumstats["MAF"][i]
    else:
        sumstats["ref_freq"][i] = 1-sumstats["MAF"][i]

print("Loading gwaslab object...")
# Convert sumstats to gwaslab object
sumstats = gl.Sumstats(FilePath,
             snpid="risid",
             chrom="chr",
             pos="pos",
             ea="alt", # alt allele is named effect allele
             nea="ref", # ref allele is named non-effect allele
             neaf="ref_freq", # non-effect allele frequency
             beta="beta",
             se="se",
             p="pval",
             #direction="Dir",
             n="n_complete_samples",
             sep="\t")

print("Plotting mqq...")
sumstats.plot_mqq()
