#!/bin/bash
#SBATCH -t 16:00:00
#SBATCH --mem 24g
#SBATCH -p epyc
#SBATCH -J snp
#SBATCH -o snp.%j.out
#SBATCH -e snp.%j.err

DIRE="mapping/mapping_plasmoparaviticola/2022_analysis"
TO="2022_SNPs"

for i in $(cat LIST.txt)
do
gunzip -c ./$DIRE/"$i"sort.pileup.gz | perl script/download_script/compsnps_pipe1_sampileup_4.py > ./$DIRE/$TO/"$i"_SNP_ratios.txt
echo "$i"Finish `date`
done
