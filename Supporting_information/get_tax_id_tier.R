get.organism.stats=function(stats,tax_id){
  org.stats=stats[stats$tax_id==tax_id,]
  return(org.stats)
}

get.norm.tier=function(org_stats){
	med=median(org_stats$score)
	mad_org=mad(org_stats$score)
	thresh=med+mad_org
	norm.tier=org_stats[org_stats$score < thresh,]
	sample_size=min(5000,length(norm.tier$score))
	sw=shapiro.test(sample(norm.tier$score,sample_size))
	return(norm.tier)
}

mask.norm.tier=function(org_stats){
	med=median(org_stats$score)
	mad_org=mad(org_stats$score)
	thresh=med+mad_org
	mask.tier=org_stats[org_stats$score > thresh,]
	return(mask.tier)
}
 
get.exceptional=function(org_stats){
	tier=1
	norm.tier=get.norm.tier(stats)
	mask.tier=mask.norm.tier(stats)
	sample_size=min(5000,length(norm.tier$score))
	sw=shapiro.test(sample(norm.tier$score,sample_size))
	prev.tier=mask.tier
	cat(
		sprintf(
			"Tier: %s, W=%f, length=%s\n",
			tier,sw$statistic,length(norm.tier$score)
			)
		)

	while(sw$statistic > .84){
		tier = tier + 1
		norm.tier=get.norm.tier(mask.tier,tax_id)
		sample_size=min(5000,length(norm.tier$score))
		if (sample_size < 10) {break}
		sw=shapiro.test(sample(norm.tier$score,sample_size))
		cat(
			sprintf(
			"Tier: %s, W=%f, length=%s\n",
			tier,sw$statistic,length(norm.tier$score)
			)
		)
		prev.tier=mask.tier
		mask.tier=mask.norm.tier(mask.tier,tax_id)
	}
	return(prev.tier)
}
