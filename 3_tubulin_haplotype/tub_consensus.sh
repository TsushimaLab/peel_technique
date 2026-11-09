#!/bin/bash
#SBATCH -t 2:00:00
#SBATCH --mem 8g
#SBATCH -p epyc,rome
#SBATCH -J tub_consensus
#SBATCH -o tub_consensus.%j.out
#SBATCH -e tub_consensus.%j.err

samtools="singularity exec /usr/local/biotools/s/samtools:1.23--h96c455f_0 samtools"

mkdir -p ./tub/seq

for inbam in $(cat LIST.txt)
do
sample_name=$(basename $inbam .rg.bam)
$samtools consensus --mode simple --ambig --call-fract 0.2 --het-fract 0.2 \
--min-BQ 20 --min-MQ 20 -r Plvit031:429765-430289 -f fasta $inbam | \
seqkit replace -p "Plvit031" -r "$sample_name" > ./tub/seq/"$sample_name"_tub.fa

$samtools depth -a -r Plvit031:429765-430289 $inbam | \
awk '{sum+=$3} END {print "'$file' Average = ", sum/NR}' >> ./tub_fasta/tub_depth.txt
done

cat ./tub/seq/*.fa ./tub/tubulin_seqs.aln.unique2.fasta > ./tub/tub_merge.fa

singularity exec /usr/local/biotools/m/muscle:5.3--h9948957_3 \
muscle -align ./tub/tub_merge.fa -output ./tub/tub_merge.afa -nt

#"tubulin_seqs.aln.unique2.fasta" was preprared by reformatting "tubulin_seqs.aln.fasta"
#"tubulin_seqs.aln.fasta" was obtained from https://entrepot.recherche.data.gouv.fr/dataset.xhtml?persistentId=doi:10.15454/FD86M2
