#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSC_heritability
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ HERITABILITY.SH ____"

module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

MUNGE_SUMSTATS_LIST=$1 #Input list of munged sumstats
EUR_REFERENCE=$2 #Directory with european reference LD score
LDSC_OUTPUT_DIR=$3 #Output directory

INPUT_FILE=$(cat ${MUNGE_SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
echo "input file is $INPUT_FILE"
NAME=$(echo $INPUT_FILE | cut -d "/" -f12 | cut -d "-" -f1)
echo "Phenotype name is $NAME"

# Run ldsc to calculate heritability

echo 'Computing heritability with LDSC'
ldsc.py --h2 ${INPUT_FILE} \
        --ref-ld-chr ${EUR_REFERENCE} \
        --w-ld-chr ${EUR_REFERENCE} \
        --out ${LDSC_OUTPUT_DIR}/${NAME} \

conda deactivate