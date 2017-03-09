#!/usr/bin/perl 
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

#6/29/12

open (BP, "<Human_BP_pairwise_spec_sens_score.txt") || die "cannot open BP";
open (CC, "<Human_CC_pairwise_spec_sens_score.txt")|| die "cannot open CC";
open (MF, "<Human_MF_pairwise_spec_sens_score.txt")|| die "cannot open MF";


open (OUT, ">Human_funsim_scores.txt");
open (OUT_BP_MF, ">Human_funsim_scores_BP+MF.txt");

open (OUT_BP, ">Human_funsim_scores_BP.txt");
open (OUT_MF, ">Human_funsim_scores_MF.txt");
open (OUT_CC, ">Human_funsim_scores_CC.txt");

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
	
	$line = <MF>;
	chomp $line;
	print "get_funsim2.pl : MF $line\n";
	@line = ();
	@line = split /\t/, $line;

	if ($line[2] > $line[3]){
		$mfmax = $line[2];
	}
	if ($line[3] > $line[2]){
		$mfmax = $line[3];
	}
	if ($line[2] == $line[3]){
		$mfmax = $line[2];
	}

	$line = <CC>;
	chomp $line;
	print "get_funsim2.pl : CC $line\n";
	@line = ();
	@line = split /\t/, $line;

	if ($line[2] > $line[3]){
		$ccmax = $line[2];
	}
	if ($line[3] > $line[2]){
		$ccmax = $line[3];
	}
	if ($line[2] == $line[3]){
		$ccmax = $line[2];
	}

	#compute funsim

	$bpsq = $bpmax * $bpmax;
	$mfsq = $mfmax * $mfmax;
	$ccsq = $ccmax * $ccmax;

	$gettingThere = $bpsq + $ccsq + $mfsq;
	$funsim = $gettingThere * (1/3);
	$bpmf = ($bpsq + $mfsq) * (1/2);

	print OUT "$prot1\t$prot2\t$funsim\n";
	print OUT_BP_MF "$prot1\t$prot2\t$bpmf\n";
	
	print OUT_BP "$prot1\t$prot2\t$bpsq\n";
	print OUT_MF "$prot1\t$prot2\t$mfsq\n";
	print OUT_CC "$prot1\t$prot2\t$ccsq\n";	
}

close(BP);
close(MF);
close(CC);

close(OUT);

close(OUT_BP_MF);



