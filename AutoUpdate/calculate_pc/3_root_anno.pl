#!/usr/bin/perl
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

open (BP, "<BPparents.txt") or die("Failed");
open (MF, "<MFparents.txt");
open (CC, "<CCparents.txt");

open (GF, "<GO_freqs.txt");

open (OUT, ">ROOT_ANNO_FREQ.txt");

%bp;
%mf;
%cc;
%gf;

while ($line = <GF>){
	chomp $line;
	@line = split /\t/, $line;
	$gf{$line[0]} = $line[1];
}

close(GF);
print "\nDone loading GF";

while ($line = <BP>){
	chomp $line;
	@line = split /\t/, $line;
	$id = $line[1];
	$child = $line[2];
	@children = split /,/, $child;
	$bp{$id} = 1;
	foreach (@children){
		$bp{$_} = 1;
	}
}

close(BP);
print "\nDone loading BP";

while ($line = <MF>){
	chomp $line;
	@line = split /\t/, $line;
	$id = $line[1];
	$child = $line[2];
	@children = split /,/, $child;
	$mf{$id} = 1;
	foreach (@children){
		$mf{$_}= 1;
	}
}

close(MF);
print "\nDone loading MF";

while ($line = <CC>){
	chomp $line;
	@line = split /\t/, $line;
	$id = $line[1];
	$child = $line[2];
	@children = split /,/, $child;
	$cc{$id} = 1;
	foreach (@children){
		$cc{$_}=1;
	}
}

close(CC);
print "\nDone loading CC";

$bpScore=0;
$mfScore=0;
$ccScore=0;

foreach $k (sort keys %bp){
	foreach $j (sort keys %gf){
		if ($k =~ m/$j/){
			$bpScore += $gf{$j};
		}
	}
}

foreach $k (sort keys %mf){
	foreach $j (sort keys %gf){
		if ($k =~ m/$j/){
			$mfScore += $gf{$j};
		}
	}
}

foreach $k (sort keys %cc){
	foreach $j (sort keys %gf){
		if ($k =~ m/$j/){
			$ccScore += $gf{$j};
		}
	}
}

print OUT "BIOLOGICAL PROCESS ROOT SCORE:\t$bpScore\nMOLECULAR FUNCTION ROOT SCORE:\t$mfScore\nCELLULAR COMPONENT ROOT SCORE:\t$ccScore\n";
close(OUT);

