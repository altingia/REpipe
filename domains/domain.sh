#!/bin/bash

## search for reverse transcriptase domains from assemblies
## usage: ./domain.sh TAXON DOMAIN
## taxa to be analyzed in TAXON.lst, models in DOMAIN.pn
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains

## make custom rps-blast library
cd $DOMAIN/CDD/cdd
cp ../../$2.pn .
makeprofiledb -in $2.pn -out $2
mv $2.* ../../

## make list of IDs for each domain in list
cd ../../
for x in `cat $2.pn`; do grep "tag id" CDD/cdd/$x ; done | sed s/\ //g | sed s/tagid// > $2cdd.lst

cd $ASSEMBLY
mkdir $RESULTS/$2
echo $2 > $RESULTS/$2/$1$2.out

## extract reverse transcriptase domains from each taxon
for x in `cat $RESULTS/$1.lst`
	do
		echo $x
		cd $x
		mkdir $2
		cd $2
		
		### Run rps-blast
		rpstblastn -query ../contig/contig.fas -db $DOMAIN/$2 -out $2rpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
		### Simplify rps-blast output and filter results shorter than 120
		echo $x | tee -a $RESULTS/$2/$1$2.out
		## extract positive hits
		grep "gnl" $2rpsblast.out > $2all.out
		wc -l $2all.out | tee -a $RESULTS/$2/$1$2.out
		## filter out hits less than 100 aa in length
		#awk '{if ($4 > 100) print $0}' $2all.out > $2length.out
		
		## separate by $2 type
		for type in `cat $DOMAIN/$2cdd.lst`
			do
			grep $type $2all.out | 		
			## print ranges of hits to pass to samtools
			awk '{if ($7 < $8)
				print $1":"$7"-"$8;
				else 
				print $1":"$8"-"$7}' > $type.lst
			wc -l $type.lst | tee -a $RESULTS/$2/$1$2.out
			## pull out fasta
			samtools faidx ../contig/contig.fas $(cat $type.lst) | sed s/:/./ > $type.fas
			## cluster hits
			cd-hit-est -i $type.fas -o $type.clust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
			grep ">" $type.clust.out | wc -l | tee -a $RESULTS/$2/$1$2.out
			## append taxon name to fasta headers
			sed "s/>/>$x./" $type.clust.out > $type.clust.fas
		done
	
	cd $ASSEMBLY			
done

## combine different $2s from different taxa 
for type in `cat $DOMAIN/$2cdd.lst`
	do
	cat */$2/$type.clust.fas > $RESULTS/$2/$type.combined.fas
	echo $type | tee -a $RESULTS/$2/$1$2.out
	grep ">" $RESULTS/$2/$type.combined.fas | wc -l | tee -a $RESULTS/$2/$1$2.out
done

## reformatting output monitoring table and creating summary table
tail +1 $RESULTS/$2/$1$2.out | paste -d " " - -


