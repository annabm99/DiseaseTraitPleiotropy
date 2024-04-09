#!/bin/bash

# Load pleiofdr file list
PLEIOFDR_LIST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/3-FindSNPs/PleioFDR_list.txt # Disease and trait sumstats
REF_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/RefFiles/9545380.ref
# Output directory
OUTPUT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/3-FindSNPs/all/

# Check if PLEIOFDR_LIST file exists
if [ ! -f "$PLEIOFDR_LIST" ]; then
    echo "Error: PLEIOFDR_LIST file '$PLEIOFDR_LIST' not found."
    exit 1
fi

# Check if REF_FILE exists
if [ ! -f "$REF_FILE" ]; then
    echo "Error: REF_FILE '$REF_FILE' not found."
    exit 1
fi

# Check if output directory exists, if not create it
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR" || { echo "Error: Unable to create OUTPUT_DIR"; exit 1; }
fi

echo "FILES LOADED"
echo "SUMSTATS LIST IS: $SUMSTATS_LIST"
echo "OUTPUT DIRECTORY IS: $OUTPUT_DIR"

# Job count
JOBS_COUNT=$(wc -l < "$PLEIOFDR_LIST")
echo "Number of jobs: $JOBS_COUNT"

# Run script
sbatch --array=1-${JOBS_COUNT} ./findSNPs.sh \
        ${PLEIOFDR_LIST} \
        ${REF_FILE} \
        ${OUTPUT_DIR}