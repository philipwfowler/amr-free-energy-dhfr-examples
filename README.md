# Calculating whether genetic mutations confer antibiotic resistance: example free energy calculations

## Release notes

The files contained within this simple tutorial complement our manuscript titled "Robust prediction of resistance to trimethoprim in *Staphylococcus aureus*" that is currently under revision. Once the manuscript is published, this README file will updated with a DOI and appropriate URLs.

To obtain the repository, assuming you have git installed, issue.

    git clone https://github.com/philipwfowler/amr-free-energy-dhfr-examples.git 

which will create a directory called alchembed-tutorial and download the files. Please note that the total repo is around 0.5GB.

## Objective

To allow a reader of our manuscript to calculate how the binding free energies of trimethoprim (TMP, an antibiotic) and dihydrofolic acid (DHA, the natural substrate) to S. aureus DHFR change upon the introduction of one of 7 protein mutations. As explained in the paper, three of these mutations confer resistance to TMP, whilst the remaining four have no effect. Our hypothesis is that a mutation confers resistance if it reduces how well TMP binds (ddG > 0) whilst having little or no effect on the binding of DHA, the natural substrate (ddG ~ 0).

## Citing

Please cite

> Fowler PW, Cole K, Gordon NC, Kearns AM, Llewelyn, Peto TEA, Crook DW, Waker AS. Robust Prediction of Resistance to Trimethoprim in Staphylococcus aureus. Cell Chem Biol 2018; in press. [doi:10.1016/j.chembiol.2017.12.009](http://dx.doi.org/10.1016/j.chembiol.2017.12.009)

or in BibTeX format

@article{Fowler2016,
author = {Fowler, Philip W and Cole, Kevin and Gordon, N Claire and Kearns, Angela M and Llewelyn, Martin J and Peto, Tim E A  and Crook, Derrick W and Walker, A Sarah},
doi = {10.1016/j.chembiol.2017.12.009},
journal = {Cell Chem Biol},
title = {{Robust Prediction of Resistance to Trimethoprim in Staphylococcus aureus}},
url = {http://dx.doi.org/10.1016/j.chembiol.2017.12.009},
volume = {in press},
year = {2018}
}

## Prerequisites

We have deliberately removed as many dependencies as possible and only provide the GROMACS TPR files to simplify the process of repeating these free energy calculations. The remaining prerequisites are

- An MPI library, such as [OpenMPI](https://www.open-mpi.org) that puts an mpirun binary in your $PATH.
- [GROMACS 5.1.2](http://www.gromacs.org) or later. Since the TPR files are provided there are no forcefield dependencies. Note that OpenMPI needs to be installed before you compile GROMACS - see [here](http://manual.gromacs.org/documentation/2016.4/install-guide/index.html)
- Python 2.X
- [alchemical-analysis](https://github.com/MobleyLab/alchemical-analysis)
- bzip2

## Instructions

The git repo contains a number of bash shell scripts in its root. Each will be explained where relevant. All the TPR files are organised in a hierarchy such as 

	$ ls f99y/01/11/
	dhfr-3fre-f99y-01-11.0.tpr.bz2 dhfr-3fre-f99y-01-11.2.tpr.bz2 dhfr-3fre-f99y-01-11.4.tpr.bz2 
	dhfr-3fre-f99y-01-11.6.tpr.bz2 dhfr-3fre-f99y-01-11.1.tpr.bz2 dhfr-3fre-f99y-01-11.3.tpr.bz2 
	dhfr-3fre-f99y-01-11.5.tpr.bz2 dhfr-3fre-f99y-01-11.7.tpr.bz2 dhfr-3fre-f99y-01-11.sh
	
here f99y is the mutation, 01 is the number of the repeat and 11 is what we call the leg and refers to Fig S5B of the Supplement and Equations S9 and S10. For example, dG_11 is the free energy of removing the electrostatic charges from the alchemical atoms in the apo protein, whilst dG_61 and dG_91 is the same free energy, but with TMP and DHA bound, respectively. Each leaf of the tree is therefore a single free energy calculation and contains eight compressed TPR files and a single bash script for running the necessary GROMACS simulation.

To ensure the repo was small enough to fit on GitHub, all the TPR files are compressed with bzip2. To compress them run

	$ bash uncompress-tpr-files.sh 
	
Note that if you have [GNU parallel](https://www.gnu.org/software/parallel/) installed, you can modify the script to speed it up. There is a corresponding script that compresses the TPR files

	$ bash compress-tpr-files.sh 

Since there are eight mutations with only a single repeat each (there were 32 in the paper), each of which has 13 legs, this repository contains 8x13 = 104 free energy calculations. To run a single calculation, assuming the prerequisites are installed and you've uncompressed all the TPR files, 

	$ cd f99y/01/11/
	$ bash dhfr-3fre-f99y-01-11.sh 

GROMACS will then run 8 separate MPI processes, one for each lambda simulation, with replica exchange swaps. Depending on the speed of your computer, each free energy calculation will take between 3-12 hours and will produce 60-70Mb of files. Feel free to run the calculations on your computing cluster or the cloud, adapting the bash script accordingly.

Assuming you have now run all 108 individual free energies, analysis is a two step process. The first assumes you have installed [alchemical-analysis](https://github.com/MobleyLab/alchemical-analysis) and this bash script will run it on each free energy in turn.

	$ bash run-alchemical-analysis.sh 
	
This will deposit two files results.txt and results.pickle into each of the 108 subdirectories. The next step parses these and then, by via Equation S10 in the Supplement, calculate the two binding free energies for each mutation

	$ bash calculate-ddG.sh 
	
This calls a stripped-down Python script that simply parses all the results.txt files and then calculates how the binding free energies of TMP and DHA vary for each mutant. To avoid confusion the output is verbose and looks like

    F99Y mutation alters free energy of TMP binding by     1.69 kcal/mol and free energy of DHA binding by    -0.99 kcal/mol

Compare the results of your n=1 free energies with the values in Tables S3 and S4. Note that since a random seed is generated at the start of each GROMACS run, repeating the simulations will lead to different free energies, although as the TPR file is the same, the same starting structure will be used.

If you wish to keep the output, redirect it to a file. In case you wish to delete ALL the output files, a bash script is provided. Use this with caution.

	$ bash delete-output-files.sh 


