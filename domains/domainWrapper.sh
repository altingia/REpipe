#!/bin/bash

## wrapper for domain scripts
## usage: ./domainWrapper.sh TAXON TAXON.lst
## taxa to be analyzed in TAXON.lst, models in DOMAIN.pn
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe
DOMAIN=~/data/domains

cd $ANNOTATE

## loop across all domains
for x in GAG INT RT RH
	do
		$SCRIPTS/domains/domain.sh $1 $x $2
		$SCRIPTS/domains/domainTable.sh $1 $x $2
		$SCRIPTS/domains/domainCombine.sh $1 $x
done
