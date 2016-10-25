#!/usr/bin/perl

#output format  childGO \t parentGO1, parentGO2, ....

open(GO, "</home/khan27/Desktop/Ishita_Projects_May201/Group_Function_Prediction/Networks/GO_association/Data_Files/GO_ALL.txt") || die "could not open GO file";

open(CAT, "</bio/kihara-web/www/webdklab/website_software/Fast-Funsim/2016_data/GO_201603_category.txt") || die "Cant open CAT\n";
open(OUT_BP, ">BPparents.txt");
open(OUT_MF, ">MFparents.txt");
open(OUT_CC, ">CCparents.txt");

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
	print "CAT $go $line[1]\n";
}
close(CAT);

my %bpParents = ();
my %mfParents = ();
my %ccParents = ();

while(<GO>)
{
	chomp $_;
	@line = split(" ", $_);		#parent child	- GO:0006996	GO:0000001
	$parent = $line[0];
	$child = $line[1];

	if($cat{$child} eq 'p')
	{
		print "BP $parent\n";
		push(@{$bpParents{$child}}, $parent);
		next;
	}

	elsif($cat{$child} eq 'f')
	{
		push(@{$mfParents{$child}}, $parent);
		next;
	}

	elsif($cat{$child} eq 'c')
	{
		push(@{$ccParents{$child}}, $parent);
		next;
	}
}

close(GO);

$bp = keys %bpParents;
$mf = keys %mfParents;
$cc = keys %ccParents;

print "Done loading GO; BP $bp MF $mf CC $cc\n";

########## print ##########

foreach $child(sort keys %bpParents)
{
	print OUT_BP "$child ";
	foreach $parent(@{$bpParents{$child}})
	{
		print OUT_BP "$parent,";
	}
	print OUT_BP "\n";
}
foreach $child(sort keys %mfParents)
{
	print OUT_MF "$child ";
	foreach $parent(@{$mfParents{$child}})
	{
		print OUT_MF "$parent,";
	}
	print OUT_MF "\n";
}
foreach $child(sort keys %ccParents)
{
	print OUT_CC "$child ";
	foreach $parent(@{$ccParents{$child}})
	{
		print OUT_CC "$parent,";
	}
	print OUT_CC "\n";
}
close(OUT_BP);
close(OUT_MF);
close(OUT_CC);




