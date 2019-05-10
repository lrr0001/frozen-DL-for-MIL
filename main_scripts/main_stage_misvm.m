addpath('scripts');
addpath('tools');
addpath('classDefs');
numberOfSubtasks = mi_svm_script();
misvm_ii = generate_mi_svmPBS(numberOfSubtasks);
generate_misvm_retrialPBS(misvm_ii);
generate_joint_PBS_bash_script;
