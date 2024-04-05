#!/bin/bash

# Load files
SUMSTATS_HT=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/1-download/HT_d.txt
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-format

echo "FILE LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_HT"

# Run munge script
JOBS_COUNT=1

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING CAD #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/HT/formatHT.sh ${SUMSTATS_HT} \
                                                          ${FORMATTED_OUTPUT_DIR} 