#!/bin/bash

## wrapper for domain scripts
## usage: ./domainWrapper.sh TAXON TAXON.lst
## taxa to be analyzed in TAXON.lst, models in DOMAIN.pn
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

ANNOTATE=~/data/$1/annotate
RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe
DOMAIN=~/data/domains

mkdir $RESULTS/domains
cd $ANNOTATE

## loop across all domains for each script
for x in GAG INT RT RH
	do
		$SCRIPTS/domains/domain.sh $1 $x $2
		$SCRIPTS/domains/domainTable.sh $1 $x $2
		$SCRIPTS/domains/domainCombine.sh $1 $x
		cp $RESULTS/$x/$x.combine.table $RESULTS/domains
done

cd $RESULTS/domains
cat *.combine.table > domains.combine.table
