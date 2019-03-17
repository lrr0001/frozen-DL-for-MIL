load('param_file.mat', ...
    'number_of_classes', ...
    'list_of_imbalance_ratios', ...
    'number_of_bags_train', ...
    'number_of_bags_val', ...
    'number_of_bags_test');
load('structure_file.mat');    



for imbalance_ratio = list_of_imbalance_ratios

% bag-label generation code
gen_bag_label_param.C = number_of_classes;
gen_bag_label_param.ur = imbalance_ratio;
gen_bag_label_param.nob = number_of_bags_train;
bag_labels_train = generate_synthetic_bag_labels(gen_bag_label_param);
gen_bag_label_param.nob = number_of_bags_val;
bag_labels_val = generate_synthetic_bag_labels(gen_bag_label_param);
gen_bag_label_param.nob = number_of_bags_test;
bag_labels_test = generate_synthetic_bag_labels(gen_bag_label_param);
bag_labels_id = dec2hex(randi(2^28) - 1);
nodeName = 'bag_labels_identifier';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'bag_labels';

coreParents = [build_relative_node('bag_labels_identifier',bag_labels_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('imbalance_ratio',imbalance_ratio)];

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

end
save('structure_file.mat','experimentLayout','-append');
