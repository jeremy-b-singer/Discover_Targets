library(RPostgreSQL)
drv=dbDriver('PostgreSQL')
con=dbConnect(drv,dbname='chembl_20',port=5432,host='localhost',user='mychembl')

tax_characteristics=data.frame(tax_id=as.integer(),median_score=as.numeric(), mad_score=as.numeric(), thresh=as.numeric())
blast_statistics=dbReadTable(con,'blast_statistics')
tax_id=unique(blast_statistics$tax_id)
for (i in 1:length(tax_id)){
	tax_statistics=blast_statistics[blast_statistics$tax_id==tax_id[i],]
	median_score=median(tax_statistics$score)
	mad_score=mad(tax_statistics$score)
	disc_thresh=median_score + 2 * mad_score
	df=data.frame(tax_id=tax_id[i], median_score=median_score, mad_score=mad_score,thresh=disc_thresh)
	tax_characteristics=rbind(tax_characteristics,df[1,])
}

tax_characteristics
