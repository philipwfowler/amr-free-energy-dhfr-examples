#! /bin/bash

for mutation in f99y y99l21v l21v l41f a135t f123l v76a i83v; do
  for repeat in 01; do
     for leg in 11 12 13 5 61 62 63 7 8 91 92 93 10; do
	      alchemical_analysis --prefix=dhfr-3fre-$mutation-$repeat-$leg.dudl -s 100 -t 310 --units=kcal --dir=$mutation/$repeat/$leg/
     done;
   done;
done;
