#!/bin/bash
#SBATCH --account=epi
#SBATCH --qos=epi-b
#SBATCH --job-name=ViNAq
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ralcala@ufl.edu
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=32gb
#SBATCH --time=80:00:00
#SBATCH --output=ViNAq_%j.out
#SBATCH --array=1-981%100
date; hostname; pwd
# Mapping
#@ Execute this program using this command
# sbatch ViNAq-ht.sbatch res_ViNAt
##two methods
module purge
module load ufrc

#@ probably i will need to do add PATH1=$1
# execute with: 
# sbatch protDB.sbatch file_of_files (fof)
DIR=$1
ls $DIR > dir.fof
#ls 2-results_papa2021 | cut -d_ -f2 | cut -d. -f1 > ID.txt
#echo "$DIR"
echo "ViNAq begins the processes :::"
#       if ID.vina permission denied ... is 0k"
ID=$(sed -n ${SLURM_ARRAY_TASK_ID}p)

grep '^>' $DIR/$ID/blastx.reference.fa > $ID-blastx.reference.txt
#grep "^>" blastx.reference.fa > $ID-blastx.reference.txt
sed -i 's/^>//g' $DIR/$ID-blastx.reference.txt

echo "retrieving proteins" 
Rscript --vanilla R/protDB_ret.R $ID-blastx.reference.txt
