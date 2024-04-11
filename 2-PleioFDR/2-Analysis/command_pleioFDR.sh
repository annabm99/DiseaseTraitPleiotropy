#!/bin/bash

#### Before running PleioFDR: make phenotype pairs and separate them to the respective directories

# # Load python module
# module load Python/3.6.6-foss-2018b

# # Run python script
# python ./make_pairs.py

### Run PleioFDR with the trait pairs

# Load summary statistics list, they are in separate directories
PATHS=(
"/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/2-Analysis/dis-trait/PairsList.txt"
"/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/2-Analysis/dis-dis/PairsList.txt"
)

# Loop over the paths and run the PleioFDR script
for SUMSTAT_PAIRS_LIST in ${PATHS[@]}; do
        echo "FILE LOADED"
        echo "SUMSTATS LIST IS: $SUMSTAT_PAIRS_LIST"
        
        # Extract the output directory path
        OUTPUT_DIR=$(dirname "$SUMSTAT_PAIRS_LIST")
        echo "Output directory: $OUTPUT_DIR"
        
        # Job count
        JOBS_COUNT=$(cat ${SUMSTAT_PAIRS_LIST} | wc -l)
        echo "Number of jobs: $JOBS_COUNT"

        # Run script
        sbatch --array=1-${JOBS_COUNT} ./pleioFDR.sh \
                                        ${SUMSTAT_PAIRS_LIST} \
                                        ${OUTPUT_DIR}
done