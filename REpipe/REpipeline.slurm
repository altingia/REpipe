#!/bin/bash

#----------------------------------------------------
# CHARACTERIZE AND QUANTIFY TES FROM MASURCA OUTPUT	
# dependencies:
# 	repeatmasker (path specified below)
#	bwa
#	samtools
#	blast+ (and makeblastdb already run on $REF, see below)
# usage: 
#	./REpipeline.slurm TAXON FASTQ REFERENCE ASSEMBLY
# run in batch using launchREpipe.slurm (disregards all slurm commands above)
# change -A option if anything other than monocotTE
#----------------------------------------------------

#SBATCH -J REpipe              # Job name
#SBATCH -o REpipe.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development        # Queue name
#SBATCH -n 16                  # Total number of  tasks requested
#SBATCH -t 2:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE          # <-- Allocation name to charge job against

module load bwa samtools blast

REPEATMASKER=$HOME/bin/RepeatMasker

DATA=$WORK/data/$1
ASSEMBLY=$WORK/assembly/$1/$4
ANNOTATE=$WORK/annotate/$1/$4
REF=$HOME/refs/$3
SCRIPTS=$HOME/REpipe/REpipe

mkdir -p $ANNOTATE

## SETUP FILES AND DIRECTORIES
	echo "$1"
	cd $ANNOTATE
	
	mkdir contig archive
	cp $ASSEMBLY/assembly/contig.fas $ASSEMBLY/assembly/$1.config.txt archive/
	cp archive/contig.fas contig/contig.fas

## QUANTIFICATION	
	
	## LIST NAMES
	cd contig
	grep ">" contig.fas | sed 's/>//' > contig.lst

	## MAKE INDEX
	samtools faidx contig.fas
	
	## MAP READS TO CONTIGS
	bwa index contig.fas 
	bwa mem contig.fas $DATA/$2 > contig.sam
	
	##SAM TO BAM CONVERSION AND SUMMARY
	samtools view -bSu contig.sam | samtools sort - contig.sorted 
	samtools index contig.sorted.bam
	samtools idxstats contig.sorted.bam > contigReads.lst
	rm contig.sam
	mv contig.sorted.bam contig.sorted.bam.bai ../archive/
	
## REMOVE CP/MT FROM CONTIGS (START IN TAXON FOLDER) and reads
	
	## BLAST AND PARSE ORGANELLAR CONTIGS
	#makeblastdb -in $REF -dbtype nucl
	blastn -evalue 0.01 -outfmt 6 -db $REF -query contig.fas -out cpmtblast.out
	awk '$0 ~ /MT/ {print $1}' cpmtblast.out | sort | uniq > mtcontigs.lst
	awk '$0 ~ /CP/ {print $1}' cpmtblast.out | sort | uniq > cpcontigs.lst
	
	## EXTRACT ORGANELLAR CONTIGS
	cat mtcontigs.lst cpcontigs.lst | sort | uniq > contigCPMT.lst
	grep -v -f contigCPMT.lst contig.lst > nuc.lst
	samtools faidx contig.fas $(cat nuc.lst) > nuc.fas
	## OR ONLY REMOVE CP CONTIGS
	#grep -v -f cpcontigs contig.lst > nuc.lst
	#samtools faidx contig.fas $(cat nuc.lst) > nuc.fas

## RUN REPEATMASKER ON ALL CONTIGS (start in taxon folder)
	$REPEATMASKER/RepeatMasker -species liliopsida nuc.fas 
	cp nuc.fas.out ../archive

## RUN PARSING SCRIPT
	$SCRIPTS/parseRM.sh
