#!/bin/bash

# Load files
INPUT_LIST_PATH=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/3-correlation/InputList.txt
PAIR_LIST_PATH=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/3-correlation/PairList.txt
        # This list will be the output of combination.sh
CORR_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/3-correlation
EUR_REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/RefFiles/eur_w_ld_chr/

echo "FILES LOADED"
echo "INPUT LIST IS: $INPUT_LIST_PATH"

##### STEP 1: MAKE PHENOTYPE PAIR COMBINATIONS

echo '##### CREATING TRAIT COMBINATIONS TO CALCULATE CORRELATION #####'

# Python module
module load Python/3.6.6-foss-2018b

# Run python script
python ./combination.py \
    ${INPUT_LIST_PATH} \
    ${PAIR_LIST_PATH}

##### STEP 2: RUN LDSC CORRELATION
echo "##### CALCULATING CORRELATION VALUES FOR PHENOTYPE PAIRS #####"
echo "PHENOTYPE PAIR LIST IS: $PAIR_LIST_PATH"

# Count jobs
JOBS_COUNT=$(wc -l < "${PAIR_LIST_PATH}")
echo "There are a total of $JOBS_COUNT jobs to run"

sbatch --array=1-${JOBS_COUNT} ./LDSC_correlation.sh    ${PAIR_LIST_PATH} \
                                                        ${EUR_REFERENCE} \
                                                        ${CORR_DIR} 