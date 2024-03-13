#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J PleioFDR
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=anna.basquet01@estudiant.upf.edu # send-to address

echo "_____ PLEIOFDR.SH _____"

# Load matlab module
module load MATLAB/2016a

# Load variables
SUMSTATS_LIST=$1
OUTPUT_DIR=$2
echo "variables loaded"

matlab -nodisplay -nosplash < runme.m