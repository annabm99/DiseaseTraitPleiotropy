#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J PleioFDR_Convert
##SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Usage function
usage() {
    echo "Usage: $0 <sumstats_list> <output_dir>"
    echo "   <sumstats_list>: Path to the list of input files"
    echo "   <output_dir>: Path to the output directory"
    exit 1
}

echo "_____ PLEIOFDRCONVERT.SH _____"

# Increase RAM memory
interactive -m 20

# Load Python module (has to be between 2.7 and 3)
module load Python/2.7.11-foss-2016b

# Check the number of arguments
if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments."
    usage
fi

SUMSTATS_LIST=$1
OUTPUT_DIR=$2

# Check if input file exists
if [ ! -f "$SUMSTATS_LIST" ]; then
    echo "Error: Input file list '$SUMSTATS_LIST' not found."
    exit 1
fi

# Check if output directory exists, if not create it
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR" || { echo "Error: Failed to create output directory."; exit 1; }
fi

echo "... Variables loaded ..."

# Grab one file from path list
INPUT_PATH=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)

# Check if the file exists
if [ ! -f "$INPUT_PATH" ]; then
        echo "Warning: Input file '$INPUT_PATH' not found. Skipping..."
        continue
else
        echo "File number is $SLURM_ARRAY_TASK_ID, input file is $INPUT_PATH"
fi

# Grab phenotype name
PHEN_NAME=$(basename "$INPUT_PATH" | cut -d "-" -f1)
echo "Phenotype name: $PHEN_NAME"

# Read the first line (header) of the file
header=$(gunzip -c $INPUT_PATH | head -n 1)
echo "Original header: $header"

# Check if the header contains "SNP"
if [[ "$header" != *"SNP"* ]]; then
        echo "Error: 'SNP' not found in the column names, rsid column has to have the name SNP."
        continue
fi

# Cheack if the header contains BETA, OR, logOR or EFFECT
if [[ "$header" == *"BETA"* ]]; then
        effect_name="BETA"
elif [[ "$header" == *"logOR"* ]]; then
        effect_name="logOR"
elif [[ "$header" == *"OR"* ]]; then
        effect_name="OR"
elif [[ "$header" == *"EFFECT"* ]]; then
        effect_name="EFFECT"
else
        echo "Error: No effect column was found."
        exit 1
fi

# Cheack if the header contains SE, SE_BETA or SE_logOR
if [[ "$header" == *"SE_BETA"* ]]; then
        se_name="SE_BETA"
elif [[ "$header" == *"LOGODDS"* ]]; then
        se_name="LOGODDS"
elif [[ "$header" == *"SE"* ]]; then
        se_name="SE"
else
        echo "Error: No standard error column was found."
        continue
fi

# Step 1: Grab SNPs only in the reference dataset
echo "... Filtering for SNPs in the reference dataset ..."
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/compare_w_ref.py \
        ${INPUT_PATH} \
        ${OUTPUT_DIR} \
        ${PHEN_NAME}-filt.csv.gz

FILT_FILE=$OUTPUT_DIR/$PHEN_NAME-filt.csv.gz
echo "Filtered file: $FILT_FILE"

# Step 2: Run PleioFDR formatter to convert to csv PleioFDR format

# Effect column mappings
declare -A effect_mappings=(
    ["BETA"]="--se $se_name --beta $effect_name"
    ["OR"]="--se $se_name --or $effect_name"
    ["logOR"]="--se $se_name --logodds $effect_name"
)

# Check if the phenotype is T2D_d, because it is handled different (has no SE)
if [[ $PHEN_NAME == "T2D_d" ]]; then
    effect_arg="--or $effect_name --oru95 ORU95 --orl95 ORL95"
elif [[ $PHEN_NAME == "CAD_d" ]]; then
    effect_arg="$effect_mappings[$effect_name] --chrpos CHRPOS"
else
    # Retrieve the effect argument based on the effect name
    effect_arg="$effect_mappings[$effect_name]"
fi

echo "The arguments to python convert will be: $effect_arg"

# Check if the effect argument is defined
if [[ -n "$effect_arg" ]]; then
    # Run PleioFDR formatter with the retrieved effect argument
    echo "... Starting conversion to csv ..."

    python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py csv \
        --auto \
        --sumstats "$FILT_FILE" \
        --out "$OUTPUT_DIR/$PHEN_NAME.csv" \
        --snp "$id_name" \
        $effect_arg \
        --force
else
        echo "ERROR: Arguments for pleioconvert could not be set successfully."
        exit 1
fi

echo "CSV convert done"
CSV_FILE=$OUTPUT_DIR/$PHEN_NAME.csv
echo "Output file: $CSV_FILE"

# Step 3: Calculate z-score

# Check if the phenotype is T2D_d, it needs an extra argument
if [[ $PHEN_NAME == "T2D_d" ]]; then
    effect_arg="--a1-inc"
else
    effect_arg=""
fi

echo "... Starting to calculate Z scores ..."
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py zscore \
        --sumstats $CSV_FILE \
        --out $OUTPUT_DIR/$PHEN_NAME-zscore.csv \
        --effect $effect_name \
        $effect_arg \
        --force

echo "Z-score calculation done"

ZSCORE_FILE=$OUTPUT_DIR/$PHEN_NAME-zscore.csv
echo "Output file: $ZSCORE_FILE"
