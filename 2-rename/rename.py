print ("____ RENAME.PY ___")

import sys
import shutil

# Dictionary to translate from codes to given names
namesDict = {
    "GCST011364" : "MI_d",
    "GCST90014023" : "T1D_d",
    "4085" : "T2D_d",
    "3693" : "CAD_d",
    "3691" : "HT_d",
    "21001" : "BMI_t",
    "48" : "WC_t",
    "4080" : "SBP_t",
    "4079" : "DBP_t",
    "30870" : "TGL_t",
    "30780" : "LDL_t",
    "30760" : "HDL_t",
    "30740" : "FG_t",
    "20116" : "SS_t",
    "1558" : "AI_t"
}

# Import arguments
FilePath = sys.argv[1].rstrip()
OutputDir = sys.argv[2].rstrip()

print("ARGUMENTS IMPORTED")

# Grab code and file ternmination
FileName=FilePath.split("/")[-1] # last item separated with /
Code=FileName.split(".")[0] # First part of the name

print("FILE NAME IS " + FileName)
print("CODE IS " + Code)

# Grab name from the dictionary and save new file name
Name=namesDict[Code]
NewFileName=Name+"-formatted.gz" # Add termination

print("NAME IS " + Name)

NewNamePath=OutputDir+"/"+NewFileName

# Save with the new name
shutil.copy(FilePath, NewNamePath)
 
print("FILE RENAMED TO " + NewNamePath)
print("Python done....")