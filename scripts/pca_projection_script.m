clear;
load('r-eStatesAndPaths/absolute_paths.mat');
% *** LOAD PARAMETERS ***
load([experimentPath,'param_file.mat'], ...
    'instances_per_bag', ...
    'number_of_bags');

% *** LOAD STRUCTURE AND SUPPORTING VARIABLES ***
load([experimentPath,'structure_file.mat']);

% *** MAKE NEW DIRECTORY IF IT DOESN'T ALREADY EXIST ***
nodePath = [experimentPath,'learned_coef/'];
mkdir(nodePath);


% *** ANONYMOUS FUNCTIONS FOR CHECKING DICTIONARY-LEARNING METHOD *** 
nodeCondition = @(node) isstreq(node,'dictionary_learning_method');
instantiationCondition = @(instantiation) isstreq(instantiation,'PCA');
condition = @(node,instance) ~nodeCondition(node) || ~instantiationCondition(instance);


% *** LOOP: LEARNED DICTIONARIES THAT USE PCA PROJECTION FOR COEFFICIENTS ***
for learned_dict_id_inst_cell = fields(experimentLayout.n.('learned_dictionary_identifier'))'
learned_dict_id_inst_str = learned_dict_id_inst_cell{1};
learned_dictionary_id = get_id_from_inst_field(learned_dict_id_inst_str);

% Check whether dictionary-learning method is PCA.
if experimentLayout.query('learned_dictionary_identifier',learned_dict_id_inst_str,condition)
    continue;
end

% Loop through learned dictionaries matching id
for child = experimentLayout.n.('learned_dictionary_identifier').(learned_dict_id_inst_str).children
if ~isstreq(child.node,'learned_dictionary')
    continue;
end
load(experimentLayout.n.(child.node).(child.instance).path,'learned_dictionary','gmat');


% *** IDENTIFY THE DATA IDENTIFIER CORRESPONDING TO LEARNED DICTIONARY ***
for parent = experimentLayout.n.('learned_dictionary_identifier').(learned_dict_id_inst_str).parents
    if ~isstreq(parent.node,'data_identifier')
        continue;
    end
    data_id_relative_node = parent;
    break;
end
data_id_inst_str = data_id_relative_node.instance;
data_id = get_id_from_inst_field(data_id_inst_str);

% *** IDENTIFY THE DATA-MEAN IDENTIFIER CORRESPONDING TO LEARNED_DICTIONARY ***
for parent = experimentLayout.n.('learned_dictionary_identifier').(learned_dict_id_inst_str).parents
    if ~isstreq(parent.node,'data_mean_identifier')
        continue;
    end
    data_mean_id_relative_node = parent;
    break;
end
data_mean_id_inst_str = data_mean_id_relative_node.instance;
data_mean_id = get_id_from_inst_field(data_mean_id_inst_str);

% Add learned-coefficients identifier to graph
learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('data_mean_identifier',data_mean_id), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

for child2 = experimentLayout.n.('data_identifier').(data_id_inst_str).children
if ~isstreq(child2.node,'data')
    continue;
end
load(experimentLayout.n.(child2.node).(child2.instance).path,'x_instances','datatype');


for child3 = experimentLayout.n.('data_mean_identifier').(data_mean_id_inst_str).children
if ~isstreq(child3.node,'data_mean_and_normalization_factor') % DNE, must be a bug
    continue;
end
load(experimentLayout.n.(child3.node).(child3.instance).path,'data_mean','row_normalization_factor');


x_demeaned = x_instances - data_mean*ones(1,size(x_instances,2));
x_normalized = x_demeaned./(row_normalization_factor*ones(1,size(x_demeaned,2)));
learned_coef = learned_dictionary'*x_normalized;
learned_coef_bags = bag_the_array(learned_coef,number_of_bags.(datatype),instances_per_bag);

% Add learned coefficients to the graph
nodeName = 'learned_coef';
coreParents = [relativeNode('coefficient_learning_method','projection'), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('data_mean_and_normalization_factor',data_mean_id), ...
    build_relative_node('learned_dictionary',learned_dictionary_id), ...
    build_relative_node('data',data_id,datatype)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,datatype);
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'learned_coef','learned_coef_bags');
inner = @(t) arrayfun(@(ii) py.list(full(t(:,ii)')),1:size(t,2),'UniformOutput',false);
outer = @(t) py.list(cellfun(@(t2) inner(t2),t,'UniformOutput',false));
py.python_save_tool.pickleSave([experimentPathPACE,'inputNodesPython/','learned_coef/',instantiationField,'.pickle'],py.list({outer(learned_coef_bags)}));

end
end
end
end




save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
