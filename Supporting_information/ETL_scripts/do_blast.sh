for i in $(ls *.fasta);do 
orf=`echo $i | cut -d'.' -f1`;
 blastp -db ~/chembl/chembl_db -query $i -num_alignments 10 -out ${orf}.blastp.txt; 
done
