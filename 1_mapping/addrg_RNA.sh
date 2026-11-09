#!/bin/bash
#SBATCH -t 12:00:00
#SBATCH --mem 16g
#SBATCH -p epyc,rome,medium
#SBATCH -J addrg_RNA
#SBATCH -o addrg_RNA.%j.out
#SBATCH -e addrg_RNA.%j.err

mkdir -p ./RNA_bam

samtools="singularity exec /usr/local/biotools/s/samtools:1.16.1--h6899075_1 samtools"

for bam in $(cat $1); do
    samtools addreplacerg --threads 8 -r "@RG\tID:${bam}\tLB:lib1\tPL:illumina\tPU:unit1\tSM:${bam}" -o ./RNA_bam/"${bam}.rg.bam" "$bam"sort.bam
    samtools index ./RNA_bam/"${bam}.rg.bam"
done
