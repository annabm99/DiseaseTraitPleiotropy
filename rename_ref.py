import pandas as pd
import sys

RefFile = "/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/merge/inputs/variants-short.tsv.gz"

f = pd.read_csv(RefFile,  compression='gzip', sep='\t', index_col=False, error_bad_lines=False, low_memory=False)
f.columns=["variant", "CHR", "BP", "A1", "A2", "SNP", "info"]
f.to_csv(f'/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/merge/inputs/ref_BB_colrename.gz', index=None, compression='gzip', sep='\t')