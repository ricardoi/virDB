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
#ls -l "$DIR"/*.txt | awk '{print $9}' | cut -d '_' -f1 | sed '/^$/d' > ./ID.vina
#echo "$DIR"
echo "ViNAq begins the processes :::"
#       if ID.vina permission denied ... is 0k"
ID=$(ls "$DIR"/*.sam | cut -d '.' -f1 | sed -n ${SLURM_ARRAY_TASK_ID}p)

grep "^>" blastx.reference.fa > $ID-blastx.reference.txt
sed -i 's/^>//g' $ID-blastx.reference.txt


echo "retrieving proteins" 
mkdir -p "$ID"_meta-index/
Rscript --vanilla R/protDB_ret.R "$ID"_uclust.csv
