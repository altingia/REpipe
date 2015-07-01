#!/bin/bash
#----------------------------------------------------
# From example SLURM job script job.mpi
#----------------------------------------------------

#SBATCH -J repark              # Job name
#SBATCH -o repark.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development	      # Queue name
#SBATCH -n 16                 # Total number of  tasks requested
#SBATCH -t 2:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE	      # <-- Allocation name to charge job against

module load velvet

REPARK=$HOME/bin/RepARK

# run RepARK
$REPARK/RepARK.pl -o $WORK/TAXON -l $WORK/TAXON/GSStrim.fastq.gz -a velvet -p 16 -t 100 

