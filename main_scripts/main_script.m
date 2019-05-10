rng('shuffle');
clear;
addpath('scripts');
addpath('tools');
addpath('classDefs');
build_experiment_path;
addAbsolutePaths;
build_PACE_staging_folder;
prelist_nodes;
parameter_script;
build_parameter_instantiations_script;
generate_dictionaries_script;
generate_bag_labels_script;
generate_instance_labels_script;
generate_coefficients_script;
generate_data_script;
numberOfSubtasks = udl_ksvd_script(true);
generate_unsupervised_ksvdPBS(numberOfSubtasks);
numberOfSubtasks = sdl_frzn_ksvd_script(true);
generate_supervised_frozen_ksvdPBS(numberOfSubtasks);
numberOfSubtasks = sparse_coding_script(true);
generate_sparse_codingPBS(numberOfSubtasks);
copyNodesToStaging('bag_labels');
copyNodesToStaging('data');
demean_and_normalize_script;
udl_pca_script;