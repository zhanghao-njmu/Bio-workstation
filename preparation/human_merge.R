maindir="/data/tmp/ID_converter/latest_Data/"
setwd(maindir)
library(tidyr)
library(plyr); library(dplyr) 
library(stringr)
library(data.table)
library(AnnotationDbi)
# args <- commandArgs(trailingOnly = TRUE )
# files <- args

##===== HGNC =====
files <- paste0(maindir,"/",c("human_HGNC_curated_latest.tab",
                              "human_HGNC_external_latest.tab"))
dl<- sapply(1:length(files), function(x){
  file <- files[x]
  no_col <- max(count.fields(file, sep = "\t"),na.rm = T)
  read.table(file = file,header = F,sep = "\t",stringsAsFactors = F,col.names=paste0(rep(paste0("f",x,"-"),no_col),1:no_col),quote = "",fill = T)
})
colnames(dl[[1]]) <- c("Gene_Symbol","Gene_name","ENTREZID","ENSEMBL_gene","Nucleotide_rna_Accession")
colnames(dl[[2]]) <- c("UniprotID","ENTREZID","ENSEMBL_gene","Nucleotide_rna_Accession")
merge_file <- rbind.fill(dl[[1]],dl[[2]])
merge_file <- merge_file[,c("Gene_Symbol","Gene_name","UniprotID","ENTREZID","ENSEMBL_gene")]
merge_file<- merge_file[!is.na(merge_file$ENTREZID),] %>%
  group_by(ENTREZID) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name, .direction = "up") %>% as.data.frame()%>%rbind(merge_file[is.na(merge_file$ENTREZID),])
merge_file<- merge_file[!is.na(merge_file$ENSEMBL_gene),] %>%
  group_by(ENSEMBL_gene) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name, .direction = "up") %>% as.data.frame()%>%rbind(merge_file[is.na(merge_file$ENSEMBL_gene),])
merge_file<- merge_file[!is.na(merge_file$UniprotID),] %>%
  group_by(UniprotID) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name, .direction = "up") %>% as.data.frame()%>%rbind(merge_file[is.na(merge_file$UniprotID),])
merge_file<- merge_file[!is.na(merge_file$Gene_Symbol),] %>%
  group_by(Gene_Symbol) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name) %>%
  fill(ENTREZID,ENSEMBL_gene,Gene_Symbol,Gene_name, .direction = "up") %>% as.data.frame()%>%rbind(merge_file[is.na(merge_file$Gene_Symbol),])
hgnc_map <- merge_file

##===== NCBI =====
files <- paste0(maindir,"/",c("human_ncbi.gene_info.tab",
                              "human_ncbi.gene2accession.tab",
                              "human_ncbi.gene2ensembl.tab",
                              "gene_refseq_uniprotkb_collab"))
dl<- sapply(1:length(files), function(x){
  file <- files[x]
  no_col <- max(count.fields(file, sep = "\t"),na.rm = T)
  read.table(file = file,header = F,sep = "\t",stringsAsFactors = F,col.names=paste0(rep(paste0("f",x,"-"),no_col),1:no_col),quote = "",fill = T)
})
dl[[1]][,1] <- NULL;dl[[2]][,1] <- NULL;dl[[3]][,1] <- NULL
merge_file<- Reduce(function(x, y) merge(x, y, by=1, all=TRUE), dl[1:3])
merge_file <- merge_file[,c("f1.3","f1.9","f1.10","f1.7","f1.2",
                            "f2.4","f2.5","f2.6","f2.7",
                            "f3.3")]
merge_file[,c("f2.4","f2.6")] <- lapply(merge_file[,c("f2.4","f2.6")], function(x) as.character(gsub("\\..*", "", x,perl = T)))
dl[[3]][,c("f3.4","f3.5","f3.6","f3.7")] <- lapply(dl[[3]][,c("f3.4","f3.5","f3.6","f3.7")], function(x) as.character(gsub("\\..*", "", x,perl = T)))
ifelse(sum(duplicated(dl[[3]][,"f3.4"]))==0,"Could be key column","Need to choose annother column as key")
merge_file <- merge(x = merge_file,by.x = "f2.4",y = dl[[3]][,c("f3.4","f3.5","f3.6","f3.7")],by.y = "f3.4",all.x = T)
merge_file <- merge_file[,c("f1.3","f1.9","f1.10","f1.7","f1.2",
                            "f2.4","f2.5","f2.6","f2.7",
                            "f3.3","f3.5","f3.7")]
merge_file$f1.10 <- gsub(pattern = "(unknown)|(other)|(biological-region)",replacement = "",x = merge_file$f1.10)
merge_file$f1.10 <- gsub(pattern = "pseudo",replacement = "pseudogene",x = merge_file$f1.10)
merge_file$f1.10[merge_file$f1.10==""] <- NA

