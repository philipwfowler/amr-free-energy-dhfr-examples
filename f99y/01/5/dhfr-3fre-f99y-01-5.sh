#!/bin/bash

# load the locally installed version of GROMACS into your $PATH
# note that if you compiled gromacs without the install prefix flag, the location will be /usr/local/gromacs/bin/GMXRC
source /usr/local/gromacs/5.1.2/bin/GMXRC

# also need to have compiled or installed OpenMPI in order for replica exchange
# since this run all 8 lambda simulations simulataneously, this will use 8 threads.
# if you have a machine with 16 threads, increase the number of OpenMP processes via the ntomp flag
mpirun -np 8 mdrun_mpi -multi 8 -replex 1000 -nex 10000 -deffnm dhfr-3fre-f99y-01-5. -dhdl dhfr-3fre-f99y-01-5.dudl. -stepout 100 -v -cpi -append -ntomp 1
