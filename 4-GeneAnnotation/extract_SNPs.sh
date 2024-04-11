#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J ExtractSNPs
#SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Load Python module
module load Python/3.6.6-foss-2018b
# Ensure proper usage
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file.csv> <output_file.txt>"
    exit 1
fi

# Assign arguments to variables
INPUT_FILE=$1
OUTPUT_DIR=$2

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
fi

# Run Python script
python ./extract_SNPs.py \
    ${INPUT_FILE} \
    ${OUT_DIR}