#!/bin/bash

# Load files
DIRECTIONALITY_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/4-GeneAnnotations/BMI/InputList.txt # List with non-LD corrected LOCI (all)
OUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/4-GeneAnnotations

echo "FILES LOADED"

# Run correlations script
JOBS_COUNT=$(wc -l < "${DIRECTIONALITY_LIST}") # Count jobs
echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### EXTRACTING RSIDs #####'

sbatch --array=1-${JOBS_COUNT} ./extract_SNPs.sh \
                                ${DIRECTIONALITY_LIST} \
                                ${OUT_DIR} 