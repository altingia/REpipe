#!/bin/bash
##$1 is taxon
##input files: $1.cidx, makeprofiledb output (see below)
##dependencies: makeprofiledb (maybe), rpstblastn, OTHERS?

### Make database against which RPS-BLAST can run
#makeprofiledb -in /Users/kate/Desktop/REdata/referenceSeq/domains/custom/RT.lst

### Run RPS-BLAST against nucleotide sequences using library specified above
rpstblastn -query $1.fa -db /Users/kate/Desktop/REdata/referenceSeq/domains/custom/RT.lst -out $1RT.rpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1

### Simplify output from RPS-BLAST and parse results by type of repeat
grep "gnl" $1RT.rpsblast.out > $1RTall.out
wc -l $1RTall.out
### Filter out alignment lengths shorter than 120
awk '{if ($4 > 120) print $0}' $1RTall.out > $1RT.out
wc -l $1RT.out
 
#RVT_1  pfam00078
grep "215698" $1RT.out > $1RTV_1.out
cat $1RTV_1.out | awk '{
	if ($8-$7>0) 
		print $1 " " $7 " " $8;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1RTV_1.fa
cat $1RTV_1.out | awk '{
	if ($8-$7<0)
		print $1 " " $8 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1RTV_1.fa
wc -l $1RTV_1.out

#RVT_2 pfam07727
grep "219537" $1RT.out > $1RTV_2.out
cat $1RTV_2.out | awk '{
	if ($8-$7>0) 
		print $1 " " $7 " " $8;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1RTV_2.fa
cat $1RTV_2.out | awk '{
	if ($8-$7<0)
		print $1 " " $8 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1RTV_2.fa
wc -l $1RTV_2.out

#RT_nLTR_like cd01650
grep "238827" $1RT.out > $1RT_nLTR_like.out
cat $1RT_nLTR_like.out | awk '{
	if ($8-$7>0) 
		print $1 " " $7 " " $8;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | sed 's/>/>'$1'./' > $1RT_nLTR_like.fa
cat $1RT_nLTR_like.out | awk '{
	if ($8-$7<0)
		print $1 " " $8 " " $7;
	}' | cdbyank $1.fa.cidx -R | fasta_formatter | fastx_reverse_complement | sed 's/>/>'$1'./' >> $1RT_nLTR_like.fa
wc -l $1RT_nLTR_like.out