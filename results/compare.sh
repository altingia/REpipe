#!/bin/bash

## compares contigs identified as TEs from different methods, focus on those of primary interest
## usage: ./compare.sh TAXON TAXON.LST

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results

## loop across all taxa
for x in `cat $2`
	do
		cd $ANNOTATE/$x
		mkdir compare
		
		## count all annotated contigs
		for domain in INT RT RH GAG
			do
				cp $domain/*all.lst compare/
		done	
		
		cat contig/annotate.lst compare/*.lst | sort | uniq -c | sort -r > compare/allOverlap.lst
		
		## RTV_1 (core domain for Gypsy) overlap with RM Gypsy
		sed s/:.*$// RT/249567.lst | cat - LTR/Gypsy.lst | sort | uniq -c > compare/GypsyRTV_1.lst
		
		## RTV_2 (core domain for Copia/Sireviruses) overlap with RM Copia
		sed s/:.*$// RT/254387.lst | cat - LTR/Copia.lst | sort | uniq -c > compare/CopiaRTV_2.lst
done	
