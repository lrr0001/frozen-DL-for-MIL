clear;
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'number_of_instance_label_sets', ...
    'number_of_classes', ...
    'list_of_witness_rates', ...
    'instances_per_bag', ...
    'number_of_bags');
load([experimentPath,'structure_file.mat']);  
nodePath = [experimentPath,'instance_labels/'];
mkdir(nodePath);

for bag_labels_id_inst_cell = fields(experimentLayout.n.('bag_labels_identifier'))'
bag_labels_id_inst_str = bag_labels_id_inst_cell{1};
bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);

for wr = list_of_witness_rates
witness_rate = wr*ones(1,number_of_classes);

for ii = 1:number_of_instance_label_sets
instance_labels_id = dec2hex(randi(2^28) - 1);
nodeName = 'instance_labels_identifier';
parents = build_relative_node('bag_labels_identifier',bag_labels_id);
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'instance_labels';
for child = experimentLayout.n.('bag_labels_identifier').(bag_labels_id_inst_str).children
if ~isstreq(child.node,'bag_labels')
    continue;
end
load(experimentLayout.n.(child.node).(child.instance).path,'bag_labels','datatype');

% instance-label generation code
gen_instance_label_param.ipb = instances_per_bag;
gen_instance_label_param.C = number_of_classes;
gen_instance_label_param.wr = witness_rate;
gen_instance_label_param.nob = number_of_bags.(datatype);
instance_labels = generate_synthetic_instance_labels(bag_labels,gen_instance_label_param);

parents = [build_relative_node('instance_labels_identifier',instance_labels_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('witness_rate',witness_rate), ...
    build_relative_node('number_of_bags',number_of_bags.(datatype),datatype)];
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id,datatype);
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
save(instantiationPath,'instance_labels','datatype');

end
end
end
end
save([experimentPath,'structure_file.mat'],'experimentLayout','-append');