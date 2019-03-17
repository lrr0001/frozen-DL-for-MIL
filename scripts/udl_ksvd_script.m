load('param_file.mat', ...
    'dl_sparsity_level', ...
    'dl_number_of_iterations', ...
    'udl_dictionary_size');
load('structure_file.mat'); 




udl_ksvd_param.Tdata = dl_sparsity_level;
udl_ksvd_param.iternum = dl_number_of_iterations;
udl_ksvd_param.dictsize = udl_dictionary_size;
udl_ksvd_param.data = x_instances_train;
%ul_ksvd_dct = ksvd(param);
ul_ksvd_dct = 1;
learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = build_relative_node('data_identifier',data_id);
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_dictionary';
parents = [relativeNode('dictionary_learning_method','unsupervised_KSVD'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('UDL_dictionary_size',udl_dictionary_size), ...
    build_relative_node('DL_sparsity_level',dl_sparsity_level), ...
    build_relative_node('DL_number_of_iterations',dl_number_of_iterations), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


save('structure_file.mat','experimentLayout','-append');
