#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J findSNPs
##SBATCH -t 0-0:30 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

module load Python/3.6.6-foss-2018b

# Check if required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 PLEIOFDR_LIST REF_FILE OUTPUT_DIR"
    exit 1
fi

# Read inputs
PLEIOFDR_LIST=$1
REF_FILE=$2
OUTPUT_DIR=$3

INPUT_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$PLEIOFDR_LIST")


# Run python script to convert to csv

python ./findSNPs.py \
        ${INPUT_FILE} \
        ${REF_FILE} \
        ${OUTPUT_DIR}