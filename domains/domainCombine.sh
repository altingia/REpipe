#!/bin/bash

## combine domain results for all taxa in one fasta
## usage: ./domainCombine.sh TAXON DOMAIN

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains

mkdir $RESULTS/$2

cd $ANNOTATE

for type in `cat $DOMAIN/$2cdd.lst`
	do
		cat */$2/$type.clust.fas > $RESULTS/$2/$type.combined.fas
		grep ">" $RESULTS/$2/$type.combined.fas | wc -l
done
