# _tubulin_ haplotype identification

`LIST.txt` contains prefix of .bam files. `tubulin_seqs.aln.unique2.fasta` was preprared by reformatting `tubulin_seqs.aln.fasta`
that is available in https://entrepot.recherche.data.gouv.fr/dataset.xhtml?persistentId=doi:10.15454/FD86M2.

1. Identify consensus sequences from . bam files and generate alignments with previously reported haplotype sequences.
    ```
    tub_consensus.sh
    ```

1. Manually trim the poorly aligned end regions in `tub_merge.afa` using MEGA. Then, remove seuqences in `tubulin_seqs.aln.unique2.fasta` from the alignments and save as `tub_merge202.fas`.

1. Unfold ambiguous(= heterozygous) sequences in `tub_merge202.fas` using DnaSP. Save as `tub_merge202_unfold.fas`.

1. Convert .fasta to .tab.
    ```
    seqkit fx2tab tub_merge202_unfold.fas \
    > tub_merge202_unfold.tab
    ```
1. Prepare `tub_merge202_unfold.arp` file based on the .tab file. Perform ELB in Arlequin.

1. Concaterate with `tubulin_seqs.aln.unique2.fasta`.
    ```
    cat tubulin_seqs.aln.unique2.fasta ELB_Best_Phases.fas \
    > tubulin_merge.fasta
    ```

1. Deduplicate and summarize.
    ```
    vsearch --derep_fulllength ./tubulin_merge.fasta \
    --output ./tubulin_merge.derep.fa \
    --sizeout --uc ./tubulin_merge.derep_uc.txt
    ```

1. Prepare sequence alignments and generate a gene tree.
    ```
    tub_tree.sh tubulin_merge.derep
    ```
