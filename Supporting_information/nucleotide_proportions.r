# genome.filename="C:/Users/Jeremy-satellite/Documents/bio research/malaria/genome/Plasmodium_falciparum.ASM276v1.28.dna.genome.fa" 
genome.filename="C:/Users/Jeremy-satellite/Documents/bio research/malaria/genome/Chlamydia_trachomatis_d_uw_3_cx.ASM872v1.dna.chromosome.Chromosome.fa"
genome.fa=read.table(file=genome.filename,header=FALSE,sep="/",stringsAsFactors=FALSE)
acgt=genome.fa[substr(genome.fa[,1],1,1)!=">",]
acgt.line.chars=strsplit(acgt,"")
acgt.line.tabs=sapply(acgt.line.chars,table)

acgt.matrix=matrix(ncol=5,nrow=length(acgt.line.tabs),byrow=FALSE)
colnames(acgt.matrix)=c('A','C','G','N','T')
for (row in 1:length(acgt.line.tabs)){
	linetab = acgt.line.tabs[row] # table
	linevec = unlist(linetab) # vector of integers
	for (col in 1:length(linevec)){
		acgt.matrix[row,names(linevec)[col]]=linevec[col]
	}
}

sum.columns<-function(obj){
	result.matrix=matrix(nrow=1,ncol=length(colnames(obj)))
	colnames(result.matrix) = colnames(obj)
	for (col in 1:length(colnames(obj))){
		result.matrix[1,col] = 0;
	}

	for (col in 1:dim(obj)[2]){
		result.matrix[1, col] = sum(obj[,col],na.rm=TRUE)
	}
	return(result.matrix)
}

sum.columns(acgt.matrix)

total.known.bp<-function(obj){
	sum.matrix=sum.columns(obj)
	result=sum.matrix[1,'A']+sum.matrix[1,'C']+sum.matrix[1,'G']+sum.matrix[1,'T']
	names(result)="Total known BP"
	return(result)
}

proportion.bp<-function(obj){
	sum.matrix=sum.columns(obj)
	total = total.known.bp(obj)
	result.matrix=matrix(ncol=4,nrow=1) # only known columns
	colnames(result.matrix)=c('A','C','G','T')
	result.matrix[1,'A'] = sum.matrix[1,'A']/total
	result.matrix[1,'C'] = sum.matrix[1,'C']/total
	result.matrix[1,'G'] = sum.matrix[1,'G']/total
	result.matrix[1,'T'] = sum.matrix[1,'T']/total
	
	return(result.matrix)
}

proportion.bp(acgt.matrix)

