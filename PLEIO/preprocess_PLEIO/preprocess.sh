#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSC_PreprocessPLEIO
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo " _________ PREPROCESS.SH _________"

# Modules
module load Miniconda3/4.9.2
echo "Miniconda loaded"
source activate ldsc_pleio
echo "ldsc_pleio activated"

# Config
# combi list file or similar with combination space separated in each line
INPUT_LIST=$1
REF_FILE=$2
OUTPUT_DIR=$3

echo "Files loaded"

echo "SUMSTATS LIST IS: $INPUT_LIST"
echo "REFERENCE FILE IS: $REF_FILE"

python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PLEIO/pleio/ldsc_preprocess.py \
        --input ${INPUT_LIST} \
        --ref-ld-chr ${REF_FILE} \
        --w-ld-chr ${REF_FILE} \
        --out ${OUTPUT_DIR}/BMIvsSTR

conda deactivate



