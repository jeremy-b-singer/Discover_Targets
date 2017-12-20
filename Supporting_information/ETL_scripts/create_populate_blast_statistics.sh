# create populate_blast_statistics.sql
echo -- populate_blast_statistics.sql > populate_blast_statistics.sql
for i in $(ls -d */);do
	for j in $(ls ${i}*.stats);do
		echo 'truncate table tmp_blast_statistics;' >> populate_blast_statistics.sql
		echo "\\copy tmp_blast_statistics (targ_comp, query_length, score, expect, identities, positives, gaps) from '${PWD}/${j}'" >> populate_blast_statistics.sql
		echo "update tmp_blast_statistics set tax_id=5691, chromosome='$i',orf='${j:${#i}}';" >> populate_blast_statistics.sql
		echo 'insert into blast_statistics select * from tmp_blast_statistics;' >> populate_blast_statistics.sql

	done
done

