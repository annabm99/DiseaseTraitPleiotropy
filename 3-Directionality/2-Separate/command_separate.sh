#!/bin/bash

# Load files
PLEIOTROPIES_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/3-Directionality/2-Separate/InputList.txt # List with non-LD corrected LOCI (all)
OUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/3-Directionality/2-Separate

echo "FILES LOADED"

# Run correlations script
JOBS_COUNT=$(wc -l < "${PLEIOTROPIES_LIST}") # Count jobs
echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### CHECKING PLEIOTROPY DIRECTIONALITY #####'

sbatch --array=1-${JOBS_COUNT} ./separate_directionality.sh \
                                ${PLEIOTROPIES_LIST} \
                                ${OUT_DIR} 