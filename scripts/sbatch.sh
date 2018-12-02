#!/bin/bash 
#SBATCH -t 1:00:00 
#SBATCH -N 12 
#SBATCH --ntasks-per-node 1 
#echo command to stdout 
set -x 
echo $SLURM_SUBMIT_DIR 
module load /software/mpi/gcc_open 
cd /scratch 
mpicc -lm /scratch/pi_mc.c 
echo "With 2 processes" 
time mpirun -np 2 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000 
echo "With 4 processes" 
time mpirun -np 4 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000 
echo "With 6 processes" 
time mpirun -np 6 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000 
echo "With 8 processes" 
time mpirun -np 8 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000 
echo "With 10 processes" 
time mpirun -np 10 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000 
echo "With 12 processes" 
time mpirun -np 12 --mca btl_base_warn_component_unused 0 /scratch/a.out 100000000
