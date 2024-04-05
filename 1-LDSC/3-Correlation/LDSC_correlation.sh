#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSC_Corr
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
TRAIT_PAIRS=$1 # list with all trait pairs combinations (pathtrait1,pathtrait2)
EUR_REFERENCE=$2 # directory with european reference LD score
CORR_OUTPUT_DIR=$3 # output directory

INPUT_PAIR=$(cat ${TRAIT_PAIRS} | sed -n ${SLURM_ARRAY_TASK_ID}p)

read PATH1 PATH2 <<< $(echo $INPUT_PAIR | cut -d ',' -f1,2)

PHEN1=$( basename $PATH1 | cut -d '-' -f1)
echo "Phenotype 1 is $PHEN1"
PHEN2=$( basename $PATH2 | cut -d '-' -f1)
echo "Phenotype 2 is $PHEN2"

ldsc.py --ref-ld-chr ${EUR_REFERENCE} \
        --out ${CORR_OUTPUT_DIR}/${PHEN1}_vs_${PHEN2}-GenCorr \
        --rg ${INPUT_PAIR} \
        --w-ld-chr ${EUR_REFERENCE} \

conda deactivate