#!/usr/bin/perl

use strict;
use DBI;


# ----- SQL Stuff ----

our ($db_host,$db_login,$db_password);
require './access.inc';

my (@ym) = (localtime($^T))[5,4]; $ym[0] += 1900; 
$ym[1]++;
my $suffix = "";
my $dbname = sprintf "GO_" . qq{%4d%02d} . $suffix, @ym;
my $dbh;

eval {
    $dbh = DBI->connect("DBI:mysql:$dbname:$db_host",$db_login,$db_password, { RaiseError => 0, PrintError => 0 });
};
if( $dbh) {
    print "$dbname exists...\n";
          
} else {
    print "$dbname does not exists...\n";
    download_go_con($dbname, $db_login, $db_password);  
}

my $path = "./tmp/GO_ALL.txt";
if (-e $path)
{ 
    print "GO_ALL.txt exists...\n";
} else {
    get_all_go_txt($dbname, $db_login, $db_password, $path);
}

my $table = "GO_CATEGORY";
generate_go_category_table_txt($dbname, $db_host, $db_login, $db_password, $table);

$path = "./tmp/GO_category.txt";
if (-e $path)
{ 
    print "GO_category.txt exists...\n";
} else {
    get_go_category_txt($dbname, $db_login, $db_password, $path);
}

reformat_go_category_txt($dbname);
separate_go_all($dbname);

get_go_map_txt($dbname, $db_login, $db_password);

my $uniprot_base_path = "./tmp/uniprot_sprot.dat";
if (-e $uniprot_base_path)
{ 
    print "Uniprot_sprot.dat exists...\n"
} else {
    print "Downloading uniprot...\n";
    download_uniprot_reviewed();
}

update_data_fast_funsim($dbname);
cleanup();

sub cleanup() {
    print "cleaning up files in tmp...\n";
    `rm ./tmp/*`;
}

sub update_data_fast_funsim($dbname) {
    `./calculate_pc/run.sh`;
    `cp -r tmp $dbname`;
}


sub download_go_con ($dbname, $db_login, $db_password) {
    print "Start to download...\n";
    `wget http://archive.geneontology.org/latest-full/go_monthly-termdb-data.gz`;
    `mv go_monthly-termdb-data.gz tmp/.`;

    print "Creating db:" . $dbname . "\n";

    `gunzip tmp/go_monthly-termdb-data.gz`;
    `echo "create database $dbname" | mysql --user=$db_login --password=$db_password`;
    `mysql --user=$db_login --password=$db_password $dbname < ./tmp/go_monthly-termdb-data`;

    print "Removing tmp files...\n";
    `rm -r ./tmp/*`;
    print "Tmp files removed...\n";
}

sub download_uniprot_reviewed() {
    `wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz`;
    `mv uniprot_sprot.dat.gz tmp/.`;
    `gunzip tmp/uniprot_sprot.dat.gz`;
}

sub get_all_go_txt ($dbname, $db_login, $db_password, $path) {
    print "Generating go all tmp file...\n";
    `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/get_all_go.sql | tail -n +2 > $path`;
}

sub get_go_category_txt ($dbname, $db_login, $db_password, $path) {
    print "Generating go category tmp file...\n";
    `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/get_go_category.sql | tail -n +2 > $path`;
}

sub get_go_map_txt ($dbname, $db_login, $db_password, $path) {
    print "Generating go map file...\n";
    `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/get_bp_go_map.sql | tail -n +2 > ./tmp/BP_GO_MAP.txt`;
    `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/get_mf_go_map.sql | tail -n +2 > ./tmp/MF_GO_MAP.txt`;
    `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/get_cc_go_map.sql | tail -n +2 > ./tmp/CC_GO_MAP.txt`;
}

sub reformat_go_category_txt ($dbname) {
    print "Reformat go category tmp file...\n";
    `python ./py_scripts/parseCategory.py -i ./tmp/GO_category.txt -o ./tmp/GO_category_format.txt`;
}

sub separate_go_all ($dbname) {
    print "Generating go GO_BPO.txt...\n";
    `python ./py_scripts/parseGOALL.py -i ./tmp/GO_ALL.txt -c ./tmp/GO_category.txt -k p -o ./tmp/GO_BPO.txt`;
    print "Generating go GO_CCO.txt...\n";
    `python ./py_scripts/parseGOALL.py -i ./tmp/GO_ALL.txt -c ./tmp/GO_category.txt -k c -o ./tmp/GO_CCO.txt`;
    print "Generating go GO_MFO.txt...\n";
    `python ./py_scripts/parseGOALL.py -i ./tmp/GO_ALL.txt -c ./tmp/GO_category.txt -k f -o ./tmp/GO_MFO.txt`;
}

sub generate_go_category_table_txt ($dbname, $db_host, $db_login, $db_password, $table) {
    my $db=DBI->connect("DBI:mysql:$dbname:$db_host",$db_login,$db_password, { RaiseError => 0, PrintError => 0 });
    our($sql, $dbq);
    $sql = "SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = '$dbname'
    AND table_name = '$table';";
    my ($exists) = $db->selectrow_array($sql);

    if ($exists eq $table){
        print "$table Table exists\n"
    }
    else{
        print "No such $table table\n";
        print "Generating GO_CATEGORY table...\n";
        `mysql --user=$db_login --password=$db_password $dbname < ./sql_scripts/generate_go_category_table.sql`;
    }
}

