#!/bin/bash

# Load files
SUMSTATS_CAD=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/1-download/CAD_d.txt
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/diseases/2-format/outputs

echo "FILE LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_CAD"

# Run munge script
JOBS_COUNT=1

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING CAD #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/CAD/formatCAD.sh ${SUMSTATS_CAD} \
                                                          ${FORMATTED_OUTPUT_DIR} 