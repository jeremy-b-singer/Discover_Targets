#!/usr/bin/perl
# chrom_genes_to_proteins.pl
# invoke: chrom_genes_to_proteins.pl <input chrom nucleic acid fasta>
# Input filename looks like <chromosomename.genes>
# Program creates a directory that looks like <chromosomename> and 
# creates a separate file named <orfname>.fasta in that directory.

if (@ARGV < 1) {die "Specify gene filename.\n"}

my $gene_filename = shift @ARGV;
$gene_filename =~ m/(\S+)\.genes/;
my $dest = $1;
mkdir $dest;

open(CHROMFILE,"$gene_filename") or die ("Unable to open $gene_filename.\n");
my @orfs=<CHROMFILE>;
close(CHROMFILE);

foreach my $orf(@orfs)
{
	$orf  =~ m/(\S+)\s+(\S+)/;
	my $orfname = $1;
	my $nucleotides = $2;
	open(TEMPGENE,">tempgene.fa") or die ("Unable to create tempgene");
	print TEMPGENE $nucleotides;
	close(TEMPGENE);
	system "transeq -sequence tempgene.fa -outseq $dest/$orfname.fasta";
}
