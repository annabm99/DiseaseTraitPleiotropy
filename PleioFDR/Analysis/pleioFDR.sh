#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J run_PleioFDR
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 5-03:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "_____ PLEIOFDR.SH _____"

# Load modules
module load Python/2.7.11-foss-2016b
module load MATLAB/2020a
echo "Modules loaded"

# Load variables
SUMSTAT_PAIRS_LIST=$1
OUTPUT_DIR=$2

echo "Variables loaded"

# Get one pair from the list
INPUT_PAIR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SUMSTAT_PAIRS_LIST")


# Separate sumstats paths by the comma
SUMSTATS1=$(echo "$INPUT_PAIR" | cut -d ',' -f 1)
SUMSTATS2=$(echo "$INPUT_PAIR" | cut -d ',' -f 2)

echo "File 1: $SUMSTATS1"
echo "File 2: $SUMSTATS2"

# Get phenotype names
PHEN1=$(basename "$SUMSTATS1" | cut -d "-" -f1)
PHEN2=$(basename "$SUMSTATS2" | cut -d "-" -f1)

echo "Phenotype 1: $PHEN1"
echo "Phenotype 2: $PHEN2"

PAIR_DIR="$OUTPUT_DIR/$PHEN1""_vs_""$PHEN2"

# # Check if the directory exists, if not, create it
# if [ ! -d "$PAIR_DIR" ]; then
#     mkdir -p "$PAIR_DIR" || { echo "Error: Unable to create new directory: $PAIR_DIR"; exit 1; }
# fi

# echo "Created new pair directory: $PAIR_DIR"

# ####################################################
# #                 PREPARE PAIR FILES               #
# ####################################################

# # Step 1: Get common SNPs between the phenotype pair
# echo "... Getting common SNPs ..."
# python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/commonSNPs.py \
#     $SUMSTATS1 \
#     $SUMSTATS2 \
#     $PHEN1 \
#     $PHEN2 \
#     $PAIR_DIR

# COMMON_FILE_1=$PAIR_DIR/$PHEN1-common.csv
# COMMON_FILE_2=$PAIR_DIR/$PHEN2-common.csv
# echo "Common SNPs files: $COMMON_FILE_1, $COMMON_FILE_2"

# echo "The two phenotypes share $(wc -l < "$COMMON_FILE_1"), $(wc -l < "$COMMON_FILE_2") total SNPs."

# # Step 2: Convert both datasets to mat format with PleioFDR formatter
# echo "... Starting conversion to mat ..."

# for FILE in "${COMMON_FILE_1}" "${COMMON_FILE_2}"; do
#     # Determine phenotype name
#     if [ "$FILE" == "${COMMON_FILE_1}" ]; then
#         PHEN_NAME="$PHEN1"
#     elif [ "$FILE" == "${COMMON_FILE_2}" ]; then
#         PHEN_NAME="$PHEN2"
#     else
#         echo "Invalid file: $FILE"
#         exit 1
#     fi
#     # Run python script to convert to mat format
#     python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py mat \
#             --sumstats "$FILE" \
#             --ref /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/RefFiles/9545380.ref \
#             --out "${PAIR_DIR}/${PHEN_NAME}.mat" \
#             --force
# done

MAT_FILE_1=$PAIR_DIR/$PHEN1.mat
MAT_FILE_2=$PAIR_DIR/$PHEN2.mat
echo "Mat files: $MAT_FILE_1, $MAT_FILE_2"

####################################################
#                 RUN PLEIOFDR                     #
####################################################

# Step 1: Change config file
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/modify_configv2.py \
    $MAT_FILE_1 \
    $MAT_FILE_2 \
    $PHEN1 \
    $PHEN2 \
    $PAIR_DIR


# # Step 2: Execute pleiofdr in Matlab

# # Go into the pleiofdr folder to execute the program properly
cd /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr
echo "Changed to pleiofdr directory"

CONFIG_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config-$PHEN1"_"$PHEN2.txt

# Run matlab for conjfdr
echo "Running Matlab..."
matlab -nodisplay -nosplash -nodesktop -r "config='$CONFIG_FILE'; run('runme.m'); exit;"
