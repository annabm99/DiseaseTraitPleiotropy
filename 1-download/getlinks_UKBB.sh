#!/bin/sh

# Folder: /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric

# Read id list from STDIN, this list is written between "" and separated by space characters
id_list=$1

# Save wget commands to file variable of both_sexes, male and female for each id
for id in $id_list; do
    cat UKBB_GWAS_Imputed_3_manifest_201807.tsv | grep $echo$id"_raw" | awk -F '\t' '{print $6}' >> UKBB_links.sh
done
# This generates a file named UKBB__links.sh, which is run using bash command to download all files