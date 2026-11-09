#!/bin/bash
#SBATCH -t 14-00:00:00
#SBATCH -p epyc,rome,medium
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16g
#SBATCH -J freebayes_dna
#SBATCH -o freebayes_dna.%j.out
#SBATCH -e freebayes_dna.%j.err

#usage freebayes.sh <bam_list.txt>

outdir=./freebayes_dna

ref=./ref_genome/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta


mkdir -p $outdir

#SNP calling
singularity exec /usr/local/biotools/f/freebayes:1.3.6--hbfe0e7f_2 \
freebayes-parallel <(./scripts/fasta_generate_regions.py ${ref}.fai 20000) 8 \
-f ${ref} -L $1 --ploidy 2 --use-best-n-alleles 6 > $outdir/merge.vcf
bgzip $outdir/merge.vcf

singularity exec /usr/local/biotools/b/bcftools:1.17--haef29d1_0 \
bcftools sort -o $outdir/merge_sort.vcf.gz $outdir/merge.vcf.gz
tabix -p vcf $outdir/merge_sort.vcf.gz
