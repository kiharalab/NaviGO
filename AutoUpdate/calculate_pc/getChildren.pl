#!/usr/bin/perl
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

#output format  parentGO \t childGO1, childGO2, ....
system("sort -k 1 GO_BPO.txt > GO_BPO_sortedP.txt");
system("sort -k 1 GO_MFO.txt > GO_MFO_sortedP.txt");
system("sort -k 1 GO_CCO.txt > GO_CCO_sortedP.txt");

open(BP, "<GO_BPO_sortedP.txt") || die "could not open BP file";
open(MF, "<GO_MFO_sortedP.txt") || die "could not open MF file";
open(CC, "<GO_CCO_sortedP.txt") || die "could not open CC file";

open(OUT_BP, ">BPchildren.txt");
open(OUT_MF, ">MFchildren.txt");
open(OUT_CC, ">CCchildren.txt");

$nChild = 0;
while(<BP>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$parent = $line[0];

	if($nChild == 0)
	{
		print OUT_BP $parent."\t". $line[1] . ",";
		$nChild++;
	}
	else
	{
		if($prevParent eq $parent)
		{
			print OUT_BP $line[1].",";	
		}
		else
		{
			print OUT_BP "\n".$parent."\t". $line[1] . ",";
		}
		
	}
	$prevParent = $parent;
}

$nChild = 0;
while(<MF>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$parent = $line[0];

	if($nChild == 0)
	{
		print OUT_MF $parent."\t". $line[1] . ",";
		$nChild++;
	}
	else
	{
		if($prevParent eq $parent)
		{
			print OUT_MF $line[1].",";	
		}
		else
		{
			print OUT_MF "\n".$parent."\t". $line[1] . ",";
		}
		
	}
	$prevParent = $parent;
}

$nChild = 0;
while(<CC>)
{
	chomp $_;
	@line = split("\t", $_);		#parent child
	$parent = $line[0];

	if($nChild == 0)
	{
		print OUT_CC $parent."\t". $line[1] . ",";
		$nChild++;
	}
	else
	{
		if($prevParent eq $parent)
		{
			print OUT_CC $line[1].",";	
		}
		else
		{
			print OUT_CC "\n".$parent."\t". $line[1] . ",";
		}
		
	}
	$prevParent = $parent;
}


close(BP);
close(MF);
close(CC);

close(OUT_BP);
close(OUT_MF);
close(OUT_CC);




