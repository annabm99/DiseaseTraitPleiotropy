# Libraries
import sys
import itertools

# Read inputs
InputFile = sys.argv[1]
OutputPath = sys.argv[2]

# Read input file content and save it to a list, separated with newline
with open(InputFile, 'r') as fh:
    PathList = fh.read().split('\n')

# Make pairs of all elements on the list            
pairs = itertools.combinations(PathList, 2)

# Open filehandle to save output
out = open(OutputPath, "w")

# Iterate through pairs and write to file in the adequate format for LDSC
for p in pairs:
    out.write(p[0]+","+p[1]+"\n")

out.close() # close filehandle