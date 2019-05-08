addpath('classDefs');
addpath('scripts');
addpath('tools');
numberOfSubtasks = udl_ksvd_script(true);
generate_unsupervised_ksvdPBS(numberOfSubtasks);
numberOfSubtasks = sdl_frzn_ksvd_script(true);
generate_supervised_frozen_ksvdPBS(numberOfSubtasks);
numberOfSubtasks = sparse_coding_script(true);
generate_sparse_codingPBS(numberOfSubtasks);

