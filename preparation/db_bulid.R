setwd("/ssd/zhanghao/ID_converter/Latest_Data")
library(DBI)
library(stringr)
##### database building #####
for (species in c("mouse","human")) {
  latest_files<- list.files("./")
  db_file<- latest_files[which(str_detect(string = latest_files,pattern = paste0("^",species,"\\.db\\..*\\.rds")))]
  df <- readRDS(paste0("./",db_file))
  mydb <- dbConnect(RSQLite::SQLite(), paste0(species,".db.sqlite"))
  dbWriteTable(mydb, "id_table", df)
  fields <- dbListFields(mydb,name = "id_table")
  
  for(field in fields){
    dbSendQuery(mydb, paste("CREATE INDEX IF NOT EXISTS",field,"ON id_table(",field,")",sep = " "))
  }
  dbDisconnect(mydb)
}

##### enrichment annotation #####
options(RCurlOptions=list(timeout=1000000))
library(rWikiPathways)
library(qusage)
library(dplyr)
library(data.table)
library(GO.db)
library(org.Hs.eg.db)
library(org.Mm.eg.db)
library(MeSH.db)
library(MeSH.Hsa.eg.db)
library(MeSH.Mmu.eg.db)
library(KEGGREST)
library(reactome.db)
library(PFAM.db)
rm(list = ls())
enrichdb <- list()
for(species in c("human","mouse")){
  orgdb <- switch(species,"human"=org.Hs.eg.db,"mouse"=org.Mm.eg.db)
  meshdb <- switch(species,"human"=MeSH.Hsa.eg.db,"mouse"=MeSH.Mmu.eg.db)
  keggdb <- switch(species,"human"="hsa","mouse"="mmu")
  wikidb <- switch(species,"human"="Homo sapiens","mouse"="Mus musculus")
  reactomedb <- switch(species,"human"="Homo sapiens","mouse"="Mus musculus")
  ##### GO #####
  bg<-AnnotationDbi::select(orgdb, keys=keys(orgdb), columns = c("GOALL"))
  bg$EVIDENCEALL <- NULL
  bg<- unique(bg[!is.na(bg$GOALL),])
  bg2<-AnnotationDbi::select(GO.db, keys=keys(GO.db), columns = c("GOID","TERM","DEFINITION"))
  bg<- merge(x = bg,by.x="GOALL",y=bg2,by.y="GOID",all.x=T)
  assign(paste0(species,"_bp2gene"), bg[which(bg$ONTOLOGYALL=="BP"),c(1,2)])
  assign(paste0(species,"_bp2name"), bg[which(bg$ONTOLOGYALL=="BP"),c(1,4)])
  assign(paste0(species,"_cc2gene"), bg[which(bg$ONTOLOGYALL=="CC"),c(1,2)])
  assign(paste0(species,"_cc2name"), bg[which(bg$ONTOLOGYALL=="CC"),c(1,4)])
  assign(paste0(species,"_mf2gene"), bg[which(bg$ONTOLOGYALL=="MF"),c(1,2)])
  assign(paste0(species,"_mf2name"), bg[which(bg$ONTOLOGYALL=="MF"),c(1,4)])
  
  ##### KEGG(latest) #####
  listDatabases()
  bg_pathway<- keggList(database = "pathway",organism = keggdb)
  bg_module <- keggList(database = "module",organism = keggdb)
  bg <- c(bg_pathway,bg_module)
  path <- list()
  for (i in 1:length(bg)) {
    pathwayid <- names(bg)[i]
    if (!pathwayid %in% names(path)) {
      cat("\nDownload KEGG Query ",i," from ",length(bg)," ","pathwayid: ",pathwayid,"\n")
      gene <-  sapply(keggGet(pathwayid), "[[", "GENE")
      if (!is.null(gene[[1]])) {
        path[[pathwayid]]<-cbind(pathwayid,
                                 bg[pathwayid],
                                 gene[c(TRUE, FALSE),]) %>% as.data.frame(stringsAsFactors =F)
      }
    }
  }
  bg <- rbindlist(path)
  # bg <-  bg[which(bg$V3 %in% keys(orgdb)),]
  bg$V2 <- gsub(pattern = " - .*$","",bg$V2,perl = T)
  assign(paste0(species,"_kegg2gene"), bg[,c(1,3)])
  assign(paste0(species,"_kegg2name"), bg[,c(1,2)])
  
  ##### WikiPathway #####
  downloadPathwayArchive(organism=wikidb, format="gmt",date = "current")
  wikidb <- gsub(x = wikidb,pattern = " ",replacement = "_")
  wiki_gmt<- read.gmt(list.files("./")[which(list.files("./") %like% paste0(".*",wikidb,".gmt"))])
  file.remove(list.files("./")[which(list.files("./") %like% paste0(".*",wikidb,".gmt"))])
  wiki_gmt<- lapply(names(wiki_gmt),function(x){
    wikiid <- str_split(x,pattern = "%")[[1]][3]
    wikiterm <- str_split(x,pattern = "%")[[1]][1]
    gmt <- wiki_gmt[[x]]
    data.frame(v0=wikiid,v1=gmt,v2=wikiterm,stringsAsFactors = F)})
  bg<- rbindlist(wiki_gmt)
  assign(paste0(species,"_wiki2gene"), bg[,c(1,2)])
  assign(paste0(species,"_wiki2name"), bg[,c(1,3)])
  
  ##### reactome #####
  bg<-AnnotationDbi::select(reactome.db, keys=keys(reactome.db), columns = c("PATHID","PATHNAME"))
  bg <- bg[str_detect(bg$PATHNAME,pattern=reactomedb),]
  bg<- na.omit(bg)
  bg$PATHNAME<- gsub(x = bg$PATHNAME,pattern = paste0("^",reactomedb,": "),replacement = "",perl = T)
  assign(paste0(species,"_reactome2gene"), bg[,c(2,1)])
  assign(paste0(species,"_reactome2name"), bg[,c(2,3)])
  
  ##### PFAM #####
  bg<-AnnotationDbi::select(orgdb, keys=keys(orgdb), columns = "PFAM")
  bg<-unique(bg[!is.na(bg$PFAM),])
  bg2<- as.data.frame(PFAMDE2AC[mappedkeys(PFAMDE2AC)])
  rownames(bg2) <- bg2[["ac"]]
  bg[["PFAM_name"]]<- bg2[bg$PFAM,"de"]
  bg[which(is.na(bg[["PFAM_name"]])),"PFAM_name"] <-  bg[which(is.na(bg[["PFAM_name"]])),"PFAM"]
  assign(paste0(species,"_pfam2gene"), bg[,c(2,1)])
  assign(paste0(species,"_pfam2name"), bg[,c(2,3)])
  
  ##### Chromosomes #####
  bg<-AnnotationDbi::select(orgdb, keys=keys(orgdb), columns = c("CHR"))
  bg<-unique(bg[!is.na(bg$CHR),])
  bg[,2] <- paste0("chr", bg[,2])
  assign(paste0(species,"_chr2gene"), bg[,c(2,1)])
  assign(paste0(species,"_chr2name"), bg[,c(2,2)])
  
  ##### MeSH #####
  ### A (Anatomy);B (Organisms);C (Diseases);D (Chemicals and Drugs);
  ### E (Analytical Diagnostic and Therapeutic Techniques and Equipment);F (Psychiatry and Psychology);
  ### G (Phenomena and Processes);H (Disciplines and Occupations);
  ### I (Anthropology, Education, Sociology and Social Phenomena);J (Technology and Food and Beverages);
  ### K (Humanities);L (Information Science);M (Persons);N (Health Care);
  ### V (Publication Type);Z (Geographical Locations)
  
  bg<-AnnotationDbi::select(meshdb, keys=keys(meshdb,keytype = "GENEID"),keytype = "GENEID",columns = c("GENEID","MESHID","MESHCATEGORY"))
  # bg <-  bg[which(bg$GENEID %in% keys(orgdb)),]
  # bg_all <- AnnotationDbi::select(MeSH.db, keys=keys(MeSH.db,keytype = "MESHID"),columns = c("MESHID","MESHTERM"),keytype = "MESHID")
  # saveRDS(bg_all,"./MeSHID2Term.rds")
  bg_all <- readRDS("./MeSHID2Term.rds")
  bg <- merge(x = bg,by.x="MESHID",y=bg_all,by.y="MESHID",all.x=T)
  bg[which(is.na(bg$MESHTERM)),"MESHTERM"] <- bg[which(is.na(bg$MESHTERM)),"MESHID"]
  assign(paste0(species,"_meshall"), bg)
  
  ##### Protein complex #####
  temp <- tempfile()
  download.file("http://mips.helmholtz-muenchen.de/corum/download/coreComplexes.txt.zip",temp)
  data <- read.table(unz(temp, "coreComplexes.txt"),header = T,sep="\t",stringsAsFactors = F,fill = T,quote = "")
  unlink(temp)
  
  data <- data[which(data$Organism==Hmisc::capitalize(species)),]
  s <- strsplit(data$subunits.Entrez.IDs., split = ";")
  procomp<- data.frame(V1 = rep(data$ComplexName, sapply(s, length)), V2 = unlist(s),V3=rep(paste0("ComplexID:",data$ComplexID), sapply(s, length)))
  # procomp$V1 <- trimws(procomp$V1) %>% gsub(pattern = "\\([^\\)]*\\)$", replacement = "", perl = FALSE)
  procomp<- procomp[!duplicated(procomp),]
  procomp <- procomp[which(procomp$V2!="None"),]
  assign(paste0(species,"_proteincomplex2gene"), procomp[,c(3,2)])
  assign(paste0(species,"_proteincomplex2name"), procomp[,c(3,1)])
  bg <- NULL
  
}


for (ont in c("BP","CC","MF")) {
  for (species in  c("human","mouse")) {
    orgdb <- switch(species,"human"=org.Hs.eg.db,"mouse"=org.Mm.eg.db)
    simData<- GOSemSim::godata(orgdb, ont=ont)
    assign(paste0(species,"_",ont,"_simData"), simData)
  }
}

##### save data #####
allvec<- ls()
rm(list=allvec[!str_detect(allvec,pattern = "(human)|(mouse)")])
if (file.exists("./enrichdb.Rdata")==T) {
  file.remove("./enrichdb.Rdata",showWarnings=F)
}
secondUniprot <- read.table("./sec_ac.txt",header = T,sep = "\t",stringsAsFactors = F)
secondUniprot[[1]] <- gsub(pattern = "\\s+", replacement = " ", x = str_trim(secondUniprot[[1]]))
secondUniprot <- data.frame(do.call('rbind', strsplit(as.character(secondUniprot[[1]]),' ',fixed=TRUE)),stringsAsFactors = F)
save.image(file = "./enrichdb.Rdata",compress = F)


