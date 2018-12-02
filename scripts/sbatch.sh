#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH -N 12
#SBATCH --ntasks-per-node 1

#echo command to stdout
set -x
echo $SLURM_SUBMIT_DIR
module load /software/mpi/gcc_open

cd /scratch
mpicc /scratch/pi_mc.c

for i in {2..12..2} 
do 
echo "With ${i} processes"
 time mpirun -np $i ./a.out
done
