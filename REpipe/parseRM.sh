#!/bin/bash

#----------------------------------------------------
# parse output from RepeatMasker
# dependencies:
#	samtools
# usage: 
# 	used internally by REpipeline.slurm and assemblyPrep.sh
#-------------------------------------------------------

## REMOVE CONFOUNDING HITS FROM REPEATMASKER OUTPUT
echo "remove confounding"
for GROUP in RC Low-complexity Simple-repeat Helitron
	do
		echo $GROUP
		grep "$GROUP" nuc.fas.out > $GROUP.lst
done
	
grep -v "RC" nuc.fas.out | grep -v "Low-complexity" | grep -v "Simple_repeat" | grep -v "Helitron" > nojunk.fas.out
	
## TOTAL REPEAT READS MAPPED (AMBIGUOUS + ANNOTATED)
tail -n+4  nojunk.fas.out | awk '{print $5}' | sort | uniq > contigRE.lst
		
## FIND CONTIGS WITH AMBIGUOUS ANNOTATIONS
echo "remove ambiguous"
tail -n+4  nojunk.fas.out | awk '{print $5,$11}' | sort | uniq | awk '{print $1}' | uniq -d > ambtemp.lst
awk '$11 ~ /Unknown/ {print $5}' nojunk.fas.out > unknown.lst
echo "ambiguous" > ambiguous.lst
cat unknown.lst ambtemp.lst | sort | uniq >> ambiguous.lst
rm ambtemp.lst
		
## FIND ANNOTATED REPEAT CONTIGS
echo "separate annotated and unannotated"
grep -v -f ambiguous.lst nojunk.fas.out > annotate.fas.out
tail -n+4  annotate.fas.out | awk '{print $5}' | sort | uniq > annotate.lst
	
## UNANNOTATED CONTIGS (INCLUDING JUNK)
grep -v -f contigRE.lst nuc.lst > unannotated.lst
## EXTRACT UNANNOTATED CONTIGS TO BLAST LATER
samtools faidx contig.fas $(cat unannotated.lst) > unannotated.fas	

## PARSING INTO REPEAT CLASSES
cd ..

echo "parsing into repeat classes"	
mkdir LTR LINE SINE Satellite rRNA DNA 
	
for CLASS in LTR LINE SINE Satellite rRNA DNA
	do
		echo $CLASS
		grep $CLASS contig/annotate.fas.out > $CLASS/$CLASS.out
		awk '{print $5}' $CLASS/$CLASS.out | sort | uniq > $CLASS/$CLASS.lst
		samtools faidx contig/contig.fas $(cat $CLASS/$CLASS.lst) > $CLASS/$CLASS.fas 
done
	
## CLASSIFY LTRs
echo "classify LTRs"
cd LTR
for RETRO in Gypsy Copia Caulimovirus
	do
		echo $RETRO
		grep $RETRO LTR.out > $RETRO.out
		awk '{print $5}' $RETRO.out | sort | uniq > $RETRO.lst
done

cat Gypsy.lst Copia.lst Caulimovirus.lst > LTRassigned.lst
grep -v -f LTRassigned.lst LTR.lst > LTRunassigned.lst

cd ..
		
## CLASSIFY DNA TEs
echo "classify DNA TEs"
cd DNA

for TE in EnSpm hAT MuDR PIF TcMar
	do
		echo $TE
		grep $TE DNA.out > $TE.out
		awk '{print $5}' $TE.out | uniq | sort > $TE.lst		
done
