import pandas as pd

# Load conjfdr results
df = pd.read_csv("/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/2-Analysis/dis-trait/CAD_d_vs_SBP_t_b/CAD_d_SBP_t_b_conjfdr_0.05_loci.csv", sep=",")

# Load the reference file
ref = pd.read_csv('/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/RefFiles/9545380.ref', sep="\t")

# Remove empty columns from the conjfdr dataframe
df = df.drop(['snpid', 'geneid'], axis=1)

# Change column names
df.columns=('NUM', 'CHR', 'BP','A1', 'A2', 'ZSCORE_CAD', 'ZSCORE_SBP', 'CONJDFR', 'PRUNE', 'MIN_CONJFDR', 'PVAL_CAD')

# Merge the data with the reference file
df_merge = pd.merge(df, ref, on=['CHR', 'BP'])

# Save the data with rsids
df_merge.to_csv('/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/2-Analysis/dis-trait/CAD_d_vs_SBP_t_b/CAD_d_SBP_t_b-sigificant.csv', index=False, sep='\t')

# Save rsid list
df_merge['SNP'].to_csv('/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/2-Analysis/dis-trait/CAD_d_vs_SBP_t_b/CAD_d_SBP_t_b-SNPs.csv', index=False, header=False, sep='\n')

locusnum,snpid,geneid,chrnum,chrpos,A1,A2,zscore_CAD_d,zscore_SBP_t_b,conjfdr_CAD_d_SBP_t_b,prune_CAD_d_SBP_t_b,min_conjfdr,pval_CAD_d,pval_SBP_t_blocusnum,snpid,geneid,chrnum,chrpos,A1,A2,zscore_CAD_d,zscore_SBP_t_b,conjfdr_CAD_d_SBP_t_b,prune_CAD_d_SBP_t_b,min_conjfdr,pval_CAD_d,pval_SBP_t_b