import os
import sys

#######################################################################
#                               FUNCTIONS                             #
#######################################################################

# Function to create pairs
def make_pairs(list1, list2, directory):
    pairs = set()  # Pairs are stored in a set to avoid repetition

    try:
        print(f"Making pairs ...")
        for root, _, files in os.walk(directory):
            for file in files:
                if file.endswith("-zscore.csv"):
                    file_path = os.path.join(root, file)
                    phen_name = file.split('-')[0]
                    # Check if the phen_name matches with any element in list1
                    if phen_name in list1:
                        for other_file in files:
                            if other_file != file and other_file.endswith("-zscore.csv"):
                                other_file_path = os.path.join(root, other_file)
                                other_phen_name = other_file.split('-')[0]
                                # Check if the other_phen_name matches with any element in list2
                                if other_phen_name in list2:
                                    pair = file_path + ',' + other_file_path
                                    reverse_pair = other_file_path + ',' + file_path
                                    # Check if the reverse pair hasn't been generated yet
                                    if (reverse_pair not in pairs) and (pair not in pairs):
                                        pairs.add(pair)
    except Exception as e:
        print(f"Error while creating pairs: {e}")
        sys.exit(1)

    return list(pairs)

# Function to separate noncorrelated traits
def remove_noncorr(lists_w_pairs, non_correlated_pairs):
    try:
        print("Separating non-correlated traits...")
        noncorr_pairs = set()  # Using a set to avoid repetition
        updated_lists = []

        # Loop through each non-correlated pair
        for nonc_pair in non_correlated_pairs:
            phen1, phen2 = nonc_pair.split(",")
            # Loop through each list of pairs
            for lst in lists_w_pairs:
                # Loop through each pair in the list
                for pair in lst:
                    file1, file2 = pair.split(",")
                    # Check if the current pair matches any non-correlated pair
                    if (phen1 in file1 and phen2 in file2) or (phen1 in file2 and phen2 in file1):
                        noncorr_pairs.add(pair)  # Add the matching pair to non-correlated pairs set

        # Remove non-correlated pairs from each list of pairs
        for lst in lists_w_pairs:
            updated_list = [x for x in lst if x not in noncorr_pairs]
            updated_lists.append(updated_list)
    
    except Exception as e:
        print(f"Error occurred: {e}")
        sys.exit(1)

    return updated_lists, list(noncorr_pairs)  # Convert set back to list for consistency

# Function to save lists to files
def save_list_to_file(lst, out_dir):
    try:
        file_path = os.path.join(out_dir, "pairs_list.txt")
        with open(file_path, 'w') as f:
            for item in lst:
                f.write("%s\n" % item)
        print(f"List saved to {file_path}")
    except Exception as e:
        print(f"Error occurred while saving list to file: {e}")


#######################################################################
#                           GENERAL CODE                              #
#######################################################################
    
# List of diseases and traits
disease_list = ['HT_d', 'T2D_d', 'CAD_d', 'STR_d']
trait_list = ['AI_t', 'BMI_t', 'DBP_t', 'FG_t', 'HDL_t', 'LDL_t', 'SBP_t', 'TGL_t', 'WC_t']

# Non-correlated pairs
non_correlated_pairs = ['LDL_t,FG_t_b', 'LDL_t,AI_t_b', 'LDL_t,CAD_d']

# Directory paths
InputDir = '/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/1-Convert/outputs'
OutDir_disdis = '/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/2-Analysis/dis-dis'
OutDir_distrait = '/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/2-Analysis/dis-trait'
OutDir_noncorr = '/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/2-PleioFDR/2-Analysis/non-correlated'

# Create output directories if they don't exist
try:
    os.makedirs(OutDir_disdis, exist_ok=True)
    os.makedirs(OutDir_distrait, exist_ok=True)
    os.makedirs(OutDir_noncorr, exist_ok=True)
    print("Output directories created successfully.")
except OSError as e:
    print(f"Error: {e.strerror}")

# Create pair lists usigng the make_pairs function
disease_trait_pairs = make_pairs(disease_list, trait_list, InputDir)
disease_disease_pairs = make_pairs(disease_list, disease_list, InputDir)

# Then remove the non-corrleated pairs to a separated list
[disease_trait_pairs, disease_disease_pairs], noncorr_pairs = remove_noncorr([disease_trait_pairs, disease_disease_pairs], non_correlated_pairs)

# Save lists to the output directories
save_list_to_file(disease_trait_pairs, OutDir_distrait)
save_list_to_file(disease_disease_pairs, OutDir_disdis)
save_list_to_file(noncorr_pairs, OutDir_noncorr)
