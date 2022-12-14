#RUN GAGE

run_pathway <- function(entity, exp.fc, compare, gage.dir, cnts, grp.idx){
  library(gage)
  ref <- which(grp.idx == "reference")
  samp <- which(grp.idx == "sample")

  kegg.gs<- kegg.gsets(entity)
  head(cnts)
  
  run_gset_analysis <- function(gsets, work.dir, same.dir , compare){
    setwd(work.dir)
    print("working in ")
    print(  work.dir)

    fc.kegg.p <- gage(exp.fc, gsets = gsets, ref = NULL, samp = NULL, same.dir = same.dir, compare = compare)
    sel <- fc.kegg.p$greater[, "q.val"] < 0.1 & !is.na(fc.kegg.p$greater[, "q.val"])
    path.ids <- rownames(fc.kegg.p$greater)[sel]
    anla_type <- "KEGG"
    if (same.dir == T){
      anla_type = "GO"
      sel.l <- fc.kegg.p$less[, "q.val"] < 0.1 & !is.na(fc.kegg.p$less[,"q.val"])
      path.ids.l <- rownames(fc.kegg.p$less)[sel.l]
      write.table(fc.kegg.p$less, file = file.path(work.dir , paste0("fc.", anla_type, ".p.less.txt")), sep = "\t")
      path.ids <- c(path.ids[1:3], path.ids.l[1:3])

    }

    path.ids <- substr(path.ids, 1, 8)
    #path.ids <- gsub("[^0-9.-]", "", sapply(stringr::str_split(path.ids, " ", 2),"[[",1))
    write.table(fc.kegg.p$greater, file = file.path(work.dir , paste0("fc.", anla_type, "p.greater.txt")), sep = "\t")
    #visualize top 3 pathways
    #run pathview only for KEGG pathways
    if (same.dir==F){
      pv.out.list <- sapply(na.omit(path.ids[1:6]), function(pid) pathview( gene.data = exp.fc, pathway.id = pid, species = entity, out.suffix=diff.tool))
    }
    kegg.sig<-sigGeneSet(fc.kegg.p, outname=paste0(entity,anla_type, ".sig",basename(work.dir)), pdf.size=c(17,17), heatmap = F)#wont give heatmap for fold change used in gage
    write.table(kegg.sig$greater, file = file.path(gage.dir , paste0(anla_type, ".sig.txt")), sep = "\t")
    }

  #TO DO try using lapply for all function call of kegg pathways
  run_gset_analysis(kegg.gs$kg.sets[kegg.gs$sigmet.idx],sig_n_met,same.dir = F, compare=compare )
  run_gset_analysis(kegg.gs$kg.sets[kegg.gs$dise.idx], disease, same.dir = F, compare=compare)
  run_gset_analysis(kegg.gs$kg.sets[kegg.gs$sig.idx], signalling, same.dir = F, compare=compare)
  run_gset_analysis(kegg.gs$kg.sets[kegg.gs$met.idx], metabolism, same.dir = F,compare=compare)
  ############################################################################################

  common_name_species <- korg[korg[,4]==entity][5]
  go.gs <- go.gsets(common_name_species)
  go.bp<- go.gs$go.sets[go.gs$go.subs$BP]
  go.mf<-go.gs$go.sets[go.gs$go.subs$MF]
  go.cc<- go.gs$go.sets[go.gs$go.subs$CC]


  run_gset_analysis(go.bp,biological_process,same.dir = T, compare=compare )
  run_gset_analysis(go.mf,molecular_function, same.dir = T, compare=compare)
  run_gset_analysis(go.cc, cellular_component, same.dir = T, compare=compare)
}

