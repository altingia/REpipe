#!/bin/bash

## compares contigs identified as TEs from different methods
## usage: ./compare.sh TAXON

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

## loop across all taxa
for x in `cat $RESULTS/$1.lst`
	do
		cd $ASSEMBLY/$x
		
		## count all annotated contigs
		#cat contig/annotate.lst INT/XXX RT/XXX | sort | uniq -c > allOverlap.lst
		
		## RTV_1 (core domain for Gypsy) overlap with RM Gypsy
		sed s/:.*$// RT/249567.lst | cat - LTR/Gypsy.lst | sort | uniq -c > GypsyRTV_1.lst
		
		## RTV_2 (core domain for Copia/Sireviruses) overlap with RM Copia
		sed s/:.*$// RT/254387.lst | cat - LTR/Copia.lst | sort | uniq -c > CopiaRTV_2.lst
done	
