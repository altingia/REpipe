#!/bin/bash

## extract subtaxonomy from RM output
## usage: ./extractSubtax.sh TAXON
## dependencies (from scripts called): 
##	samtools
##	cd-hit-est

SCRIPTS=~/GitHub/REpipe/REpipe

## nonLTR 
for sub in SINE LINE
	do
		$SCRIPTS/extractNonLTR.sh $1 $sub
done

## LTR
for sub in Gypsy Copia
	do
		$SCRIPTS/extractLTR.sh $1 $sub
done

## DNA transposons
for sub in EnSpm hAT MuDR PIF TcMar
	do
		$SCRIPTS/extractDNA.sh $1 $sub
done
