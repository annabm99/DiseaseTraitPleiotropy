#!/bin/bash

# Load files
FORMAT_SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/1-munge/InputList.txt
 # Disease and trait sumstats
MUNGE_ALLELES_REF=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/RefFiles/w_hm3.snplist.gz # Reference genome

# Output directory
MUNGE_OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/1-LDSC/1-munge

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $FORMAT_SUMSTATS_LIST"

# Count jobs
JOBS_COUNT=$(wc -l < "${FORMAT_SUMSTATS_LIST}")
echo "Number of jobs: $JOBS_COUNT"

# Run munge script
echo '##### MUNGING #####'
 sbatch --array=1-${JOBS_COUNT} ./munge.sh  ${FORMAT_SUMSTATS_LIST} \
                                            ${MUNGE_ALLELES_REF} \
                                            ${MUNGE_OUTPUT_DIR} 