#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J MungeSumStats
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-01:30 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "_____ MUNGE.SH _____"

module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Load variables
FORMAT_SUMSTATS_LIST=$1
MUNGE_ALLELES_FILE=$2
MUNGE_OUTPUT_DIR=$3

echo "variables loaded"

# Grab one file from path list
INPUT_FILE=$(cat ${FORMAT_SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "input file is $INPUT_FILE"

# Grab phenotype name
NAME=$(echo $INPUT_FILE | cut -d "/" -f10 | cut -d "-" -f1)

echo "Name is $NAME"

# BEFORE MUNGE: Compare alleles to reference SNP panel

# Run munge python script (implemented in the ldsc module)
munge_sumstats.py --sumstats ${INPUT_FILE} \
                  --out ${MUNGE_OUTPUT_DIR}/${NAME} \
                  --merge-alleles ${MUNGE_ALLELES_FILE} \
                  --a1-inc # THIS IS ONLY IN T2D

echo "...................... Python munge done!"

echo "Renaming output.. "

mv ${MUNGE_OUTPUT_DIR}/${NAME}.sumstats.gz ${MUNGE_OUTPUT_DIR}/${NAME}-munge.gz

conda deactivate
#munge.sh (END)