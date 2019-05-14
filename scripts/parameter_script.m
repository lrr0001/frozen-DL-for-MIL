clear;
% this script defines all my MATLAB parameters
number_of_generating_dictionaries = 1;
list_of_witness_rates = 0.2;
list_of_imbalance_ratios = 0.2;
number_of_bag_label_sets = 1;
number_of_instance_label_sets = 1;
number_of_generating_coef_sets = 1;
list_of_gen_sparsity_levels = 4;
number_of_coef_sets = 1;
list_of_dl_sparsity_levels = 1:6;
list_of_lc_sparsity_levels = 1:8;
%list_of_cost_exp = 0:2:12;
list_of_cost_exp = 0:2:12;
%list_of_pca_r = 6:3:12;
list_of_pca_r = 6:3:12;
max_pca_r = max(list_of_pca_r);

number_of_classes = 4;

dimension = 16;

number_of_negative_dictionary_atoms = 16;

number_of_class_specific_dictionary_atoms = 8;

K = number_of_class_specific_dictionary_atoms*ones(1,number_of_classes);

number_of_bags.train = 2^10;
number_of_bags.val = 2^9;
number_of_bags.test = 2^10;

instances_per_bag = 16;

gen_sparsity_level = 4;

L_i(1) = 0; % if negative class, use 0 positive atoms
L_i(2) = 2; % if there is 1 positive class, use two positive atoms
L_i(3) = 1; % if 2 positive classes, use one atom from each class
L_i(4) = 1; % if 3 positive classes, use one atom from each class
L_i(5) = 1; % if 4 positive classes, use one atom from each class

%dl_sparsity_level = gen_sparsity_level;

dl_number_of_iterations = 150;

udl_dictionary_size = number_of_negative_dictionary_atoms + sum(K);

%lc_sparsity_level = dl_sparsity_level;

pca_normalize = false;

SDL_negative_dictsize = number_of_negative_dictionary_atoms + sum(K) - round(mean(K));

SDL_total_dictsize = number_of_negative_dictionary_atoms + sum(K);

%SDL_negative_sparsity_level = gen_sparsity_level;

SDL_negative_iternum = dl_number_of_iterations;

SDL_positive_iternum = dl_number_of_iterations;

%SDL_positive_sparsity_level = gen_sparsity_level;

vars = who;
load('r-eStatesAndPaths/absolute_paths.mat');
%save([experimentPath,'param_file.mat'],'-regexp','^(?!(experimentPath)$). ');
save([experimentPath,'param_file.mat'],vars{:});
