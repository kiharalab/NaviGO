#!/bin/bash

pushd /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/tmp
perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/getAncestors.pl
perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/getChildren.pl

perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/1_go_freq.pl
perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/2_calc_freq_ancestorProp.pl
perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/3_root_anno.pl
perl /bio/kihara-web/www/webdklab/website_software/Fast-Funsim/AutoUpdate/calculate_pc/4_calc_pc.pl

popd
