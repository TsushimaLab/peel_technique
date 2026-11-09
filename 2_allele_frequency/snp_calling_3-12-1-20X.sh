#!/bin/bash
#SBATCH -t 2:00:00
#SBATCH --mem 24g
#SBATCH -p epyc,rome,medium
#SBATCH -J snp
#SBATCH -o snp.%j.out
#SBATCH -e snp.%j.err

LIBRARY="2022_analysis"
NAME="2022_"
DOWNLOAD="./../../script/download_script"

#注意:mapping/mapping_plasmoparaviticolaディレクトリから実行する
#depth:20

mkdir $LIBRARY/"$NAME"SNPs/20X
mkdir $LIBRARY/"$NAME"Allele_freq

for i in $(cat RNA_LIST.txt)
do
cat $LIBRARY/"$NAME"SNPs/"$i"_SNP_ratios.txt | perl $DOWNLOAD/compsnps_pipe_filter_SNPs_sample_stdin_pipe4_08.pl 20 0.2 0.8 > $LIBRARY/"$NAME"SNPs/20X/$LIBRARY\_"$i"_SNP_freq_20x.txt
echo "$i"20X_Finish `date`
perl $DOWNLOAD/tab2ggplot2input_allele_frequency_2.pl $LIBRARY $LIBRARY/"$NAME"SNPs/20X/$LIBRARY\_"$i"_SNP_freq_20x.txt $LIBRARY/"$NAME"Allele_freq/ "$i"_20X
echo "$i"freq_Finish `date`
done