ncbi_map<- merge_file
ncbi_map[ncbi_map=="-"] <- NA
ncbi_map<- unique(ncbi_map)
colnames(ncbi_map) <- c("Gene_Symbol","Gene_name","Gene_type","Chrom","ENTREZID",
                        "Nucleotide_rna_Accession","Nucleotide_rna_GI","Nucleotide_protein_Accession","Nucleotide_protein_GI",
                        "ENSEMBL_gene","ENSEMBL_rna","ENSEMBL_protein")

refseq_uniprotkb <- dl[[4]];colnames(refseq_uniprotkb) <- c("Nucleotide_protein_Accession","UniprotID")
ncbi_map<- merge(x = ncbi_map,by.x = "Nucleotide_protein_Accession",all.x = T,
                 y = refseq_uniprotkb,by.y = "Nucleotide_protein_Accession",all.y = F)

##===== ENSEMBL =====
library(biomaRt)
listMarts()
ensembl_datasets<-listDatasets(useMart("ensembl"))
ensembl_species<-useMart(biomart = "ensembl",dataset = "hsapiens_gene_ensembl")
ensembl_species_attributes<-listAttributes(ensembl_species)
ensembl_base <- getBM(mart = ensembl_species,
                      attributes = c("ensembl_gene_id","ensembl_transcript_id","ensembl_peptide_id",
                                     "external_gene_name","description","gene_biotype","chromosome_name","entrezgene"))
ensembl_external_1_1 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_mrna","uniprotswissprot","uniprotsptrembl"))
ensembl_external_1_2 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_ncrna","uniprotswissprot","uniprotsptrembl"))
ensembl_external_1_3 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_mrna_predicted","uniprotswissprot","uniprotsptrembl"))
ensembl_external_1_4 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_ncrna_predicted","uniprotswissprot","uniprotsptrembl"))
ensembl_external_1_5 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_peptide","uniprotswissprot","uniprotsptrembl"))
ensembl_external_1_6 <- getBM(mart = ensembl_species,
                              attributes = c("refseq_peptide_predicted","uniprotswissprot","uniprotsptrembl"))
ensembl_external_2 <- getBM(mart = ensembl_species,
                            attributes = c("ensembl_gene_id","ensembl_transcript_id","ensembl_peptide_id",
                                           "refseq_mrna","refseq_ncrna","refseq_peptide"))
ensembl_external_3 <- getBM(mart = ensembl_species,
                            attributes = c("ensembl_gene_id","ensembl_transcript_id","ensembl_peptide_id",
                                           "refseq_mrna_predicted","refseq_ncrna_predicted","refseq_peptide_predicted"))
ensembl_external_4<- getBM(mart = ensembl_species,
                           attributes = c("ensembl_gene_id","ensembl_transcript_id","ensembl_peptide_id","entrezgene",
                                          "uniprotswissprot","uniprotsptrembl"))
colnames(ensembl_external_1_1)[1] <- colnames(ensembl_external_1_2)[1] <- 
  colnames(ensembl_external_1_3)[1] <- colnames(ensembl_external_1_4)[1] <- "Nucleotide_rna_Accession"
colnames(ensembl_external_1_5)[1] <- colnames(ensembl_external_1_6)[1] <- "Nucleotide_protein_Accession"
ensembl_map_1<- rbind.fill(ensembl_external_1_1,ensembl_external_1_2,ensembl_external_1_3,ensembl_external_1_4)
ensembl_map_2<- rbind.fill(ensembl_external_1_5,ensembl_external_1_6)
ensembl_map_1 <- reshape2::melt(data = ensembl_map_1,measure.vars=c("uniprotswissprot","uniprotsptrembl"),value.name = "UniprotID")
ensembl_map_1$variable <- NULL
ensembl_map_2 <- reshape2::melt(data = ensembl_map_2,measure.vars=c("uniprotswissprot","uniprotsptrembl"),value.name = "UniprotID")
ensembl_map_2$variable <- NULL
ensembl_map_1<- ensembl_map_1[-which(ensembl_map_1$Nucleotide_rna_Accession==""),]
ensembl_map_2<- ensembl_map_2[-which(ensembl_map_2$Nucleotide_protein_Accession==""),]

ensembl_external_2 <- reshape2::melt(data = ensembl_external_2,measure.vars=c("refseq_mrna","refseq_ncrna"),value.name = "Nucleotide_rna_Accession")
ensembl_external_2$variable <- NULL
ensembl_external_3 <- reshape2::melt(data = ensembl_external_3,measure.vars=c("refseq_mrna_predicted","refseq_ncrna_predicted"),value.name = "Nucleotide_rna_Accession")
ensembl_external_3$variable <- NULL
ensembl_external_4 <- reshape2::melt(data = ensembl_external_4,measure.vars=c("uniprotswissprot","uniprotsptrembl"),value.name = "UniprotID")
ensembl_external_4$variable <- NULL
colnames(ensembl_external_3)[4] <- colnames(ensembl_external_2)[4] <- "Nucleotide_protein_Accession"
ensembl_map_3<- rbind.fill(ensembl_external_2,ensembl_external_3)

