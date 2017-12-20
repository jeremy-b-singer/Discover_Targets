for i in $(ls *.fa);do
 k=`echo $i | cut -d '.' -f 4,5`
 g3-iterated.csh $i $k
 extract -2 $i $k.coords > $k.genes
done 
