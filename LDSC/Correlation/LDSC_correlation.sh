#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSC_Correlation
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Modules
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Config
TRAIT_PAIRS=$1 #list with all trait pairs combinations (pathtrait1 pathtrait2)
#MUNGE_SUMSTATS_DIR=$2 #Input directory
LDSC_OUTPUT_DIR=$2 #Output directory
EUR_REFERENCE=$3 #directory with european reference LD score

FILE1=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${TRAIT_PAIRS} | cut -f1 -d';')
FILE2=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${TRAIT_PAIRS} | cut -f2 -d';')


ldsc.py --ref-ld-chr ${EUR_REFERENCE} \
        --out ${LDSC_OUTPUT_DIR}/${CODE1}.${CODE2}-genetic-correlation \
        --rg ${FILE1},${FILE2} \
        --w-ld-chr ${EUR_REFERENCE} \

conda deactivate