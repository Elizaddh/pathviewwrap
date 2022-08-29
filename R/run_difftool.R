library(DESeq2)
library(edgeR)
#setwd("/scratch/edhungel/Rsubread/script")
run_difftool <- function(diff.tool, result.dir,grp.idx, geneLevels, entity, deseq2.dir){ #make sure correct dir is chosen
#geneData_my <- as.data.frame(readRDS(file.path(result.dir, "combinedcount.trimmed.RDS"))) #TO DO maybe I can just use geneLevels variable
geneData_my <- geneLevels
library(gage)
library(pathview)
cnts <- geneData_my[,-1]
kegg.gs.species <- kegg.gsets(entity)
orgcode<- kegg.species.code(entity)
data(bods)
#if(!all(rownames(cnts)%in% unlist(unname(kegg.gs.species$kg.sets)))){ #check if the use of "all" is appropriate
if(sum(rownames(cnts)%in% unlist(unname(kegg.gs.species$kg.sets)) ) < 10){
  rownames(cnts)<- str_remove(rownames(cnts),"\\.[0-9]+$" )
  cnts<- mol.sum(cnts, id.map = "ENSEMBL", gene.annotpkg =bods[ which(bods[,3]==orgcode)]) #converting to entrez # what if gene id is not ensembl and what if arabidopsis thaliana id.map might be ath or else thing
}

#ref <- which(grp.idx == "reference")
#samp <- which(grp.idx == "samples")
#grp.idx[ref] <- "reference"
#grp.idx[samp] <- "sample"

if(diff.tool == "DESEQ2"){
  coldat=DataFrame(grp=factor(grp.idx))
  dds <- DESeqDataSetFromMatrix(cnts, colData=coldat, design =~ grp)
  dds <- DESeq(dds)
  deseq2.res <- results(dds)
  #direction of fc, depends on levels(coldat$grp), the first level
  #taken as reference (or control) and the second one as experiment.
  deseq2.fc=deseq2.res$log2FoldChange
  names(deseq2.fc)=rownames(deseq2.res)
  exp.fc=deseq2.fc
  table(is.na(deseq2.res$padj))
  write.table(deseq2.res , file.path(deseq2.dir, "DESEQ2_logfoldchange.txt"), col.names =TRUE, row.names =TRUE, quote =FALSE)
  tiff(file.path(deseq2.dir, "Volcano_deseq2.tiff"), units="in", width=15, height=15, res=300)
  plot(EnhancedVolcano::EnhancedVolcano(deseq2.res, x ='log2FoldChange', y ='pvalue', lab =rownames(deseq2.res)))
  dev.off()
}
if(diff.tool=="edgeR"){
  ###########################################################################################################################################
  library(edgeR)
  dgel <- edgeR::DGEList(counts=cnts, group=factor(grp.idx))
  dgel <- edgeR::calcNormFactors(dgel)
  dgel <- edgeR::estimateCommonDisp(dgel)
  dgel <- edgeR::estimateTagwiseDisp(dgel)
  et <- edgeR::exactTest(dgel)
  edger.fc=et$table$logFC
  names(edger.fc)=rownames(et$table)
  exp.fc=edger.fc
  write.table(et , file.path(edger.dir, "EDGER_logfoldchange.txt"), col.names =TRUE, row.names =TRUE, quote =FALSE)
  tiff(file.path(edger.dir, "edgeR_Volcano_edgeR.tiff"), units="in", width=15, height=15, res=300)
  plot(EnhancedVolcano::EnhancedVolcano(et$table, x ='logFC', y="PValue", lab=rownames(et$table)))
  dev.off()
}
######
#include bayseq

 return(c(exp.fc, cnts))
}
