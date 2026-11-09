#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --mem 48g
#SBATCH -p epyc
#SBATCH -J star
#SBATCH -o star.%j.out
#SBATCH -e star.%j.err

DIRE="2022_analysis"

cat $1 | while read i
    do
    echo "$i"STAR-Start`date`
    singularity exec /usr/local/biotools/s/star:2.7.10b--h9ee0642_0 STAR \
    --runThreadN 12 \
    --quantMode TranscriptomeSAM GeneCounts \
    --genomeDir ./star/index_plasmopara_viticola \
    --readFilesIn ./filtered_read/"$i"/"$i"_Read1_f.fq.gz ./filtered_read/"$i"/"$i"_Read2_f.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix ./mapping/mapping_plasmoparaviticola/$DIRE/"$i" \
    --alignIntronMax 5000
    
    echo "$i"BAM-Start `date`
    singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
    samtools view -t ./reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta.fai -b ./mapping/mapping_plasmoparaviticola/$DIRE/"$i"Aligned.out.sam > ./mapping/mapping_plasmoparaviticola/$DIRE/"$i".bam
    rm ./mapping/mapping_plasmoparaviticola/$DIRE/"$i"Aligned.out.sam
    singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
    samtools sort -o ./mapping/mapping_plasmoparaviticola/$DIRE/"$i"sort.bam ./mapping/mapping_plasmoparaviticola/$DIRE/"$i".bam
    singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 \
    samtools index ./mapping/mapping_plasmoparaviticola/$DIRE/"$i"sort.bam
    rm ./mapping/mapping_plasmoparaviticola/$DIRE/"$i".bam
    echo "$i"All-Finish `date`
done