ensembl_map <- merge(x = ensembl_map_3,y = ensembl_base,all=TRUE)
ensembl_map_a <- merge(x = ensembl_map,y = ensembl_map_1,by = c("Nucleotide_rna_Accession"),all=TRUE)
ensembl_map_b <- merge(x = ensembl_map,y = ensembl_map_2,by = c("Nucleotide_protein_Accession"),all=TRUE)
ensembl_map_c <- merge(x = ensembl_map,y = ensembl_external_4,by = c("ensembl_gene_id","ensembl_transcript_id","ensembl_peptide_id","entrezgene"),all=TRUE)
ensembl_map <- rbind.fill(ensembl_map_a,ensembl_map_b,ensembl_map_c)
colnames(ensembl_map) <- c("Nucleotide_rna_Accession","ENSEMBL_gene","ENSEMBL_rna","ENSEMBL_protein",
                           "Nucleotide_protein_Accession","Gene_Symbol","Gene_name","Gene_type","Chrom","ENTREZID","UniprotID")
ensembl_map$Gene_name <- gsub(pattern = "\\[.*\\]",replacement = "",x = ensembl_map$Gene_name,perl = T) %>% trimws()
ensembl_map$Chrom[which(ensembl_map$Chrom%like%"(.*\\..*)|(CHR_.*)")] <- NA
ensembl_map<- unique(ensembl_map)

##===== Uniprot =====
uniprot_file <- paste0(maindir,"/","HUMAN_9606_idmapping_latest.dat")
no_col <- max(count.fields(uniprot_file, sep = "\t"),na.rm = T)
uniprot <- read.table(file = uniprot_file,header = F,sep = "\t",stringsAsFactors = F,col.names=1:no_col,quote = "",fill = T)
uniprot <- uniprot[which(uniprot$X2%in%c("Gene_Name","GeneID","RefSeq","RefSeq_NT","Ensembl","Ensembl_TRS","Ensembl_PRO")),]
uniprot_map <- data.frame(Gene_Symbol=ifelse(uniprot$X2=="Gene_Name",uniprot$X3,NA),
                          UniprotID_iso=uniprot$X1,
                          ENTREZID=ifelse(uniprot$X2=="GeneID",uniprot$X3,NA),
                          Nucleotide_protein_Accession=ifelse(uniprot$X2=="RefSeq",uniprot$X3,NA),
                          Nucleotide_rna_Accession=ifelse(uniprot$X2=="RefSeq_NT",uniprot$X3,NA),
                          ENSEMBL_gene=ifelse(uniprot$X2=="Ensembl",uniprot$X3,NA),
                          ENSEMBL_rna=ifelse(uniprot$X2=="Ensembl_TRS",uniprot$X3,NA),
                          ENSEMBL_protein=ifelse(uniprot$X2=="Ensembl_PRO",uniprot$X3,NA))
uniprot_map$UniprotID <- gsub("-.*$","",uniprot_map$UniprotID_iso)
uniprot_map[] <- lapply(uniprot_map, function(x) as.character(gsub("\\..*", "", x,perl = T)))
uniprot_map<- unique(uniprot_map)

##===== bioconductor =====
library(org.Hs.eg.db)
# keytypes(org.Hs.eg.db)
# ### eg.db always has three col:ENTREZID,SYMBOL,GENENAME
# ENTREZID<-keys(org.Hs.eg.db,keytype = "ENTREZID")
# all_IDtypes <- c("SYMBOL","GENENAME","ENTREZID","ENSEMBL","ENSEMBLTRANS","ENSEMBLPROT","UNIPROT","REFSEQ")
# bioc_map<-AnnotationDbi::select(org.Hs.eg.db, keys=ENTREZID, keytype = "ENTREZID",columns =all_IDtypes)
# colnames(bioc_map) <- c("ENTREZID","Gene_Symbol","Gene_name","ENSEMBL_gene","ENSEMBL_rna","ENSEMBL_protein","UniprotID","Nucleotide_rna_Accession")
# bioc_map_pro<- bioc_map[which(str_detect("^.*P_.*",string = bioc_map$Nucleotide_rna_Accession,negate = F)),] %>%unique()
# bioc_map_rna<- bioc_map[which(str_detect("^.*P_.*",string = bioc_map$Nucleotide_rna_Accession,negate = T)),] %>%unique()
# bioc_map<- bioc_map[rowSums(!is.na(bioc_map)) >= 4,]
# colnames(bioc_map_pro)[8] <- "Nucleotide_protein_Accession"
# bioc_map <- rbind.fill(bioc_map_pro,bioc_map_rna)
# saveRDS(bioc_map,paste0(maindir,"/", "bioc_map.human.db.",Sys.Date(),".rds"))
# bioc_map_pro <- bioc_map_rna <- NULL
bioc_map <- readRDS("../bioc_map.human.db.2019-04-06.rds")

