#!/bin/bash

## search for reverse transcriptase domains from assemblies
## usage: ./RT.sh TAXON
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
#makeprofiledb -in RT.pn -out RT

cd $ASSEMBLY
echo "REVERSE TRANSCRIPTASE" > $RESULTS/$1RT.out

## extract reverse transcriptase domains from each taxon
for x in `cat $RESULTS/$1.lst`
	do
		echo $x
		cd $x
		mkdir RT
		cd RT
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/RT -out RTrpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results shorter than 120
		echo $x | tee -a $RESULTS/$1RT.out
		## extract positive hits
		grep "gnl" RTrpsblast.out > RTall.out
		wc -l RTall.out | tee -a $RESULTS/$1RT.out
		## filter out hits less than 100 aa in length
		awk '{if ($4 > 100) print $0}' RTall.out > RTlength.out
		
		## separate by RT type
		for type in 238185 238822 238823 238825 238827 238828 238843 239569 239684 239685 249567 254387 
			do
			grep $type RTlength.out | 		
			## print ranges of hits to pass to samtools
			awk '{if ($7 < $8)
				print $1":"$7"-"$8;
				else 
				print $1":"$8"-"$7}' > $type.lst
			wc -l $type.lst | tee -a $RESULTS/$1RT.out
			## pull out fasta
			samtools faidx ../contig/contig.fas $(cat $type.lst) | sed s/:/./ > $type.fas
			## cluster hits
			cd-hit-est -i $type.fas -o $type.clust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
			echo "clusters" | tee -a $RESULTS/$1RT.out
			grep ">" $type.clust.out | wc -l | tee -a $RESULTS/$1RT.out
			## append taxon name to fasta headers
			sed "s/>/>$x./" $type.clust.out > $type.clust.fas
			
		done
	
	cd $ASSEMBLY			

done
