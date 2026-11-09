#!/bin/bash
#$ -cwd
#$ -V
#$ -l short
#$ -l d_rt=12:00:00
#$ -l s_rt=12:00:00
#$ -l s_vmem=36G
#$ -l mem_req=36G
#$ -N BI
#$ -S /bin/bash

#execute at bwa/index_plasmopara_viticola/
singularity exec /usr/local/biotools/b/bwa:0.7.18--he4a0461_1 bwa index ./../../reference_genome/Plasmopara_viticola_GCA_001695595.3/plasmopara_viticola_INRA-PV221.assembly.PBv1.fasta