##===== merge database =====
dl <- NULL
df <- rbind.fill(hgnc_map,ncbi_map,ensembl_map,uniprot_map)
df[df==""] <- NA
df<- unique(df)
colnames(df)

## Fill the same value for each group in R 
df<- df[!is.na(df$ENTREZID),] %>%
  group_by(ENTREZID) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$ENTREZID),])
df<- df[!is.na(df$ENSEMBL_gene),] %>%
  group_by(ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$ENSEMBL_gene),])
df<- df[!is.na(df$ENSEMBL_rna),] %>%
  group_by(ENSEMBL_rna) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$ENSEMBL_rna),])
df<- df[!is.na(df$ENSEMBL_protein),] %>%
  group_by(ENSEMBL_protein) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$ENSEMBL_protein),])
df<- df[!is.na(df$UniprotID),] %>%
  group_by(UniprotID) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$UniprotID),])
df<- df[!is.na(df$Gene_Symbol),] %>%
  group_by(Gene_Symbol) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$Gene_Symbol),])
df<- df[!is.na(df$Nucleotide_rna_Accession),] %>%
  group_by(Nucleotide_rna_Accession) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$Nucleotide_rna_Accession),])
df<- df[!is.na(df$Nucleotide_protein_Accession),] %>%
  group_by(Nucleotide_protein_Accession) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$Nucleotide_protein_Accession),])
df<- df[!is.na(df$Nucleotide_rna_GI),] %>%
  group_by(Nucleotide_rna_GI) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$Nucleotide_rna_GI),])
df<- df[!is.na(df$Nucleotide_protein_GI),] %>%
  group_by(Nucleotide_protein_GI) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$Nucleotide_protein_GI),])

df$Gene_type <- gsub(pattern = "[_-]",replacement = " ",x = df$Gene_type)
df$Gene_type <- gsub(pattern = " gene",replacement = "",x = df$Gene_type)
df[df==""] <- NA
df<- unique(df)

df <- rbind.fill(df,bioc_map)
df<- df[!is.na(df$ENTREZID),] %>%
  group_by(ENTREZID) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene) %>%
  fill(Gene_Symbol,Gene_name,Gene_type,Chrom,ENTREZID,ENSEMBL_gene, .direction = "up") %>% as.data.frame()%>%rbind(df[is.na(df$ENTREZID),])
df<- unique(df)
saveRDS(df,paste0(maindir,"/", "human.db.",Sys.Date(),".rds"))

##===== mapping =====
# library(data.table)
# key_type <- "UniprotID_iso"
# ids <- c("Q14680-1")
# out_types <- setdiff(colnames(df),key_type)
# df_out<- df[which(df[,key_type]%in%ids),c(key_type,out_types)]
# df_out$key_ID <- df_out[,key_type] %>% unlist()
# DT <- data.table(df_out,key="key_ID")
# DT<- DT[,list( Gene_Symbol=paste(unique(Gene_Symbol), collapse=';'),
#                Gene_name=paste(unique(Gene_name), collapse=';'),
#                Gene_type=paste(unique(Gene_type), collapse=';'),
#                Chrom=paste(unique(Chrom), collapse=';'),
#                ENTREZID=paste(unique(ENTREZID), collapse=';'),
#                UniprotID=paste(unique(UniprotID), collapse=';'),
#                ENSEMBL_gene=paste(unique(ENSEMBL_gene), collapse=';'),
#                ENSEMBL_rna=paste(unique(ENSEMBL_rna), collapse=';'),
#                ENSEMBL_protein=paste(unique(ENSEMBL_protein), collapse=';'),
#                Nucleotide_protein_Accession=paste(unique(Nucleotide_protein_Accession), collapse=';'),
#                Nucleotide_protein_GI=paste(unique(Nucleotide_protein_GI), collapse=';'),
#                Nucleotide_rna_Accession=paste(unique(Nucleotide_rna_Accession), collapse=';'),
#                Nucleotide_rna_GI=paste(unique(Nucleotide_rna_GI), collapse=';')
# ),
# by = key(DT)]
# DT[] <- lapply(DT, function(x) as.character(gsub("(;$)|(^;)|(NA;)|(;NA)", "", x)))


