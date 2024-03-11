#!/bin/bash

# Load files
INPUT_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PLEIO/preprocess/inputs/BMI\&stroke_prep.txt # Pair (or more) we want to compare in Pleio
EUR_REF_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/2-heritability/inputs/eur_w_ld_chr/ # Reference genome
# Output directory
OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PLEIO/preprocess/outputs

# Run munge script
JOBS_COUNT=1
echo "Number of jobs: $JOBS_COUNT"
echo '##### SENDING PREPROCESS FOR PLEIO #####'
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PLEIO/preprocess/preprocess.sh ${INPUT_LIST} \
                                                          ${EUR_REF_FILE}\
                                                          ${OUTPUT_DIR}