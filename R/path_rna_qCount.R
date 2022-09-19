##
#for mapping
##move this chunck to up where u have processed annotation and genome file##
library(Rsamtools) #scanFaIndex
library(GenomicFeatures)
library(parallel)

run_qCount <- function(genomeFile, geneAnnotation, aligned_proj,corenum, result.dir, txdb){
  cl2 <- makeCluster(corenum)
  geneLevels <- qCount(aligned_proj, txdb, reportLevel ="gene", clObj=cl2)
  saveRDS(geneLevels, file.path(result.dir, "combinedcount.trimmed.RDS"))
  return(geneLevels)
}
