#!/bin/bash
#$ -cwd 
#$ -V 
#$ -l epyc
#$ -l d_rt=05:00:00
#$ -l s_rt=05:00:00
#$ -l s_vmem=12G 
#$ -l mem_req=12G
#$ -N SI
#$ -S /bin/bash

singularity exec /usr/local/biotools/s/star:2.7.10b--h9ee0642_0 STAR \
--runThreadN 12 \
--runMode genomeGenerate \
--genomeDir ./star/index \
--genomeFastaFiles ./reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta \
--sjdbGTFfile ./reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.geneAnnotation.v1.gff3 \
--genomeSAindexNbases 12
