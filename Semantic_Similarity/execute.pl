my ($config) = @ARGV;
require "$config";

my $navigo_sem_path = get_navigo_sem_path();
system("perl $navigo_sem_path/get_rel_ancestors.pl $config\n");
system("perl $navigo_sem_path/compute_allSim.pl $config\n");
