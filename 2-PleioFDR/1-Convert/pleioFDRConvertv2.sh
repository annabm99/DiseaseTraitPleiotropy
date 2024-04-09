#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J rev_ConvertPleioFDR
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

# Print usage message if not enough arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SUMSTATS_LIST OUTPUT_DIR"
    exit 1
fi

echo "_____ PLEIOFDRCONVERT.SH _____"

# Load Python module (has to be between 2.7 and 3)
module load Python/2.7.11-foss-2016b || { echo "Unable to load Python module"; exit 1; }

# Load variables
SUMSTATS_LIST=$1
OUTPUT_DIR=$2
echo "Variables loaded"

# Check if SUMSTATS_LIST exists
if [ ! -e "$SUMSTATS_LIST" ]; then
    echo "SUMSTATS_LIST file not found: $SUMSTATS_LIST"
    exit 1
fi

# Grab one file from path list
INPUT_PATH=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SUMSTATS_LIST")

# Check if INPUT_PATH exists
if [ ! -e "$INPUT_PATH" ]; then
    echo "Input file not found: $INPUT_PATH"
    exit 1
fi

echo "File number is $SLURM_ARRAY_TASK_ID"
echo "Input file is $INPUT_PATH"

# Grab phenotype name
PHEN_NAME=$(echo "$INPUT_PATH" | cut -d "/" -f11 | cut -d "-" -f1)
echo "Name is $PHEN_NAME"

# Read the first line (header) of the file
header=$(gunzip -c "$INPUT_PATH" | head -n 1)

# Check if "ID" or "SNP" exists in the header
if [[ "$header" == *"ID"* ]]; then
    id_name="ID"
elif [[ "$header" == *"SNP"* ]]; then
    id_name="SNP"
else
    echo "Neither 'ID' nor 'SNP' found in the column names"
    exit 1
fi

# Check if "BETA", "logOR", "OR", or "EFFECT" exists in the header
if [[ "$header" == *"BETA"* ]]; then
    effect_name="BETA"
elif [[ "$header" == *"LOGODDS"* ]]; then
    effect_name="LOGODDS"
elif [[ "$header" == *"OR"* ]]; then
    effect_name="OR"
elif [[ "$header" == *"EFFECT"* ]]; then
    effect_name="EFFECT"
else
    echo "No effect column was found"
    exit 1
fi

# Check if "SE_BETA", "SE_logOR", or "SE" exists in the header
if [[ "$header" == *"SE_BETA"* ]]; then
    se_name="SE_BETA"
elif [[ "$header" == *"SE_logOR"* ]]; then
    se_name="SE_LOGODDS"
elif [[ "$header" == *"SE"* ]]; then
    se_name="SE"
else
    echo "No SE column was found"
    continue
fi

# Step 1: Filter for SNPs in the reference dataset
echo "... Filtering for SNPs in the reference dataset ..."
python ./compare_w_ref.py \
        "$INPUT_PATH" \
        "$OUTPUT_DIR" \
        "${PHEN_NAME}-filt.csv.gz" || { echo "Filtering failed"; exit 1; }

FILT_FILE="$OUTPUT_DIR/$PHEN_NAME-filt.csv.gz"
echo "Filtered file: $FILT_FILE"

###############################################################
#                       PLEIOFDR FORMATTER                    #
###############################################################

# Step 2: Convert to csv format
echo "... Starting conversion to csv ..."

# Determine arguments based on the effect column of the given input file
conversion_args=""
case "$PHEN_NAME" in
    "T2D_d")
        conversion_args="--auto --or $effect_name --oru95 ORU95 --orl95 ORL95"
        ;;
    "CAD_d")
    conversion_args="--auto --chrpos CHRPOS --logodds $effect_name --se $se_name"
    ;;
    *)
        if [[ "$effect_name" == "BETA" ]]; then
            conversion_args="--auto --se $se_name --beta $effect_name"
        elif [[ "$effect_name" == "OR" ]]; then
            conversion_args="--auto --se $se_name --or $effect_name"
        elif [[ "$effect_name" == "LOGODDS" ]]; then
            conversion_args="--auto --se $se_name --logodds $effect_name"
        fi
        ;;
esac

# Run the conversion command
python ./python_convert/sumstats.py csv \
        --sumstats "$FILT_FILE" \
        --out "$OUTPUT_DIR/$PHEN_NAME.csv" \
        --snp "$id_name" \
        $conversion_args --force || { echo "CSV conversion failed"; exit 1; }

echo "CSV convert done"

CSV_FILE="$OUTPUT_DIR/$PHEN_NAME.csv"
echo "Output file: $CSV_FILE"

# Step 3: Calculate z-score
echo "... Starting to calculate Z scores ..."

# Determine additional arguments based on phenotype name for T2D
zscore_args=""
if [[ "$PHEN_NAME" == "T2D_d" ]]; then
    zscore_args="--a1-inc"
fi

# Run the z-score calculation command
python ./python_convert/sumstats.py zscore \
        --sumstats "$CSV_FILE" \
        --out "$OUTPUT_DIR/$PHEN_NAME-zscore.csv" \
        --effect "$effect_name" \
        $zscore_args --force || { echo "Z-score calculation failed"; exit 1; }

echo "Z-score calculation done"

ZSCORE_FILE="$OUTPUT_DIR/$PHEN_NAME-zscore.csv"
echo "Output file: $ZSCORE_FILE"
