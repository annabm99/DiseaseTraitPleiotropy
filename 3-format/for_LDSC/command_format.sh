#!/bin/bash

# Load files
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/3-format/LDSC/inputs/SumstatLst.txt # Change list depending on disease or trait
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/3-format/LDSC/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"

# Run munge script
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING FOR LDSC #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/LDSC/LDSC_format.sh ${SUMSTATS_LIST} \
                                                          ${FORMATTED_OUTPUT_DIR} 