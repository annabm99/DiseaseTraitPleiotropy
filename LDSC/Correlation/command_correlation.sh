#!/bin/bash

# Load files
TRAIT_PAIRS=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/3-correlation/inputs/PairComb_good.txt
EUR_REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/2-heritability/inputs/eur_w_ld_chr/
CORR_OUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/3-correlation/outputs

echo "FILES LOADED"
echo "INPUT PAIR LIST IS: $TRAIT_PAIRS"

# Run correlations script
JOBS_COUNT=$(cat ${TRAIT_PAIRS} | wc -l) # Count jobs
echo "There are a total of $JOBS_COUNT jobs to run"

echo '##### CALCULATING PHENOTYPE PAIR CORRELATIONS #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/LDSC/correlation/LDSC_correlation.sh ${TRAIT_PAIRS} \
                                                        ${EUR_REFERENCE} \
                                                        ${CORR_OUT_DIR} 