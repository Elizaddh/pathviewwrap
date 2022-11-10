#run fastp
#run fastp
run_fastp <-function(samplename){
  
  if (seq_tech == "PacBio" | seq_tech == "Nanopore" ){

  if (endness=="PE"){

    cmd <- paste0("fastp -i " ,file.path(fq.dir , "samplename_to_sed_1.fastq") , " -I ",  file.path(fq.dir , "samplename_to_sed_2.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired_1.fastq"), " -O ", file.path(trim.dir , "samplename_to_sed_paired_2.fastq"),  "--adapter_fasta", "data/adapters.fna", "-h samplename_to_sed.html", "-j samplename_to_sed.json")

  } else {
    cmd <- paste0("fastp -i ", file.path(fq.dir , "samplename_to_sed.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired.fastq"), " --adapter_fasta ", "data/adapters.fna", " -h samplename_to_sed.html", "-j samplename_to_sed.json")


  }
    } else {
    if (endness=="PE"){

    cmd <- paste0("fastp -i " ,file.path(fq.dir , "samplename_to_sed_1.fastq") , " -I ",  file.path(fq.dir , "samplename_to_sed_2.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired_1.fastq"), " -O ", file.path(trim.dir , "samplename_to_sed_paired_2.fastq"),   "-h samplename_to_sed.html", "-j samplename_to_sed.json")

  } else {
    cmd <- paste0("fastp -i ", file.path(fq.dir , "samplename_to_sed.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired.fastq"), " -h samplename_to_sed.html", "-j samplename_to_sed.json")

}
    }
    
    
    
    
  cmd <- stringr::str_replace_all(cmd, "samplename_to_sed", samplename)
  print(cmd)
  system(cmd)
    
}



# run_fastp <-function(samplename){
# library(Rfastp)
#   print(samplename)
#   print("this is endness")
#   print(endness)
#
# #   if (endness=="PE"){
# #
# #     cmd <- paste0("fastp -i " ,file.path(fq.dir , "samplename_to_sed_1.fastq") , " -I ",  file.path(fq.dir , "samplename_to_sed_2.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired_1.fastq"), " -O ",
# #                   file.path(trim.dir , "samplename_to_sed_paired_2.fastq"))
# #
# #   } else {
# #     cmd <- paste0("fastp -i ", file.path(fq.dir , "samplename_to_sed.fastq"), " -o ",  file.path(trim.dir , "samplename_to_sed_paired.fastq"))
# #
# #   }
# #   cmd <- stringr::str_replace_all(cmd, "samplename_to_sed", samplename)
# #   print(cmd)
# #   system(cmd)
# # }
#
#
# if (endness == "PE"){
#   read2  = "samplename_to_sed_paired_2.fastq"
#   read2 = stringr::str_replace_all(read2,"samplename_to_sed", samplename)
# }
#
# if (endness== "SE"){
#   read2 = ""
# }
#   print(file.exists( paste0(samplename, "1.fastq")))
# rfastp("sample1.fastq", read2 = "", outputFastq = "sample1outfastq", merge = FALSE, adapterFasta= "adapters.fasta")
#
# #rfastp(read1 = paste0(samplename, "1.fastq"), read2 = read2 , merge = FALSE, outputFastq = paste0(samplename),"samplename_to_sed_paired.fastq")
#
# }
