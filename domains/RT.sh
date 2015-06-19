#!/bin/bash

##search for reverse transcriptase domains from assemblies
##dependencies: 
#	blast + (makeprofiledb, rpstblastn)
#	samtools
#	cd-hit-est

RESULTS=~/Copy/Agave/results
DOMAIN=~/Copy/REdata/referenceSeq/domains
OUT=~/Copy/Agave/results/RT.out

cd $RESULTS
echo REVERSE TRANSCRIPTASE > $OUT

##make custom rps-blast library
#makeprofiledb -in $DOMAIN/custom/RT.lst

for x in assembly_sp
	do
		echo $x
		cd $x
		mkdir RT
		cd RT
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/custom/RT.lst -out RTrpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results shorter than 120
		echo $x | tee -a $OUT
		grep "gnl" RTrpsblast.out > RTall.out
		wc -l RTall.out | tee -a $OUT
		awk '{if ($4 > 120) prRT $0}' RTall.out > RT.out
		wc -l RT.out | tee -a $OUT
		cut -f 1 RT.out > RT.lst

		#RVT_1  pfam00078
		grep "215698" 1RT.out > RTV_1.out
		wc -l RTV_1.out
		cut -f 1 RTV_1.out > RTV_1.lst
		samtools faidx ../contig/contig.fas $(cat RTV_1.lst) > RTV_1.fas
		mafft --adjustdirectionaccurately RTV_1.fas > RTV_1.afa
		cd-hit-est -i RTV_1.afa -o RTV_1 -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		wc -l RTV_1 | tee -a $OUT
		
		#RVT_2 pfam07727
		grep "219537" RT.out > RTV_2.out
		wc -l RTV_2.out
		cut -f 1 RTV_2.out > RTV_2.lst
		samtools faidx ../contig/contig.fas $(cat RTV_2.lst) > RTV_2.fas
		mafft --adjustdirectionaccurately RTV_2.fas > RTV_2.afa
		cd-hit-est -i RTV_2.afa -o RTV_2 -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		wc -l RTV_2 | tee -a $OUT
		
		#RT_nLTR_like cd01650
		grep "238827" RT.out > RT_nLTR_like.out
		wc -l RT_nLTR_like.out
		cut -f 1 RT_nLTR_like.out > RT_nLTR_like.lst
		samtools faidx ../contig/contig.fas $(cat RT_nLTR_like.lst) > RT_nLTR_like.fas
		mafft --adjustdirectionaccurately RT_nLTR_like.fas > RT_nLTR_like.afa
		cd-hit-est -i RT_nLTR_like.afa -o RT_nLTR_like -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
		wc -l RT_nLTR_like | tee -a $OUT
		
		cd $RESULTS
done
