#!/usr/bin/perl
#6/29/12
my ($table_file, $annotation_file, $score_type, $config) = @ARGV;
require "$config";

my $cas_path = get_cas_path();
my $pas_path = get_pas_path();
my $ias_path = get_ias_path();

#THE OUTPUT FILE IS IN THIS TYPE OF FORMAT: PROTEIN 1 \t PROTEIN 2 \t SPECIFICITY \t SENSITIVITY


open (GO, "<$table_file") || die "Cannot open GO\n";
open (CC, "<$annotation_file") || die "Cannot open CC\n";

open (OUT, ">Human_".$score_type."_pairwise_spec_sens_score.txt");
#open (OUT, ">Ecoli_CC_protein_pairwise_spec_sens_score.txt");

open (TEST, ">test.txt");#debugging file


#cas and pas
open(CAS, "<$cas_path") || die "Cannot open CAS\n";
open(PAS, "<$pas_path") || die "Cannot open PAS\n";

#ias
open(IAS, "<$ias_path") || die "Cannot open IAS\n";

my %cas = ();
my %pas = ();

if($score_type eq "CAS"){
	while(<CAS>)
	{
		chomp $_;
		@line = split(" ", $_);
		$cas{$line[0]}{$line[1]} = $line[2];
	}
	print "compute_allSim.pl : Done loading CAS\n";

}

if($score_type eq "PAS"){

	while(<PAS>)
	{
		chomp $_;
		@line = split(" ", $_);
		$pas{$line[0]}{$line[1]} = $line[2];
	}
	print "compute_allSim.pl : Done loading PAS\n";
}

if($score_type eq "IAS"){

	while(<IAS>)
	{
		chomp $_;
		@line = split(" ", $_);
		$pas{$line[0]}{$line[1]} = $line[2];
	}
	print "compute_allSim.pl : Done loading PAS\n";
}

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


%go;
@prot;
@term;

$linecount = 0;
while ($line = <GO>){
	$linecount++;
	#print "get_go_cc_score.pl : loading CC sim $linecount\n";
	chomp $line;
	@line = split(" ", $line);
	$term1 = $line[0];
	$term2 = $line[1];
	$score = -1;
	if($score_type eq "IAS"){
		$score = ias($term1, $term2);
	}
	if($score_type eq "PAS"){
		$score = pas($term1, $term2);
	}
	if($score_type eq "CAS"){
		$score = cas($term1, $term2);
	}
	
	if($score > 0)
	{
		$go{$term1}{$term2} = $score; #sim matrix stored as a hash of hashes where the keys are the GO terms and the value is the similarity shared between them 
	}
}

print "get_go_cc_score.pl : DONE LOADING GO\n";
close (GO);
	
my %prot = ();
$count = 1;

while ($line = <CC>){
	chomp $line;
	$prot{$count}=$line; #stores the protein information in a hash indexed by a number (key) and whos value is in this format 'protein name\tGO terms sep by commas
	$count++;
}

close (CC);

$counter = $count;
@rowMax;
@rMax;
@cMax;
@colMax;
%matrix;

for ($i = 1; $i < $count; $i++){
	print "get_go_cc_score.pl : Computing CC specsenc " . --$counter ."\n";
	for($k = $i+1 ; $k < $count; $k++){
		@p1 = split(" ", $prot{$i}); 
		@p2 = split(" ", $prot{$k}); 

		$id1 = $p1[0];	
		$id2 = $p2[0];
	
		print OUT "$id1\t$id2\t";#prints the two proteins that are being compared
		#print TEST "$id1\t$id2\t";#prints the two proteins that are being compared

		@go1 = split /,/, $p1[1];
		@go2 = split /,/, $p2[1];
		@rowMax = ();
		@colMax = ();
		@rMax = ();
		@cMax = ();
		$normColMax = $normMax = 0;
		
		for ($q=1; $q<=scalar(@go1);$q++){
			$term1=$go1[$q-1];
			#print TEST "TERM 1:$term1\tTERM(S)2: ";#check matrix row
			for($z=1;$z<=scalar(@go2);$z++){
				$term2=$go2[$z-1];
				#print TEST "$term2 ";#checks matrix column
				if(exists($go{$term1}{$term2}))
				{
					$matrix{$q}{$z} = $go{$term1}{$term2};
				}
				elsif(exists($go{$term2}{$term1}))
				{
					$matrix{$q}{$z} = $go{$term2}{$term1};
				}
				else
				{
					$matrix{$q}{$z} = 0;
				}
				#print "$term1 $term2 $go{$term1}{$term2} \n";
			}
			#print TEST "\n\n";#debugging	
		}
		for($w=1;$w<=scalar(@go1);$w++){
			for($x=1;$x<=scalar(@go2);$x++){
				push (@rowMax, $matrix{$w}{$x});
			}
			@rowMax = sort {$a <=> $b} @rowMax;
			$Rmax = $rowMax[$#rowMax];
			push (@rMax, $Rmax);
			@rowMax = ();
		}
		foreach (@rMax) {
			if (scalar(@rMax) == 1 ){
				$finR = $rMax[0];
			} else {
				$finR += $_;
			}
		}
		if (scalar(@go1) != 0) {
			$normMax = $finR/scalar(@go1);
		}
		print OUT "$normMax\t";	#prints the normalized average of the row vectors for the protein pair

		@rMax = ();
		$finR = 0;
		for ($b=1;$b<=scalar(@go2);$b++){
			for($f=1;$f<=scalar(@go1);$f++){
				push (@colMax, $matrix{$f}{$b});
				#print TEST"$matrix{$f}{$b} ";#checks column values
			}
			@colMax = sort {$a <=> $b} @colMax;
			$Cmax = $colMax[$#colMax];
			push (@cMax, $Cmax);
			#print TEST "COLUMN MAX:$Cmax\n";#checks column values
			@colMax = ();
			print TEST "\n";#debugging columns
		}
		foreach (@cMax) {
			if (scalar(@cMax) == 1 ) {
				$finC = $cMax[0];
			} else {
				$finC += $_;
			}
		}
		if (scalar(@go2) != 0 ) {
			$normColMax = $finC/scalar(@go2);
		}
		#print TEST "FINAL MAX:$finC\tNORM AVE:$normColMax\n\n\n";#checks column values
	
		print OUT "$normColMax\n";#prints the normalized average of the column vectors for the protein pair
		@cMax = ();
		$finC = 0;
	
	}	
}
close(OUT);

 %go = ();
