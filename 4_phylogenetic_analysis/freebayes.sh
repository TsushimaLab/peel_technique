#!/bin/bash
#SBATCH -t 10-00:00:00
#SBATCH -p epyc,rome,medium
#SBATCH --mem 96g
#SBATCH --cpus-per-task=4
#SBATCH -J freebayes
#SBATCH -o freebayes.%j.out
#SBATCH -e freebayes.%j.err

#usage freebayes.sh <bam_list.txt>

outdir=./freebayes

ref=./ref_genome/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta

alias bcftools="singularity exec /usr/local/biotools/b/bcftools:1.17--haef29d1_0 bcftools"

mkdir -p $outdir

#SNP calling
singularity exec /usr/local/biotools/f/freebayes:1.3.6--hbfe0e7f_2 \
freebayes-parallel <(./scripts/fasta_generate_regions.py ${ref}.fai 20000) 4 \
-f ${ref} -L $1 --ploidy 2 --use-best-n-alleles 6 > $outdir/merge.vcf

bgzip $outdir/merge.vcf
bcftools sort -o $outdir/merge_sort.vcf.gz $outdir/merge.vcf.gz
tabix -p vcf $outdir/merge_sort.vcf.gz
