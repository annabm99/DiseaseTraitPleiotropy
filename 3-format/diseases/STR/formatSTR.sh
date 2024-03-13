#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J FormatSTR
#SBATCH --mem 10G # memory pool for all cores
##SBATCH -t 0-00:30 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ FORMATSTR.SH ____"

module load Python/3.6.6-foss-2018b

# Load input variables
SUMSTATS_STR=$1
REF_SNSP=$2
OUTPUT_DIR=$3

echo "SUMSTATS IS: $SUMSTATS_STR, REFERENCE IS: $REF_SNPS, OUTPUT DIR IS: $OUTPUT_DIR"

# Run Python
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/STR/formatSTR.py \
    ${SUMSTATS_STR} \
    ${REF_SNPS} \
    ${OUTPUT_DIR}