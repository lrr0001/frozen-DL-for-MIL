function kk = sdl_frzn_ksvd_script(usePACE)
% Check if prepping PACE or computing on current machine.
if nargin < 1
    usePACE = false;
end
% kk captures how many dictionaries we've prepped to learn using PACE.
if nargout > 0 && ~usePACE
    error('output only used in PACE mode');
end

% dependencies will capture all that is necessary to prep for PACE
if usePACE
    dependencies = sdl_frzn_ksvd_struct;
    kk = 0;
end
load('r-eStatesAndPaths/absolute_paths.mat');

% should load list_of_dl_sparsity_levels instead of + and -
% load all relevant parameters from param_file.mat'
load([experimentPath,'param_file.mat'], ...
    'SDL_negative_dictsize', ...
    'SDL_total_dictsize', ...
    'list_of_dl_sparsity_levels', ...
    'SDL_negative_iternum', ...
    'SDL_positive_iternum', ...
    'number_of_classes');

load([experimentPath,'structure_file.mat']);

% Loop through all data identifiers.
for data_id_inst_cell = fields(experimentLayout.n.('data_identifier'))'
data_id_inst_str = data_id_inst_cell{1};
data_id = get_id_from_inst_field(data_id_inst_str);
% relative path works in PACE and on computer
dataPath = ['data/',instanceNameFun.ms.('data')(data_id,'train'),'.mat'];
if ~usePACE
    load([experimentPath,dataPath],'x');
    x_train = x;
end

% Find the bag-labels identifier corresponding to the current
% data identifier.
%{
for data_parent = experimentLayout.n.('data_identifier').(data_id_inst_str).parents
    if ~isstreq(data_parent.node,'generating_coefficients_identifier')
        continue;
    end
    coef_relative = data_parent;
    break
end
for coef_parent = experimentLayout.n.(coef_relative.node).(coef_relative.instance).parents
    if ~isstreq(coef_parent.node,'instance_labels_identifier')
        continue;
    end
    instance_labels_relative = coef_parent;
    break;
end
for inst_labels_parent = experimentLayout.n.(instance_labels_relative.node).(instance_labels_relative.instance).parents
    if ~isstreq(inst_labels_parent.node,'bag_labels_identifier')
        continue;
    end
    bag_labels_id_inst_str = inst_labels_parent.instance;
    bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);
    break;
end
%}
nodeCondition = @(node) isstreq(node,'bag_labels_identifier');
for bag_labels_identifier_search = fields(experimentLayout.n.('bag_labels_identifier'))'
    bag_labels_id_inst_str = bag_labels_identifier_search{1};
    instantiationCondition = @(instantiation) isstreq(instantiation,bag_labels_id_inst_str);
    condition = @(node,instantiation) ~(nodeCondition(node) && instantiationCondition(instantiation));
    if subDirectionQuery(experimentLayout,'data_identifier',data_id_inst_str,condition,'parents')
        continue;
    end
    bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);
    break;
end

%relative path
bagLabelsPath = ['bag_labels/',instanceNameFun.ms.('bag_labels')(bag_labels_id,'train')];
if ~usePACE
    load([experimentPath,bagLabelsPath],'bag_labels');
    bag_labels_train = bag_labels;
end

for dl_sparsity_level = list_of_dl_sparsity_levels
SDL_negative_sparsity_level = dl_sparsity_level;
SDL_positive_sparsity_level = dl_sparsity_level;

% assign a learned-dictionary identifier.
learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = [relativeNode('dictionary_learning_method','supervised_frozen_KSVD'), ...
    build_relative_node('data_identifier',data_id), ...
    build_relative_node('bag_labels_identifier',bag_labels_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

% List all dependencies except class.
coreParents = [relativeNode('dictionary_learning_method','supervised_frozen_KSVD'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('SDL_negative_dictionary_size',SDL_negative_dictsize), ...
    build_relative_node('SDL_total_dictionary_size',SDL_total_dictsize), ...
    build_relative_node('SDL_negative_sparsity_level',SDL_negative_sparsity_level), ...
    build_relative_node('SDL_positive_sparsity_level',SDL_positive_sparsity_level), ...
    build_relative_node('SDL_negative_number_of_iterations',SDL_negative_iternum), ...
    build_relative_node('SDL_positive_number_of_iterations',SDL_positive_iternum), ...
    build_relative_node('data',data_id,'train'), ...
    build_relative_node('bag_labels',bag_labels_id,'train'), ...
    build_relative_node('number_of_classes',number_of_classes)];


frzn_ksvd_param.negative_dictsize = SDL_negative_dictsize;
frzn_ksvd_param.negative_Tdata = SDL_negative_sparsity_level;
frzn_ksvd_param.negative_iternum = SDL_negative_iternum;
frzn_ksvd_param.total_dictsize = SDL_total_dictsize;
frzn_ksvd_param.total_tdata = SDL_positive_sparsity_level;
frzn_ksvd_param.positive_iternum = SDL_positive_iternum;

for cc = 1:number_of_classes
    % add learned dictionary instanstiation to layout
    instantiationField = instanceNameFun.ms.('learned_dictionary')(learned_dictionary_id,cc);
    parents = [coreParents,build_relative_node('class',cc)];
    learnedDictionaryPath = ['learned_dictionary/',instantiationField,'.mat'];
    instantiationPath = [experimentPath,learnedDictionaryPath];
    experimentLayout.add_instantiation('learned_dictionary',instantiationField,nodeInstance(parents,instantiationPath));
    class = cc;
    if usePACE
        kk = kk + 1;
        dependencies(kk) = sdl_frzn_ksvd_struct(dataPath,bagLabelsPath,frzn_ksvd_param,class,learnedDictionaryPath);
    else
        learned_dictionary = MIL_supervised_ksvd(x_train,bag_labels_train(cc,:),frzn_ksvd_param);
        gmat = learned_dictionary'*learned_dictionary;
    end

    if ~usePACE
         save(instantiationPath,'learned_dictionary','gmat','class');
    end
end
end
end
if usePACE
    save([experimentPathPACE,'dependencies/sdl_fzn_dependencies.mat'],'dependencies');
%    generate_sdl_frzn_PBS(experimentPath,kk)
end
save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
end
