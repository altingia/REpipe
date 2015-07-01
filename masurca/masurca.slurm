#!/bin/bash
#----------------------------------------------------
# script to run masurca on TACC's Stampede for multiple taxa in a series
# dependency:
# 	masurca (path specified below)
# usage: sbatch masurca.slurm taxa.lst
#	where "taxa.lst" is the list of species
# sequence files and config.txt in folders with taxon names in $WORK
# change -A option if anything other than monocotTE
# From example SLURM job script job.mpi
#----------------------------------------------------

#SBATCH -J masurca              # Job name
#SBATCH -o masurca.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development	      # Queue name
#SBATCH -n 16                  # Total number of  tasks requested
#SBATCH -t 2:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE	      # <-- Allocation name to charge job against

MASURCA=$HOME/bin/MaSuRCA-2.3.2/bin
DATA=$WORK/data
ASSEMBLY=$WORK/assembly
ANNOTATE=$WORK/annotate

for TAXON in `cat $1`
  do
	echo $TAXON
	
	#set up files and directories
	mkdir $ASSEMBLY/$TAXON $ASSEMBLY/$TAXON/masurca
	cd $ASSEMBLY/$TAXON/masurca

	#run masurca
	$MASURCA/masurca $DATA/$TAXON/$TAXON.config.txt 
	./assemble.sh

	#transfer files
	mkdir $ANNOTATE/$TAXON/masurca
	cp CA/9-terminator/* assemble.sh $DATA/$TAXON/$TAXON.config.txt $ANNOTATE/$TAXON/masurca
done
