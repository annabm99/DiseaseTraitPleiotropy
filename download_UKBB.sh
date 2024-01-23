# Download UKBB sumstats to Marvin Cluster
id=21001

# Save wget commands to OUT variable
OUT=$(cat UKBB_GWAS_Imputed_3_manifest_201807.tsv | grep $echo$id"_raw" | awk -F '\t' '{print $6}')

# Print OUT variable to execute wget commands
$OUT