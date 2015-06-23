#!/bin/bash
#----------------------------------------------------
# From example SLURM job script job.mpi
#----------------------------------------------------

#SBATCH -J repark              # Job name
#SBATCH -o repark.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	      # Queue name
#SBATCH -n 16                 # Total number of  tasks requested
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com
#SBATCH --mail-type END

#SBATCH -A monocotTE	      # <-- Allocation name to charge job against

module load velvet

# run RepARK
$HOME/bin/RepARK/RepARK.pl -o $WORK/Anemarrhena_asphodeloides/repark -l EL03-100511trim.fastq.gz -a velvet -p 16  
		
