#!/bin/bash

# Load files
FORMAT_SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/1-munge/inputs/test.txt # Disease and trait sumstats
MUNGE_ALLELES_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/RefFiles/w_hm3.snplist.gz # Reference genome
# Output directory
COMPARE_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/1-munge/outputs/compare
MUNGE_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/1-munge/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $FORMAT_SUMSTATS_LIST"

# Run munge script
JOBS_COUNT=$(cat ${FORMAT_SUMSTATS_LIST} | wc -l)
echo "Number of jobs: $JOBS_COUNT"

# Run munge script
echo '##### MUNGING #####'
 sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/LDSC/munge/munge.sh ${FORMAT_SUMSTATS_LIST} \
                                                           ${MUNGE_ALLELES_FILE}\
                                                            ${COMPARE_DIR}\
                                                           ${MUNGE_OUTPUT_DIR} 