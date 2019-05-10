addpath('scripts');
addpath('tools');
addpath('classDefs');
numberOfSubtasks = mi_svm_script();
generate_mi_svmPBS(numberOfSubtasks);
generate_misvm_retrialPBS;

