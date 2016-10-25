#!/usr/bin/perl

my ($config) = @ARGV;
require "$config";

my $data_path = get_data_file_path();
open (BP, "<".$data_path."BPparents.txt") || die "Cannot open BP\n";
open (MF, "<".$data_path."MFparents.txt") || die "Cannot open MF\n";
open (CC, "<".$data_path."CCparents.txt") || die "Cannot open CC\n";

open (OUT1, ">ALLpair_commonAncestor_uniq.txt");
#open (OUT2, ">MFpair_commonAncestor_uniq.txt");
#open (OUT3, ">CCpair_commonAncestor_uniq.txt");

open(CAT, "<".$data_path."GO_category_format.txt") || die "Cant open CAT\n";
my %cat = ();
while(<CAT>)
{
	chomp $_;
	@line = split(" ", $_);		#8049	p
	$len = length($line[0]);
	$prefix = "GO:";
	$n_zeros = 7 - $len;
	
	for($i = 0; $i < $n_zeros; $i++)
	{
		$prefix = $prefix . "0";
	}
	$go = $prefix.$line[0];
	$cat{$go} = $line[1];
	#print "get_rel_ancestors.pl : CAT $go $line[1]\n";
}
close(CAT);

#print "get_rel_ancestors.pl : Done loading Category\n";

$file = $ARGV[0]; 
open(ANNOT, "<annotation.txt") || die "Cant open ANNOT\n";
my @golist_bp = ();
my @golist_cc = ();
my @golist_cc = ();
my %seen = ();

while(<ANNOT>)
{
	chomp $_;
	my @line = split(" ", $_);		#GOLIST GO:0033301,GO:0008283,GO:0060718,GO:0070365,GO:0032466,GO:0000122,GO:0001890,GO:0032877,GO:0045944
	my @goterms = split(/,/, $line[1]);

	foreach $go(@goterms)
	{
		unless($seen{$go})
		{
			$seen{$go} = 1;
			if($cat{$go} eq 'p')
			{
				push(@golist_bp, $go);
				#print "get_rel_ancestors.pl : $go P\n";
				next;
			}
			if($cat{$go} eq 'f')
			{
				push(@golist_mf, $go);
				#print "get_rel_ancestors.pl : $go F\n";
				next;
			}
			if($cat{$go} eq 'c')
			{
				push(@golist_cc, $go);
				#print "get_rel_ancestors.pl : $go C\n";
				next;
			}
		}
	}

}
#print "get_rel_ancestors.pl : Done loading annotations. Total GO terms BP = ". scalar(@golist_bp) . " MF = ". scalar(@golist_mf) . " CC = ". scalar(@golist_cc) . "\n";
close(ANNOT);

#use Set::Intersection;

%bp = ();
$count=1;
while (<BP>)
{

	chomp $_;
	@line = split(" ", $_);		#GO:0000015	GO:0000015,GO:0005575,GO:0005622,GO:0005623,GO:0005737,GO:0005829,GO:0032991,GO:0043234,GO:0044424,GO:0044444,GO:0044445,GO:0044464,
	$bp{$line[0]} = $line[1];
}
close(BP);
#print "get_rel_ancestors.pl : Done loading BP parents\n";

%mf = ();
$count=1;
while (<MF>)
{

	chomp $_;
	@line = split(" ", $_);		#GO:0000015	GO:0000015,GO:0005575,GO:0005622,GO:0005623,GO:0005737,GO:0005829,GO:0032991,GO:0043234,GO:0044424,GO:0044444,GO:0044445,GO:0044464,
	$mf{$line[0]} = $line[1];
}
close(MF);
#print "get_rel_ancestors.pl : Done loading MF parents\n";

%cc = ();
$count=1;
while (<CC>)
{

	chomp $_;
	@line = split(" ", $_);		#GO:0000015	GO:0000015,GO:0005575,GO:0005622,GO:0005623,GO:0005737,GO:0005829,GO:0032991,GO:0043234,GO:0044424,GO:0044444,GO:0044445,GO:0044464,
	$cc{$line[0]} = $line[1];
}
close(CC);
#print "get_rel_ancestors.pl : Done loading CC parents\n";

