#!/bin/bash

## Prep input fasta file (assemblies from other people) and run RepeatMasker
## assembly files listed in TAXONAssembly.lst
## usage: ./assemblyPrep.sh TAXON
## dependencies: 
##	samtools
##	repeatmasker

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe/REpipe

for x in `cat $RESULTS/$1Assembly.lst`
	do 
		echo $x
		## create directory structure
		cd $ASSEMBLY
		mkdir $ASSEMBLY/$x/contig		 			 			#setup directory
		
		## clean data
		sed 's/n/N/' $x/*.fas > $ASSEMBLY/$x/contig/contig.fas 	#remove lowercase ns from data
		
		## prep files
		cd $ASSEMBLY/$x/contig 									#move to directory
		grep ">" contig.fas | sed 's/>//' > contig.lst			#list contigs
		cp contig.fas nuc.fas
		cp contig.lst nuc.lst
		samtools faidx contig.fas 								#index assembly file
		
		## run repeatmasker
		RepeatMasker -species liliopsida nuc.fas 				#run repeatmasker

		## RUN PARSING SCRIPT
		echo "parsing RM"
		$SCRIPTS/parseRM.sh

		## QC SUMMARY
		echo "QC"
		cd $ASSEMBLY/$x
		echo "contigs" | tee $OUT
		wc -l contig/contig.lst | tee -a $OUT
		echo "repeatcontigs" | tee -a $x.QCout
		wc -l contig/contigRE.lst | tee -a $x.QCout
		echo "retrotransposoncontigs" | tee -a $x.QCout
		wc -l LTR/LTR.lst | tee -a $x.QCout

done
 