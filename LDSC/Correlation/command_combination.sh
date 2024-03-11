#!/bin/bash

# Load files
INPUT_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/3-correlation/inputs/PathList.txt # Change list depending on disease or trait
CORR_INPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/3-correlation/inputs/PairComb.txt

echo "FILES LOADED"
echo "INPUT LIST IS: $INPUT_LIST"

JOBS_COUNT=1

# Run combination script

echo '##### CREATING TRAIT COMBINATIONS TO CALCULATE CORRELATION #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/LDSC/correlation/combination.sh ${INPUT_LIST} \
                                                          ${CORR_INPUT_DIR} 