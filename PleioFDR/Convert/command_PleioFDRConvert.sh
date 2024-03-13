#!/bin/bash

# Load summary statistics list
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/1-Convert/inputs/test.txt # Disease and trait sumstats

# Output directory
OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/1-Convert/outputs

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"
echo "OUTPUT DIRECTORY IS: $OUTPUT_DIR"

# Run munge script
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
echo "Number of jobs: $JOBS_COUNT"

# Run munge script
sbatch --array=1-${JOBS_COUNT} /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/pleioFDRConvert.sh \
        ${SUMSTATS_LIST} \
        ${OUTPUT_DIR}