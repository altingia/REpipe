#!/bin/bash

## counts shared clusters
## usage: ./clusterSummary.sh TAXON TAXON.LST

RESULTS=~/Copy/$1/results

## loop across all taxa
for x in `cat $2`
	do
		cd $ANNOTATE/$x
		mkdir compareTrans
		rm compareTrans/*	
		
		
done	
