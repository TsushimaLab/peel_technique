# Calculate allele frequency

We calculated allele frequecny following the methods described in this SaundersLab Github repository (https://github.com/SaundersLab/Field_Pathogenomics) with minor modifications. `compsnps_pipe_filter_SNPs_sample_stdin_pipe4_08.pl` was downloaded from this repository.

LIST.txt contains prefix of .bam files. RNA_LIST.txt and DNA_LIST.txt contains prefix of RNA-seq and WGS datasets, respectively.

1. samtools mpileup
    ```
    snp_calling_1-7-1.sh LIST.txt
    ```
1. calculate SNP ratio
    ```
    snp_calling_2-7-1.sh LIST.txt
    ```
1. RNA-seq datasets: extract SNPs at sites with >x20 depth
    ```
    snp_calling_3-12-1-20X RNA_LIST.txt
    ```
1. WGS datasets: extract SNPs at sites with >x10 depth
    ```
    snp_calling_3-11-6-10X.sh DNA_LIST.txt
    ```
1. visualize using ggplot2
    ```
    Allele_freq_ggplot_combined_one_2_arrange.R
    ```