load('r-eStatesAndPaths/absolute_paths.mat')

load([experimentPath,'param_file.mat'], ...
    'pca_normalize');

load([experimentPath,'structure_file.mat']);
nodePath = [experimentPath,'data_mean_and_normalization_factor/'];
mkdir(nodePath);


for data_id_inst_cell = fields(experimentLayout.n.('data_identifier'))'
data_id = get_id_from_inst_field(data_id_inst_cell{1});
load([experimentPath,'data/',instanceNameFun.ms.('data')(data_id,'train'),'.mat'],'x_instances');
x_instances_train = x_instances;

data_mean_id = dec2hex(randi(2^28) - 1);
nodeName = 'data_mean_identifier';
parents = [build_relative_node('data_identifier',data_id), ...
    build_relative_node('PCA_normalize',pca_normalize), ...
    relativeNode('dictionary_learning_method','PCA')];
instantiationField = instanceNameFun.ms.(nodeName)(data_mean_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

data_mean = mean(x_instances_train,2);
demeaned_x = x_instances_train - data_mean*ones(1,size(x_instances_train,2));
if pca_normalize
    row_normalization_factor = sqrt(sum(demeaned_x.^2,2));
    if any(row_normalization_factor < 1e-10)
        warning('normalization factor for PCA close to zero');
        row_normalization_factor(row_normalization_factor < 1e-10) = 1;
    end
else
    row_normalization_factor = ones(size(data_mean));
end

nodeName = 'data_mean_and_normalization_factor';
parents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('data_mean_identifier',data_mean_id), ...
    build_relative_node('PCA_normalize',pca_normalize), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(data_mean_id);
instantiationPath = [nodePath,instantiationField];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'row_normalization_factor','data_mean');

end

save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
