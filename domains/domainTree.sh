#!/bin/bash

## phylogenetic analysis of domain searching results
## usage: ./XXX.sh TAXON DOMAIN
## reference file as DOMAIN.fas in $DOMAIN
## dependencies: 
#	mafft
#	raxml

RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains

cd $RESULTS

## align domain as nucleotides
mafft --auto --phylipout --inputorder $RESULTS/INTcombined.fas > $RESULTS/INTcombined.phy

## add references
cat $RESULTS/$2combined.fas $DOMAIN/$2ref.fas > $2combref.fas

## translate domain to protein and realign


## build trees for both nucleotide and protein
raxml -n $1 -f o -m GTRGAMMA -s $1.phy 