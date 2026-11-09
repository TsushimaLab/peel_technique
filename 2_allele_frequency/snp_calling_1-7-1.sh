#!/bin/bash
#SBATCH -t 16:00:00
#SBATCH --mem 24g
#SBATCH -p epyc
#SBATCH -J pileup
#SBATCH -o pileup.%j.out
#SBATCH -e pileup.%j.err

DIRE="mapping/mapping_plasmoparaviticola/2022_analysis"

for i in $(cat LIST.txt)
do
echo "$i"Start `date`
singularity exec /usr/local/biotools/s/samtools:1.19.2--h50ea8bc_1 \
samtools mpileup -f ./reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta ./$DIRE/"$i"sort.bam | gzip -9 -c > ./$DIRE/"$i"sort.pileup.gz
echo "$i"Finish `date`
done
