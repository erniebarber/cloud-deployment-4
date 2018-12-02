#!/bin/bash
#SBATCH -p RM
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 28

#echo command to stdout
set -x
echo $SLURM_SUBMIT_DIR
module load /software/mpi/gcc_open
mpi

cd /SCRATCH
mpicc /scratch/hello.c

#for i in {2..28..2} 
#do 
# echo "With ${i} processes"
 time mpirun -np $i ./a.out
#done
