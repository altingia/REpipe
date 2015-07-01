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
#SBATCH -p normal	      # Queue name
#SBATCH -n 16                  # Total number of  tasks requested
#SBATCH -t 6:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE	      # <-- Allocation name to charge job against

MASURCA=$HOME/bin/MaSuRCA-2.3.2/bin
WORK=$WORK
HOME=$HOME

for TAXON in `cat $1`
  do
	echo $TAXON
	
	#set up files and directories
	mkdir $WORK/$TAXON/masurca
	cd $WORK/$TAXON/masurca

	#run masurca
	$MASURCA/masurca config.txt 
	./assemble.sh

	#transfer files
	mkdir $HOME/$TAXON $HOME/$TAXON/masurcaAssembly
	cp $WORK/$TAXON/masurca/CA/9-terminator/* assemble.sh $HOME/$TAXON/config.txt $HOME/$TAXON/masurcaAssembly
done
