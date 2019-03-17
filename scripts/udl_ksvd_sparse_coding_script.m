load('param_file.mat', ...
    'lc_sparsity_level', ...
    'instances_per_bag');
load('structure_file.mat');


ul_ksvd_Gmat = ul_ksvd_dct'*ul_ksvd_dct;
%{
ul_ksvd_coef_train = omp(ul_ksvd_dct'*x_instances_train,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_train = bag_the_array(ul_ksvd_coef_train,instances_per_bag);
ul_ksvd_coef_val = omp(ul_ksvd_dct'*x_instances_val,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_val = bag_the_array(ul_ksvd_coef_val,instances_per_bag);
ul_ksvd_coef_test = omp(ul_ksvd_dct'*x_instances_test,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_test = bag_the_array(ul_ksvd_coef_test,instances_per_bag);
%}
learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_coef';
coreParents = [relativeNode('dictionary_learning_method','unsupervised_KSVD'), ...
    build_relative_node('learned_coefficients_identifier',learned_coef_id), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('learned_coef_sparsity_level',lc_sparsity_level), ...
    build_relative_node('learned_dictionary',learned_dictionary_id)];

parents = [coreParents,build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents,build_relative_node('data',data_id,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents)); 

parents = [coreParents,build_relative_node('data',data_id,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

save('structure_file.mat','experimentLayout','-append');
