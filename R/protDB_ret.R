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
  protID <- gbf[grep("coded_by", gbf, value = F,)]
  pAccNo <- gsub(pattern = '                     /coded_by=\"', replacement =  '', protID) |>
            gsub(pattern = '\\..*[0-9]', replacement = '')|>
            gsub(pattern = '\\\"', replacement = '')
  pAccNo
  return(pAccNo) 
}

#' passing through BASH
x <- commandArgs(TRUE)
print(x)
#x = "test_blastx.reference.txt"
file <- strsplit(x, "\\." )[[1]][1]
xAccNo<- read.csv(x, header = F)

for (j in 1:nrow(xAccNo)){
  gb <- entrez_fetch(db="protein", id=xAccNo[j,], rettype = 'gb')
  paccno <- protDB_ret(gb)
  print(paste0("Fetching Proteins::", " ", paccno))
  Sys.sleep(1)
  # prec <- entrez_fetch(db="protein", id=pAccNo[j], rettype = 'fasta', api_key=ENTREZ_KEY)
  prec <- entrez_fetch(db="nucleotide", id=paccno, rettype = 'fasta')
  fasx <- capture.output(cat(substr(prec, 1, nchar(prec)-2), sep = "\r\n"))
  write.fasta(sequences = as.list(fasx), names = NULL, open = "a", 
              file.out = paste0(file,".fasta"))
}

Sys.info()[1] == "Darwin"
system("sed -i '' -e '/^>$/d' *.fasta")
