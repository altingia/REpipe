#!/bin/bash

##Agave project QC and prep for transcriptome data
#dependencies:
#	sra_toolkit
#	FastQC
#	prinseq-lite.pl

AGAVE=/Users/KHertweck/Copy/Agave/agave_data

#Chlorophytum
cd Chlorophytum
fastq-dump SRR402444.sra
fastqc *.fastq

cd ..

#Hosta_venusta
cd Hosta_venusta
fastq-dump SRR402444.sra
fastqc *.fastq

cd ..

#Yucca_filamentosa
cd Yucca_filamentosa
fastq-dump ERR364399.sra
fastqc *.fastq