#!/bin/bash

## extract LINEs from RepeatMasker screens of assemblies
## dependencies: 
##	samtools
##	cd-hit-est

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

mkdir $RESULTS/LINE
echo "LINEs" | tee $RESULTS/LINE/$1LINE.out

cd $ASSEMBLY

## loop across all taxa
for x in `cat $RESULTS/$1.lst`
	do
		cd $x/LINE
		## create list of unique LINEs recognized
		awk '{print $10}' LINE.out | sort | uniq > LINEtypes.lst
		echo $x | tee -a $RESULTS/LINE/$1LINE.out
		wc -l LINEtypes.lst | tee -a $RESULTS/LINE/$1LINE.out
		
		## loop across all LINE types
		for type in `cat LINEtypes.lst`
			do
				## print ranges to pass to samtools
				grep $type LINE.out | awk '{print $5":"$6"-"$7}' > $type.lst
				wc -l $type.lst | tee -a $RESULTS/LINE/$1LINE.out
				## extract from fasta
				samtools faidx ../contig/contig.fas $(cat $type.lst) s/:/./ > $type.fas
				## cluster results to remove redundancy
				cd-hit-est -i $type.fas -o $type.clust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
				grep ">" $type.clust.out | wc -l | tee -a $RESULTS/LINE/$1LINE.out
				## append taxon name to fasta headers
				sed "s/>/>$x./" $type.clust.out > $type.clust.fas
		done
		
		cd $ASSEMBLY

done	

## combine LINEs from all taxa by type
cat */LINE/LINEtypes.lst > $RESULTS/LINE/LINEall.lst

for group in `cat $RESULTS/LINE/LINEall.lst`
	do
	cat */LINE/$group.clust.fas > $RESULTS/LINE/$group.combined.fas
	echo $group | tee -a $RESULTS/LINE/$1LINE.out
	grep ">" $RESULTS/LINE/$group.combined.fas | wc -l | tee -a $RESULTS/LINE/$1LINE.out
done
