#!/bin/bash
#SBATCH -t 3:00:00
#SBATCH --mem 4g
#SBATCH -p epyc,rome
#SBATCH -J tub_tree
#SBATCH -o tub_tree.%j.out
#SBATCH -e tub_tree.%j.err

singularity exec /usr/local/biotools/m/muscle:5.3--h9948957_3 \
muscle -align -nt $1.fa -output $1.afa

singularity exec /usr/local/biotools/r/raxml-ng:1.2.2--h6747034_2 \
raxml-ng --all --msa $1.afa --model DNA --prefix $1 --seed 1000
