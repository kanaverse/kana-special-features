# Parallelized submission script for Slurm.

for spec in 9606 10090 6239 10116 9541 7227 7955 9598
do
    echo $spec
    sbatch << XXX
#!/bin/bash
#SBATCH -e log_${spec}.err
#SBATCH -o log_${spec}.out
#SBATCH --mem=10000

ml R/dev
R -e "spec <- '${spec}'; source('blacklists.R')"
XXX
done
