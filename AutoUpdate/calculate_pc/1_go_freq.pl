#!/usr/bin/perl

#8/1/12

#The input file is the raw Uniprot data

#this script finds the number of times a GO term exists in the Uniprot/Swiss-Prot Database

open (IN, "<uniprot_sprot.dat");
open (OUT, ">GO_freqs.txt");
open (OUT1, ">GO_freqs_without_iea.txt");

%go;
%iea;

while ($line = <IN>){

	chomp $line;
	
	if($line =~ /^DR/ && $line =~ /GO;\sGO:/){ #matches only if the line begins with DR and contains 'GO; GO:' in the line. 

		$saved = $line;
		@line = split /;/, $line;
		$line[1] =~ s/\s//; #removes any white space from the GO annotation
		#print "$line[1]\n";
		$go{$line[1]}++;


		if($saved =~ /IEA:/g){ #matches to the line if it contains 'IEA:' anywhere in the line
			next;
		} else {

			@saved = split /;/, $saved;
			$saved[1] =~ s/\s//; #removes whitespace from annotation
			
			$iea{$saved[1]}++;

			
		}
	}
}

foreach $key(sort keys %go){

	$go{$key} = $go{$key} + 1;
	print OUT "$key\t$go{$key}\n";

}
			
foreach $key(sort keys %iea){

	print OUT1 "$key\t$iea{$key}\n";

}
