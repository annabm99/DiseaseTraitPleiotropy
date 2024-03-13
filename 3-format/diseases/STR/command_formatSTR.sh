#!/bin/bash

# Load files
SUMSTATS_STR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/1-download/STR_d.out
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-format
REF_SNPS=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/1-download/merge/inputs/variants-short.tsv.gz

echo "FILE LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_STR"
echo "REFERENCE IS: $REF_SNPS"

# Run munge script
JOBS_COUNT=1

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING STR #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/STR/formatSTR.sh \
            ${SUMSTATS_STR} \
            ${REF_SNPS} \
            ${FORMATTED_OUTPUT_DIR} 