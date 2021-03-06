#!/bin/bash

## Prep input fasta file (assemblies from other people) and run RepeatMasker
## usage: ./assemblyPrep.sh TAXON LIST
## dependencies: 
##	samtools
##	repeatmasker

ASSEMBLY=~/Copy/$1/assembly
ANNOTATE=~/data/$1/annotate
RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe/REpipe

for x in `cat $2`
	do 
		echo $x
		## create directory structure
		mkdir -p $ANNOTATE/$x/archive
		cd $ASSEMBLY/$x
		
		## clean data (remove lowercase ns and transfer to annotate folder)
		#sed 's/n/N/' *.fas > $ANNOTATE/$x/archive/contig.fas
		cp $x.fas $ANNOTATE/$x/archive/contig.fas
		
		## prep files
		cd $ANNOTATE/$x
		mkdir contig
		cp archive/contig.fas contig/contig.fas
		cd contig
		grep ">" contig.fas | sed 's/>//' > contig.lst			# list contigs
		cp contig.fas nuc.fas
		cp contig.lst nuc.lst
		samtools faidx contig.fas 								# index assembly file
		echo -e 'X\t0\t0\t0\t0' > contigReads.lst				# create dummy read file
		touch cpcontigs.lst mtcontigs.lst contigCPMT.lst		# create dummy org files
		
		## run repeatmasker
		RepeatMasker -species liliopsida nuc.fas				# run repeatmasker
		cp nuc.fas.out ../archive

		## RUN PARSING SCRIPT
		echo "parsing RM"
		$SCRIPTS/parseRM.sh

done
 