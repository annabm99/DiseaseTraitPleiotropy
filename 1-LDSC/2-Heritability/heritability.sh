#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J rev_LDSC_heritability
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ HERITABILITY.SH ____"

set -e # Error-catching

# Check if required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 MUNGE_SUMSTATS_LIST EUR_REFERENCE LDSC_OUTPUT_DIR"
    exit 1
fi

MUNGE_SUMSTATS_LIST=$1 # Input list of munged sumstats
EUR_REFERENCE=$2 # Directory with european reference LD score
LDSC_OUTPUT_DIR=$3 # Output directory

echo "Variables loaded"

# Grab one file from path list
INPUT_FILE=$(sed -n ${SLURM_ARRAY_TASK_ID}p "${MUNGE_SUMSTATS_LIST}")
echo "input file is $INPUT_FILE"

# Extract phenotype name from the file path
NAME=$(basename "$INPUT_FILE" | cut -d "-" -f1)
echo "Phenotype name is $NAME"

# Activate LDSC module
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Run ldsc to calculate heritability
echo 'Computing heritability with LDSC'
ldsc.py --h2 ${INPUT_FILE} \
        --ref-ld-chr ${EUR_REFERENCE} \
        --w-ld-chr ${EUR_REFERENCE} \
        --out ${LDSC_OUTPUT_DIR}/${NAME}

conda deactivate