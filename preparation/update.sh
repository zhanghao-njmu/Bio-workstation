
### uniprot
# #axel -an 10 ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/idmapping.dat.2015_03.gz; gunzip ./idmapping.dat.2015_03.gz
awk '$3~/^.*_HUMAN$/' "../Basic_Data/idmapping.dat.2015_03" >HUMAN_9606_idmapping_2015_03.id
awk '$3~/^.*_MOUSE$/' "../Basic_Data/idmapping.dat.2015_03" >MOUSE_10090_idmapping_2015_03.id
### test  ... is in idmapping.dat.2015_03 but not in HUMAN_9606_idmapping_2015_03.dat
### awk 'FNR==NR { arr[$1]; next }{key=gensub(/-.*/,"",$1);if((key in arr)) print key "\t" $1}' HUMAN_9606_idmapping_2015_03.dat idmapping.dat.2015_03 
awk 'FNR==NR { arr[$1]; next }{key=gensub(/-.*/,"",$1);if((key in arr)) print $0}' HUMAN_9606_idmapping_2015_03.id idmapping.dat.2015_03 >HUMAN_9606_idmapping_2015_03_iso.dat
awk 'FNR==NR { arr[$1]; next }{key=gensub(/-.*/,"",$1);if((key in arr)) print $0}' MOUSE_10090_idmapping_2015_03.id idmapping.dat.2015_03 >MOUSE_10090_idmapping_2015_03_iso.dat
awk 'FNR==NR { arr[$1]; next }{if(($1 in arr)) print $0}' HUMAN_9606_idmapping_2015_03.id idmapping.dat.2015_03 >HUMAN_9606_idmapping_2015_03_main.dat
awk 'FNR==NR { arr[$1]; next }{if(($1 in arr)) print $0}' MOUSE_10090_idmapping_2015_03.id idmapping.dat.2015_03 >MOUSE_10090_idmapping_2015_03_main.dat
cat HUMAN_9606_idmapping_2015_03_main.dat HUMAN_9606_idmapping_2015_03_iso.dat > HUMAN_9606_idmapping_2015_03_full.dat
cat MOUSE_10090_idmapping_2015_03_main.dat MOUSE_10090_idmapping_2015_03_iso.dat > MOUSE_10090_idmapping_2015_03_full.dat
rm -f HUMAN_9606_idmapping_2015_03_main.dat HUMAN_9606_idmapping_2015_03_iso.dat
rm -f MOUSE_10090_idmapping_2015_03_main.dat MOUSE_10090_idmapping_2015_03_iso.dat

### uniparc data... too large
#axel -an 8 ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/uniparc/uniparc_all.xml.gz

#new start
rm -f HUMAN_9606_idmapping.dat.gz ;axel -an 10 ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/by_organism/HUMAN_9606_idmapping.dat.gz; gunzip -f ./HUMAN_9606_idmapping.dat.gz
rm -f MOUSE_10090_idmapping.dat.gz ;axel -an 10 ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/by_organism/MOUSE_10090_idmapping.dat.gz; gunzip -f./MOUSE_10090_idmapping.dat.gz
cat HUMAN_9606_idmapping_2015_03_full.dat HUMAN_9606_idmapping.dat >HUMAN_9606_idmapping_latest.dat
cat MOUSE_10090_idmapping_2015_03_full.dat MOUSE_10090_idmapping.dat >MOUSE_10090_idmapping_latest.dat

###secondary uniprot ac mapping
rm -f sec_ac.txt ; axel -an 10 ftp://ftp.uniprot.org/pub/databases/uniprot/knowledgebase/docs/sec_ac.txt 
sed -i -n -e '/^Secondary AC/,$p' "./sec_ac.txt" 

### NCBI
wget -O Mus_musculus.gene_info.gz ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Mus_musculus.gene_info.gz; gunzip -f ./Mus_musculus.gene_info.gz
wget -O Homo_sapiens.gene_info.gz ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz; gunzip -f ./Homo_sapiens.gene_info.gz
wget -O gene2ensembl.gz ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2ensembl.gz; gunzip -f ./gene2ensembl.gz
wget -O gene2accession.gz ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz; gunzip -f ./gene2accession.gz
wget -O gene_refseq_uniprotkb_collab.gz ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_refseq_uniprotkb_collab.gz; gunzip -f ./gene_refseq_uniprotkb_collab.gz

awk '$1~/^9606$/' "./Homo_sapiens.gene_info" >human_ncbi.gene_info.tab
awk '$1~/^10090$/' "./Mus_musculus.gene_info" >mouse_ncbi.gene_info.tab
awk '$1~/^9606$/' "./gene2ensembl" >human_ncbi.gene2ensembl.tab
awk '$1~/^10090$/' "./gene2ensembl" >mouse_ncbi.gene2ensembl.tab
awk '$1~/^9606$/' "./gene2accession" >human_ncbi.gene2accession.tab
awk '$1~/^10090$/' "./gene2accession" >mouse_ncbi.gene2accession.tab

#cut -f2- Mus_musculus.gene_info > tmpfile; mv -f tmpfile Mus_musculus.gene_info
#cut -f2- Homo_sapiens.gene_info > tmpfile; mv -f tmpfile Homo_sapiens.gene_info


###MGI test:MGI:104524 NCBI£º18687 / MGI:1096399 NCBI£º20955
rm -f MRK_List1.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MRK_List1.rpt
rm -f MRK_List2.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MRK_List2.rpt
sed '1d' MRK_List1.rpt > tmpfile; mv -f tmpfile MRK_List1.rpt
sed '1d' MRK_List2.rpt > tmpfile; mv -f tmpfile MRK_List2.rpt
cat MRK_List1.rpt MRK_List2.rpt |awk '$1~/^MGI:.*$/' >MRK_total_list.rpk ;rm -f MRK_List1.rpt MRK_List2.rpt

rm -f MRK_SwissProt_TrEMBL.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MRK_SwissProt_TrEMBL.rpt
rm -f MGI_EntrezGene.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MGI_EntrezGene.rpt
rm -f MRK_ENSEMBL.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MRK_ENSEMBL.rpt
rm -f MGI_Gene_Model_Coord.rpt; axel -an 10 http://www.informatics.jax.org/downloads/reports/MGI_Gene_Model_Coord.rpt
sed '1d' MGI_Gene_Model_Coord.rpt > tmpfile; mv -f tmpfile MGI_Gene_Model_Coord.rpt
rm -f MRK_Sequence.rpt; axel -o MRK_Sequence.rpt -an 10 http://www.informatics.jax.org/downloads/reports/MRK_Sequence.rpt 
sed '1d' MRK_Sequence.rpt > tmpfile; mv -f tmpfile MRK_Sequence.rpt

### HGNC
curl "https://www.genenames.org/cgi-bin/download/custom?col=gd_app_sym&col=gd_app_name&col=gd_pub_eg_id&col=gd_pub_ensembl_id&col=gd_pub_refseq_ids&status=Approved&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit" >human_HGNC_curated_latest.tab
curl "https://www.genenames.org/cgi-bin/download/custom?col=md_prot_id&col=md_eg_id&col=md_ensembl_id&col=md_refseq_id&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit" >human_HGNC_external_latest.tab

sed '1d' human_HGNC_curated_latest.tab > tmpfile; mv -f tmpfile human_HGNC_curated_latest.tab
sed '1d' human_HGNC_external_latest.tab > tmpfile; mv -f tmpfile human_HGNC_external_latest.tab


#Rscript ./mouse_merge.R
#Rscript ./human_merge.R




