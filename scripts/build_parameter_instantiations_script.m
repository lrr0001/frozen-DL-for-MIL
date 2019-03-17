load('structure.mat');

nodeName = 'number_of_classes';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(number_of_classes);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'dimension';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(dimension);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'number_of_negative_dictionary_atoms';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(number_of_negative_dictionary_atoms);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = build_relative_node('number_of_classes',number_of_classes);
nodeName = 'K';
instantiationField = instanceNameFun.ms.(nodeName)(K);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'dataset_type';
parents = [];
instantiationField = 'train';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'val';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'test';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'number_of_bags';

parents = relativeNode('dataset_type','train');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_train,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = relativeNode('dataset_type','val');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_val,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = relativeNode('dataset_type','test');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_test,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'imbalance_ratio';
parents = [];
for imbalance_ratio = list_of_imbalance_ratios
    instantiationField = instanceNameFun.ms.(nodeName)(imbalance_ratio);
    experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end


nodeName = 'instances_per_bag';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(instances_per_bag);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'witness_rate';
parents = relativeNode('number_of_classes',instanceNameFun.ms.('number_of_classes')(number_of_classes));
for wr = list_of_witness_rates
    witness_rate = wr*ones(1,number_of_classes);
    instantiationField = instanceNameFun.ms.(nodeName)(witness_rate);
    experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end


nodeName = 'gen_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(gen_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'Li';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(L_i);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'DL_sparsity_level';
parents = [];
nodeAbrev = 'DL_L';
instanceNameFun.ms.(nodeName) = @(dl_L) sprintf('%s%d',nodeAbrev,dl_L);
instantiationField = instanceNameFun.ms.(nodeName)(dl_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'DL_number_of_iterations';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(dl_number_of_iterations);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'UDL_dictionary_size';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(udl_dictionary_size);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'dictionary_learning_method';
parents = [];
instantiationField = 'unsupervised_KSVD';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'frozen_KSVD';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'PCA';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_coef_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(lc_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'PCA_r';
parents = [];
nodeAbrev = 'r';
instanceNameFun.ms.(nodeName) = @(r) sprintf('%s%d',nodeAbrev,r);
instantiationField = instanceNameFun.ms.(nodeName)(pca_r);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'PCA_normalize';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(pca_normalize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_negative_dictionary_size';
parents = [build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_dictsize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_total_dictionary_size';
parents = [build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_total_dictsize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_negative_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_negative_number_of_iterations';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_iternum);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_positive_number_of_iterations';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_iternum);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'SDL_positive_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_positive_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'class';
parents = [];
for cc = 1:number_of_classes
    instantiationField = instanceNameFun.ms.(nodeName)(cc);
    experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end

save('structure.mat','experimentLayout','-append');