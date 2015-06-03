#!/bin/bash
##$1 is input taxon
##input files: $1.fa.out, $1.fa.cidx, $1.fa
##dependencies: cdbyank, fasta_formatter, fastx_reverse_complement

##SINEs
grep 'SINE/tRNA-RTE' $1.fa.out > $1SINE.out
##filter out partial sequences (for SINEs, less than 100 bp)
cat $1SINE.out | awk '{
	if ($7-$6>100)
		print $0;
	}' > $1SINEfiltered.out
##pull out SINE fasta
cat $1SINEfiltered.out | awk '{
	if ($9=="+") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1SINE.fa
cat $1SINEfiltered.out | awk '{
	if ($9=="C")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1SINE.fa