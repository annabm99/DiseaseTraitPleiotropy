#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J ukbbformat
#SBATCH --mem 80G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Load Python module
module load Python/3.6.6-foss-2018b

echo "SCRIPT RUNNING"

# Import files as variables
SUMSTATS_LST=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-format/inputs/sumstats_path.txt
VARIANTS_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-format/inputs/variants-short.tsv.gz
OUTPUTS_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-format/sumstats_f

echo "FILES IMPORTED"

# Iterate through list of files and codes

iteration=1
echo "list length is $(wc -l ${SUMSTATS_LST} | cut -d " " -f1) and iteration is $iteration"

while [ $iteration -le $(wc -l ${SUMSTATS_LST} | cut -d " " -f1) ]; do
    
    echo "running iteration $iteration"

    # Grab file and code corresponding to this iteration
    INPUT_FILE=$(cat ${SUMSTATS_LST} | sed -n ${iteration}p)
    echo "input file is $INPUT_FILE"
    CODE=$(echo $INPUT_FILE | cut -d '/' -f11 | cut -d '_' -f1,3 | cut -d '.' -f1)
    echo "code is $CODE"


    # Run python script to merge sumstats with variants file
    python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/traits/2-format/scripts/reformat.py \
        ${INPUT_FILE} \
        ${VARIANTS_FILE} \
        ${OUTPUTS_DIR}  \
        ${CODE}

    let iteration=iteration+1 
done

echo "DONE"