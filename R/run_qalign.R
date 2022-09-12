#############################################################################
#2. RUN THE ANALYSIS # Alignmnet and counting
#############################################################################
library(QuasR)
run_qAlign <- function(corenum, endness, sampleFile, genomeFile,geneAnnotation){
  cl2 <- makeCluster(corenum)
  print("Alignment is running")
  if (endness=="PE"){
    aligned_proj <- QuasR::qAlign(sampleFile,paired ="fr", clObj=cl2, alignmentsDir =aligned_bam , 
                                  genome=genomeFile, geneAnnotation=geneAnnotation, splicedAlignment =TRUE, aligner ="Rhisat2" )
  } else {

    aligned_proj <- QuasR::qAlign(sampleFile,paired ="no", clObj=cl2, alignmentsDir =aligned_bam ,  
                                  genome=genomeFile,geneAnnotation=geneAnnotation, splicedAlignment =TRUE, aligner ="Rhisat2" )
    }
  saveRDS(aligned_proj, file.path(aligned_bam , "alltrimmedalignedobj.RDS"))
  stopCluster(cl2)
  return(aligned_proj)
}
