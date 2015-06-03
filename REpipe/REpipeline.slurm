#!/bin/bash

##CHARACTERIZE AND QUANTIFY TES FROM MASURCA OUTPUT	

#SBATCH -J REpipeline              # Job name
#SBATCH -o REpipeline.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development        # Queue name
#SBATCH -n 16                  # Total number of  tasks requested
#SBATCH -t 2:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE          # <-- Allocation name to charge job against

##enter name of taxon as $1, fastq file as $2
##DEPENDENCIES: repeatmasker, bwa, samtools, blast+ (and makeblastdb already run on $REF, see below)
##run in batch using launchREpipe.slurm (disregards all slurm commands above)

module load bwa samtools blast

REPEATMASKER=$HOME/bin/RepeatMasker

DATA=$WORK/agave_data/$1
REF=$HOME/refs/AlliumOrg.fasta
OUT=$HOME/$1/$1.QCout

##SETUP FILES AND DIRECTORIES
	echo "$1"
	cd $HOME/$1
	
	mkdir contig
	cp assembly/genome.ctg.fasta contig/contig.fas

##QUANTIFICATION	
	##LIST NAMES
cd contig
	grep ">" contig.fas | sed 's/>//' > contig.lst

	##MAKE INDEX
	samtools faidx contig.fas
	
	##MAP READS TO CONTIGS
	bwa index contig.fas 
	bwa mem contig.fas $DATA/$2 > $DATA/contig.sam
	
	##SAM TO BAM CONVERSION AND SUMMARY
	samtools view -bSu $DATA/contig.sam | samtools sort - $DATA/contig.sorted 
	samtools index $DATA/contig.sorted.bam
	samtools idxstats $DATA/contig.sorted.bam > contigReads.lst
	
##REMOVE CP/MT FROM CONTIGS (START IN TAXON FOLDER) and reads
	
	##BLAST AND PARSE ORGANELLAR CONTIGS
	#makeblastdb -in $REF -dbtype nucl
	blastn -evalue 0.01 -outfmt 6 -db $REF -query contig.fas -out cpmtblast.out
	awk '$0 ~ /MT/ {print $1}' cpmtblast.out | sort | uniq > mtcontigs.lst
	awk '$0 ~ /CP/ {print $1}' cpmtblast.out | sort | uniq > cpcontigs.lst
	
	##EXTRACT ORGANELLAR CONTIGS
	cat mtcontigs.lst cpcontigs.lst | sort | uniq > contigCPMT.lst
	diff contig.lst contigCPMT.lst | awk '$2 ~ /ctg/ {print $2}' > nuc.lst
	samtools faidx contig.fas $(cat nuc.lst) > nuc.fas

##RUN REPEATMASKER ON ALL CONTIGS (start in taxon folder)
	$REPEATMASKER/RepeatMasker -species liliopsida nuc.fas 

##REMOVE CONFOUNDING HITS FROM REPEATMASKER OUTPUT
	for GROUP in RC Low-complexity Simple-repeat Helitron
		do
			grep "$GROUP" nuc.fas.out > $GROUP.lst
	done
	
	grep -v "RC" nuc.fas.out | grep -v "Low-complexity" | grep -v "Simple-repeat" | grep -v "Helitron" > nojunk.fas.out
	
	##TOTAL REPEAT READS MAPPED (AMBIGUOUS + ANNOTATED)
	tail -n+4  nojunk.fas.out | awk '{print $5}' | sort | uniq > contigRE.lst
		
	##FIND CONTIGS WITH AMBIGUOUS ANNOTATIONS
	tail -n+4  nojunk.fas.out | awk '{print $5,$11}' | sort | uniq | awk '{print $1}' | uniq -d > ambtemp.lst
	awk '$11 ~ /Unknown/ {print $5}' nojunk.fas.out > unknown.lst
	cat unknown.lst ambtemp.lst > ambiguous.lst
	rm ambtemp.lst
		
	##FIND ANNOTATED REPEAT CONTIGS
	grep -v -f ambiguous.lst nojunk.fas.out > annotate.fas.out
	tail -n+4  annotate.fas.out | awk '{print $5}' | sort | uniq > annotate.lst
	
	##UNANNOTATED CONTIGS (INCLUDING JUNK)
	grep -v -f contigRE.lst nuc.lst > unannotated.lst
	##EXTRACT UNANNOTATED CONTIGS TO BLAST LATER
	samtools faidx contig.fas $(cat unannotated.lst) > unannotated.fas	

##PARSING INTO REPEAT CLASSES
cd $HOME/$1

mkdir LTR LINE SINE Satellite rRNA DNA 
	
for CLASS in LTR LINE SINE Satellite rRNA DNA
	do
		grep $CLASS contig/annotate.fas.out > $CLASS/$CLASS.out
		awk '{print $5}' $CLASS/$CLASS.out | sort | uniq > $CLASS/$CLASS.lst
		samtools faidx contig/contig.fas $(cat $CLASS/$CLASS.lst) > $CLASS/$CLASS.fas 
done
	
##PARSING LTR TYPES
for RETRO in Gypsy Copia
	do
		grep $RETRO LTR/LTR.out > LTR/$RETRO.out
		awk '{print $5}' LTR/$RETRO.out | sort | uniq > LTR/$RETRO.lst
		samtools faidx contig/contig.fas $(cat LTR/$RETRO.lst) > LTR/$RETRO.fas
done
			
##CLASSIFY DNA TEs BY SUPERFAMILY
cd DNA

for TE in EnSpm hAT MuDR PIF TcMar
	do
		grep $TE DNA.out > $TE.out
		awk '{print $5}' $TE.out | uniq | sort > $TE.lst		
done

##QC SUMMARY
cd $HOME/$1
echo "QC SUMMARY"
echo "contigs" | tee $OUT
wc -l contig/contig.lst | tee -a $OUT
echo "mappedreads" | tee -a $OUT
awk '{s+=$3}END{print s}' contig/contigReads.lst | tee -a $OUT
echo "unmappedreads" | tee -a $OUT
awk '{s+=$4}END{print s}' contig/contigReads.lst | tee -a $OUT
echo "orgcontigs" | tee -a $OUT
wc -l contig/contigCPMT.lst | tee -a $OUT
echo "orgreads" | tee -a $OUT
grep -f contig/contigCPMT.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $OUT
echo "repeatcontigs" | tee -a $OUT
wc -l contig/contigRE.lst | tee -a $OUT
echo "repeatreads" | tee -a $OUT
grep -f contig/contigRE.lst contig/contigReads.lst | awk '{s+=$3}END{print s}' | tee -a $OUT
echo "retrotransposoncontigs"
wc -l LTR/LTR.lst | tee -a $OUT
echo "retrotransposon.fas"
wc -l LTR/LTR.fas | tee -a $OUT
