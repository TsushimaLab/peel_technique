#!/bin/bash
#SBATCH -t 48:00:00
#SBATCH --mem 32g
#SBATCH -p epyc,rome,medium
#SBATCH -J addrg_DNA
#SBATCH -o addrg_DNA.%j.out
#SBATCH -e addrg_DNA.%j.err

#usage: addrg_DNA.sh <bam_list.txt>

mkdir -p ./DNA_bam

samtools="singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 samtools"

for bam in $(cat $1); do
    samtools addreplacerg --threads 8 -r "@RG\tID:${bam}\tLB:lib1\tPL:illumina\tPU:unit1\tSM:${bam}" -o ./DNA_bam/"${bam}.rg.bam" "$bam"sort.bam
    samtools index ./DNA_bam/"${bam}.rg.bam"
done
