load('param_file.mat', ...
    'pca_r', ...
    'pca_normalize');
load('structure_file.mat');



pca_param.r = pca_r;
pca_param.x = x_instances_train;
pca_param.normalize = pca_normalize;
if pca_param.normalize
    [ul_pca_dct,ul_pca_coef_train,data_mean,normalization_factor] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*((x_instances_val - data_mean*ones(1,size(x_instances_val,2)))./(normalization_factor*ones(1,size(x_instances_val,2))));
    ul_pca_coef_test = ul_pca_dct'*(x_instances_test- data_mean*ones(1,size(x_instances_test,2))./(normalization_factor*ones(1,size(x_test_instaces,2))));
else
    [ul_pca_dct,ul_pca_coef_train,data_mean] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*(x_instances_val - data_mean*ones(1,size(x_instances_val,2)));
    ul_pca_coef_test = ul_pca_dct'*(x_instances_test- data_mean*ones(1,size(x_instances_test,2)));
end
ul_pca_coef_bags_train = bag_the_array(ul_pca_coef_train,number_of_bags_train,instances_per_bag);
ul_pca_coef_bags_val = bag_the_array(ul_pca_coef_val,number_of_bags_val,instances_per_bag);
ul_pca_coef_bags_test = bag_the_array(ul_pca_coef_test,number_of_bags_test,instances_per_bag);

learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = build_relative_node('data_identifier',data_id);
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_dictionary';
parents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('PCA_normalize',pca_normalize), ...
    build_relative_node('PCA_r',pca_r), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

data_mean_id = dec2hex(randi(2^28) - 1);
nodeName = 'data_mean_and_normalization_factor';
parents = [build_relative_node('data',data_id,'train'), ...
    build_relative_node('PCA_normalize',pca_normalize)];

instantiationField = instanceNameFun.ms.(nodeName)(data_mean_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'learned_coef';
coreParents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('data_mean_and_normalization_factor',data_mean_id), ...
    build_relative_node('learned_dictionary',learned_dictionary_id)];

parents = [coreParents, ...
    build_relative_node('data',data_id,'train'), ...
    build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, ...
    build_relative_node('data',data_id,'val'), ...
    build_relative_node('number_of_bags',number_of_bags_val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents)); 

parents = [coreParents, ...
    build_relative_node('data',data_id,'test'), ...
    build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


















save('structure_file.mat','experimentLayout','-append');
