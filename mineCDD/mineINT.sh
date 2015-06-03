#!/bin/bash
##$1 is taxon
##input files: $1.cidx, makeprofiledb output (see below)
##dependencies: makeprofiledb (maybe), rpstblastn, OTHERS?

### Make database against which RPS-BLAST can run
#makeprofiledb -in /Users/kate/Desktop/REdata/referenceSeq/domains/custom/INT.lst

### Run RPS-BLAST against nucleotide sequences using library specified above
rpstblastn -query $1.fa -db /Users/kate/Desktop/REdata/referenceSeq/domains/custom/INT.lst -out $1INT.rpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1

### Simplify output from RPS-BLAST and parse results by type of repeat
grep "gnl" $1INT.rpsblast.out > $1INTall.out
wc -l $1INTall.out
### Filter out alignment lengths shorter than 120
awk '{if ($4 > 120) print $0}' $1INTall.out > $1INT.out
wc -l $1INT.out

##pull out fasta
cat $1INT.out | awk '{
	if ($8-$7>0) 
		print $1 " " $7 " " $8;	
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1INT.fa
cat $1INT.out | awk '{
	if ($8-$7<0)
		print $1 " " $8 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1INT.fa