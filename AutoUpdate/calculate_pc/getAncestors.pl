#!/usr/bin/perl
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

#output format  childGO \t parentGO1, parentGO2, ....
system("sort -k 2 GO_BPO.txt > GO_BPO_sortedC.txt");
system("sort -k 2 GO_MFO.txt > GO_MFO_sortedC.txt");
system("sort -k 2 GO_CCO.txt > GO_CCO_sortedC.txt");

open(BP, "<GO_BPO_sortedC.txt") || die "could not open BP file";
open(MF, "<GO_MFO_sortedC.txt") || die "could not open MF file";
open(CC, "<GO_CCO_sortedC.txt") || die "could not open CC file";

open(OUT_BP, ">BPparents.txt");
open(OUT_MF, ">MFparents.txt");
open(OUT_CC, ">CCparents.txt");

$nChild = 0;
while(<BP>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$child = $line[1];

	if($nChild == 0)
	{
		print OUT_BP $child."\t". $line[0] . ",";
		$nChild++;
	}
	else
	{
		if($prevChild eq $child)
		{
			print OUT_BP $line[0].",";	
		}
		else
		{
			print OUT_BP "\n".$child."\t". $line[0] . ",";
		}
		
	}
	$prevChild = $child;
}

$nChild = 0;
while(<MF>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$child = $line[1];

	if($nChild == 0)
	{
		print OUT_MF $child."\t". $line[0] . ",";
		$nChild++;
	}
	else
	{
		if($prevChild eq $child)
		{
			print OUT_MF $line[0].",";	
		}
		else
		{
			print OUT_MF "\n".$child."\t". $line[0] . ",";
		}
		
	}
	$prevChild = $child;
}

$nChild = 0;
while(<CC>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$child = $line[1];

	if($nChild == 0)
	{
		print OUT_CC $child."\t". $line[0] . ",";
		$nChild++;
	}
	else
	{
		if($prevChild eq $child)
		{
			print OUT_CC $line[0].",";	
		}
		else
		{
			print OUT_CC "\n".$child."\t". $line[0] . ",";
		}
		
	}
	$prevChild = $child;
}

close(BP);
close(MF);
close(CC);

close(OUT_BP);
close(OUT_MF);
close(OUT_CC);




