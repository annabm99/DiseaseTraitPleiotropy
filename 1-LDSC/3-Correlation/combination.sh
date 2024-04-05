#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J CombLDSC
#SBATCH --mem 5G # memory pool for all cores
##SBATCH -t 0-00:30 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "_____ COMBINATION.SH _____"

# Python module
module load Python/3.6.6-foss-2018b

# Load variables
INPUT_LIST=$1
CORR_INPUT_DIR=$2

echo "variables loaded"

# Run python script
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/LDSC/correlation/combination.py \
    ${INPUT_LIST} \
    ${CORR_INPUT_DIR}