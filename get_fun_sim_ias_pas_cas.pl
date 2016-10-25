#!/usr/bin/perl 

#6/29/12
my ($score_type) = @ARGV;

open (BP, "<Human_".$score_type."_pairwise_spec_sens_score.txt") || die "cannot open score";


open (OUT, ">Human_".$score_type."_scores.txt");

# TODO: ONLY use bp matrix

my %bp = ();
$bpmax;
while ($line = <BP>){
	chomp $line;
	print "get_funsim2.pl : BP $line\n";
	@line = ();
	@line = split /\t/, $line;

	$prot1 = $line[0];
	$prot2 = $line[1];

	if ($line[2] > $line[3]){
		$bpmax = $line[2];
	}
	if ($line[3] > $line[2]){
		$bpmax = $line[3];
	}
	if ($line[2] == $line[3]){
		$bpmax = $line[2];
	}
	

	#compute funsim
	#TODO should only use one and no root value
	$bpsq = $bpmax;

	print OUT "$prot1\t$prot2\t$bpsq\n";

}

close(BP);
close(OUT);




