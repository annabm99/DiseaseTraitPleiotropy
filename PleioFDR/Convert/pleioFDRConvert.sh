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

echo "_____ PLEIOFDRCONVERT.SH _____"

# Load Python module (has to be between 2.7 and 3)
module load Python/2.7.11-foss-2016b

# Load variables
SUMSTATS_LIST=$1
OUTPUT_DIR=$2
echo "variables loaded"

# Grab one file from path list
INPUT_PATH=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)

echo "file number is $SLURM_ARRAY_TASK_ID"
echo "input file is $INPUT_PATH"

# Grab phenotype name
PHEN_NAME=$(echo $INPUT_PATH | cut -d "/" -f11 | cut -d "-" -f1)
echo "Name is $PHEN_NAME"

# Read the first line (header) of the file
header=$(gunzip -c $INPUT_PATH | head -n 1)
echo $header

# Check if the header contains "ID" or "SNP"
if [[ "$header" == *"ID"* ]]; then
        id_name="ID"
elif [[ "$header" == *"SNP"* ]]; then
        id_name="SNP"
else
    echo "Neither 'ID' nor 'SNP' found in the column names"
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
    echo "No effect column was found"
fi

# Cheack if the header contains SE, SE_BETA or SE_logOR
if [[ "$header" == *"SE_BETA"* ]]; then
        se_name="SE_BETA"
elif [[ "$header" == *"SE_logOR"* ]]; then
        se_name="SE_logOR"
elif [[ "$header" == *"SE"* ]]; then
        se_name="SE"
else
    echo "No SE column was found"
fi

# Step 1: Grab SNPs only in the reference dataset
echo "... Filtering for SNPs in the reference dataset ..."
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py rs \
        --sumstats $INPUT_PATH \
        --ref /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/RefFiles/9545380.ref \
        --out $OUTPUT_DIR/$PHEN_NAME-filt.csv \
        --force

FILT_FILE=$OUTPUT_DIR/$PHEN_NAME-filt.csv
echo "Filtered file: $FILT_FILE"

# Step 2: Run PleioFDR formatter to convert to csv PleioFDR format
echo "... Starting conversion to csv ..."
# The arguments passed to pleioFDR convert will depend on the effect column of the given input file
if [[ $PHEN_NAME == "T2D_d" ]]; then
        python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py csv \
                --auto \
                --sumstats $FILT_FILE \
                --out $OUTPUT_DIR/$PHEN_NAME.csv \
                --or $effect_name \
                --oru95 ORU95 \
                --orl95 ORL95 \
                --snp $id_name \
                --force

elif [[ "$effect_name" == "BETA" ]]; then
        python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py csv \
                --auto \
                --sumstats $FILT_FILE \
                --out $OUTPUT_DIR/$PHEN_NAME.csv \
                --se $se_name \
                --snp $id_name \
                --beta $effect_name \
                --force

elif [[ "$effect_name" == "OR" ]]; then
        python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py csv \
                --auto \
                --sumstats $FILT_FILE \
                --out $OUTPUT_DIR/$PHEN_NAME.csv \
                --se $se_name \
                --snp $id_name \
                --or $effect_name \
                --force

elif [[ "$effect_name" == "logOR" ]]; then
        python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py csv \
                --auto \
                --sumstats $FILT_FILE \
                --out $OUTPUT_DIR/$PHEN_NAME.csv \
                --se $se_name \
                --snp $id_name \
                --logodds $effect_name \
                --force
fi
echo "CSV convert done"

CSV_FILE=$OUTPUT_DIR/$PHEN_NAME.csv
echo "Output file: $CSV_FILE"

# Step 3: Calculate z-score
echo "... Starting to calculate Z scores ..."
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py zscore \
        --sumstats $CSV_FILE \
        --out $OUTPUT_DIR/$PHEN_NAME-zscore.csv \
        --effect $effect_name \
        --force
echo "Z-score calculation done"

ZSCORE_FILE=$OUTPUT_DIR/$PHEN_NAME-zscore.csv
echo "Output file: $SZCORE_FILE"

# Step 4: Run PleioFDR formatter to convert to mat format
echo "... Starting conversion to mat ..."
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/1-Convert/python_convert/sumstats.py mat \
        --sumstats $ZSCORE_FILE \
        --ref /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/2-PleioFDR/RefFiles/9545380.ref \
        --out $OUTPUT_DIR/$PHEN_NAME.mat \
        --force

echo "Output file: $OUTPUT_DIR/$PHEN_NAME.mat"
