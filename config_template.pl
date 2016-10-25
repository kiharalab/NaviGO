#!/usr/bin/perl
use strict;
use warnings;


sub get_data_file_path {
my (@ym) = (localtime($^T))[5,4]; $ym[0] += 1900; 
$ym[1]++;
my $suffix = "";
my $dbname = sprintf "GO_" . qq{%4d%02d} . $suffix, @ym;
return "/XXX/".$dbname."/"; };


sub get_navigo_path {
return "/XXX/"; };


sub get_navigo_sem_path {
return "/XXX/"; };


sub get_ias_path {
return "/XXX"; };


sub get_pas_path {
return "/XXX"; };


sub get_cas_path {
return "/XXX"; };


1;
