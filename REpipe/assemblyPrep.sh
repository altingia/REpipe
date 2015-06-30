#!/bin/bash

## Prep input fasta file (assemblies from other people) and run RepeatMasker
## assembly files listed in TAXONAssembly.lst
## usage: ./domainprep.sh TAXON
## dependencies: 
##	samtools
##	repeatmasker

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

for x in `cat $RESULTS/$1Assembly.lst`
	do 
		## create directory structure
		cd $ASSEMBLY
		mkdir $ASSEMBLY/$x/contig		 			 			#setup directory
		
		## clean data
		sed 's/n/N/' $x/*.fas > $ASSEMBLY/$x/contig/contig.fas 	#remove lowercase ns from data
		
		## index contigs
		cd $ASSEMBLY/$x/contig 									#move to directory
		cp contig.fas nuc.fas
		samtools faidx contig.fas 								#index assembly file
		
		## run repeatmasker
		RepeatMasker -species liliopsida nuc.fas 				#run repeatmasker

		## RUN PARSING SCRIPT
		$SCRIPTS/parseRM.sh

		## QC SUMMARY
		cd $ASSEMBLY/$x
		echo "QC SUMMARY" | tee $x.QCout
		echo "contigs" | tee -a $x.QCout
		wc -l contig/contig.lst | tee -a $x.QCout
		echo "orgcontigs" | tee -a $x.QCout
		wc -l contig/contigCPMT.lst | tee -a $x.QCout
		echo "repeatcontigs" | tee -a $x.QCout
		wc -l contig/contigRE.lst | tee -a $x.QCout
		echo "retrotransposoncontigs" | tee -a $x.QCout
		wc -l LTR/LTR.lst | tee -a $x.QCout
		echo "retrotransposon.fas" | tee -a $x.QCout
		wc -l LTR/LTR.fas | tee -a $x.QCout

done
 