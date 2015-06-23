#!/bin/bash

### P-clouds repeat analysis
## estimates repeat proportion for assembled contigs
## dependencies:
##	pclouds (http://www.evolutionarygenomics.com/ProgramsData/PClouds/PClouds.html)

PCLOUD=/Applications/P-Clouds_v0.9d

## pre-processing in pclouds
$PCLOUD/preprocessor INFILE OUTFILE

## run pclouds