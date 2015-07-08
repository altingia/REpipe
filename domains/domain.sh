#!/bin/bash

## search for domains from assemblies
## usage: ./domain.sh TAXON DOMAIN TAXON.lst
## taxa to be analyzed in TAXON.lst, models in DOMAIN.pn
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

ANNOTATE=~/data/$1/annotate
RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe
DOMAIN=~/data/domains

## make custom rps-blast library
cd $DOMAIN/CDD/cdd
cp $SCRIPTS/domains/$2.pn $DOMAIN/
cp ../../$2.pn .
makeprofiledb -in $2.pn -out $2
mv $2.* ../../

## make list of IDs for each domain in list
cd ../../
for x in `cat $2.pn`; do grep "tag id" CDD/cdd/$x ; done | sed s/\ //g | sed s/tagid// > $2cdd.lst

cd $ANNOTATE

## extract domains from each taxon
for x in `cat $3`
	do
		echo $x
		mkdir -p $x/$2
		cd $x/$2
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/$2 -out $2rpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results shorter than 120
		## extract positive hits
		grep "gnl" $2rpsblast.out > $2raw.out
		## filter out hits less than ca 80 bp in length
		awk '{if ($4 > 80) print $0}' $2raw.out > $2all.out
		## create list for combining
		cut -f 1 $2all.out | sort | uniq > $2all.lst
		
		## separate by $2 type
		for type in `cat $DOMAIN/$2cdd.lst`
			do
			grep $type $2all.out | 		
			## print ranges of hits to pass to samtools
			awk '{if ($7 < $8)
				print $1":"$7"-"$8;
				else 
				print $1":"$8"-"$7}' > $type.lst
			## make list of unique names
			cut -d : -f 1 $type.lst | sort | uniq > $type.uniq.lst
			## pull out fasta
			split $type.lst $type.lst.
			echo -n > $type.fas
			for y in $type.lst.*
				do
					samtools faidx ../contig/contig.fas $(cat $y) | sed s/:/./ >> $type.fas
					rm $y
			done
			## cluster hits
			cd-hit-est -i $type.fas -o $type.clust.out -c 0.8 -n 8 -aL 0.8 -aS 0.8 -g 1
			## append taxon name to fasta headers
			sed "s/>/>$x./" $type.clust.out > $type.clust.fas
		done
	
	cd $ANNOTATE			
done
