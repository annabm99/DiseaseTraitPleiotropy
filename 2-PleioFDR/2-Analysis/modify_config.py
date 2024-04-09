import ConfigParser
import sys

def modify_config(file1, file2, phen1, phen2, dir):
    print("Modifying configuration file...")
    
    try:
        # Read the configuration from the default file
        OgConfig="/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config.txt"
        print("Original configuration file: {}".format(OgConfig))
        
        # Start configuration parser
        config = ConfigParser.ConfigParser()
        config.read(OgConfig)

        # Make modifications to the configuration
        config.set('', 'traitfolder', dir)
        print("Changed trait folder to: {}".format(dir))
        config.set('', 'traitfile1', file1)
        print("Changed file 1 to: {}".format(file1))
        config.set('', 'traitname1', phen1)
        print("Changed traitname1 to: {}".format(phen1))
        # The next two are different because in the config file they go between brackets: {'BMI_t'}
        config.set('', 'traitfiles', "{'%s'}" % file2)
        print("Changed traitfiles (traitfile2) to: {}".format(file2))
        config.set('', 'traitnames', "{'%s'}" % phen2)
        print("Changed traitnames (traitname2) to: {}".format(phen2))
        config.set('', 'outputdir', dir)
        print("Changed output directory to: {}".format(dir))
        
        # Modify other parameters as needed

        # Write the modified configuration to the output file
        output_file = "/gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config_{0}_{1}.txt".format(phen1, phen2)
        print("Writing the final configuration file to {}".format(output_file))
        with open(output_file, 'w') as f:
            config.write(f)

    except Exception as e:
        print("Error occurred while modifying the configuration file:", e)
        sys.exit(1)

# End of modify function
        
# Read input arguments
if len(sys.argv) != 6:
    print ("Usage: python script.py <file1> <file2> <phen1> <phen2>")
    sys.exit(1)

File1=sys.argv[1].rstrip()
File2=sys.argv[2].rstrip()
Phen1=sys.argv[3].rstrip()
Phen2=sys.argv[4].rstrip()
Dir=sys.argv[5].rstrip()

# Run modify function
modify_config(File1, File2, Phen1, Phen2, Dir)
print ("Modified configuration file: /gpfs42/projects/lab_anavarro/disease_pleiotropies/anthropometric/anna/scripts/PleioFDR/2-Analysis/pleiofdr/config_{0}_{1}.txt".format(Phen1, Phen2))
