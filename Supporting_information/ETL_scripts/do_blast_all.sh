for i in $(ls -d *chrom*/);do 
echo $i
cd $i
bash ./do_blast.sh
cd ..
done
