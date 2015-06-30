#!/bin/bash

#----------------------------------------------------
# parse output from RepeatMasker
# dependencies:
#	samtools
# usage: 
# 	enter name of taxon as $1, fastq file as $2 (or enter batch in REscripts), reference file as $3
#-------------------------------------------------------

## REMOVE CONFOUNDING HITS FROM REPEATMASKER OUTPUT
for GROUP in RC Low-complexity Simple-repeat Helitron
	do
		grep "$GROUP" nuc.fas.out > $GROUP.lst
done
	
grep -v "RC" nuc.fas.out | grep -v "Low-complexity" | grep -v "Simple_repeat" | grep -v "Helitron" > nojunk.fas.out
	
## TOTAL REPEAT READS MAPPED (AMBIGUOUS + ANNOTATED)
tail -n+4  nojunk.fas.out | awk '{print $5}' | sort | uniq > contigRE.lst
		
## FIND CONTIGS WITH AMBIGUOUS ANNOTATIONS
tail -n+4  nojunk.fas.out | awk '{print $5,$11}' | sort | uniq | awk '{print $1}' | uniq -d > ambtemp.lst
awk '$11 ~ /Unknown/ {print $5}' nojunk.fas.out > unknown.lst
echo "ambiguous" > ambiguous.lst
cat unknown.lst ambtemp.lst | sort | uniq >> ambiguous.lst
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
	
## CLASSIFY LTRs
for RETRO in Gypsy Copia
	do
		grep $RETRO LTR/LTR.out > LTR/$RETRO.out
		awk '{print $5}' LTR/$RETRO.out | sort | uniq > LTR/$RETRO.lst
		samtools faidx contig/contig.fas $(cat LTR/$RETRO.lst) > LTR/$RETRO.fas
done
			
## CLASSIFY DNA TEs
cd DNA

for TE in EnSpm hAT MuDR PIF TcMar
	do
		grep $TE DNA.out > $TE.out
		awk '{print $5}' $TE.out | uniq | sort > $TE.lst		
done
