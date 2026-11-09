# Mapping

The original .fastq files are placed in `./original_reads`. `RNA_LIST.txt` and `DNA_LIST.txt` contain .fastq file prefix. The reference genome .fatsa and .gff are placed in `./reference_genome`.

1. Map RNA-seq reads to the reference genome
    ```
    fastp_7-1.sh RNA_LIST.txt
    starindex.sh
    star_7-3-1.sh RNA_LIST.txt
    addrg_RNA.sh RNA_LIST.txt
    ```

1. Map WGS reads to the refernece genome
    ```
    fastp_7-1.sh DNA_LIST.txt
    bwaindex.sh
    bwa_1-5-2.sh DNA_LIST.txt
    addrg_DNA.sh DNA_LIST.txt
    ```

