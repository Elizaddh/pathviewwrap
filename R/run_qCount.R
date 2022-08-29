##
#for mapping
##move this chunck to up where u have processed annotation and genome file##
library(Rsamtools) #scanFaIndex
library(GenomicFeatures)
library(parallel)

run_qCount <- function(genomeFile, geneAnnotation, aligned_proj,corenum, result.dir){
  txdb <- try(loadDb(geneAnnotation), silent = T)
  cl2 <- makeCluster(corenum)
  if (class(txdb)==  "TxDb"){
    if(!grepl("chr", seqlevels(txdb)[1])){ #check if this is necessary
      newSeqNames <- paste('Chr', seqlevels(txdb), sep = '')
      names(newSeqNames) <- seqlevels(txdb)
      txdb <- renameSeqlevels( txdb, newSeqNames )
      seqlevels(txdb)
    }
  }else{
    library(GenomicFeatures)

    chrLen <- scanFaIndex(genomeFile)
    chrominfo <- data.frame(chrom = as.character(seqnames(chrLen)),
                            length = width(chrLen),
                            is_circular = rep(FALSE, length(chrLen)))
    txdb <- makeTxDbFromGFF(file = geneAnnotation, format = "gtf",
                            chrominfo = chrominfo,
                            dataSource = "Ensembl",
                            organism = entity)
  }
  geneLevels <- qCount(aligned_proj, txdb, reportLevel ="gene", clObj=cl2)
  saveRDS(geneLevels, file.path(result.dir, "combinedcount.trimmed.RDS"))
  return(geneLevels)
}
