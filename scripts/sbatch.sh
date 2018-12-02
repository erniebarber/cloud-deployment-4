#!/bin/bash
#SBATCH -p RM
#SBATCH -t 1:00:00
#SBATCH -N 3
#SBATCH --ntasks-per-node 1

#echo command to stdout
set -x
echo $SLURM_SUBMIT_DIR
module load /software/mpi/gcc_open

cd /scratch
mpicc /scratch/hello.c

#for i in {2..28..2} 
#do 
# echo "With ${i} processes"
 time mpirun -np 3 ./a.out
#done
