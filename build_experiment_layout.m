%destinationDirectory = getDestination();
clear
prelist_nodes;

number_of_generating_dictionaries = 8;
list_of_witness_rates = 0.1;
list_of_imbalance_ratios = 0.2;
number_of_bag_label_sets = 1;
number_of_instance_label_sets = 32;
list_of_gen_sparsity_levels = 4;
number_of_coef_sets = 1;
list_of_dl_sparsity_levels = 4;
list_of_cl_sparsity_levels = 4;

number_of_classes = 4;
parents = [];
nodeName = 'number_of_classes';
instantiationField = instanceNameFun.ms.(nodeName)(number_of_classes);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

dimension = 16;
parents = [];
nodeName = 'dimension';
instantiationField = instanceNameFun.ms.(nodeName)(dimension);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

number_of_negative_dictionary_atoms = 16;
parents = [];
nodeName = 'number_of_negative_dictionary_atoms';
instantiationField = instanceNameFun.ms.(nodeName)(number_of_negative_dictionary_atoms);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

number_of_class_specific_dictionary_atoms = 8;
K = number_of_class_specific_dictionary_atoms*ones(1,number_of_classes);
parents = build_relative_node('number_of_classes',number_of_classes);
nodeName = 'K';
instantiationField = instanceNameFun.ms.(nodeName)(K);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

for ii = 1:number_of_generating_dictionaries
    
    % dictionary generation code
