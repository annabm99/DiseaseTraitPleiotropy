#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J Directionality
#SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Load Python module
module load Python/3.6.6-foss-2018b

# Import arguments
PLEIOTROPIES_LIST=$1
OUT_DIR=$2

PLEIOTROPIES_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$PLEIOTROPIES_LIST")


echo "File: $PLEIOTROPIES_FILE"
echo "Output dir: $OUT_DIR"

python ./directionality.py \
    ${PLEIOTROPIES_FILE} \
    ${OUT_DIR}