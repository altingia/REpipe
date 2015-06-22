#!/bin/bash

### P-clouds repeat analysis
## dependencies:
##	pclouds (http://www.evolutionarygenomics.com/ProgramsData/PClouds/PClouds.html)
##	fastx toolkit (http://hannonlab.cshl.edu/fastx_toolkit/index.html)

PCLOUD=/Applications/P-Clouds_v0.9d

## fastq to fasta conversion (keeping sequences with Ns)
fastq_to_fasta -n -i INFILE -o OUTFILE

## pre-processing in pclouds
$PCLOUD/preprocessor INFILE OUTFILE