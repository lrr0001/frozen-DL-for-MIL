clear;
load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'param_file.mat'], ...
    'number_of_classes', ...
    'list_of_imbalance_ratios', ...
    'number_of_bags');
load([experimentPath,'structure_file.mat']);    

nodePath = [experimentPath,'bag_labels/'];
mkdir(nodePath);

for imbalance_ratio = list_of_imbalance_ratios

% bag-label generation code
gen_bag_label_param.C = number_of_classes;
gen_bag_label_param.ur = imbalance_ratio;
gen_bag_label_param.nob = number_of_bags.train;
bag_labels_train = generate_synthetic_bag_labels(gen_bag_label_param);
gen_bag_label_param.nob = number_of_bags.val;
bag_labels_val = generate_synthetic_bag_labels(gen_bag_label_param);
gen_bag_label_param.nob = number_of_bags.test;
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

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags.train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'train');
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
bag_labels = bag_labels_train;
datatype = 'train';
save(instantiationPath,'bag_labels','datatype');
bin2pm = @(t) 2*(t - 0.5);
vectorize = @(t) arrayfun(@(cc) py.list(full(t(cc,:))),1:size(t,1),'UniformOutput',false);
py.python_save_tool.pickleSave([experimentPathPACE,'inputNodesPython/','bag_labels/',instantiationField,'.pickle'],py.list({vectorize(bin2pm(bag_labels)),datatype}));

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags.val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'val');
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
bag_labels = bag_labels_val;
datatype = 'val';
save(instantiationPath,'bag_labels','datatype');


py.python_save_tool.pickleSave([experimentPathPACE,'inputNodesPython/','bag_labels/',instantiationField,'.pickle'],py.list({vectorize(bin2pm(bag_labels)),datatype}));

parents = [coreParents, build_relative_node('number_of_bags',number_of_bags.test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(bag_labels_id,'test');
instantiationPath = [nodePath,instantiationField,'.mat'];
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents,instantiationPath));
bag_labels = bag_labels_test;
datatype = 'test';

py.python_save_tool.pickleSave([experimentPathPACE,'inputNodesPython/','bag_labels/',instantiationField,'.pickle'],py.list({vectorize(bin2pm(bag_labels)),datatype}));

save(instantiationPath,'bag_labels','datatype');


end
save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
clear;
