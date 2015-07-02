#!/bin/bash

##-------------
## Fast summary as QC of annotation
## usage: ./annotateQC.sh TAXA.lst ASSEMBLY
##-------------

ANNOTATE=$WORK/annotate

for x in `cat $1`
	do

	cd $ANNOTATE/$x/$2
	echo $x | tee $1.QCout
	echo "contigs" | tee -a $1.QCout
	wc -l contig/contig.lst | tee -a $1.QCout
	echo "mappedreads" | tee -a $1.QCout
	awk '{s+=$3}END{print s}' contig/contigReads.lst | tee -a $1.QCout
	echo "unmappedreads" | tee -a $1.QCout
	awk '{s+=$4}END{print s}' contig/contigReads.lst | tee -a $1.QCout
	echo "orgcontigs" | tee -a $1.QCout
	wc -l contig/contigCPMT.lst | tee -a $1.QCout
	echo "orgreads" | tee -a $1.QCout
	grep -f contig/contigCPMT.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $1.QCout
	echo "repeatcontigs" | tee -a $1.QCout
	wc -l contig/contigRE.lst | tee -a $1.QCout
	echo "repeatreads" | tee -a $1.QCout
	grep -f contig/contigRE.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $1.QCout
	echo "retrotransposoncontigs"
	wc -l LTR/LTR.lst | tee -a $1.QCout
done
