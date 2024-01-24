#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J FormatLDSC
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ LDSC_FORMAT.SH RUNNING ____"

module load Python/3.6.6-foss-2018b

# Load variables
SUMSTATS_LIST=$1
FORMATTED_OUTPUT_DIR=$2

# Grab one file from path list, name and termination
INPUT_FILE=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
NAME=$(echo $INPUT_FILE | cut -d '/' -f11 | cut -d '.' -f1)

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "input file is $INPUT_FILE, and its name is $NAME"

python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/LDSC/LDSC_format.py \
    ${INPUT_FILE} \
    ${NAME} \
    ${FORMATTED_OUTPUT_DIR}