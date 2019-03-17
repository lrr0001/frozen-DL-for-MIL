load('param_file.mat', ...
    'number_of_classes', ...
    'list_of_witness_rates', ...
    'instances_per_bag', ...
    'number_of_bags_train', ...
    'number_of_bags_val', ...
    'number_of_bags_test');
load('structure_file.mat');  



for wr = list_of_witness_rates
witness_rate = wr*ones(1,number_of_classes);
for bag_labels_id_inst_cell = fields(experimentLayout.n.('bag_labels_identifier'))'
bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_cell{1});
for ii = 1:number_of_instance_label_sets

% instance-label generation code
gen_instance_label_param.ipb = instances_per_bag;
gen_instance_label_param.C = number_of_classes;
gen_instance_label_param.wr = witness_rate;
gen_instance_label_param.nob = number_of_bags_train;
instance_labels_train = generate_synthetic_instance_labels(bag_labels_train,gen_instance_label_param);
gen_instance_label_param.nob = number_of_bags_val;
instance_labels_val = generate_synthetic_instance_labels(bag_labels_val,gen_instance_label_param);
gen_instance_label_param.nob = number_of_bags_test;
instance_labels_test = generate_synthetic_instance_labels(bag_labels_test,gen_instance_label_param);
instance_labels_id = dec2hex(randi(2^28) - 1);
nodeName = 'instance_labels_identifier';
parents = build_relative_node('bag_labels_identifier',bag_labels_id);
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'instance_labels';


coreParents = [build_relative_node('instance_labels_identifier',instance_labels_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('witness_rate',witness_rate)];
parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(instance_labels_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end
end
end
save('structure_file.mat','experimentLayout','-append');