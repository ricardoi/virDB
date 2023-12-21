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
Rscript --vanilla 2>&1 R/virDB.001.R ${option} 
 

date
