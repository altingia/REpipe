#!/bin/bash

##QC and prep for analysis
#dependencies:
#	FastQC
#	prinseq-lite.pl

TAXON=~/Copy/$1

#initial fastqc run
cd $TAXON
for x in `cat taxa.lst`
	do
		cd $x
		fastqc *.fastq.gz
		cd ..
done

#Genus_species
echo Genus_species
cd Genus_species
gzip -dc Genus_species.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log Genus_species.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > Genus_speciestrim.fastq.gz
fastqc *trim.fastq.gz
cd ..
