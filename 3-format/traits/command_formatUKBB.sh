#!/bin/bash

# Load files
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/3-format/inputs/SumstatLst.txt # List with all UKBB to format
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/3-format/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"

# Run munge script
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING UKBB FOR LDSC TO MUNGE #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/traits/formatUKBB.sh ${SUMSTATS_LIST} \
                                                          ${FORMATTED_OUTPUT_DIR} 