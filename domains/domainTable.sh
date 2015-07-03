#!/bin/bash

## summarize results from domain.sh
## usage: ./domainTable.sh TAXON DOMAIN TAXON.lst
## taxa to be analyzed in TAXON.lst

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains
SCRIPTS=~/GitHub/REpipe

mkdir -p $RESULTS/$2/summary
cd $ANNOTATE

## summarize domain for each taxon
for x in `cat $3`
	do
		echo $x
		cd $x/$2
		
		echo $2.hits | tee -a $x.$2.out
		wc -l $2all.out | tee -a $x.$2.out
		
		## summarize by type of each domain
		for type in `cat $DOMAIN/$2cdd.lst`
			do
			echo $2.$type.hits | tee -a $x.$2.out
			wc -l $type.lst | tee -a $x.$2.out
			echo $2.$type.clust | tee -a $x.$2.out
			grep ">" $type.clust.out | wc -l | tee -a $x.$2.out
		done
	
	cp $x.$2.out $RESULTS/$2/summary	
done

# combine outfiles into table
cd $RESULTS/$2/summary

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
tr -d " " < temp.csv > $RESULTS/$2.Results.csv
#cd ..
#rm -r combine/