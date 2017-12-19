#compute thresholds for all organisms in blast_statistics
org.tiers=list()
org_num=1
for(tax_id in tax_norm_threshold$tax_id){
  org.tiers[[org_num]]=get.org.tiers(blast_statistics,tax_id)
  org_num=org_num+1
}

dmax=dnorm(0,mean=0,sd=1)

# plots for reports
for (org_num in 1:length(org.tiers)){
  organism=org.tiers[[org_num]]$organism
  stats=org.tiers[[org_num]]$stats
  
  h= hist(log(stats$score),breaks=length(stats$score)/20,main= paste("Histogram log(score) for",organism ))
  
  xmean=match(max(h$counts),h$counts)
  d=mad(log(stats$score))*1.25

  n=function(x){
    dnorm(x,mean=h$mids[xmean],sd=d) * max(h$counts) * dmax*.8 
  }
  
  n2=function(x){
    dnorm(x,mean=median(log(stats$score)),sd=mad(log(stats$score))) * max(h$counts) * dmax
  }
  
  n3=function(x){
    dnorm(x,mean=median(log(stats$score)),sd=mad(log(stats$score))*1.2) * max(h$counts)*dmax*.68
  }
  
  curve(n,from=3,to=8,add=TRUE,col='red')
  x=sapply(1:4,function(m){
    median(log(stats$score))+mad(log(stats$score))*m
  })
  
  text(x,y=max(h$counts), labels=1:4)
  
  sapply(1:4,function(m){
    abline(v=median(log(stats$score))+mad(log(stats$score))*m, col='blue')
  })
  invisible(readline(prompt="Press [enter] to continue"))
}

