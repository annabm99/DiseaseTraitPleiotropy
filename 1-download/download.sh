#!/bin/bash

# Open needed files
FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/UKBB_GWAS_Imputed_3_manifest_201807.tsv
ID_list=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/ID_list_ukbb.txt

# Take only interest lines and fields from the Neale Lab file, save it to a new file
cat ${FILE} | grep -wf ${ID_list} | cut -f1,6 > /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/tmp/IntList.txt
FILE_SHT=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/tmp/IntList.txt

# For each ID, fetch its link, execute wget command, and save file in outputs directory
for ID in $(cat ${ID_list}); do
  LINK_B=$(cat ${FILE_SHT} | grep ${ID} | grep -w both_sexes | cut -f2 | cut -d " " -f2)
  wget -O /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/sumstats/${ID}_b.gz ${LINK_B}
  # add female and male if wanted
done
