#!/usr/bin/perl
# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

my ($config) = @ARGV;
require "$config";

my $navigo_path = get_navigo_path();

#$file = "/home/khan27/Desktop/Ishita_Projects_May201/Group_Function_Prediction/Networks/GO_association/Data_Files/Human_uniprot_annot_full";				#filename = annotation.txt
$file = "annotation";
system("perl $navigo_path/get_rel_ancestors.pl $file $config\n");

system("perl $navigo_path/simRel_table_bp.pl $config\n");		#pairwise SS BP
system("perl $navigo_path/get_go_bp_score.pl $file $config\n");		#pairwise spec sens BP

system("perl $navigo_path/simRel_table_mf.pl $config\n");		#pairwise SS MF
system("perl $navigo_path/get_go_mf_score.pl $config\n");		#pairwise spec sens MF

system("perl $navigo_path/simRel_table_cc.pl $config\n");		#pairwise SS CC
system("perl $navigo_path/get_go_cc_score.pl $config\n");		#pairwise spec sens CC

system("perl $navigo_path/get_fun_sim2.pl\n");		#pairwise funsim score of input proteins

system("perl $navigo_path/get_all_pairs.pl $config\n");
system("perl $navigo_path/get_go_score.pl ALLpair_uniq.txt annotation.txt PAS $config\n");
system("perl $navigo_path/get_fun_sim_ias_pas_cas.pl PAS\n");		#pairwise funsim score of input proteins

system("perl $navigo_path/get_go_score.pl ALLpair_uniq.txt annotation.txt CAS $config\n");
system("perl $navigo_path/get_fun_sim_ias_pas_cas.pl CAS\n");		#pairwise funsim score of input proteins


system("perl $navigo_path/get_go_score.pl ALLpair_uniq.txt annotation.txt IAS $config\n");
system("perl $navigo_path/get_fun_sim_ias_pas_cas.pl IAS\n");		#pairwise funsim score of input proteins

system("mv Human_funsim_scores.txt Human_funsim_scores_comp.txt");
system("cat Human_funsim_scores_comp.txt | sort -k3 -g | tail -200 > Human_funsim_scores.txt");

system("mv Human_funsim_scores_MF.txt Human_funsim_scores_MF_comp.txt");
system("cat Human_funsim_scores_MF_comp.txt | sort -k3 -g | tail -200 > Human_funsim_scores_MF.txt");

system("mv Human_funsim_scores_BP.txt Human_funsim_scores_BP_comp.txt");
system("cat Human_funsim_scores_BP_comp.txt | sort -k3 -g | tail -200 > Human_funsim_scores_BP.txt");

system("mv Human_funsim_scores_CC.txt Human_funsim_scores_CC_comp.txt");
system("cat Human_funsim_scores_CC_comp.txt | sort -k3 -g | tail -200 > Human_funsim_scores_CC.txt");

system("mv Human_funsim_scores_BP+MF.txt Human_funsim_scores_BP+MF_comp.txt");
system("cat Human_funsim_scores_BP+MF_comp.txt | sort -k3 -g | tail -200 > Human_funsim_scores_BP+MF.txt");

system("mv Human_PAS_scores.txt Human_PAS_scores_comp.txt");
system("cat Human_PAS_scores_comp.txt | sort -k3 -g | tail -200 > Human_PAS_scores.txt");

system("mv Human_CAS_scores.txt Human_CAS_scores_comp.txt");
system("cat Human_CAS_scores_comp.txt | sort -k3 -g | tail -200 > Human_CAS_scores.txt");

system("mv Human_IAS_scores.txt Human_IAS_scores_comp.txt");
system("cat Human_IAS_scores_comp.txt | sort -k3 -g | tail -200 > Human_IAS_scores.txt");

system("python $navigo_path/combine_scores.py > combine_scores.txt");

system("sed -i '1s/^/Protein1 Protein2 FUNSIM MF BP CC BP+MF PAS CAS IAS\n/' combine_scores.txt | sed 's/ \{1,\}/,/g' combine_scores.txt > combine_scores.csv");

