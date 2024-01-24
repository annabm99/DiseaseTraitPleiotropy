#!/bin/bash

# Load files
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-rename/eda/inputs/SumstatsEDA.txt # Change list depending on disease or trait
OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-rename/eda/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"

# Run munge script
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### RUNNING EDA #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/eda/eda.sh ${SUMSTATS_LIST} \
                                                          ${FOUTPUT_DIR} 