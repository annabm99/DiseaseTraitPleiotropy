import sys
import os

def modify_template(ref_file, file1, file2, phen1, phen2, pair_dir, stat_type, fdr_thresh, randprune_n, exclude_chr_pos):
    
    try:
        # Read the template file
        default_config="/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config_template.txt"
        with open(default_config, "r") as f:
            template = f.read()

        # Replace placeholders with provided values
        print ("Replacing values in config.txt: {}, {}, {}, {}, {}, {}, {}, {}, {}, {}".format(
            ref_file, file1, file2, phen1, phen2, pair_dir, stat_type, fdr_thresh, randprune_n, exclude_chr_pos
            ))
        
        modified_config = template.replace('${ref_file}', ref_file)\
                                .replace('${trait_folder}', pair_dir)\
                                .replace('${trait_file1}', file1)\
                                .replace('${trait_name1}', phen1)\
                                .replace('${trait_file2}', file2)\
                                .replace('${trait_name2}', phen2)\
                                .replace('${out_dir}', pair_dir)\
                                .replace('${stat_type}', stat_type)\
                                .replace('${fdr_thresh}', fdr_thresh)\
                                .replace('${randprune_n}', randprune_n)\
                                .replace('${exclude_chr_pos}', exclude_chr_pos)

        # Write the modified content to config_pair.txt
        outfile="/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config-{}_{}.txt".format(phen1, phen2)
        with open(outfile, "w") as f:
            f.write(modified_config)
        print("New config file written: {}",format(outfile))

    except Exception as e:
        print("Error:", e)
        sys.exit(1)

# Check if the correct number of arguments is provided
if len(sys.argv) != 6:
    print("Usage: python script.py file1 file2 phen1 phen2 pair_dir")
    sys.exit(1)

# Import variables from input arguments
File1, File2, Phen1, Phen2, Dir = [arg.strip() for arg in sys.argv[1:]]

# Grab only filenames of the two input files (with the whole path)
FileName1 = os.path.basename(File1)
FileName2 = os.path.basename(File2)

# Execute modifyer function
try:
    modify_template(
        ref_file="/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/RefFiles/ref9545380_1kgPhase3eur_LDr2p1.mat",
        file1=FileName1,
        file2=FileName2,
        phen1=Phen1,
        phen2=Phen2,
        pair_dir=Dir,
        stat_type="conjfdr",
        fdr_thresh="0.05",
        randprune_n="500",
        exclude_chr_pos=""
    )
except Exception as e:
    print("Error:", e)
    sys.exit(1)