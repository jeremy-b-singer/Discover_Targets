for i in $(ls *.genes); do
	perl chrom_genes_to_proteins.pl $i
done
