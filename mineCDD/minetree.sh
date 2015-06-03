#!/bin/bash
##$1 is taxonTE
##input files: *TE.fa
##dependencies: muscle, raxml

##combine fasta files for all taxa of same TE
#cat *$1.fa > $1.fa

##align SINEs
mafft --auto --phylipout --inputorder $1.fa > $1.phy
##build SINE tree
raxml -n $1 -f o -m GTRGAMMA -s $1.phy 