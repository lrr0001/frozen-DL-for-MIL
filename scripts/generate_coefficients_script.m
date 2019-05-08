clear;
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'K', ...
    'number_of_negative_dictionary_atoms', ...
    'number_of_classes', ...
    'L_i', ...
    'gen_sparsity_level', ...
    'number_of_bags', ...
    'number_of_generating_coef_sets', ...
    'instances_per_bag');
load([experimentPath,'structure_file.mat']);
nodePath = [experimentPath,'coef/'];
mkdir(nodePath);


for instance_labels_id_inst_cell = fields(experimentLayout.n.('instance_labels_identifier'))'
instance_labels_id_inst_str = instance_labels_id_inst_cell{1};
instance_labels_id = get_id_from_inst_field(instance_labels_id_inst_str);

for ii = 1:number_of_generating_coef_sets
coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'generating_coefficients_identifier';
parents = build_relative_node('instance_labels_identifier',instance_labels_id);
instantiationField = instanceNameFun.ms.(nodeName)(coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


for child = experimentLayout.n.('instance_labels_identifier').(instance_labels_id_inst_str).children
if ~isstreq(child.node,'instance_labels')
    continue;
end

load(experimentLayout.n.(child.node).(child.instance).path,'instance_labels','datatype');

% coefficient generation code
gen_coef_param.K = K;
gen_coef_param.K0 = number_of_negative_dictionary_atoms;
gen_coef_param.C = number_of_classes;
gen_coef_param.Li = L_i;
gen_coef_param.L = gen_sparsity_level;
gen_coef_param.nob = number_of_bags.(datatype);
gen_coef_param.ipb = instances_per_bag;
coef = generate_synthetic_coef(instance_labels,gen_coef_param);

nodeName = 'coef';

parents = [build_relative_node('generating_coefficients_identifier',coef_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('K',K), ...
    build_relative_node('Li',L_i), ...
    build_relative_node('gen_sparsity_level',gen_sparsity_level), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('instance_labels',instance_labels_id,datatype), ...
    build_relative_node('number_of_bags',number_of_bags.(datatype),datatype)];
instantiationField = instanceNameFun.ms.(nodeName)(coef_id,datatype);
instantiationPath = [nodePath,instantiationField];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'coef','datatype');

end
end
end

save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
