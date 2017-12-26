for i in $(ls -d */);do
	for j in $(ls ${i}*.blastp.txt);do
		k=`echo $j | cut -d '.' -f 1,2` 
		perl extract_header.pl < $j > ${k}.stats
	done
done

