#!/bin/bash

# Load files
CODE_SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-rename/inputs/CodeSumstatsList.txt # Change list depending on disease or trait
NEWNAME_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-rename/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $CODE_SUMSTATS_LIST"

# Run munge script
JOBS_COUNT=$(cat ${CODE_SUMSTATS_LIST} | wc -l)
echo '##### RENAMING #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/rename/rename.sh ${CODE_SUMSTATS_LIST} \
                                                          ${NEWNAME_OUTPUT_DIR} 