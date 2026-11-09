#!/bin/bash
#SBATCH -t 2:00:00
#SBATCH --mem 24g
#SBATCH -p epyc
#SBATCH -J snp
#SBATCH -o snp.%j.out
#SBATCH -e snp.%j.err

LIBRARY="SRR_240807"
NAME2="new_"
DOWNLOAD="./../../script/download_script"

#注意:mapping/mapping_plasmoparaviticolaディレクトリから実行する
#depth:10

for i in $(cat WGS_LIST.txt)
do
cat $LIBRARY/"$NAME2"SNPs/"$i"_SNP_ratios.txt | perl $DOWNLOAD/compsnps_pipe_filter_SNPs_sample_stdin_pipe4_08.pl 10 0.2 0.8 > $LIBRARY/"$NAME2"SNPs/10X/$LIBRARY\_"$i"_SNP_freq_10x.txt
echo "$i"first_Finish `date`
perl $DOWNLOAD/tab2ggplot2input_allele_frequency_2.pl $LIBRARY $LIBRARY/"$NAME2"SNPs/10X/$LIBRARY\_"$i"_SNP_freq_10x.txt $LIBRARY/"$NAME2"Allele_freq/ "$i"_10X
echo "$i"second_Finish `date`
done