#my @intersection = ();
for ($i = 0; $i < scalar(@golist_bp); $i++)
{
	#print "get_rel_ancestors.pl : BP pairwise ancester for $i\n";
	for ($k = $i+1; $k < scalar(@golist_bp); $k++)
	{
		$go1 = $golist_bp[$i];
		$go2 = $golist_bp[$k];

		print OUT1 "$go1\t$go2\t";

		@parents1 = split(/,/, $bp{$go1});
		@parents2 = split(/,/, $bp{$go2});
		
		#@intersection = get_intersection(\@test1, \@test2);
		my %parents2_hash = ();
		%parents2_hash = map{$_ =>1} @parents2;
		
		foreach $go(@parents1)
		{
			if(exists($parents2_hash{$go}))
			{
				print OUT1 "$go,";
			}
		}

		@parents1 = ();
		@parents2 = ();
		print OUT1 "\n";
	}
}
print "get_rel_ancestors.pl : Done printing common parents BP\n";

#my @intersection = ();
for ($i = 0; $i < scalar(@golist_mf); $i++)
{
	#print "get_rel_ancestors.pl : MF pairwise ancester for $i\n";
	for ($k = $i+1; $k < scalar(@golist_mf); $k++)
	{
		$go1 = $golist_mf[$i];
		$go2 = $golist_mf[$k];

		#print "MF $go1\t$go2\n";
		print OUT1 "$go1\t$go2\t";

		@parents1 = split(",", $mf{$go1});
		@parents2 = split(",", $mf{$go2});
		
		#@intersection = get_intersection(\@test1, \@test2);
		my %parents2_hash = ();
		%parents2_hash = map{$_ =>1} @parents2;
		
		foreach $go(@parents1)
		{
			if(exists($parents2_hash{$go}))
			{
				print OUT1 "$go,";
			}
		}

		@parents1 = ();
		@parents2 = ();
		print OUT1 "\n";
	}
}
print "get_rel_ancestors.pl : Done printing common parents MF\n";;

#my @intersection = ();
for ($i = 0; $i < scalar(@golist_cc); $i++)
{
	#print "get_rel_ancestors.pl : CC pairwise ancester for $i\n";
	for ($k = $i+1; $k < scalar(@golist_cc); $k++)
	{
		$go1 = $golist_cc[$i];
		$go2 = $golist_cc[$k];

		print OUT1 "$go1\t$go2\t";

		@parents1 = split(",", $cc{$go1});
		@parents2 = split(",", $cc{$go2});
		
		#@intersection = get_intersection(\@test1, \@test2);
		my %parents2_hash = ();
		%parents2_hash = map{$_ =>1} @parents2;
		
		foreach $go(@parents1)
		{
			if(exists($parents2_hash{$go}))
			{
				print OUT1 "$go,";
			}
		}
		@parents1 = ();
		@parents2 = ();
		print OUT1 "\n";
	}
}
print "get_rel_ancestors.pl : Done printing common parents CC\n";


close(OUT1);


open (OUT2, ">GOpairs_BetweenOntologies.txt");
for ($i = 0; $i < scalar(@golist_bp); $i++)
{
	$go1 = $golist_bp[$i];
	for ($k = 0; $k < scalar(@golist_mf); $k++)
	{
		$go2 = $golist_mf[$k];
		print OUT2 "$go1 $go2\n";
	}
}
for ($i = 0; $i < scalar(@golist_bp); $i++)
{
	$go1 = $golist_bp[$i];
	for ($k = 0; $k < scalar(@golist_cc); $k++)
	{
		$go2 = $golist_cc[$k];
		print OUT2 "$go1 $go2\n";
	}
}
for ($i = 0; $i < scalar(@golist_mf); $i++)
{
	$go1 = $golist_mf[$i];
	for ($k = 0; $k < scalar(@golist_cc); $k++)
	{
		$go2 = $golist_cc[$k];
		print OUT2 "$go1 $go2\n";
	}
}
close(OUT2);

@golist_bp = ();
@golist_mf = ();
@golist_cc = ();
