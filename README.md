# vinaDB - Virome Network Analysis DataBase

A program to retrieve the Reference Sequence datasets for plant, insect and fungal viruses. \
Keep in mind this is a beta version, bugs are expected. Program tested only in Mac and Linux OS.

------ 

## Installation 
First, you need to install `R` (version >4.0) if you don't have it. \
You can use on mac `brew` or in linux `apt get` to install `R`. \
Then, install the `R libraries` execute the `sh installRpkg.sh install` command and it will install the packages necessary to run `virDB-launcher.sh`.

## Running 

You need to exectute `virDB-launcher.sh` in the command line and with an **stable internet connection** - otherwise, NCBI fetcher will be interrupted, and the process needs to starts again.

>#You have 5 options (select a number) \
#1: plants \
#2: land plants \
#3: invertebrates,land plants \
#4: invertebrates \
#5: fungi

This is an example to run `virDB-launcher`:
```bash
sh virDB-launcher.sh 1 # to retrieve option 1: plants
```


>### Note:
> The NCBI entries for plant hosts were splited as _plants_, _land plants_, and viruses that infect plants and are vectored by insects as _invertebrates,landplants_, because this has to do with NCBI indexing. You need to download _plants_, _land plants_ and _invertebrates,landplants_ to have the FULL plants database.
After downloading all the databases, you can merge your fasta files with `cat plants_722.fasta, land_plants_722.fasta invertebrates,landplants_722.fasta`
