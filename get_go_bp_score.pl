#!/usr/bin/perl

#6/29/12

#THE OUTPUT FILE IS IN THIS TYPE OF FORMAT: PROTEIN 1 \t PROTEIN 2 \t SPECIFICITY \t SENSITIVITY
my ($file, $config) = @ARGV;
require "$config";

my $data_path = get_data_file_path();
open (GO, "<BP_cursim_table_Rel.txt") || die "Cannot open GO\n";
open (BP, "<annotation_bp.txt") || die "Cannot open BP\n";
open (MAP, "<".$data_path ."BP_GO_MAP.txt") || die "Cannot open MAP\n"; 

open (OUT, ">Human_BP_pairwise_spec_sens_score.txt");

#open (TEST, ">text.txt");#debugging file

my %go = ();
my @prot = ();
my @term = ();
my %map = ();

while(<MAP>)
{
	chomp $_;
	@line =split(" ", $_);
	$map{$line[0]} = $line[1];	#GO:0000001 1
}
close(MAP);

$linecount = 0;
while ($line = <GO>){
	$linecount++;
	#print "get_go_bp_score.pl : loading BP sim $linecount\n";
	chomp $line;
	@line = split(" ", $line);
	$term1 = $line[0];
	$term2 = $line[1];
	$score = $line[2];
	if($score > 0)
	{
		$go{$map{$term1}}{$map{$term2}} = $score;
	}
	#$go{$term1}{$term2} = $score;
	#print "$term1\t$term2\t$score\n";
}
print "get_go_bp_score.pl : DONE LOADING GO\n";
close (GO);
	
my %prot = ();
$count = 1;

while ($line = <BP>){
	chomp $line;
	#print "$line\n";
	$prot{$count} = $line; 	#stores the protein information in a hash indexed by a number (key) and whos value is in this format 'protein name\tGO terms sep by commas
	$count++;
}

close (BP);
print "get_go_bp_score.pl : $count proteins read\n";

$counter = $count;
@rowMax;
@rMax;
@cMax;
@colMax;
%matrix;

for ($i = 1; $i < $count; $i++){
	print "get_go_bp_score.pl : Computing BP specsenc " . --$counter ."\n";
	for($k = $i+1 ; $k < $count; $k++){
		@p1 = split(" ", $prot{$i}); 
		@p2 = split(" ", $prot{$k}); 

		$id1 = $p1[0];	
		$id2 = $p2[0];
	
		print OUT "$id1\t$id2\t";#prints the two proteins that are being compared
		#print TEST "$id1\t$id2\t";#prints the two proteins that are being compared

		@go1 = split(",", $p1[1]);
		@go2 = split(",", $p2[1]);

		#print "prot1 annot size ". scalar(@go1) . " prot2 annot size ". scalar(@go1) . "\n";
		@rowMax = ();
		@colMax = ();
		@rMax = ();
		@cMax = ();
		$normColMax = $normMax = 0;
		
		for ($q=1; $q <= scalar(@go1);$q++){
			$term1 = $map{$go1[$q-1]};
			#print "TERM 1:$term1\tTERM(S)2: ";	#check matrix row
			for($z=1; $z <= scalar(@go2); $z++){
				$term2 = $map{$go2[$z-1]};
				#print "$term2 ";		#checks matrix column
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
				#print "score $matrix{$q}{$z} \n";
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
%map = ();
