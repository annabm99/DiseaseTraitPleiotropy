# Libraries
import sys
import itertools

# Read inputs
InputFile = sys.argv[1]
OutputPath = sys.argv[2]

### IN CASE WE JUST WANT TO COMBINE 1 TRAIT TO ALL OTHERS (InputFile should contain the paths of all the traits to combine)
CombTraitPath = ["/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/pleiotropy/1-LDSC/1-munge/outputs/T2D_d-munge.gz"]

with open(InputFile, 'r') as fh:
    PathList = fh.read().split('\n')


# Make pairs of all elements on the list            
#pairs = itertools.combinations(PathList, 2) # For all traits with all traits
pairs = itertools.product(CombTraitPath, PathList) # For 1 trait with all traits

# Open filehandle to save output
out = open(OutputPath, "w")

# Iterate through pairs and write to file in the adequate format for LDSC
for p in pairs:
    out.write(p[0]+","+p[1]+"\n")

out.close() # close filehandle