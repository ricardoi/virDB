#!/bin/bash 

echo file running:: database

#options (select a number)
# 1: plants
# 2: land plants
# 3: invertebrates,land plants
# 4: invertebrates
# 5: fungi
# selecting option
option=$1
echo "retrieving"  ${option} "databases"

esearch -db nucleotide -query 'plant' & 'viruses' | efetch -format fasta > $option-virDB.fasta
 

date
