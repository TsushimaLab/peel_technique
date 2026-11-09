#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH -p epyc,rome,medium
#SBATCH --mem 24g
#SBATCH -J vcf_filter
#SBATCH -o vcf_filter.%j.out
#SBATCH -e vcf_filter.%j.err

outdir=./freebayes
ref_genome=./ref_genome/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta
bcftools="singularity exec /usr/local/biotools/b/bcftools:1.17--haef29d1_0 bcftools"

# normalize .vcf file (n)
$bcftools norm -f $ref_genome -m -any -O z -o $outdir/merge_sort_n.vcf.gz $outdir/merge_sort.vcf.gz
tabix -p vcf $outdir/merge_sort_n.vcf.gz

# quality filter (q)
singularity exec /usr/local/biotools/v/vcflib:1.0.15--h3fa9d83_0 \
vcffilter -f "QUAL > 20 & QUAL / AO > 10 & SAF > 0 & SAR > 0 & RPR > 1 & RPL > 1 & AC > 0" $outdir/merge_sort_n.vcf.gz > $outdir/merge_sort_nq.vcf
bgzip $outdir/merge_sort_nq.vcf
tabix -p vcf $outdir/merge_sort_nq.vcf.gz

# prepare a site list containing depth >= 10 sites among > 80% of WGS datasets
$bcftools view -Ou -S DNA_list.txt $outdir/merge_sort_nq.vcf.gz | \
$bcftools view -Ou -i 'F_PASS(10 <= FMT/DP) >= 0.8' | \
$bcftools query -f '%CHROM\t%POS\n' > $outdir/DNA_valid_sites.txt
echo "DNA valid sites: $(wc -l < $outdir/DNA_valid_sites.txt)"

# prepare a site list containing depth >= 20 sites among > 80% of RNA-seq datasets
$bcftools view -Ou -S RNA_list.txt $outdir/merge_sort_nq.vcf.gz | \
$bcftools view -Ou -i 'F_PASS(20 <= FMT/DP) >= 0.8' | \
$bcftools query -f '%CHROM\t%POS\n' > $outdir/RNA_valid_sites.txt
echo "RNA valid sites: $(wc -l < $outdir/RNA_valid_sites.txt)"

# intersect the DNA and RNA valid sites
comm -12 <(sort $outdir/DNA_valid_sites.txt) <(sort $outdir/RNA_valid_sites.txt) > $outdir/intersect_valid_sites.txt
echo "intersect valid sites: $(wc -l < $outdir/intersect_valid_sites.txt)"

# extract the intersect valid sites (d)
$bcftools view -T $outdir/intersect_valid_sites.txt -O z -o $outdir/merge_sort_nqd.vcf.gz $outdir/merge_sort_nq.vcf.gz
tabix -p vcf $outdir/merge_sort_nqd.vcf.gz

# retain biallelic SNPs (b)
$bcftools view -m2 -M2 -v snps -O z -o $outdir/merge_sort_nqdb.vcf.gz $outdir/merge_sort_nqd.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb.vcf.gz

# missing rate <= 20% and MAF >= 0.05 sites (5)
$bcftools view -i 'F_MISSING <= 0.2 & MAF >= 0.05' -O z -o $outdir/merge_sort_nqdb5.vcf.gz $outdir/merge_sort_nqdb.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb5.vcf.gz

# missing rate <= 20% and MAF >= 0.01 sites (1)
$bcftools view -i 'F_MISSING <= 0.2 & MAF >= 0.01' -O z -o $outdir/merge_sort_nqdb1.vcf.gz $outdir/merge_sort_nqdb.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb1.vcf.gz

# extract 3rd-codon positions (3)
$bcftools view -R ./ref_genome/third_codon.bed -O z -o $outdir/merge_sort_nqdb3.vcf.gz $outdir/merge_sort_nqdb.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb3.vcf.gz

# 3rd-codon + Missing <= 20% and MAF >= 0.05 (35)
$bcftools view -i 'F_MISSING <= 0.2 & MAF >= 0.05' -O z -o $outdir/merge_sort_nqdb35.vcf.gz $outdir/merge_sort_nqdb3.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb35.vcf.gz

# 3rd-codon + Missing <= 20% and MAF >= 0.01 (31)
$bcftools view -i 'F_MISSING <= 0.2 & MAF >= 0.01' -O z -o $outdir/merge_sort_nqdb31.vcf.gz $outdir/merge_sort_nqdb3.vcf.gz
tabix -p vcf $outdir/merge_sort_nqdb31.vcf.gz
