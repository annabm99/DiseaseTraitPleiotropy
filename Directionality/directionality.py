
import pandas as pd

# Import data
df=pd.read_csv('/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/3-FindSNPs/loci/dis-trait/CAD_d_vs_BMI_t_b-sigificant.csv', sep='\t')

# Multiply Z score columns
df['Z_PROD'] = df['ZSCORE_CAD'] * df['ZSCORE_BMI']

# Count positive and negative results
positive_count = (df['Z_PROD'] > 0).sum()
negative_count = (df['Z_PROD'] < 0).sum()

# Report
print("Positive (synergistic) pleiotropies:", positive_count)
print("Negative (antagonistic) pleiotropies:", negative_count)
print("Total pleiotropies:", positive_count+positive_count)
