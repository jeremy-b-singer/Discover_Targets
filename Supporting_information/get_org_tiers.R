# environment contains blast_statistics, tax_norm_threshold
# stats is blast_statistics object, containing stats for all organisms
# this function returns a list with the following elements:
# [1] organism_name
# [2] org_stats - stats belonging only to this tax_id
# [3] list of thresholds for each tier
# [4] list of W values

  
get.org.tiers<-function(stats,tax_id){
  num_tiers=1
  org_stats= stats[stats$tax_id == tax_id,]
  org.tiers = list( tax_norm_threshold[tax_norm_threshold$tax_id==tax_id, 'organism']
                 ,org_stats
                 ,list()
                 ,list()
                ) 
  names(org.tiers)=c('organism','stats','threshold_list','W_list')

  work_stats = org.tiers$stats
  
  for( tier in 1:num_tiers){
    org.tiers$threshold_list[tier] = median(work_stats$score) + 2 * mad(work_stats$score)
    norm_work =work_stats[work_stats$score < org.tiers$threshold_list[[tier]],]
    sample_size=min(length(norm_work$score),5000)
    org.tiers$W_list[tier]=shapiro.test(sample(norm_work$score,sample_size))['statistic']
    work_stats=work_stats[work_stats$score > org.tiers$threshold_list[[tier]],]
  }
  return((org.tiers))	
}
