#!/bin/bash
#SBATCH -t 12:00:00
#SBATCH -p epyc,rome,medium
#SBATCH --mem=16g
#SBATCH -J raxml-ng
#SBATCH -o raxml-ng.%j.out
#SBATCH -e raxml-ng.%j.err

#usage: modeltest-ng.sh PREFIX

singularity exec /usr/local/biotools/m/modeltest-ng:0.1.7--hf316886_3 \
modeltest-ng -i "$1".min4.phy.varsites.phy