gen_dict_param.K_0 = number_of_negative_dictionary_atoms;
gen_dict_param.K = K;
gen_dict_param.d = dimension;
gen_dict_param.C = number_of_classes;
generating_dictionary = generate_synthetic_dictionary(gen_dict_param);
dict_id = dec2hex(randi(2^28) - 1);
nodeName = 'generating_dictionary_identifier';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(dict_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


parents = [build_relative_node('generating_dictionary_identifier',dict_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('dimension',dimension), ...
    build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
nodeName = 'dictionary';
instantiationField = instanceNameFun.ms.(nodeName)(dict_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end


parents = [];
nodeName = 'dataset_type';
instantiationField = 'train';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'val';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'test';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


number_of_bags_train = 2^9;
number_of_bags_val = 2^8;
number_of_bags_test = 2^9;

nodeName = 'number_of_bags';


parents = relativeNode('dataset_type','train');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_train,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = relativeNode('dataset_type','val');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_val,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = relativeNode('dataset_type','test');
instantiationField = instanceNameFun.ms.(nodeName)(number_of_bags_test,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

for imbalance_ratio = list_of_imbalance_ratios
parents = [];
nodeName = 'imbalance_ratio';
instantiationField = instanceNameFun.ms.(nodeName)(imbalance_ratio);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end

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



instances_per_bag = 16;
parents = [];
nodeName = 'instances_per_bag';
instantiationField = instanceNameFun.ms.(nodeName)(instances_per_bag);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

for wr = list_of_witness_rates
witness_rate = wr*ones(1,number_of_classes);
parents = relativeNode('number_of_classes',instanceNameFun.ms.('number_of_classes')(number_of_classes));
nodeName = 'witness_rate';
instantiationField = instanceNameFun.ms.(nodeName)(witness_rate);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end

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

gen_sparsity_level = 4;
parents = [];
nodeName = 'gen_sparsity_level';
instantiationField = instanceNameFun.ms.(nodeName)(gen_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

L_i(1) = 0; % if negative class, use 0 positive atoms
L_i(2) = 2; % if there is 1 positive class, use two positive atoms
L_i(3) = 1; % if 2 positive classes, use one atom from each class
L_i(4) = 1; % if 3 positive classes, use one atom from each class
L_i(5) = 1; % if 4 positive classes, use one atom from each class
parents = [];
nodeName = 'Li';
instantiationField = instanceNameFun.ms.(nodeName)(L_i);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));



% coefficient generation code
gen_coef_param.K = K;
gen_coef_param.K0 = number_of_negative_dictionary_atoms;
gen_coef_param.C = number_of_classes;
gen_coef_param.Li = L_i;
gen_coef_param.L = gen_sparsity_level;
gen_coef_param.nob = number_of_bags_train;
gen_coef_param.ipb = instances_per_bag;
gen_coef_train = generate_synthetic_coef(instance_labels_train,gen_coef_param);
gen_coef_param.nob = number_of_bags_val;
gen_coef_val = generate_synthetic_coef(instance_labels_val,gen_coef_param);
gen_coef_param.nob = number_of_bags_test;
gen_coef_test = generate_synthetic_coef(instance_labels_test,gen_coef_param);
coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'generating_coefficients_identifier';
parents = build_relative_node('instance_labels_identifier',instance_labels_id);
instantiationField = instanceNameFun.ms.(nodeName)(coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'coef';

coreParents = [build_relative_node('generating_coefficients_identifier',coef_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('K',K), ...
    build_relative_node('Li',L_i), ...
    build_relative_node('gen_sparsity_level',gen_sparsity_level), ...
    build_relative_node('instances_per_bag',instances_per_bag)];
parents = [coreParents, ...
    build_relative_node('instance_labels',instance_labels_id,'train'), ...
    build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(coef_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, ...
    build_relative_node('instance_labels',instance_labels_id,'val'), ...
    build_relative_node('number_of_bags',number_of_bags_val,'val')];

instantiationField = instanceNameFun.ms.(nodeName)(coef_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, ...
    build_relative_node('instance_labels',instance_labels_id,'test'), ...
    build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(coef_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

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

dl_sparsity_level = gen_sparsity_level;
parents = [];
nodeName = 'DL_sparsity_level';
nodeAbrev = 'DL_L';
instanceNameFun.ms.(nodeName) = @(dl_L) sprintf('%s%d',nodeAbrev,dl_L);
instantiationField = instanceNameFun.ms.(nodeName)(dl_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

dl_number_of_iterations = 150;
parents = [];
nodeName = 'DL_number_of_iterations';
instantiationField = instanceNameFun.ms.(nodeName)(dl_number_of_iterations);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

udl_dictionary_size = number_of_negative_dictionary_atoms + sum(K);
parents = [];
nodeName = 'UDL_dictionary_size';
instantiationField = instanceNameFun.ms.(nodeName)(udl_dictionary_size);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [];
nodeName = 'dictionary_learning_method';
instantiationField = 'unsupervised_KSVD';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'frozen_KSVD';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
instantiationField = 'PCA';
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


udl_ksvd_param.Tdata = dl_sparsity_level;
udl_ksvd_param.iternum = dl_number_of_iterations;
udl_ksvd_param.dictsize = udl_dictionary_size;
udl_ksvd_param.data = x_instances_train;
%ul_ksvd_dct = ksvd(param);
ul_ksvd_dct = 1;
learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = build_relative_node('data_identifier',data_id);
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_dictionary';
parents = [relativeNode('dictionary_learning_method','unsupervised_KSVD'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('UDL_dictionary_size',udl_dictionary_size), ...
    build_relative_node('DL_sparsity_level',dl_sparsity_level), ...
    build_relative_node('DL_number_of_iterations',dl_number_of_iterations), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

lc_sparsity_level = dl_sparsity_level;
parents = [];
nodeName = 'learned_coef_sparsity_level';
instantiationField = instanceNameFun.ms.(nodeName)(lc_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

ul_ksvd_Gmat = ul_ksvd_dct'*ul_ksvd_dct;
%{
ul_ksvd_coef_train = omp(ul_ksvd_dct'*x_instances_train,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_train = bag_the_array(ul_ksvd_coef_train,instances_per_bag);
ul_ksvd_coef_val = omp(ul_ksvd_dct'*x_instances_val,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_val = bag_the_array(ul_ksvd_coef_val,instances_per_bag);
ul_ksvd_coef_test = omp(ul_ksvd_dct'*x_instances_test,ul_ksvd_Gmat,lc_sparsity_level);
ul_ksvd_coef_bags_test = bag_the_array(ul_ksvd_coef_test,instances_per_bag);
%}
learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_coef';
coreParents = [relativeNode('dictionary_learning_method','unsupervised_KSVD'), ...
    build_relative_node('learned_coefficients_identifier',learned_coef_id), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('learned_coef_sparsity_level',lc_sparsity_level), ...
    build_relative_node('learned_dictionary',learned_dictionary_id)];

parents = [coreParents,build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents,build_relative_node('data',data_id,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents)); 

parents = [coreParents,build_relative_node('data',data_id,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

pca_r = 12;
nodeName = 'PCA_r';
parents = [];
nodeAbrev = 'r';
instanceNameFun.ms.(nodeName) = @(r) sprintf('%s%d',nodeAbrev,r);
instantiationField = instanceNameFun.ms.(nodeName)(pca_r);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

pca_normalize = false;
nodeName = 'PCA_normalize';
parents = [];

instantiationField = instanceNameFun.ms.(nodeName)(pca_normalize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

pca_param.r = pca_r;
pca_param.x = x_instances_train;
pca_param.normalize = pca_normalize;
if pca_param.normalize
    [ul_pca_dct,ul_pca_coef_train,data_mean,normalization_factor] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*((x_instances_val - data_mean*ones(1,size(x_instances_val,2)))./(normalization_factor*ones(1,size(x_instances_val,2))));
    ul_pca_coef_test = ul_pca_dct'*(x_instances_test- data_mean*ones(1,size(x_instances_test,2))./(normalization_factor*ones(1,size(x_test_instaces,2))));
else
    [ul_pca_dct,ul_pca_coef_train,data_mean] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*(x_instances_val - data_mean*ones(1,size(x_instances_val,2)));
    ul_pca_coef_test = ul_pca_dct'*(x_instances_test- data_mean*ones(1,size(x_instances_test,2)));
end
ul_pca_coef_bags_train = bag_the_array(ul_pca_coef_train,number_of_bags_train,instances_per_bag);
ul_pca_coef_bags_val = bag_the_array(ul_pca_coef_val,number_of_bags_val,instances_per_bag);
ul_pca_coef_bags_test = bag_the_array(ul_pca_coef_test,number_of_bags_test,instances_per_bag);

learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = build_relative_node('data_identifier',data_id);
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

nodeName = 'learned_dictionary';
parents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('PCA_normalize',pca_normalize), ...
    build_relative_node('PCA_r',pca_r), ...
    build_relative_node('data',data_id,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

data_mean_id = dec2hex(randi(2^28) - 1);
nodeName = 'data_mean_and_normalization_factor';
parents = [build_relative_node('data',data_id,'train'), ...
    build_relative_node('PCA_normalize',pca_normalize)];

instantiationField = instanceNameFun.ms.(nodeName)(data_mean_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


nodeName = 'learned_coef';
coreParents = [relativeNode('dictionary_learning_method','PCA'), ...
    build_relative_node('instances_per_bag',instances_per_bag), ...
    build_relative_node('data_mean_and_normalization_factor',data_mean_id), ...
    build_relative_node('learned_dictionary',learned_dictionary_id)];

parents = [coreParents, ...
    build_relative_node('data',data_id,'train'), ...
    build_relative_node('number_of_bags',number_of_bags_train,'train')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'train');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

parents = [coreParents, ...
    build_relative_node('data',data_id,'val'), ...
    build_relative_node('number_of_bags',number_of_bags_val,'val')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'val');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents)); 

parents = [coreParents, ...
    build_relative_node('data',data_id,'test'), ...
    build_relative_node('number_of_bags',number_of_bags_test,'test')];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id,'test');
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));



SDL_negative_dictsize = number_of_negative_dictionary_atoms + sum(K) - round(mean(K));
nodeName = 'SDL_negative_dictionary_size';
parents = [build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_dictsize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

SDL_total_dictsize = number_of_negative_dictionary_atoms + sum(K);
nodeName = 'SDL_total_dictionary_size';
parents = [build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_total_dictsize);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

SDL_negative_sparsity_level = gen_sparsity_level;
nodeName = 'SDL_negative_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

SDL_negative_iternum = dl_number_of_iterations;
nodeName = 'SDL_negative_number_of_iterations';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_iternum);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

SDL_positive_iternum = dl_number_of_iterations;
nodeName = 'SDL_positive_number_of_iterations';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_negative_iternum);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

SDL_positive_sparsity_level = gen_sparsity_level;
nodeName = 'SDL_positive_sparsity_level';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(SDL_positive_sparsity_level);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));



learned_dictionary_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_dictionary_identifier';
parents = [build_relative_node('data_identifier',data_id), ...
    build_relative_node('bag_labels_identifier',bag_labels_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_dictionary_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
learned_coef_id = dec2hex(randi(2^28) - 1);
nodeName = 'learned_coefficients_identifier';
parents = [build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('data_identifier',data_id)];
instantiationField = instanceNameFun.ms.(nodeName)(learned_coef_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));

coreParents = [relativeNode('dictionary_learning_method','frozen_KSVD'), ...
    build_relative_node('learned_dictionary_identifier',learned_dictionary_id), ...
    build_relative_node('SDL_negative_dictionary_size',SDL_negative_dictsize), ...
    build_relative_node('SDL_total_dictionary_size',SDL_total_dictsize), ...
    build_relative_node('SDL_negative_sparsity_level',SDL_negative_sparsity_level), ...
    build_relative_node('SDL_positive_sparsity_level',SDL_positive_sparsity_level), ...
    build_relative_node('SDL_negative_number_of_iterations',SDL_negative_iternum), ...
    build_relative_node('SDL_positive_number_of_iterations',SDL_positive_iternum), ...
    build_relative_node('data',data_id,'train'), ...
    build_relative_node('bag_labels',bag_labels_id,'train'), ...
    build_relative_node('number_of_classes',number_of_classes)];
coreParents2 = [relativeNode('dictionary_learning_method','frozen_KSVD'), ...
    build_relative_node('learned_coefficients_identifier',learned_coef_id), ...
    build_relative_node('learned_coef_sparsity_level',lc_sparsity_level)];
frzn_ksvd_param.negative_dictsize = SDL_negative_dictsize;
frzn_ksvd_param.negative_Tdata = SDL_negative_sparsity_level;
frzn_ksvd_param.negative_iternum = SDL_negative_iternum;
frzn_ksvd_param.total_dictsize = SDL_total_dictsize;
frzn_ksvd_param.total_tdata = SDL_positive_sparsity_level;
frzn_ksvd_param.positive_iternum = SDL_positive_iternum;
for cc = 1:number_of_classes
    instantiationField = instanceNameFun.ms.('class')(cc);
    experimentLayout.add_instantiation('class',instantiationField,nodeInstance([]));
%    frzn_ksvd_dct = MIL_supervised_ksvd(x_train,bag_labels_train(cc,:),frzn_ksvd_param);
    instantiationField = instanceNameFun.ms.('learned_dictionary')(learned_dictionary_id,cc);
    parents = [coreParents,build_relative_node('class',cc)];
    experimentLayout.add_instantiation('learned_dictionary',instantiationField,nodeInstance(parents));
%    frzn_ksvd_Gmat = frzn_ksvd_dct'*frzn_ksvd_dct;
%    frzn_ksvd_coef_train = omp(frzn_ksvd_dct'*x_instances_train,frzn_ksvd_Gmat,lc_sparsity_level);
%    frzn_ksvd_coef_bags_train = bag_the_array(frzn_ksvd_coef_train,instances_per_bag);
    parents = [coreParents2, ...
        build_relative_node('learned_dictionary',learned_dictionary_id,cc), ...
        build_relative_node('data',data_id,'train')];
    instantiationField = instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'train');
    experimentLayout.add_instantiation('learned_coef',instantiationField,nodeInstance(parents));
%    frzn_ksvd_coef_val = omp(frzn_ksvd_dct'*x_instances_val,frzn_ksvd_Gmat,lc_sparsity_level);
%    frzn_ksvd_coef_bags_val = bag_the_array(frzn_ksvd_coef_val,instances_per_bag);
    parents = [coreParents2, ...
        build_relative_node('learned_dictionary',learned_dictionary_id,cc), ...
        build_relative_node('data',data_id,'val')];
    instantiationField = instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'val');
    experimentLayout.add_instantiation('learned_coef',instantiationField,nodeInstance(parents));
%    frzn_ksvd_coef_test = omp(frzn_ksvd_dct'*x_instances_test,frzn_ksvd_Gmat,lc_sparsity_level);
%    frzn_ksvd_coef_bags_test = bag_the_array(frzn_ksvd_coef_test,instances_per_bag);
    parents = [coreParents2, ...
        build_relative_node('learned_dictionary',learned_dictionary_id,cc), ...
        build_relative_node('data',data_id,'test')];
    instantiationField = instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'test');
    experimentLayout.add_instantiation('learned_coef',instantiationField,nodeInstance(parents));
    
end
