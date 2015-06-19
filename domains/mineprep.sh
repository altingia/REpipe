#!/bin/bash

## Prep input fasta file (assemblies from other people) and run RepeatMasker
## assembly files listed in TAXONAssembly.lst
## usage: ./mineprep.sh TAXON
## dependencies: 
#	samtools
#	repeatmasker

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

cd $ASSEMBLY

for x in `cat $RESULTS/$1Assembly.lst`
	do 
		mkdir $RESULTS/$x $RESULTS/$x/contig		  			#setup directory
		sed 's/n/N/' $x/$x.fas > $RESULTS/$x/contig/contig.fas 	#remove lowercase ns from data
		cd $RESULTS/$x/contig 									#move to directory
		samtools faidx contig.fas 								#index assembly file
		#$REPEATMASKER -species liliopsida $x.fas 				#run repeatmasker
		cd $ASSEMBLY						
done
 