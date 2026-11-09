#!/bin/bash
#SBATCH -t 5-00:00:00
#SBATCH -p epyc,rome,medium
#SBATCH --mem=4g
#SBATCH --cpus-per-task=8
#SBATCH -J raxml-ng
#SBATCH -o raxml-ng.%j.out
#SBATCH -e raxml-ng.%j.err

#usage: raxml-ng3.sh PREFIX

#heuristic search for the ML tree
singularity exec /usr/local/biotools/r/raxml-ng:1.2.2--h6747034_2 \
raxml-ng --msa "$1".min4.phy.varsites.phy --model TVM+G4+ASC_LEWIS --prefix "$1" --seed 1000 \
--threads $SLURM_CPUS_PER_TASK --workers auto

#infer bootstrap trees
singularity exec /usr/local/biotools/r/raxml-ng:1.2.2--h6747034_2 \
raxml-ng --bootstrap --msa "$1".min4.phy.varsites.phy --model TVM+G4+ASC_LEWIS --prefix "$1" --seed 1000 \
--threads $SLURM_CPUS_PER_TASK --workers auto

#map the bootstrap support values onto the best ML tree
singularity exec /usr/local/biotools/r/raxml-ng:1.2.2--h6747034_2 \
raxml-ng --support --tree "$1".raxml.bestTree --bs-trees "$1".raxml.bootstraps --prefix bs_support_"$1"
