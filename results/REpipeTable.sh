#!/bin/bash

# PROCESS OUTFILES FROM REpipeline
# specify taxon as $1
# dependency: joinTables.R

RESULTS=~/Copy/$1/results
ASSEMBLY=~/Copy/$1/assembly
JOIN=~/GitHub/REpipe

cd $ASSEMBLY 

# expand results
#	for x in *.tar.gz
#		do
#			tar -xvzf $x
#	done

# CONSTRUCT OUTFILE FOR EACH TAXON

mkdir $RESULTS/combine

for x in `cat $RESULTS/$1.lst`
	do
	cd $ASSEMBLY/$x

	## TOTAL CONTIGS + READS, ORGANELLAR CONTIGS + READS
		cd contig
		echo "contigs" | tee ../$x.out
		wc -l contig.lst | tee -a ../$x.out
	
		echo "mappedreads" | tee -a ../$x.out
		awk '{s+=$3}END{print s}' contigReads.lst | tee -a ../$x.out
		echo "unmappedreads" | tee -a ../$x.out
		awk '{s+=$4}END{print s}' contigReads.lst | tee -a ../$x.out
	
		echo "mtcontigs" | tee -a ../$x.out
		wc -l mtcontigs.lst | tee -a ../$x.out
		echo "cpcontigs" | tee -a ../$x.out
		wc -l cpcontigs.lst | tee -a ../$x.out
		echo "orgcontigs" | tee -a ../$x.out
		wc -l contigCPMT.lst | tee -a ../$x.out
		echo "orgreads" | tee -a ../$x.out
		grep -f contigCPMT.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a ../$x.out
	
	## RC, LOW-COMPLEXITY, SIMPLE REPEAT, HELITRON CONTIGS
		for GROUP in RC Low-complexity Simple-repeat Helitron
			do
				echo $GROUP.contigs | tee -a ../$x.out
				wc -l $GROUP.lst | tee -a ../$x.out
		done
	
	## TOTAL REPEAT CONTIGS + READS (AMBIGUOUS + ANNOTATED)
		echo "repeatcontigs" | tee -a ../$x.out
		wc -l contigRE.lst | tee -a ../$x.out
		echo "repeatreads" | tee -a ../$x.out
		grep -f contigRE.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a ../$x.out
	
	## AMBIGUOUS CONTIGS + READS
		echo "unknowncontigs" | tee -a ../$x.out
		wc -l unknown.lst | tee -a ../$x.out
		echo "ambiguouscontigs" | tee -a ../$x.out
		wc -l ambiguous.lst | tee -a ../$x.out
		echo "ambiguousreads" | tee -a ../$x.out
		grep -f ambiguous.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a ../$x.out
	
	## ANNOTATED + UNANNOTATED (INCLUDES JUNK) REPEAT CONTIGS
		echo "annotatedcontigs" | tee -a ../$x.out
		wc -l annotate.lst | tee -a ../$x.out
		
		echo "unannotatedcontigs" | tee -a ../$x.out
		wc -l unannotated.lst | tee -a ../$x.out
		
		cd ..

	## REPEAT CLASS CONTIGS + READS	
		for CLASS in LTR LINE SINE Satellite rRNA DNA
			do
				echo $CLASS.contigs | tee -a $x.out
				wc -l $CLASS/$CLASS.lst | tee -a $x.out
				echo $CLASS.reads | tee -a $x.out
				grep -f $CLASS/$CLASS.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $x.out
		done
		
	## RETROTRANSPOSONS + READS
		for RETRO in Gypsy Copia
			do
				echo $RETRO.contigs | tee -a $x.out
				wc -l LTR/$RETRO.lst | tee -a $x.out
				echo $RETRO.reads | tee -a $x.out
				grep -f LTR/$RETRO.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $x.out
		done
								
	## DNA TE SUPERFAMILY TE + READS
	for TE in EnSpm hAT MuDR PIF TcMar
		do
			echo $TE.contigs | tee -a $x.out
			wc -l DNA/$TE.lst | tee -a $x.out
			echo $TE.reads | tee -a $x.out
			grep -f DNA/$TE.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $x.out
	done

	cp $x.out $RESULTS/combine

done

# combine outfiles into table
cd $RESULTS/combine

# add 0 on empty lines, remove extra spaces at beginning of wc lines, remove wc filenames, paste adjacent lines
	for f in *.out
		do 
			sed "s/^$/0/" $f | sed -E "s/\ +//" | cut -f 1 -d " " | paste -d " " - - | sed "s/-//" > $f.table
	done

# list all accessions
	ls *.out.table | sed "s/.out.table/\ /" > accessions.lst
	chmod +x accessions.lst
	
# join all accessions together
R CMD BATCH $JOIN/results/joinTables.R
tr -d " " < temp.csv > $RESULTS/REpipeResults.csv
cd ..
rm -r combine/