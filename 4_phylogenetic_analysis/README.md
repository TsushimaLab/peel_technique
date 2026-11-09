# Phylogenetic analysis using RNA-seq and WGS datasets
`vcf2phylip.py` was obtained from here: https://github.com/edgardomortiz/vcf2phylip.

1. SNP calling
    ```
    head -n 3 RNADNA_BAM.txt
    ./DNA_bam/INRA-PV1085-G1.rg.bam
    ./DNA_bam/INRA-PV1094-G1.rg.bam
    ./DNA_bam/INRA-PV1102-G1.rg.bam

    tail -n 3 RNADNA_BAM.txt
    ./RNA_bam/2023_1-D9.rg.bam
    ./RNA_bam/2023_1-E4.rg.bam
    ./RNA_bam/2023_1-E9.rg.bam

    freebayes.sh RNADNA_BAM.txt

    vcf_filter3.sh
    ```

1. ML tree construction

    ```
    mkdir ./raxml-ng
    cd ./freebayes

    #convert .vcf to .phy
    python vcf2phylip.py -i merge_sort_nqdb5.vcf.gz --output-folder raxml-ng --output-prefix merge_sort_nqdb5

    #estimate the best model based on BIC
    cd ./raxml-ng
    modeltest-ng.sh merge_sort_nqdb5

    #ML tree construction
    raxml-ng3.sh merge_sort_nqdb5
    ```

# Phylogenetic analysis using WGS datasets

1. SNP calling
    ```
    head -n 3 DNA_BAM.txt
    ./DNA_bam/INRA-PV1085-G1.rg.bam
    ./DNA_bam/INRA-PV1094-G1.rg.bam
    ./DNA_bam/INRA-PV1102-G1.rg.bam

    freebayes.sh DNA_BAM.txt

    vcf_filter3_dna.sh
    ```


1. ML tree construction

    ```
    mkdir ./raxml-ng_dna
    cd ./freebayes_dna

    #convert .vcf to .phy
    python vcf2phylip.py -i merge_sort_nqdb35.vcf.gz --output-folder raxml-ng_dna --output-prefix merge_sort_nqdb35

    #estimate the best model based on BIC
    cd ../raxml-ng_dna
    modeltest-ng.sh merge_sort_nqdb35

    #ML tree construction (100 bootstrap replicates)
    raxml-ng_dna3.sh merge_sort_nqdb35
    ```