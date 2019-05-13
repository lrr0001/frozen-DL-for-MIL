function kk = sparse_coding_script(usePACE)
if nargin < 1
    usePACE = false;
end
if nargout > 0 && ~usePACE
    error('too many outputs without using PACE');
end

if usePACE
    dependencies = sc_struct;
    kk = 0;
end


load('r-eStatesAndPaths/absolute_paths.mat');

% *** LOAD PARAMETERS ***
load([experimentPath,'param_file.mat'], ...
    'lc_sparsity_level', ...
    'instances_per_bag');

% *** LOAD STRUCTURE AND SUPPORTING VARIABLES ***
load([experimentPath,'structure_file.mat']);

% *** MAKE NEW DIRECTORY IF IT DOESN'T ALREADY EXIST ***
mkdir([experimentPath,'learned_coef/']);
if usePACE
    mkdir([experimentPathPACE,'inputNodesMATLAB/learned_coef']);
    mkdir([experimentPathPACE,'outputNodesMATLAB/learned_coef']);
    mkdir([experimentPathPACE,'inputNodesPython/learned_coef']);
    mkdir([experimentPathPACE,'outputNodesPython/learned_coef']);
end


% *** ANONYMOUS FUNCTIONS FOR CHECKING DICTIONARY-LEARNING METHOD *** 
nodeCondition = @(node) isstreq(node,'dictionary_learning_method');
instantiationCondition1 = @(instantiation) isstreq(instantiation,'unsupervised_KSVD');
instantiationCondition2 = @(instantiation) isstreq(instantiation,'supervised_frozen_KSVD');
condition1 = @(node,instance) ~nodeCondition(node) || ~instantiationCondition1(instance);
condition2 = @(node,instance) ~nodeCondition(node) || ~instantiationCondition2(instance);


% *** LOOP: LEARNED DICTIONARIES THAT USE SPARSE CODING FOR COEFFICIENTS ***
for learned_dict_id_inst_cell = fields(experimentLayout.n.('learned_dictionary_identifier'))'
learned_dict_id_inst_str = learned_dict_id_inst_cell{1};
learned_dictionary_id = get_id_from_inst_field(learned_dict_id_inst_str);

% Check whether dictionary-learning method is supervised.
if ~experimentLayout.query('learned_dictionary_identifier',learned_dict_id_inst_str,condition1)
    supervised = false;
elseif ~experimentLayout.query('learned_dictionary_identifier',learned_dict_id_inst_str,condition2)
    supervised = true;
else
    continue;
end

% *** IDENTIFY THE DATA IDENTIFIER CORRESPONDING TO LEARNED DICTIONARY ***
for parent = experimentLayout.n.('learned_dictionary_identifier').(learned_dict_id_inst_str).parents
if ~isstreq(parent.node,'data_identifier')
    continue;
end
data_id_inst_str = parent.instance;
data_id = get_id_from_inst_field(data_id_inst_str);

% *** ADD LEARNED COEFFICIENT IDENTIFIER TO GRAPH ***
learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [relativeNode('coefficient_learning_method','OMP'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

% Either looping through classes (if supervised) or selecting the one
% learned dictionary (unsupervised)
for child = experimentLayout.n.('learned_dictionary_identifier').(learned_dict_id_inst_str).children
if ~isstreq(child.node,'learned_dictionary')
    continue;
end

% Load learned dictionary, (need class if DL method is supervised)
if ~usePACE
    if supervised
        load(experimentLayout.n.(child.node).(child.instance).path,'learned_dictionary','gmat','class');
    else
        load(experimentLayout.n.(child.node).(child.instance).path,'learned_dictionary','gmat');
    end
else
    if supervised
        for parent = experimentLayout.n.(child.node).(child.instance).parents
            if ~isstreq(parent.node,'class')
                continue;
            end
            class = get_class_from_inst_field(parent.instance);
            break;
        end
    end
    learnedDictionaryPath = [child.node,'/',child.instance];
end


% *** FOR EACH DATA INSTANTIATION CORRESPONDING TO DATA IDENTIFIER ***
for child2 = experimentLayout.n.('data_identifier').(data_id_inst_str).children
if ~isstreq(child2.node,'data')
    continue;
end
if ~usePACE
    load(experimentLayout.n.(child2.node).(child2.instance).path,'x_instances','datatype');
else
    load(experimentLayout.n.(child2.node).(child2.instance).path,'datatype');
    dataPath = [child2.node,'/',child2.instance];
end

% *** ADD LEARNED COEFFICIENTS TO GRAPH ***
nodeName = 'learned_coef';
coreParents = [relativeNode('coefficient_learning_method','OMP'), ...
    relativeNode('dataset_type',datatype), ...
    build_relative_node('learned_coefficients_identifier',learned_coef_id), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('learned_coef_sparsity_level',lc_sparsity_level), ...
    build_relative_node('data',data_id,datatype)];

if supervised
    parents = [coreParents,build_relative_node('learned_dictionary',learned_dictionary_id,class),build_relative_node('class',class)];
    instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,class,datatype);
else
    parents = [coreParents,build_relative_node('learned_dictionary',learned_dictionary_id)];
    instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,datatype);
end
learnedCoefPath = ['learned_coef/',instantiationField];
instantiationPath = [experimentPath,learnedCoefPath];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,[instantiationPath,'.mat']));

% *** LEARN COEFFICIENTS ***
if ~usePACE
%{
learned_coef = omp(learned_dictionary'*x_instances,gmat,lc_sparsity_level);
learned_coef_bags = bag_the_array(learned_coef,instances_per_bag);
%}
learned_coef = 1;
learned_coef_bags = 1;
else
    param.sl = lc_sparsity_level;
    param.ipb = instances_per_bag;
    kk = kk + 1;
    dependencies(kk) = sc_struct(learnedDictionaryPath,dataPath,param,learnedCoefPath);
end
if ~usePACE
    if supervised
        save(instantiationPath,'learned_coef_bags','class','datatype');
    else
        save(instantiationPath,'learned_coef_bags','datatype');
    end
end


end
end
end
end
if usePACE
    save([experimentPathPACE,'dependencies/sc_dependencies.mat'],'dependencies');
end
save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
end
