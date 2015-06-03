#!/bin/bash
##$1 is input taxon
##input files: $1.fa.out, $1.fa.cidx, $1.fa
##dependencies: cdbyank, fasta_formatter, fastx_reverse_complement

##Copias
grep 'LTR/Copia' $1.fa.out > $1Copia.out
##filter out partial sequences (for Copia, less than 2000 bp)
cat $1Copia.out | awk '{
	if ($7-$6>2000)
		print $0;
	}' > $1Copiafiltered.out

done
BELOW NEEDS TO BE CORRECTED FOR COPIA TAXONOMY 
##DEA1
##pull out fasta
cat $1Copiafiltered.out | awk '{
	if ($9=="+" && $10=="DEA1") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Copia.DEA1.fa
cat $1Copiafiltered.out | awk '{
	if ($9=="C" && $10=="DEA1")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Copia.DEA1.fa

##Copia22-ZM_I-int
##pull out fasta
cat $1Copiafiltered.out | awk '{
	if ($9=="+" && $10=="Copia22-ZM_I-int") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Copia.Copia22ZMIint.fa
cat $1Copiafiltered.out | awk '{
	if ($9=="C" && $10=="Copia22-ZM_I-int")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Copia.Copia22ZMIint.fa

##Copia-5_PD-I
##pull out fasta
cat $1Copiafiltered.out | awk '{
	if ($9=="+" && $10=="Copia-5_PD-I") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Copia.Copia5PDI.fa
cat $1Copiafiltered.out | awk '{
	if ($9=="C" && $10=="Copia-5_PD-I")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Copia.Copia5PDI.fa
	
##Copia-4_PD-I
##pull out fasta
cat $1Copiafiltered.out | awk '{
	if ($9=="+" && $10=="Copia-4_PD-I") 
		print $5 " " $6 " " $7;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1Copia.Copia4PDI.fa
cat $1Copiafiltered.out | awk '{
	if ($9=="C" && $10=="Copia-4_PD-I")
		print $5 " " $6 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1Copia.Copia4PDI.fa