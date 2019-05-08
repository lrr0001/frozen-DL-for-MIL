function kk = mat_to_pickle_script(usePACE)
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
    dependencies = mat_to_pickle_struct;
    kk = 0;
end
load('r-eStatesAndPaths/absolute_paths.mat');
% load all relevant parameters from param_file.mat'
load([experimentPath,'param_file.mat']);

load([experimentPath,'structure_file.mat']);

% Loop through learned coefficients
for learned_coef_id_inst_cell = fields(experimentLayout.n.('learned_coefficients_identifier'))'
learned_coef_id_inst_str = learned_coef_id_inst_cell{1};
learned_coef_id = get_id_from_inst_field(learned_coef_id_inst_str);

% Find data identifier corresponding to current learned coef ID.
for lci_parent = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).parents
    if ~isstreq(lci_parent.node,'data_identifier')
        continue;
    end
    data_id_inst_str = lci_parent.instance;
    break;
end
data_id = get_id_from_inst_field(data_id_inst_str);

% Determine whether DLM is supervised
for lci_parent = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).parents
    if ~isstreq(lci_parent.node,'learned_dictionary_identifier')
        continue;
    end
    ldi_inst_str = lci_parent.instance;
    break;
end
for ldi_parent = experimentLayout.n.('learned_dictionary_identifier').(ldi_inst_str).parents
    if ~isstreq(ldi_parent.node,'dictionary_learning_method')
        continue;
    end
    supervised = dlm_issupervised(ldi_parent.instance);
end

% Find the bag-labels identifier corresponding to the current
% data identifier.
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
    break;
end
bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);

for learned_coef_relativeNode = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).children
if ~isstreq(learned_coef_relativeNode.node,'learned_coef')
    continue;
end






% relative path works in PACE and on computer
dataPath = ['data/',instanceNameFun.ms.('data')(data_id,'train'),'.mat'];
if ~usePACE
    load([experimentPath,dataPath],'x');
    x_train = x;
end
%relative path
bagLabelsPath = ['bag_labels/',instanceNameFun.ms.('bag_labels')(bag_labels_id,'train')];
if ~usePACE
    load([experimentPath,bagLabelsPath],'bag_labels');
    bag_labels_train = bag_labels;
end



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
%    learned_dictionary = MIL_supervised_ksvd(x_train,bag_labels_train(cc,:),frzn_ksvd_param);
        learned_dictionary = 1;
        gmat = learned_dictionary'*learned_dictionary;
    end

    if ~usePACE
         save(instantiationPath,'learned_dictionary','gmat','class');
    end
end
end
end
end
if usePACE
    save([experimentPathPACE,'dependencies/sdl_fzn_dependencies.mat'],'dependencies');
%    generate_sdl_frzn_PBS(experimentPath,kk)
end
end
save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
end