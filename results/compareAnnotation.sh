#!/bin/bash

## compares contigs identified as TEs from different methods, focus on those of primary interest
## usage: ./compareAnnotation.sh TAXON TAXON.LST

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results

## loop across all taxa
for x in `cat $2`
	do
		cd $ANNOTATE/$x
		mkdir compare
		rm compare/*
		
		## count all annotated contigs
		for domain in INT RT RH GAG
			do
				cp $domain/*all.lst compare/
		done	
		
		cat contig/annotate.lst compare/*.lst | sort | uniq -c | sort -r > compare/allOverlap.lst
		
		## Gypsy, Ty3
		## RM Gypsy
		## RTV_1 (core domain for Gypsy) 249567
		## rve (integrase for Copia and Gypsy) 250040 
		cat LTR/Gypsy.lst RT/249567.uniq.lst INT/250040.uniq.lst | sort | uniq -c | sort -r > compare/GypsyCompare.lst
		
		
		## Copia, Ty1
		## RM Copia
		## RTV_2 (core domain for Copia/Sireviruses) 254387 
		## rve (integrase for Copia and Gypsy) 250040 
		cat LTR/Copia.lst RT/254387.uniq.lst INT/250040.uniq.lst | sort | uniq -c | sort -r > compare/CopiaCompare.lst
		
		## DIRS
		## RT_DIRS1 239684
		## RNAse_HI_RT_DIRS1 260007
		cat RT/239684.uniq.lst RH/260007.uniq.lst | sort | uniq -c | sort -r > compare/DIRSCompare.lst
		
		## non-LTR
		## RM LINE and SINE
		## RNAse_HI_RT_non_LTR 260008
		## RT_nLTR_like 238827
		cat LINE/LINE.lst SINE/SINE.lst RH/260008.uniq.lst RT/238827.uniq.lst | sort | uniq -c | sort -r > compare/nonLTRCompare.lst

done	
