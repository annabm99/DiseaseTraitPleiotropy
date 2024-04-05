#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J val_format
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ FORMAT.SH RUNNING ____"

module load Python/3.6.6-foss-2018b

# Load variables
SUMSTATS_LIST=$1
FORMATTED_OUTPUT_DIR=$2

# Grab one file from path list, name and termination
INPUT_FILE=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
NAME=$(basename $INPUT_FILE | cut -d '.' -f1)

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "input file is $INPUT_FILE, and its name is $NAME"

python ./formatUKBB.py \
    ${INPUT_FILE} \
    ${NAME} \
    ${FORMATTED_OUTPUT_DIR}