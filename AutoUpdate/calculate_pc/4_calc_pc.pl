#!/usr/bin/perl

open (BP, "<BP_freq_AP.txt");
open (MF, "<MF_freq_AP.txt");
open (CC, "<CC_freq_AP.txt");

open (OUT1, ">BP_pc.txt");
open (OUT2, ">MF_pc.txt");
open (OUT3, ">CC_pc.txt");
open (OUT, ">Combined_pc.txt");

%bp;
%mf;
%cc;

while ($line = <BP>){
	chomp $line;
	@line = split /\t/, $line; 
	#$bp{$line[0]} = $line[1]/1823138;	#DANNY
	$bp{$line[0]} = $line[1]/915791;
}

while ($line = <MF>){
	chomp $line;
	@line = split /\t/, $line; 
	#$mf{$line[0]}=$line[1]/1711383;	#DANNY
	$mf{$line[0]}=$line[1]/869336;
	}
while ($line = <CC>){
	chomp $line;
	@line = split /\t/, $line;
	#$cc{$line[0]}=$line[1]/1739392;	#DANNY
	$cc{$line[0]}=$line[1]/598325;
}

foreach $k (sort keys %bp){
	print OUT1 "$k\t$bp{$k}\n";
	print OUT "$k\t$bp{$k}\n";
}

foreach $k (sort keys %mf){
	print OUT2 "$k\t$mf{$k}\n";
	print OUT "$k\t$mf{$k}\n";
}
foreach $k (sort keys %cc){
	print OUT3 "$k\t$cc{$k}\n";
	print OUT "$k\t$cc{$k}\n";
}

close(OUT1);
close(OUT2);
close(OUT3);
close(OUT);



