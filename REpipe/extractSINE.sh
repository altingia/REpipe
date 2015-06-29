#!/bin/bash

## extract SINEs from RepeatMasker screens of assemblies
## usage: ./extractSINE.sh TAXON
## dependencies: 
## 	samtools
## 	cd-hit-est

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

cd $ASSEMBLY

## loop extraction across all taxa
for x in `cat $RESULTS/$1.lst`
	do
		cd $x/SINE
		## filter out partial sequences (less than 100 bp)
		#awk '{if ($7-$6>100) print $X; }' SINE.out > XXX.out
		## cluster
		cd-hit-est -i SINE.fas -o SINEclust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		## append taxon name to fasta headers
		sed "s/>/>$x./" SINEclust.out > SINEclust.fas
		
		cd $ASSEMBLY
done

## combine SINEs from all taxa
cat */SINE/SINEclust.fas > $RESULTS/SINEcombined.fas