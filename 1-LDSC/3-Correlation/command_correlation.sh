#!/bin/bash

# Load files
INPUT_LIST= # Change list depending on disease or trait
CORR_DIR=

echo "FILES LOADED"
echo "INPUT LIST IS: $INPUT_LIST"

# Run combination script

echo '##### CREATING TRAIT COMBINATION PAIRS TO CALCULATE CORRELATION #####'
bash ./combination.sh   ${INPUT_LIST} \
                        ${CORR_DIR} 

# Load additional files
TRAIT_PAIRS=$CORR_DIR/PairComb.txt
EUR_REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/RefFiles/eur_w_ld_chr/

echo "FILES LOADED"
echo "INPUT PAIR LIST IS: $TRAIT_PAIRS"

# Count jobs
JOBS_COUNT=$(wc -l < "${TRAIT_PAIRS}")
echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### CALCULATING PHENOTYPE PAIR CORRELATIONS #####'
sbatch --array=1-${JOBS_COUNT} ./LDSC_correlation.sh    ${TRAIT_PAIRS} \
                                                        ${EUR_REFERENCE} \
                                                        ${CORR_DIR} 