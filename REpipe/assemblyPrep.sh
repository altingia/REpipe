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

		## REMOVE CONFOUNDING HITS FROM REPEATMASKER OUTPUT
		for GROUP in RC Low-complexity Simple-repeat Helitron
			do
				grep "$GROUP" nuc.fas.out > $GROUP.lst
			done
	
		grep -v "RC" nuc.fas.out | grep -v "Low-complexity" | grep -v "Simple-repeat" | grep -v "Helitron" > nojunk.fas.out
	
		## TOTAL REPEAT READS MAPPED (AMBIGUOUS + ANNOTATED)
		tail -n+4  nojunk.fas.out | awk '{print $5}' | sort | uniq > contigRE.lst
		
		## FIND CONTIGS WITH AMBIGUOUS ANNOTATIONS
		tail -n+4  nojunk.fas.out | awk '{print $5,$11}' | sort | uniq | awk '{print $1}' | uniq -d > ambtemp.lst
		awk '$11 ~ /Unknown/ {print $5}' nojunk.fas.out > unknown.lst
		cat unknown.lst ambtemp.lst > ambiguous.lst
		rm ambtemp.lst
		
		## FIND ANNOTATED REPEAT CONTIGS
		grep -v -f ambiguous.lst nojunk.fas.out > annotate.fas.out
		tail -n+4  annotate.fas.out | awk '{print $5}' | sort | uniq > annotate.lst
	
		## UNANNOTATED CONTIGS (INCLUDING JUNK)
		grep -v -f contigRE.lst nuc.lst > unannotated.lst
		## EXTRACT UNANNOTATED CONTIGS TO BLAST LATER
		samtools faidx contig.fas $(cat unannotated.lst) > unannotated.fas	

		## PARSING INTO REPEAT CLASSES
		cd ..
	
		mkdir LTR LINE SINE Satellite rRNA DNA 
	
		for CLASS in LTR LINE SINE Satellite rRNA DNA
			do
				grep $CLASS contig/annotate.fas.out > $CLASS/$CLASS.out
				awk '{print $5}' $CLASS/$CLASS.out | sort | uniq > $CLASS/$CLASS.lst
				samtools faidx contig/contig.fas $(cat $CLASS/$CLASS.lst) > $CLASS/$CLASS.fas 
			done
	
		## PARSING LTR TYPES
		for RETRO in Gypsy Copia
			do
				grep $RETRO LTR/LTR.out > LTR/$RETRO.out
				awk '{print $5}' LTR/$RETRO.out | sort | uniq > LTR/$RETRO.lst
				samtools faidx contig/contig.fas $(cat LTR/$RETRO.lst) > LTR/$RETRO.fas
			done
			
		## CLASSIFY DNA TEs BY SUPERFAMILY
		cd DNA

		for TE in EnSpm hAT MuDR PIF TcMar
			do
				grep $TE DNA.out > $TE.out
				awk '{print $5}' $TE.out | uniq | sort > $TE.lst		
		done

	## QC SUMMARY
	cd $ASSEMBLY/$x
	echo "QC SUMMARY"
	echo "contigs" | tee $OUT
	wc -l contig/contig.lst | tee -a $OUT
	echo "orgcontigs" | tee -a $OUT
	wc -l contig/contigCPMT.lst | tee -a $OUT
	echo "repeatcontigs" | tee -a $OUT
	wc -l contig/contigRE.lst | tee -a $OUT
	echo "retrotransposoncontigs"
	wc -l LTR/LTR.lst | tee -a $OUT
	echo "retrotransposon.fas"
	wc -l LTR/LTR.fas | tee -a $OUT

done
 