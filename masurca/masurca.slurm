#!/bin/bash
#----------------------------------------------------
# script to run masurca on TACC's Stampede for multiple taxa in a series
# dependency:
# 	masurca (path specified below)
# taxa specified in list (taxa.lst) located in folder named $1
# sequence files in folders with taxon names in $WORK
# change -A option if anything other than monocotTE
# From example SLURM job script job.mpi
#----------------------------------------------------

#SBATCH -J masurca              # Job name
#SBATCH -o masurca.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	      # Queue name
#SBATCH -n 16                  # Total number of  tasks requested
#SBATCH -t 6:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE	      # <-- Allocation name to charge job against

MASURCA=$HOME/bin/MaSuRCA-2.3.2/bin
GROUP=$HOME/$1

cd $GROUP
for TAXON in `cat taxa.lst`
  do
	echo $TAXON
	
	#set up files and directories
	mkdir $WORK/$TAXON/masurca
	cd $WORK/$TAXON/masurca

	#run masurca
	$MASURCA/masurca $HOME/$TAXON/config.txt 
	./assemble.sh

	#transfer files
	mkdir $HOME/$TAXON/assembly
	cp $WORK/$TAXON/masurca/CA/9-terminator/* assemble.sh $HOME/$TAXON/config.txt $HOME/$TAXON/assembly
done
