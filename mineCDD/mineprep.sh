#!/bin/bash

##Prep input fasta file (assemblies from other people) and run RepeatMasker
##assembly files listed in assembly.lst
##dependencies: 
#	samtools
#	repeatmasker

AGAVE=~/Copy/Agave/assemblies
REPEATMASKER=~XXX

cd $AGAVE

for x in `cat assembly.lst`
	do 
		mkdir ../results/$x ../results/$x/contig	  			#setup directory
		sed 's/n/N/' $x.fas > ../results/$x/contig/contig.fas 	#remove lowercase ns from data
		cd ../results/$x/contig 								#move to directory
		samtools faidx $x.fas 									#index assembly file
		$REPEATMASKER -species liliopsida $x.fas 				#run repeatmasker
		cd $AGAVE						
done
 