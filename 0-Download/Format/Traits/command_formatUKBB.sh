#!/bin/bash

# Load files
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/0-Download/traits/3a-format/InputList.txt # List with all UKBB to format
FORMATTED_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/0-Download/traits/3a-format

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"

# Count jobs script
JOBS_COUNT=$(wc -l < "${SUMSTATS_LIST}")

echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### FORMATTING UKBB FOR PLEIOFDR #####'
sbatch --array=1-${JOBS_COUNT} ./formatUKBB.sh  ${SUMSTATS_LIST} \
                                                ${FORMATTED_OUTPUT_DIR} 