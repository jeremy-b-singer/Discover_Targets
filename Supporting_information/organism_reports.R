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

  n=function(x){
    dnorm(x,mean=h$mids[xmean],sd=d) * max(h$counts) * dmax
  }
  
  n2=function(x){
    dnorm(x,mean=median(log(stats$score)),sd=mad(log(stats$score))) * max(h$counts) * dmax
  }
  
  n3=function(x){
    dnorm(x,mean=median(log(stats$score)),sd=mad(log(stats$score))*1.1) * max(h$counts)*dmax*.68
  }
  
  curve(n,from=3,to=8,add=TRUE,col='red')
  curve(n3,from=3,to=8,add=TRUE,col='orange')
  #curve(n2,from=3,to=8,add=TRUE,col='orange')
  
  #for(tier_num in 1:length(org.tiers[[org_num]]$threshold_list)){
  #  thresh=org.tiers[[org_num]]$threshold_list[[tier_num]]
  #  abline(v=log(thresh),col='red')
  #}
  #invisible(readline(prompt="Press [enter] to continue"))
  #tier2.stats=stats[stats$score > org.tiers[[org_num]]$threshold_list[[2]],]
  #hist(log(tier2.stats$score),main=paste("Histogram log(score) for",organism, ' tier2' ),breaks=max(dim(tier2.stats)[1]/20,100))
  #for(tier_num in 2:length(org.tiers[[org_num]]$threshold_list)){
  # thresh=org.tiers[[org_num]]$threshold_list[[tier_num]]
   # abline(v=log(thresh),col='red')
  #}
  invisible(readline(prompt="Press [enter] to continue"))
}

