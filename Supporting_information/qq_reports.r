report_full_distribution<-function(tax_id,organism){
  query=paste("select score from blast_statistics where tax_id=",tax_id)
  rs=dbSendQuery(con,query)
  scores=dbFetch(rs,-1)
  label=paste("All",organism)
  qqnorm(log(scores$score),main=label)
  qqline(log(scores$score), col='red',lwd=3)
}

report_normal_distribution<-function(tax_id,threshold,organism){
  query=paste("select score from blast_statistics where tax_id=",tax_id, ' and score < ', threshold)
  rs=dbSendQuery(con,query)
  scores=dbFetch(rs,-1)
  label=paste("Normal", organism)
  qqnorm(log(scores$score),main=label)
  qqline(log(scores$score), col='red',lwd=3)
}

opar=par(mfrow=c(2,5))
apply(tax_norm_threshold,1,function(row){
  report_full_distribution(row[1],row[3])})

apply(tax_norm_threshold,1,function(row){
  report_normal_distribution(row[1], row[2], row[3])})
par(opar)

