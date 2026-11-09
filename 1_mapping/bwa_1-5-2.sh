#!/bin/bash
#SBATCH -t 36:00:00
#SBATCH --mem 24g
#SBATCH -p epyc
#SBATCH -J bwa
#SBATCH -o bwa.%j.out
#SBATCH -e bwa.%j.err

#usage: sbatch bwa_1-5-2.sh LIST.txt

cat $1 | while read i

do
echo "$i"Mapping-Start`date`

singularity exec /usr/local/biotools/b/bwa:0.7.18--he4a0461_1 \
bwa mem ./../../../bwa/index_plasmopara_viticola/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta ./../../../filtered_read/$i/"$i"_Read1_f.fq.gz ./../../../filtered_read/$i/"$i"_Read2_f.fq.gz > ./"$i".sam

echo "$i"BAM-Start`date`

singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
samtools view -t ./../../../reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta.fai -b ./"$i".sam > ./"$i".bam

rm ./"$i".sam

singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
samtools sort -o ./"$i"sort.bam ./"$i".bam

singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
samtools index ./"$i"sort.bam

rm ./"$i".bam

echo "$i"Finish`date`
done
