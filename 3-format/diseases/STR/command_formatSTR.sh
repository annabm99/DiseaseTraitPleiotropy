#!/bin/bash

# Load files
SUMSTATS_STR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/1-download/STR_d.out
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-format/outputs

echo "FILE LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_STR"

# Run munge script
JOBS_COUNT=1

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING CAD #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/STR/formatSTR.sh ${SUMSTATS_STR} \
                                                          ${FORMATTED_OUTPUT_DIR} 