#!/bin/bash
#SBATCH --account=epi
#SBATCH --qos=epi
#SBATCH --job-name=protret
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ralcala@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=500mb
#SBATCH --time=1:00:00
#SBATCH --output=protret_%j.out
#SBATCH --array=1-2%1
date; hostname; pwd
# Mapping
#@ Execute this program using this command
# sbatch ViNAq-ht.sbatch res_ViNAt
##two methods
module purge
module load ufrc R

#@ probably i will need to do add PATH1=$1
# execute with: 
# sbatch protDB.sbatch file_of_files (fof)
DIR=$1
ls $DIR > dir.fof
#ls 2-results_papa2021 | cut -d_ -f2 | cut -d. -f1 > ID.txt
#echo "$DIR"
echo "ViNAq begins the processes :::"
#       if ID.vina permission denied ... is 0k"
ID=$(sed -n ${SLURM_ARRAY_TASK_ID}p dir.fof)

grep '^>' $DIR$ID/blastx.reference.fa > $ID-blastx.reference.txt
#grep "^>" blastx.reference.fa > $ID-blastx.reference.txt
sed -i 's/^>//g' $DIR/$ID-blastx.reference.txt

echo "retrieving proteins" 
Rscript --vanilla virDB/R/protDB_ret.R $ID-blastx.reference.txt
