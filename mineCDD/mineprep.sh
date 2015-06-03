#!/bin/bash
##Prep input fasta file and run analysis
##$1 is input taxon, input file is $1ORIGINAL.fa
##dependencies: cdbfasta, repeatmasker

AGAVE=~/Copy/Agave/test

cd $AGAVE
mkdir archive data

##make sure no lowercase n
cat $1ORIGINAL.fa | sed 's/n/N/' > $1.fa
mv *ORIGINAL.fa archive
mv *.fa data

##index fasta file
cd data
cdbfasta $1.fa
cd ..

##repeatmasker (quick and dirty)
repeatmasker -qq -nolow -no_is -norna -species liliopsida -nocut data/$1.fa