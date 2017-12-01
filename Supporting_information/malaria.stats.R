malaria=blast_statistics[blast_statistics$tax_id==5833,]
malaria.stats=data.frame(score=malaria$score,expect=1-log(malaria$expect),identities=malaria$identities,positives=malaria$positives)
pairs(malaria.stats)
