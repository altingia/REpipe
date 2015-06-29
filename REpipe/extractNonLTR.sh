#!/bin/bash

## extract LINEs or SINEs from RepeatMasker screens of assemblies
## usage: ./extractNonLTR.sh LINE or ./extractNonLTR.sh SINE
## dependencies: 
##	samtools
##	cd-hit-est

ASSEMBLY=~/Copy/$1/assembly
RESULTS=~/Copy/$1/results

mkdir $RESULTS/$2
echo $2 | tee $RESULTS/$2/$1$2.out

cd $ASSEMBLY

## loop across all taxa
for x in `cat $RESULTS/$1.lst`
	do
		cd $x/$2
		## create list of unique elements recognized
		awk '{print $10}' $2.out | sort | uniq > $2types.lst
		echo $x | tee -a $RESULTS/$2/$1$2.out
		wc -l $2types.lst | tee -a $RESULTS/$2/$1$2.out
		
		## loop across all element types
		for type in `cat $2types.lst`
			do
				## print ranges to pass to samtools
				grep $type $2.out | awk '{print $5":"$6"-"$7}' > $type.lst
				wc -l $type.lst | tee -a $RESULTS/$2/$1$2.out
				## extract from fasta
				samtools faidx ../contig/contig.fas $(cat $type.lst) s/:/./ > $type.fas
				## cluster results to remove redundancy
				cd-hit-est -i $type.fas -o $type.clust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
				grep ">" $type.clust.out | wc -l | tee -a $RESULTS/$2/$1$2.out
				## append taxon name to fasta headers
				sed "s/>/>$x./" $type.clust.out > $type.clust.fas
		done
		
		cd $ASSEMBLY

done	

## combine elements from all taxa by type
cat */$2/$2types.lst > $RESULTS/$2/$2all.lst

for group in `cat $RESULTS/$2/$2all.lst`
	do
	cat */$2/$group.clust.fas > $RESULTS/$2/$group.combined.fas
	echo $group | tee -a $RESULTS/$2/$1$2.out
	grep ">" $RESULTS/$2/$group.combined.fas | wc -l | tee -a $RESULTS/$2/$1$2.out
done
