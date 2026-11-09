#!/bin/bash
#SBATCH -t 8:00:00
#SBATCH --mem 12g
#SBATCH -p epyc
#SBATCH -J fastp
#SBATCH -o fastp.%j.out
#SBATCH -e fastp.%j.err

#usage: sbatch fastp_7-1.sh LIST.txt

cat $1 | while read i
do
echo "$i"_start_`date`
mkdir ./filtered_read/$i
singularity exec /usr/local/biotools/f/fastp:0.23.2--h5f740d0_3 \
fastp -i ./original_read/$i/"$i"_1.fastq.gz -I ./original_read/$i/"$i"_2.fastq.gz -o ./filtered_read/$i/"$i"_Read1_f.fq.gz -O ./filtered_read/$i/"$i"_Read2_f.fq.gz -h ./filtered_read/$i/"$i"_fastp.html
echo "$i"_finish_`date`
done
