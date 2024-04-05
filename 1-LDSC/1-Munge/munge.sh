#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J rev_MungeSumStats
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 1-00:00 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "_____ MUNGE.SH _____"

set -e # Error-catching

# Check if arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 FORMAT_SUMSTATS_LIST MUNGE_ALLELES_REF MUNGE_OUTPUT_DIR"
    exit 1
fi

# Load variables
FORMAT_SUMSTATS_LIST=$1
MUNGE_ALLELES_REF=$2
# COMPARE_DIR=$3
MUNGE_OUTPUT_DIR=$3

echo "Variables loaded"

# Grab one file from path list
INPUT_FILE=$(sed -n ${SLURM_ARRAY_TASK_ID}p "${FORMAT_SUMSTATS_LIST}")

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "Input file is $INPUT_FILE"

# Grab phenotype name
PHEN_NAME=$(basename $INPUT_FILE | cut -d "-" -f1)
echo "Phenotype name is $PHEN_NAME"

echo "Reference file is $MUNGE_ALLELES_REF"
# echo "Compare dir is $COMPARE_DIR"

# Activate LDSC module
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Run munge python script (implemented in the ldsc module)
munge_sumstats.py --sumstats ${INPUT_FILE} \
                  --out ${MUNGE_OUTPUT_DIR}/${PHEN_NAME} \
                  --merge-alleles ${MUNGE_ALLELES_REF} \
                #   --a1-inc # THIS IS ONLY IN T2D
echo "Python munge done!"

# Rename the munge file
echo "Renaming output... "
mv ${MUNGE_OUTPUT_DIR}/${PHEN_NAME}.sumstats.gz ${MUNGE_OUTPUT_DIR}/${PHEN_NAME}-munge.gz

conda deactivate