function kk = udl_ksvd_script(usePACE)
% Check if prepping PACE or computing on current machine.
if nargin < 1
    usePACE = false;
end
% kk captures how many dictionaries we've prepped to learn using PACE.
if nargout > 0 && ~usePACE
    error('Too many outputs; output only used in PACE mode');
end
if usePACE
    dependencies = udl_ksvd_struct;
    kk = 0;
end
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'dl_sparsity_level', ...
    'dl_number_of_iterations', ...
    'udl_dictionary_size');
load([experimentPath,'structure_file.mat']); 
mkdir([experimentPath,'learned_dictionary/']);
if usePACE
    mkdir([experimentPathPACE,'inputNodesMATLAB/learned_dictionary']);
    mkdir([experimentPathPACE,'outputNodesMATLAB/learned_dictionary']);
end



for data_id_inst_cell = fields(experimentLayout.n.('data_identifier'))'
data_id = get_id_from_inst_field(data_id_inst_cell{1});
dataPath = ['data/',instanceNameFun.ms.('data')(data_id,'train'),'.mat'];
if ~usePACE
    load([experimentPath,dataPath],'x_instances');
    x_instances_train = x_instances;
end



udl_ksvd_param.Tdata = dl_sparsity_level;
udl_ksvd_param.iternum = dl_number_of_iterations;
udl_ksvd_param.dictsize = udl_dictionary_size;
if ~usePACE
    udl_ksvd_param.data = x_instances_train;
end

learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = [build_relative_node('data_identifier',data_id), ...
    relativeNode('dictionary_learning_method','unsupervised_KSVD')];
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
learnedDictionaryPath = ['learned_dictionary/',instantiationField,'.mat'];
instantiationPath = [experimentPath,learnedDictionaryPath];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));

if ~usePACE
    %learned_dictionary = ksvd(param);
    learned_dictionary = 1;
    gmat = learned_dictionary'*learned_dictionary;
else
    kk = kk + 1;
    dependencies(kk) = udl_ksvd_struct(dataPath,udl_ksvd_param,learnedDictionaryPath);
end


if ~usePACE
    save(instantiationPath,'learned_dictionary','gmat');
end

end

if usePACE
    save([experimentPathPACE,'dependencies/udl_ksvd_dependencies.mat'],'dependencies');
end

save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
end