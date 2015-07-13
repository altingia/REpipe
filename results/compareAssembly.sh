#!/bin/bash

## compares annotations from GSS and transcriptome
## usage: ./compareAssembly.sh TAXON TAXON.LST
## for taxa with $x and $x_trans

ANNOTATE=~/Copy/$1/annotate
RESULTS=~/Copy/$1/results

## loop across all taxa
for x in `cat $2`
	do
		cd $ANNOTATE/$x
		mkdir compareTrans
		rm compareTrans/*	
		
		## Gypsy, Ty3
		## RM Gypsy
		## RTV_1 (core domain for Gypsy) 249567
		## rve (integrase for Copia and Gypsy) 250040 
		cat LTR/Gypsy.fas $ANNOTATE/"$x"_trans/LTR/Gypsy.fas > compareTrans/GypsyCompare.fas
		cat RT/249567.fas $ANNOTATE/"$x"_trans/RT/249567.fas > compareTrans/249567Compare.fas
		cat INT/250040.fas $ANNOTATE/"$x"_trans/INT/250040.fas > compareTrans/250040Compare.fas
				
		## Copia, Ty1
		## RM Copia
		## RTV_2 (core domain for Copia/Sireviruses) 254387 
		## rve (integrase for Copia and Gypsy) 250040 
		cat LTR/Copia.fas $ANNOTATE/"$x"_trans/LTR/Copia.fas > compareTrans/CopiaCompare.fas
		cat RT/254387.fas $ANNOTATE/"$x"_trans/RT/254387.fas > compareTrans/254387Compare.fas
		cat INT/250040.fas $ANNOTATE/"$x"_trans/INT/250040.fas > compareTrans/250040Compare.fas
		
		## DIRS
		## RT_DIRS1 239684
		## RNAse_HI_RT_DIRS1 260007
		#cat RT/239684.fas RH/260007.fas > compareTrans/DIRSCompare.fas
		
		## non-LTR
		## RM LINE and SINE
		## RNAse_HI_RT_non_LTR 260008
		## RT_nLTR_like 238827
		cat LINE/LINE.fas $ANNOTATE/"$x"_trans/LINE/LINE.fas > compareTrans/LINECompare.fas
		cat SINE/SINE.fas $ANNOTATE/"$x"_trans/SINE/SINE.fas > compareTrans/SINECompare.fas
		cat RH/260008.fas $ANNOTATE/"$x"_trans/RH/260008.fas > compareTrans/260008Compare.fas
		cat RT/238827.fas $ANNOTATE/"$x"_trans/RT/238827.fas > compareTrans/238827Compare.fas
		
		## cluster each combined file
		cd compareTrans
		for file in *.fas
			do
				cd-hit-est -i $file -o $file.clust.out -c 0.8 -n 8 -aL 0.8 -aS 0.8 -g 1
		done
done	
