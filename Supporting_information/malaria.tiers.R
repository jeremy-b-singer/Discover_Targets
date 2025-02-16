malaria=get.organism.stats(blast_statistics,5833)
thresh1=median(malaria$score)+2*mad(malaria$score)
tier2=mask.norm.tier(malaria)
thresh2=median(tier2$score)+2*mad(tier2$score)
tier3=mask.norm.tier(tier2)
thresh3=median(tier3$score)+2*mad(tier3$score)
tier4=mask.norm.tier(tier3)
thresh4=median(tier4$score)+2*mad(tier4$score)
tier5=mask.norm.tier(tier4)
norm5=get.norm.tier(tier5)
thresh5=median(tier5$score) + 2 * mad(tier5$score)

hist(log(malaria$score),breaks=dim(malaria)[1])
abline(v=log(thresh1),col='red')
abline(v=log(thresh2),col='red')
abline(v=log(thresh3),col='red')
abline(v=log(thresh3),col='red')
abline(v=log(thresh4),col='red')
abline(v=log(thresh5),col='red')

hist(log(tier3$score),breaks=dim(tier3)[1]/10)
abline(v=log(thresh3),col='red')
abline(v=log(thresh3),col='red')
abline(v=log(thresh4),col='red')
abline(v=log(thresh5),col='red')

hist(log(tier4$score),breaks=length(tier4$score)/10)
abline(v=log(thresh4),col='red')
abline(v=log(thresh5),col='red')
