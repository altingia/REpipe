#!/bin/bash

-------------
## Fast summary as QC of annotation
## usage: ./annotateQC.sh TAXA.lst ASSEMBLY
-------------

ANNOTATE=$WORK/annotate
OUT=$ANNOTATE/$1.QCout

for x in `cat $1`
	do

	cd $ANNOTATE/$x/$2
	echo $x | tee $OUT
	echo "contigs" | tee -a $OUT
	wc -l contig/contig.lst | tee -a $OUT
	echo "mappedreads" | tee -a $OUT
	awk '{s+=$3}END{print s}' contig/contigReads.lst | tee -a $OUT
	echo "unmappedreads" | tee -a $OUT
	awk '{s+=$4}END{print s}' contig/contigReads.lst | tee -a $OUT
	echo "orgcontigs" | tee -a $OUT
	wc -l contig/contigCPMT.lst | tee -a $OUT
	echo "orgreads" | tee -a $OUT
	grep -f contig/contigCPMT.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $OUT
	echo "repeatcontigs" | tee -a $OUT
	wc -l contig/contigRE.lst | tee -a $OUT
	echo "repeatreads" | tee -a $OUT
	grep -f contig/contigRE.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $OUT
	echo "retrotransposoncontigs"
	wc -l LTR/LTR.lst | tee -a $OUT
done
