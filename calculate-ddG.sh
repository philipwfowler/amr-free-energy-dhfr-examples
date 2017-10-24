#! /bin/bash

for mutation in f99y y99l21v l21v l41f a135t f123l v76a i83v; do
  ./calculate-ddG.py --mutation $mutation --repeat 01;
done
