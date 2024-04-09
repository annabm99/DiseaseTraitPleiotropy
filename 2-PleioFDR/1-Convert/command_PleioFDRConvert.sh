#!/bin/bash

# Load summary statistics list
SUMSTATS_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/1-Convert/InputList.txt # Disease and trait sumstats

# Output directory
OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/1-Convert

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"
echo "OUTPUT DIRECTORY IS: $OUTPUT_DIR"

# Job count
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
echo "Number of jobs: $JOBS_COUNT"

# Run script
sbatch --array=1-${JOBS_COUNT} ./pleioFDRConvertv2.sh \
        ${SUMSTATS_LIST} \
        ${OUTPUT_DIR}