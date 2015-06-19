#!/bin/bash

##search for integrase domains from assemblies
##dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools
#	cd-hit-est

RESULTS=~/Copy/Agave/results
DOMAIN=~/Copy/REdata/referenceSeq/domains
OUT=~/Copy/Agave/results/INT.out

cd $RESULTS
echo INTEGRASE > $OUT

##make custom rps-blast library
#makeprofiledb -in $DOMAIN/custom/INT.lst

for x in assembly_sp
	do
		echo $x
		cd $x
		mkdir INT
		cd INT
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/custom/INT.lst -out INTrpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results shorter than 120
		echo $x | tee -a $OUT
		grep "gnl" INTrpsblast.out > INTall.out
		wc -l INTall.out | tee -a $OUT
		awk '{if ($4 > 120) print $0}' INTall.out > INT.out
		wc -l INT.out | tee -a $OUT
		cut -f 1 INT.out > INT.lst

		##pull out fasta
		samtools faidx ../contig/contig.fas $(cat INT.lst) > INT.fas
		
		##align and correct for directionality
		mafft --adjustdirectionaccurately INT.fas > INT.afa
		
		#cluster results to remove redundancy
		cd-hit-est -i INT.afa -o INT -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		wc -l INT | tee -a $OUT
		cd $RESULTS
done
		