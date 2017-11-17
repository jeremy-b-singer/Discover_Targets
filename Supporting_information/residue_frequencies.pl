#!/usr/bin/perl
# residue_frequencies.pl
#
# Create a log odds substitution matrix for a genome from all its peptide files.
# Also creates a file containing counts/probabilities for each residue.
#
# author: Jeremy Singer
# date: 9/6/2016
#
use Getopt::Long;
my $root_dir='.';	# where to find chromosome directories containing peptide .fasta files
my $genome = '';	# subject genome

GetOptions('root_dir=s' => \$root_dir,
	   'genome=s' => \$genome);

print "Root directory: $root_dir\n";
my $freq_fn = $genome . "_residue_frequency.txt";

my $dh;
my @sub_dirs;
opendir($dh, $root_dir) || die "Can't open $root_dir\n";
@sub_dirs = readdir($dh);
closedir($dh);

my %residue_count;	# accumulate count of identified residues (excludes X and *) for calculating P(E) of each residue
my %residue_sub_count;	# for each residue, value is ref hash with counts used to calculate log odds of transition from previous residue
my $total_residues = 0;	# count of identified residues in the subject genome

foreach my $dir (@sub_dirs){ # find all chromosome directories
	if ( -d "$root_dir/$dir" && $dir ne '.' && $dir ne '..' ) {
		print "$dir\n";
		my $path_dir = "$root_dir/$dir";
		opendir($dh, $path_dir) || die "Can't open $path_dir\n";
		my @path_entries = readdir($dh);
		closedir($dh);

		foreach my $entry (@path_entries){ # process chromosome directory
			if ( -f "$path_dir/$entry" && $entry =~ m/\.fasta/i ) {
				open($IN, '<', "$path_dir/$entry") || die "Can't open $entry\n";
				my @fasta = <$IN>;
				close($IN);

				my $first = 1;
				my $prev_residue = '';
				foreach my $line (@fasta){ # process .fasta file
					chomp;
					if ( $first ) {
						$first = 0;
					} else {
						my @residues = split //, $line;
						foreach my $residue (@residues){ # process residue
							if ( $residue =~ m/\S/ && $residue ne '*'  && $residue ne 'X' ) {
								if ( exists $residue_count{$residue} ){
									$residue_count{$residue}++;
								} else {
									$residue_count{$residue} = 1;
								}
								$total_residues++;
								if ( $prev_residue ne '' ){
									my $sub_res_hash_ref;
									if ( exists $residue_sub_count{$residue} ){
										$sub_res_hash_ref = $residue_sub_count{$residue};
										${$sub_res_hash_ref}{$prev_residue}++;
									} else {
										my %sub_res;
										$sub_res{$prev_residue} = 1;
										$sub_res_hash_ref = \%sub_res;
										 $residue_sub_count{$residue} = $sub_res_hash_ref;
									}
								}
								$prev_residue = $residue;
							}
						}
					}
				}
			}
		}	
	}
}

print "Total residues: $total_residues\n\n";

# write file containing proportion of each residue.
my $rfh;
open($rfh, ">", $freq_fn) || die "Can't open $freq_fn\n";
print $rfh "residue\tcount\tfrac\n";
foreach my $residue (sort keys %residue_count){
	if (  $residue ne '*' && $residue !=~ m/s/ ){
		my $frac = $residue_count{$residue} / $total_residues;
		print $rfh "$residue\t$residue_count{$residue}\t$frac\n";
	}
}
close($rfh);


