#! /bin/bash

# CAUTION: This deletes all the GROMACS output and backup files in all subdirectories so use carefully

find . -name '\#dhfr-3fre*' -delete
find . -name 'dhfr-3fre*xtc' -delete
find . -name 'dhfr-3fre*trr' -delete
find . -name 'dhfr-3fre*gro' -delete
find . -name 'dhfr-3fre*xvg' -delete
find . -name 'dhfr-3fre*edr' -delete
find . -name 'dhfr-3fre*cpt' -delete
find . -name 'dhfr-3fre*log' -delete
