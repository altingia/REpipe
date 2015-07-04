#!/bin/bash

## combine domain results for all taxa in one fasta
## usage: ./domainCombine.sh TAXON DOMAIN

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains

mkdir $RESULTS/$2

cd $ANNOTATE
echo -n > $RESULTS/$2/$2.combine.out

## create master fasta and recluster
for type in `cat $DOMAIN/$2cdd.lst`
	do
		cat */$2/$type.clust.fas > $RESULTS/$2/$type.combine.fas
		echo $2.$type.all | tee -a $RESULTS/$2/$2.combine.out
		grep ">" $RESULTS/$2/$type.combine.fas | wc -l | tee -a $RESULTS/$2/$2.combine.out
		cd-hit-est -i $RESULTS/$2/$type.combine.fas -o $RESULTS/$2/$type.combine.clust.out -c 0.8 -n 8 -aL 0.8 -aS 0.8 -g 1
		echo $2.$type.clust | tee -a $RESULTS/$2/$2.combine.out
		grep ">" $RESULTS/$2/$type.combine.clust.out | wc -l | tee -a $RESULTS/$2/$2.combine.out
done

## reformat table
cd $RESULTS/$2
sed "s/^$/0/" $2.combine.out | sed -E "s/\ +//" | cut -f 1 -d " " | paste -d " " - - | sed "s/-//" > $2.combine.table
