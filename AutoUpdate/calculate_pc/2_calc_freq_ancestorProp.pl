#!/usr/bin/perl

open (IN, "<GO_freqs.txt");
open (BP, "<BPchildren.txt");
open (CC, "<CCchildren.txt");
open (MF, "<MFchildren.txt");

open (OUT, ">BP_freq_AP.txt");
open (OUT2, ">CC_freq_AP.txt");
open (OUT3, ">MF_freq_AP.txt");

my %go = ();
my %cc = ();
my %bp = ();
my %mf = ();

while ($line = <IN>){

	chomp $line;
	@line = split /\t/, $line;
	$go{$line[0]} = $line[1];
}

$bproot = $mfroot = $ccroot = 0;
$bpCount = $mfCount = $ccCount = 0;
while ($line = <BP>) {

	chomp $line;
	
	@line = split /\t/, $line;
	$parent = $line[0];
	print "\n\nparent " . $parent."\n";
	$parent =~ s/\s//;
	@child = split /,/, $line[1];
	
	foreach (@child)
	{
		if($_ eq $parent)	#if child == parent
		{
			if(exists $go{$_})
			{
				$p_score = $go{$_};
				$bproot += $p_score;
			}
			else 
			{
				$p_score = 1;
				$bproot += $p_score;
			}
		}

		elsif(exists $go{$_})
		{
			$c_score += $go{$_};
			print " child ".$_." score ".$go{$_}."\n";
		}
		else
		{
			print " child ".$_." freq not found \n";
			$c_score += 1;
		}
	}
	
	$freq = $p_score + $c_score;
	$bp{$parent} = $freq;
	$p_score=0;
	$c_score=0;
	$bpCount++;
}

while ($line = <MF>) {

	chomp $line;
	
	@line = split /\t/, $line;
	$parent = $line[0];
	print "\n\nparent " . $parent."\n";
	$parent =~ s/\s//;
	@child = split /,/, $line[1];
	
	foreach (@child)
	{
		if($_ eq $parent)	#if child == parent
		{
			if(exists $go{$_})
			{
				$p_score = $go{$_};
				$mfroot += $p_score;
			}
			else 
			{
				$p_score = 1;
				$mfroot += $p_score;
			}
		}

		elsif(exists $go{$_})
		{
			$c_score += $go{$_};
			print " child ".$_." score ".$go{$_}."\n";
		}
		else
		{
			print " child ".$_." freq not found \n";
			$c_score += 1;
		}
	}
	
	$freq = $p_score + $c_score;
	$mf{$parent} = $freq;
	$p_score=0;
	$c_score=0;

	$mfCount++;
}

while ($line = <CC>) {

	chomp $line;
	
	@line = split /\t/, $line;
	$parent = $line[0];
	print "\n\nparent " . $parent."\n";
	$parent =~ s/\s//;
	@child = split /,/, $line[1];
	
	foreach (@child)
	{
		if($_ eq $parent)	#if child == parent
		{
			if(exists $go{$_})
			{
				$p_score = $go{$_};
				$ccroot += $p_score;
			}
			else 
			{
				$p_score = 1;
				$ccroot += $p_score;
			}
		}

		elsif(exists $go{$_})
		{
			$c_score += $go{$_};
			print " child ".$_." score ".$go{$_}."\n";
		}
		else
		{
			print " child ".$_." freq not found \n";
			$c_score += 1;
		}
	}
	
	$freq = $p_score + $c_score;
	$cc{$parent} = $freq;
	$p_score=0;
	$c_score=0;

	$ccCount++;
}

print "bpCount " . $bpCount . " mfCount " . $mfCount . " ccCount " . $ccCount . "\n"; 

$bpCount = $mfCount = $ccCount = 0;
foreach $key (sort keys %bp){
	print OUT "$key\t$bp{$key}\n";
	$bpCount++;
}

foreach $key (sort keys %cc) {
	print OUT2 "$key\t$cc{$key}\n";
	$ccCount++;
}

foreach $key (sort keys %mf) {
	print OUT3 "$key\t$mf{$key}\n";
	$mfCount++;
}

print "bpCount " . $bpCount . " mfCount " . $mfCount . " ccCount " . $ccCount . "\n";
 
open(ROOT, ">rootFreq.txt");
print ROOT "BP root ". $bproot."\nMF root ".$mfroot."\nCC root ".$ccroot;
close(ROOT);
