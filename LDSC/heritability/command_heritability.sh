#!/bin/bash
#

# Clean directory
rm -fr outputs/*
echo "Directory cleaned"

MUNGE_SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/2-heritability/inputs/MungeSumstatsLst.txt
EUR_REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/2-heritability/inputs/eur_w_ld_chr/
LDSC_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/2-heritability/outputs

echo "Sumstat list is $MUNGE_SUMSTATS_LIST"
echo "Reference genome is $EUR_REFERENCE"
echo "Output directory is $LDSC_OUTPUT_DIR"

JOBS_COUNT=$(cat ${MUNGE_SUMSTATS_LIST} | wc -l)
echo "There are a total of ${JOBS_COUNT} jobs"

sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/LDSC/heritability/heritability.sh ${MUNGE_SUMSTATS_LIST} \
                                                        ${EUR_REFERENCE} \
                                                        ${LDSC_OUTPUT_DIR}