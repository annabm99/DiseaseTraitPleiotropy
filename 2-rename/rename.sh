#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J RenameSumstats
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "RENAME.SH RUNNING..."

module load Python/3.6.6-foss-2018b

# Load variables
CODE_SUMSTATS_LIST=$1
NEWNAME_OUTPUT_DIR=$2

echo "_____ RENAME.SH _____"

# Grab one file from path list
INPUT_FILE=$(cat ${CODE_SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "input file is $INPUT_FILE"

python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/rename/rename.py \
    ${INPUT_FILE} \
    ${NEWNAME_OUTPUT_DIR}

