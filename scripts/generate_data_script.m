clear;
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'number_of_bags');
load([experimentPath,'structure_file.mat']); 
nodePath = [experimentPath,'data/'];
mkdir(nodePath);


for dictionary_id_inst_cell = fields(experimentLayout.n.('generating_dictionary_identifier'))'
dict_id = get_id_from_inst_field(dictionary_id_inst_cell{1});
load([experimentPath,'dictionary/',instanceNameFun.ms.('dictionary')(dict_id),'.mat'],'generating_dictionary');


for coef_id_inst_cell = fields(experimentLayout.n.('generating_coefficients_identifier'))'
coef_id_inst_str = coef_id_inst_cell{1};
coef_id = get_id_from_inst_field(coef_id_inst_str);

data_id = dec2hex(randi(2^28) - 1);
nodeName = 'data_identifier';
parents = [build_relative_node('generating_coefficients_identifier',coef_id), ...
    build_relative_node('generating_dictionary_identifier',dict_id)];
instantiationField = instanceNameFun.ms.(nodeName)(data_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

for child = experimentLayout.n.('generating_coefficients_identifier').(coef_id_inst_str).children
if ~isstreq(child.node,'coef')
    continue;
end
load(experimentLayout.n.(child.node).(child.instance).path,'coef','datatype');

% generate data code
gen_data_param.nob = number_of_bags.(datatype);
x = generate_synthetic_data(generating_dictionary,coef,gen_data_param);
x_instances = horzcat(x{:});


nodeName = 'data';

coreParents = [build_relative_node('data_identifier',data_id), ...
    build_relative_node('dictionary',dict_id)];
parents = [coreParents, ...
    build_relative_node('coef',coef_id,datatype), ...
    build_relative_node('number_of_bags',number_of_bags.(datatype),datatype)];
instantiationField = instanceNameFun.ms.(nodeName)(data_id,datatype);
instantiationPath = [nodePath,instantiationField];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'x','x_instances','datatype');


end
end
end

save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
