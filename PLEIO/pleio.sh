#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J PLEIO
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo " _________ PLEIO.SH _________"

# Pleio needs version >= 3.7
module load Python/3.7.2-GCCcore-8.2.0

python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PLEIO/pleio/pleio.py \
        --metain /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/4-preprocess_PLEIO/output/metain.txt.gz \
        --sg /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/4-preprocess_PLEIO/output/sg.txt.gz \
        --ce /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/4-preprocess_PLEIO/output/ce.txt.gz \
        --create \
        --out /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PLEIO/output