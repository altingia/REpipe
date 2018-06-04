#!/bin/bash

#----------------------------------------------------
# extract hits with confirmed annotations and build custom RM library
# dependencies:
#	samtools
# usage: 
# 	./buildlibrary.sh TAXON TAXA.LST
#-------------------------------------------------------

RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe

mkdir $RESULTS/rerun

for x in `cat $2`
	do
	cd ~/Copy/$1/annotate/$x/compare
	echo -n > $x.Rerun.out

	for type in Copia Gypsy
		do
			mkdir $type
			cp "$type"Compare.lst $type
			cd $type
			## create custom library
			awk '{print $2}' "$type"Compare.lst | samtools faidx ../../contig/contig.fas $(cat -) | sed "s/>/>$x.$type./" > $x.$type.fas
			## rerun repeatmasker
			#repeatmasker -lib $x.$type.fas -dir . -nolow ../../contig/nuc.fas
			## summarize results
			echo "$type.original_contigs" | tee -a ../$x.Rerun.out
			wc -l ../../LTR/$type.lst | tee -a ../$x.Rerun.out
			echo "$type.original_reads" | tee -a ../$x.Rerun.out
			grep -f ../../LTR/$type.lst ../../contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a ../$x.Rerun.out
			tail +4 nuc.fas.out | awk '{print $5}' | sort | uniq > "$type"Rerun.lst
			echo "$type.rerun_contigs" | tee -a ../$x.Rerun.out
			wc -l "$type"Rerun.lst | tee -a ../$x.Rerun.out
			echo "$type.rerun_reads" | tee -a ../$x.Rerun.out
			grep -f "$type"Rerun.lst ../../contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a ../$x.Rerun.out 
			cd ..
	done
	
	cp $x.Rerun.out $RESULTS/rerun/$x.out

done

cd $RESULTS/rerun

# add 0 on empty lines, remove extra spaces at beginning of wc lines, remove wc filenames, paste adjacent lines
	for f in *.out
		do 
			sed "s/^$/0/" $f | sed -E "s/\ +//" | cut -f 1 -d " " | paste -d " " - - | sed "s/-//" > $f.table
	done

# list all accessions
ls *.out.table | sed "s/.out.table/\ /" > accessions.lst
chmod +x accessions.lst
	
# join all accessions together
R CMD BATCH $SCRIPTS/results/joinTables.R
tr -d " " < temp.csv > $RESULTS/rerunLTR.csv
cd ..
#rm -r combine/