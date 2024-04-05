#!/bin/bash

#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J FormatCAD
#SBATCH --mem 5G # memory pool for all cores
##SBATCH -t 0-00:30 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "____ FORMATCAD.SH ____"

module load Python/3.6.6-foss-2018b

# Load input variables
SUMSTATS_CAD=$1
OUTPUT_DIR=$2

# Run Python
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/format/diseases/CAD/formatCAD.py \
    ${SUMSTATS_CAD} \
    ${OUTPUT_DIR}
