library(RCurl)
library(tidyverse)
library(rentrez)
library(seqinr)

#'@functions: protDB retriever
# Gets the nucleotide Acc. No., and retrieves the protein accession numbers
# used to generate the protein database
protDB_ret <- function(genebankrecord){
  gbf = gb |>
    # substr(1, 2000) |>
    cat( sep="\n") |>
    capture.output()
  #capture.output(cat(subst
  #print("Getting Prot ID")
  protID <- gbf[grep("  /protein_id=", gbf, value = F,)]
  pAccNo <- gsub(pattern = '                     /protein_id', replacement =  '', protID) |>
    gsub(pattern = '^=\\\"', replacement = '') |>
    gsub(pattern = '.$', replacement = '')
  return(pAccNo) 
}

#'@databases: NCBI have a viral genomes database that can be retrieved 
#' from this link https://www.ncbi.nlm.nih.gov/genomes/, double check 
#' that the link works
link = "https://www.ncbi.nlm.nih.gov/genomes/GenomesGroup.cgi?taxid=10239&cmd=download2"
download.file(link, "virDB.csv")
#' Load the table downloaded from NCBI, skip two raws to begin with the table format
virDB <- read.csv("virDB.csv", sep = "\t", header = F, skip = 2) |>
  as_tibble()
#' add names to the table now as_tible()
colnames(virDB) <- c("Representative", "Neighbor", "Host", "Selected_lineage", "Taxonomy_name", "Segment_name")
#'@details The database has 20 host (2022), and you can select any
#' I am using host of agricultural interest, but you can expand as you wish
host <- c("plants", "land plants", "invertebrates,land plants", "invertebrates", "fungi")
#' sub-setting based on your selection
#' passing through BASH
k <- commandArgs(TRUE)
k=as.numeric(k)

print(paste("Option", k, "::", host[k]))
#' selecting host
virDBs <-  virDB[which(virDB$Host == host[k]),]
#' formatting taxa and adding names
taxon <- do.call(rbind.data.frame,
                 strsplit(virDBs$Selected_lineage, ","))
colnames(taxon) <-  c("Family", "Genera", "Species")
#' adding colums with taxa
virDB <- cbind(virDBs, taxon) |>
  as_tibble()
#' selecting Acc. Nos.
AccNo <- virDB$Neighbor

#'@description: Using rentrez to retrieve genebank (gb) Acc. Nos.
#'The information will be retrieved as fasta format to generate the
#'viral nucleotide database and from the gb file will also retrieve 
#'the protein Acc. Nos, for the protein database.
#'@note: Get a ENTREZ_KEY from GeneBank, you need to create an account
#'and generate a key - this will make your NCBI rentrez experience better
key="NA"
paccno = list()
#'for loop to fetch Acc. Nos, and generate a fasta file 
for (i in seq_along(AccNo)){
  print(paste0("Fetching Nucleotides::", " ", AccNo[i]))
  Sys.sleep(1)
  gb <- entrez_fetch(db="nuccore", id=AccNo[i], rettype = 'gb')
  rec <- entrez_fetch(db="nuccore", id=AccNo[i], rettype = 'fasta')
<<<<<<< HEAD:R/virDB.001.R
  fasn <- capture.output(cat(substr(rec, 1, nchar(rec)-2), sep = "\r\n"))
  write.fasta(sequences = as.list(fasn), names = NULL, open = "a", 
=======
  fasn <- capture.output(cat(substr(rec, 1, nchar(rec)-2), sep = "\n"))
  write.fasta(sequences = fasn, names = NULL, open = "a", 
>>>>>>> ae8044262a2d20a77cf5b4a6eb77ca4081d04562:R/virDB.000.R
              file.out = paste0(gsub(" ","",host[k]),"_", format(Sys.time(), "%m%y"),"_virDB.fna"))
  paccno <- protDB_ret(gb)
  pAccNo = unlist(paccno)
  for (j in seq_along(pAccNo)){
    print(paste0("Fetching Proteins::", " ", pAccNo[j]))
    Sys.sleep(5)
<<<<<<< HEAD:R/virDB.001.R
    prec <- entrez_fetch(db="protein", id=pAccNo[j], rettype = 'fasta', api_key=ENTREZ_KEY)
    fasa <- capture.output(cat(substr(prec, 1, nchar(prec)-2), sep = "\r\n"))
    write.fasta(sequences = as.list(fasa), names = NULL, open = "a", 
=======
    prec <- entrez_fetch(db="protein", id=pAccNo[j], rettype = 'fasta')
    fasa <- capture.output(cat(substr(prec, 1, nchar(prec)-2), sep = "\n"))
    write.fasta(sequences = fasa, names = NULL, open = "a", 
>>>>>>> ae8044262a2d20a77cf5b4a6eb77ca4081d04562:R/virDB.000.R
                file.out = paste0(gsub(" ","",host[k]),"_",format(Sys.time(), "%m%y"),"_virDB.faa"))
  }
}
print("GeneBank Metadata Recorded")

system("sed -i '/^>$/d' *_virDB.fna")
system("sed -i '/^>$/d' *_virDB.faa")

print(paste("Done::", Sys.time()))


