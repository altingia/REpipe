#!/bin/bash

## search for integrase domains from assemblies
## usage: ./INT.sh TAXON
## taxa to be analyzed in TAXON.lst
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains/CDD/cdd

## make custom rps-blast library
#cd $DOMAIN
#makeprofiledb -in INT.pn -out INT

cd $ASSEMBLY
echo "INTEGRASE" > $RESULTS/INT/$1INT.out

## extract integrase domains from each taxon
for x in `cat $RESULTS/$1.lst`
	do
		echo $x
		cd $x
		mkdir INT
		cd INT
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/INT -out INTrpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results
		echo $x | tee -a $RESULTS/INT/$1INT.out
		## extract positive hits
		grep "gnl" INTrpsblast.out > INTall.out
		wc -l INTall.out | tee -a $RESULTS/INT/$1INT.out
		## filter out hits less than 100 aa in length 
		awk '{if ($4 > 100) print $0}' INTall.out > INTlength.out
		## print ranges of hits to pass to samtools
		awk '{if ($7 < $8)
			print $1":"$7"-"$8;
			else 
			print $1":"$8"-"$7}' INTlength.out > INT.lst
		wc -l INT.lst | tee -a $RESULTS/INT/$1INT.out

		## pull out fasta
		samtools faidx ../contig/contig.fas $(cat INT.lst) | s/:/./ > INT.fas
		
		## cluster results to remove redundancy
		cd-hit-est -i INT.fas -o INTclust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		grep ">" INTclust.out | wc -l | tee -a $RESULTS/INT/$1INT.out
		
		## append taxon name to fasta headers
		sed "s/>/>$x./" INTclust.out > INTclust.fas
	
		cd $ASSEMBLY
done

## combine integrase from different taxa
cat */INT/INTclust.fas > $RESULTS/INT/INTcombined.fas
