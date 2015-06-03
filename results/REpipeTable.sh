#!/bin/bash

#PROCESS OUTFILES FROM REpipeline
#specify tax
#dependency: joinTables.R

RESULTS=~/Copy/TAXON/results
JOIN=~/GitHub/REpipe

cd $RESULTS 

#expand results
#	for x in *.tar.gz
#		do
#			tar -xvzf $x
#	done

#CONSTRUCT OUTFILE FOR EACH TAXON

for x in `cat $1`
	do

	cd $RESULTS/$x

	##TOTAL CONTIGS + READS, ORGANELLAR CONTIGS + READS

		cd contig
		echo "contigs" | tee $RESULTS/$x/$x.out
		wc -l contig.lst | tee -a $RESULTS/$x/$x.out
	
		echo "mappedreads" | tee -a $RESULTS/$x/$x.out
		awk '{s+=$3}END{print s}' contigReads.lst | tee -a $RESULTS/$x/$x.out
		echo "unmappedreads" | tee -a $RESULTS/$x/$x.out
		awk '{s+=$4}END{print s}' contigReads.lst | tee -a $RESULTS/$x/$x.out
	
		echo "mtcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l mtcontigs.lst | tee -a $RESULTS/$x/$x.out
		echo "cpcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l cpcontigs.lst | tee -a $RESULTS/$x/$x.out
		echo "orgcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l contigCPMT.lst | tee -a $RESULTS/$x/$x.out
		echo "orgreads" | tee -a $RESULTS/$x/$x.out
		grep -f contigCPMT.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
	
	##RC, LOW-COMPLEXITY, SIMPLE REPEAT, HELITRON CONTIGS
		for GROUP in RC Low-complexity Simple-repeat Helitron
			do
				echo $GROUP.contigs | tee -a $RESULTS/$x/$x.out
				wc -l $GROUP.lst | tee -a $RESULTS/$x/$x.out
		done
	
	##TOTAL REPEAT CONTIGS + READS (AMBIGUOUS + ANNOTATED)
		echo "repeatcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l contigRE.lst | tee -a $RESULTS/$x/$x.out
		echo "repeatreads" | tee -a $RESULTS/$x/$x.out
		grep -f contigRE.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
	
	##AMBIGUOUS CONTIGS + READS
		echo "unknowncontigs" | tee -a $RESULTS/$x/$x.out
		wc -l unknown.lst | tee -a $RESULTS/$x/$x.out
		echo "ambiguouscontigs" | tee -a $RESULTS/$x/$x.out
		wc -l ambiguous.lst | tee -a $RESULTS/$x/$x.out
		echo "ambiguousreads" | tee -a $RESULTS/$x/$x.out
		grep -f ambiguous.lst contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
	
	##ANNOTATED + UNANNOTATED (INCLUDES JUNK) REPEAT CONTIGS
		echo "annotatedcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l annotate.lst | tee -a $RESULTS/$x/$x.out
		
		echo "unannotatedcontigs" | tee -a $RESULTS/$x/$x.out
		wc -l unannotated.lst | tee -a $RESULTS/$x/$x.out	
		
cd ..

	##REPEAT CLASS CONTIGS + READS	
		for CLASS in LTR LINE SINE Satellite rRNA DNA
			do
				echo $CLASS.contigs | tee -a $RESULTS/$x/$x.out
				wc -l $CLASS/$CLASS.lst | tee -a $RESULTS/$x/$x.out
				echo $CLASS.reads | tee -a $RESULTS/$x/$x.out
				grep -f $CLASS/$CLASS.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
		done
		
	##RETROTRANSPOSONS + READS
		for RETRO in Gypsy Copia
			do
				echo $RETRO.contigs | tee -a $RESULTS/$x/$x.out
				wc -l LTR/$RETRO.lst | tee -a $RESULTS/$x/$x.out
				echo $RETRO.reads | tee -a $RESULTS/$x/$x.out
				grep -f LTR/$RETRO.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
		done
								
	##DNA TE SUPERFAMILY TE + READS

	for TE in EnSpm hAT MuDR PIF TcMar
		do
			echo $TE.contigs | tee -a $RESULTS/$x/$x.out
			wc -l DNA/$TE.lst | tee -a $RESULTS/$x/$x.out
			echo $TE.reads | tee -a $RESULTS/$x/$x.out
			grep -f DNA/$TE.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $RESULTS/$x/$x.out
	done

done

cd $RESULTS

#set up for combining table results
	mkdir combine
	cp */*.out combine/

cd combine/

#add 0 on empty lines, remove extra spaces at beginning of wc lines, remove wc filenames, paste adjacent lines
	for f in *.out
		do 
			sed "s/^$/0/" $f | sed -E "s/\ +//" | cut -f 1 -d " " | paste -d " " - - | sed "s/-//" > $f.table
	done

#list all accessions
	ls *.out.table | sed "s/.out.table/\ /" > accessions.lst
	chmod +x accessions.lst
	
#join all accessions together
R CMD BATCH $JOIN/joinTables.R
