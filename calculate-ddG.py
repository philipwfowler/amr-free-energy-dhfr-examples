#! /usr/bin/env python

import argparse

# command line options
parser = argparse.ArgumentParser()
parser.add_argument("--mutation",type=str,required=True,help="the name of a specific mutation to calculate how the free energy of binding of TMP and DHA change")
parser.add_argument("--repeat",type=str,required=False,default='01',help="the identifier of the repeat to consider e.g. 01")
options = parser.parse_args()

# these free energies are defined in Fig S5D of the Supplement
# to simplify the calculation, these dictionaries also define whether each free energy is positive or negative in Equation S10
# note that to calculate the ddG for DHA simply requires replacing the tmp_legs by dha_legs i.e. 5->8, 61->91, 7->10.
apo_legs={'11':-1,'12':-1,'13':-1}
tmp_legs={'5':1,'61':1,'62':1,'63':1,'7':-1}
dha_legs={'8':1,'91':1,'92':1,'93':1,'10':-1}

# define an empty dictionary to store the results
dG={}

# make a list of all the legs, and therefore all the results files to read in
all_legs=apo_legs.keys()+tmp_legs.keys()+dha_legs.keys()

# iterate over each leg
for leg in all_legs:

    # open the text file written by alchemical_analysis
    with open(options.mutation+"/"+options.repeat+"/"+leg+"/results.txt") as INPUT:

        # iterate through the file line-by-line
        for line in INPUT:

            # split each line
            cols=line.split()

            # if the line isn't empty and starts with "TOTAL:", pick out the TI free energy
            if len(cols)>0 and cols[0]=="TOTAL:":
                dG[leg]=float(cols[1])

ddG_tmp=0
ddG_dha=0
for leg in apo_legs:
    ddG_tmp+=dG[leg]*apo_legs[leg]
    ddG_dha+=dG[leg]*apo_legs[leg]

for leg in tmp_legs:
    ddG_tmp+=dG[leg]*tmp_legs[leg]

for leg in dha_legs:
    ddG_dha+=dG[leg]*dha_legs[leg]

print "%8s mutation alters free energy of TMP binding by  %7.2f kcal/mol and free energy of DHA binding by  %7.2f kcal/mol" % ( options.mutation.upper(),ddG_tmp, ddG_dha)
