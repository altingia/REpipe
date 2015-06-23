#!/bin/bash

## search for integrase domains from assemblies
## usage: ./INT.sh TAXON
## taxa to be analyzed in TAXONINT.lst
## dependencies: 
#	blast+: rpstblastn and makeprofiledb
#	samtools
#	cd-hit-est

RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains/CDD/cdd

## make custom rps-blast library
#cd $DOMAIN
#makeprofiledb -in INT.pn -out INT

cd $RESULTS
echo INTEGRASE > $RESULTS/$1INT.out

for x in agave_deserti #`cat $1INT.lst`
	do
		echo $x
		cd $x
		mkdir INT
		cd INT
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/INT -out INTrpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results
		echo $x | tee -a $RESULTS/$1INT.out
		## extract positive hits
		grep "gnl" INTrpsblast.out > INTall.out
		wc -l INTall.out | tee -a $RESULTS/$1INT.out
		## filter out hits less than 120 aa in length and print ranges of hits to pass to samtools
		awk '{if ($4 > 120) print $0}' > temp
		## put ranges in numerical order
		#":"$7"-"$8}' INTall.out > INT.lst
		wc -l INT.lst | tee -a $RESULTS/$1INT.out
		rm temp


		## pull out fasta
		samtools faidx ../contig/contig.fas $(cat INT.lst) > INT.fas
		
		## align and correct for directionality
		mafft --adjustdirectionaccurately INT.fas > INT.afa
		
		## cluster results to remove redundancy
		cd-hit-est -i INT.afa -o INT.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		wc -l INT.out | tee -a $RESULTS/$1INT.out
		cd $RESULTS
done
		