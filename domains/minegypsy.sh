#!/bin/bash
##$1 is input taxon
##input files: $1.fa.out, $1.fa.cidx, $1.fa
##dependencies: cdbyank, fasta_formatter, fastx_reverse_complement

##Gypsys
grep 'LTR/Gypsy' $1.fa.out > $1Gypsy.out
##filter out partial sequences (for Gypsy, less than 2000 bp)
cat $1Gypsy.out | awk '{
	if ($7-$6>2000)
		print $0;
	}' > $1Gypsyfiltered.out

##DEA1
##pull out fasta
cat $1Gypsyfiltered.out | awk '{
	if ($9=="+" && $10=="DEA1") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Gypsy.DEA1.fa
cat $1Gypsyfiltered.out | awk '{
	if ($9=="C" && $10=="DEA1")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Gypsy.DEA1.fa

##Gypsy22-ZM_I-int
##pull out fasta
cat $1Gypsyfiltered.out | awk '{
	if ($9=="+" && $10=="Gypsy22-ZM_I-int") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Gypsy.Gypsy22ZMIint.fa
cat $1Gypsyfiltered.out | awk '{
	if ($9=="C" && $10=="Gypsy22-ZM_I-int")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Gypsy.Gypsy22ZMIint.fa

##Gypsy-5_PD-I
##pull out fasta
cat $1Gypsyfiltered.out | awk '{
	if ($9=="+" && $10=="Gypsy-5_PD-I") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Gypsy.Gypsy5PDI.fa
cat $1Gypsyfiltered.out | awk '{
	if ($9=="C" && $10=="Gypsy-5_PD-I")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Gypsy.Gypsy5PDI.fa
	
##Gypsy-4_PD-I
##pull out fasta
cat $1Gypsyfiltered.out | awk '{
	if ($9=="+" && $10=="Gypsy-4_PD-I") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Gypsy.Gypsy4PDI.fa
cat $1Gypsyfiltered.out | awk '{
	if ($9=="C" && $10=="Gypsy-4_PD-I")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Gypsy.Gypsy4PDI.fa