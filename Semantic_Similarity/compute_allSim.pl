#!/usr/bin/perl 
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

my ($config) = @ARGV;
require "$config";
my $cas_path = get_cas_path();
my $pas_path = get_pas_path();
my $ias_path = get_ias_path();

my $data_path = get_data_file_path();

open (ALL, "<ALLpair_commonAncestor_uniq.txt")|| die "Cannot open BP_related_ancestors.txt file.\n";
open (PC, "<".$data_path."Combined_pc.txt")|| die "Cannot open Combined_pc.txt file.\n";	

open (OUT, ">GO_Similarity_Scores.txt") || die "Cannot open out";	#Relevance Similarity


my %pc = ();
@max;
%zeros;

while ($line = <PC>)
{
	chomp $line;
	@line = split("\t", $line);
	$pc{$line[0]} = $line[1];
}

close (PC);

#cas and pas
open(CAS, "<$cas_path") || die "Cannot open CAS\n";
open(PAS, "<$pas_path") || die "Cannot open PAS\n";

#ias
open(IAS, "<$ias_path") || die "Cannot open IAS\n";
my %cas = ();
my %pas = ();
my %ias = ();

while(<CAS>)
{
	chomp $_;
	@line = split(" ", $_);
	$cas{$line[0]}{$line[1]} = $line[2];
}
print "compute_allSim.pl : Done loading CAS\n";

while(<PAS>)
{
	chomp $_;
	@line = split(" ", $_);
	$pas{$line[0]}{$line[1]} = $line[2];
}
print "compute_allSim.pl : Done loading PAS\n";


while(<IAS>)
{
	chomp $_;
	@line = split(" ", $_);
	$ias{$line[0]}{$line[1]} = $line[2];
}
print "compute_allSim.pl : Done loading IAS\n";

close(IAS);
close(CAS);
close(PAS);

sub cas
{
	$go1 = $_[0];
	$go2 = $_[1];
	if(exists($cas{$go1}{$go2}))
	{
		$score = $cas{$go1}{$go2};
		return $score;
	}
	if(exists($cas{$go2}{$go2}))
	{
		$score = $cas{$go2}{$go1};
		return $score;
	}
	$score = -1;
	return $score;
	
};

sub pas
{
	$go1 = $_[0];
	$go2 = $_[1];
	if(exists($pas{$go1}{$go2}))
	{
		$score = $pas{$go1}{$go2};
		return $score;
	}
	if(exists($pas{$go2}{$go2}))
	{
		$score = $pas{$go2}{$go1};
		return $score;
	}
	$score = -1;
	return $score;
	
};

sub ias
{
	$go1 = $_[0];
	$go2 = $_[1];
	if(exists($ias{$go1}{$go2}))
	{
		$score = $ias{$go1}{$go2};
		return $score;
	}
	if(exists($ias{$go2}{$go2}))
	{
		$score = $ias{$go2}{$go1};
		return $score;
	}
	$score = -1;
	return $score;
};

$nl = 0;
@maxRes = ();
@maxLin = ();
@maxRel = ();

while ($line = <ALL>){
	$count++;
	chomp $line;
	@line = split("\t", $line);

#	print "simRel_table_bp.pl : Computing BPsim $nl\n";
	$nl++;

	$term1 = $line[0];
	$term2 = $line[1];
	$ancestors = $line[2];

	if(exists($pc{$term1}))
	{
		$score1 = $pc{$term1};
	}
	else
	{
		die "compute_allSim.pl : Term $term1 does not have a fequency in the database\n";
	}
	
	if(exists($pc{$term2}))
	{
		$score2 = $pc{$term2};
	}
	else
	{
		die "compute_allSim.pl : Term $term2 does not have a fequency in the database\n";
	}

	print "compute_allSim.pl : term1 ". $term1. " pc1 ". $score1 . " term2 ". $term2. " pc2 ". $score2 . "\n";
	$a = $b = 0;
	if($score1 > 0)
	{
		$a = (log($score1)/log(10));
	}
	if($score2 > 0)
	{
		$b = (log($score2)/log(10));
	}
	$ic1 = 0 - $a;
	$ic2 = 0 - $b;

	print OUT "------------------------------------------------\n";
	print OUT "GO Pair $term1 $term2\n";
	print OUT "Information Content\n$term1 $ic1\n$term2 $ic2\n";
	
	@anc = split(",", $ancestors);
	if(scalar(@anc) == 0)		#OBSOLETE, push root
	{
		push @anc, "GO:0008150";
	}
	
	foreach (@anc)
	{
		if(exists($pc{$_}))
		{
			$ancScore = $pc{$_};
		}
		else
		{
			print "Ancestor Term $_ does not have a fequency in the database\n";
			next;
		}
		#print "anc term " . $_ ." ancPC " .$ancScore . "\n";
		$top = 2* (log($ancScore)/log(10));
		
		$bottom =  $a + $b;
		if($bottom == 0)
		{
			$bottom = 1;
		}
		$first = $top/$bottom;
		$resnik = 0 - (log($ancScore)/log(10));
		$lin = $first;
		$rel = $first * (1-$ancScore);
		push @maxRes, $resnik;
		push @maxLin, $lin;
		push @maxRel, $rel;
#		print "curr_ss $rel\n";
	}
	
	@maxRes = sort {$a <=> $b} @maxRes;
	@maxLin = sort {$a <=> $b} @maxLin;
	@maxRel = sort {$a <=> $b} @maxRel;
	$max_res = $maxRes[$#maxRes];
	$max_lin = $maxLin[$#maxLin];
	$max_rel = $maxRel[$#maxRel];

#	print "$term1\t$term2\t$max_rel\n";
	print OUT "Resnik Semantic Similarity $max_res\n";
	print OUT "Lin's Semantic Similarity $max_lin\n";
	print OUT "Relevance Semantic Similarity $max_rel\n";

	$cas = cas($term1, $term2);
	$pas = pas($term1, $term2);
	if($cas > 0)
	{
		print OUT "Co-occurence Association Score (CAS) $cas\n";
	}
	if($pas > 0)
	{
		print OUT "Pubmet Association Score (PAS) $pas\n";
	}
	
	# IAS stuff here
	$ias_score = ias($term1, $term2);
	if($ias_score >= 0){
		print OUT "IAS $ias_score\n";
	}
	
	@maxRes = ();
	@maxLin = ();
	@maxRel = ();
}



close(ALL);

open (PAIRS, "<GOpairs_BetweenOntologies.txt") || die "Cannot open PAIRS\n";
while(<PAIRS>)
{
	chomp $_;
	@line = split(" ", $_);
	$term1 = $line[0];
	$term2 = $line[1];
	$cas = cas($term1, $term2);
	$pas = pas($term1, $term2);
	$ias = ias($term1, $term2);
	$header = 0;
	if($cas > 0)
	{
		print OUT "------------------------------------------------\n";
		print OUT "GO Pair Between Ontologies $term1 $term2\n";
		print OUT "Co-occurence Association Score (CAS) $cas\n";
		$header = 1;
	}
	if($pas > 0)
	{
		if($header == 0)
		{
			print OUT "------------------------------------------------\n";
			print OUT "GO Pair Between Ontologies $term1 $term2\n";
		}
		print OUT "Pubmet Association Score (PAS) $pas\n";
	}
	if($ias >= 0)
	{
		if($header == 0)
		{
			print OUT "------------------------------------------------\n";
			print OUT "GO Pair Between Ontologies $term1 $term2\n";
		}
		print OUT "IAS $ias\n";
	}
	
}
close(PAIRS);
close(OUT);
%pc = ();



