#! /bin/bash

# This will search for all the GROMACS TPR files in all subdirectories and compress them with bzip2
find . -name 'dhfr-3fre*tpr.bz2' | xargs bunzip2 -v

# if you have GNU parallel installed, this command will be faster
# find . -name 'dhfr-3fre*tpr.bz2' | parallel bunzip2 -v {}
