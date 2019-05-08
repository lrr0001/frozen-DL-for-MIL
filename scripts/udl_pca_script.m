clear;
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'pca_normalize', ...
    'max_pca_r');
load([experimentPath,'structure_file.mat']);
nodePath = [experimentPath,'learned_dictionary/'];

% Loop through data-mean identifiers and load means.
for data_mean_id_inst_cell = fields(experimentLayout.n.('data_mean_identifier'))
data_mean_id_inst_str = data_mean_id_inst_cell{1};
data_mean_id = get_id_from_inst_field(data_mean_id_inst_str);
load([experimentPath,'data_mean_and_normalization_factor/',instanceNameFun.ms.('data_mean_and_normalization_factor')(data_mean_id)],'row_normalization_factor','data_mean');

% find corresponding data identifier
for data_mean_id_parent_node = experimentLayout.n.('data_mean_identifier').(data_mean_id_inst_str).parents
    if isstreq(data_mean_id_parent_node.node,'data_identifier')
         data_id_relative_node = data_mean_id_parent_node;
         break;
    end
end
data_id = get_id_from_inst_field(data_id_relative_node.instance);

% load training data
load([experimentPath,'data/',instanceNameFun.ms.('data')(data_id,'train'),'.mat'],'x_instances');
x_instances_train = x_instances;

% generate learned dictionary identifier. Add to experiment-structure
% graph.
learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('data_mean_identifier',data_mean_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

% learn the dictionary from training data
demeaned_x = x_instances_train - data_mean*ones(1,size(x_instances_train,2));
normalized_x = demeaned_x./(row_normalization_factor*ones(1,size(x_instances_train,2)));
[full_learned_dictionary,~,~] = svd(normalized_x,'econ');
learned_dictionary = full_learned_dictionary(:,1:max_pca_r);
gmat = learned_dictionary'*learned_dictionary;

% add learned dictionary to experiment-structure graph and save.
nodeName = 'learned_dictionary';
parents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('max_PCA_r',max_pca_r), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_mean_and_normalization_factor',data_mean_id), ...
    build_relative_node('PCA_normalize',pca_normalize), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'learned_dictionary','gmat');


end


save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
