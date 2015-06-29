#!/bin/bash

## compares contigs identified as TEs from different methods
## usage: ./compare.sh TAXON

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

cd $ASSEMBLY

## loop across all taxa
for x in `cat $RESULTS/$1.lst`
	do
		cd $x
		## RTV_1 (core domain for Gypsy)
		sed s/:.*$// RT/249567.lst | cat - LTR/Gypsy.lst | sort | uniq -c > 
		
		## RTV_2 (core domain for Copia/Sireviruses)
		sed s/:.*$// RT/254387.lst | cat - LTR/Copia.lst | sort | uniq -c
done	
