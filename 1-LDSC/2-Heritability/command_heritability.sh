#!/bin/bash
#

# Input files
MUNGE_SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/2-heritability/InputList.txt
EUR_REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/RefFiles/eur_w_ld_chr/
LDSC_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/2-heritability/

echo "Sumstat list is $MUNGE_SUMSTATS_LIST"
echo "Reference genome is $EUR_REFERENCE"
echo "Output directory is $LDSC_OUTPUT_DIR"

# Count jobs
JOBS_COUNT=$(wc -l < "${MUNGE_SUMSTATS_LIST}")
echo "There are a total of ${JOBS_COUNT} jobs"

sbatch --array=1-${JOBS_COUNT} ./heritability.sh    ${MUNGE_SUMSTATS_LIST} \
                                                    ${EUR_REFERENCE} \
                                                    ${LDSC_OUTPUT_DIR}