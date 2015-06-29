#!/bin/bash
##$1 is input taxon
##input files: $1.fa.out, $1.fa.cidx, $1.fa
##dependencies: cdbyank, fasta_formatter, fastx_reverse_complement

##LINEs
grep 'LINE/RTE-BovB' $1.fa.out > $1LINE.out
##filter out partial sequences (for LINEs, less than 2000 bp)
cat $1LINE.out | awk '{
	if ($7-$6>2000)
		print $0;
	}' > $1LINEfiltered.out

##RTE2_ZM
##pull out LINE fasta
cat $1LINEfiltered.out | awk '{
	if ($9=="+" && $10=="RTE2_ZM") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1LINE.RTE2ZM.fa
cat $1LINEfiltered.out | awk '{
	if ($9=="C" && $10=="RTE2_ZM")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1LINE.RTE2ZM.fa

##RTE-1_PD
##pull out LINE fasta
cat $1LINEfiltered.out | awk '{
	if ($9=="+" && $10=="RTE-1_PD") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1LINE.RTE1PD.fa
cat $1LINEfiltered.out | awk '{
	if ($9=="C" && $10=="RTE-1_PD")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1LINE.RTE1PD.fa