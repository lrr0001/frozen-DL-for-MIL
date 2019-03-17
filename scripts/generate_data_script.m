load('param_file.mat', ...
    'number_of_bags_train', ...
    'number_of_bags_val', ...
    'number_of_bags_test');
load('structure_file.mat'); 


% generate data code
gen_data_param.nob = number_of_bags_train;
x_train = generate_synthetic_data(generating_dictionary,gen_coef_train,gen_data_param);
gen_data_param.nob = number_of_bags_val;
x_val = generate_synthetic_data(generating_dictionary,gen_coef_val,gen_data_param);
gen_data_param.nob = number_of_bags_test;
x_test = generate_synthetic_data(generating_dictionary,gen_coef_test,gen_data_param);
data_id = dec2hex(randi(2^28) - 1);
nodeName = 'data_identifier';
parents = [build_relative_node('generating_coefficients_identifier',coef_id), ...
    build_relative_node('generating_dictionary_identifier',dict_id)];
instantiationField = instanceNameFun.ms.(nodeName)(data_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'data';

coreParents = [build_relative_node('data_identifier',data_id), ...
    build_relative_node('dictionary',dict_id)];
parents = [coreParents, ...
    build_relative_node('coef',coef_id,'train'), ...
    build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(data_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


parents = [coreParents, ...
    build_relative_node('coef',coef_id,'val'), ...
    build_relative_node('number_of_bags',number_of_bags_val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(data_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, ...
    build_relative_node('coef',coef_id,'test'), ...
    build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(data_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

x_instances_train = horzcat(x_train{:});
x_instances_val = horzcat(x_val{:});
x_instances_test = horzcat(x_test{:});


save('structure_file.mat','experimentLayout','-append');
