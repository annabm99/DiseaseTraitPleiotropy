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
DIRECTIONALITY_LIST=$1
OUTPUT_DIR=$2

INPUT_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$DIRECTIONALITY_LIST")

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found: $INPUT_FILE"
    exit 1
fi
echo "Input file: $INPUT_FILE, output dir: $OUTPUT_DIR"
# Run Python script
python ./extract_SNPs.py \
    ${INPUT_FILE} \
    ${OUTPUT_DIR}