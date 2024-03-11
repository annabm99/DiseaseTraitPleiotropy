#!/bin/bash

# Load files
SUMSTATS_T2D=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/1-download/T2D_d.txt
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-format

echo "FILE LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_T2D"

# Run munge script
JOBS_COUNT=1

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/T2D/formatT2D.sh ${SUMSTATS_T2D} \
                                                        ${FORMATTED_OUTPUT_DIR} 