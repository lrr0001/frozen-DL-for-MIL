clear;
sparsity_level = 4;
pca_r = 12;
% altered
%number_of_classes = 4;

% adjustable
number_of_classes = 4;

% adjustable
dimension = 16;

%adjustable
%witness_rate = 0.6;

%adjustable
%unbalance_ratio = 0.5;

load('folder_param.mat');

%adjustable
instances_per_bag = 12;
number_of_bags = 2^9;
number_of_bags_val = 2^8;
number_of_bags_test = 2^8;
number_of_ksvd_iterations = 150;

% adjustable
number_of_negative_dictionary_atoms = 16;
number_of_class_specific_dictionary_atoms = 8;

K_0 = number_of_negative_dictionary_atoms;

% Code in synthetic generator assumes all classes have same number of
% atoms.
K(1:number_of_classes) = number_of_class_specific_dictionary_atoms;
offset = [0,cumsum(K)] + K_0;
offset(end) = [];
offset_0 = 0;


L_i = zeros(number_of_classes + 1,1);
L_0 = zeros(number_of_classes + 1,1);


% adjusted with number of classes, sparsity, and number of atoms
L_i(1) = 0; % if negative class, use 0 positive atoms
L_i(2) = 2; % if there is 1 positive class, use two positive atoms

% alterred
L_i(3) = 1; % if 2 positive classes, use one atom from each class
L_i(4) = 1; % if 3 positive classes, use one atom from each class
L_i(5) = 1; % if 4 positive classes, use one atom from each class

for cc = 1:number_of_classes + 1
    L_0(cc) = sparsity_level - L_i(cc)*(cc - 1); % number of negative atoms used
end

%generator parameters
generator_param.L = sparsity_level;
generator_param.C = number_of_classes;
generator_param.d = dimension;
generator_param.wr = witness_rate;
generator_param.ur = unbalance_ratio;
generator_param.ipb = instances_per_bag;
generator_param.nob = number_of_bags + number_of_bags_val + number_of_bags_test;
generator_param.K0 = number_of_negative_dictionary_atoms;
generator_param.K = K;
generator_param.offset = offset;
generator_param.Li = L_i;
generator_param.L0 = L_0;

[x_all,coef_all,bag_labels_all,instance_labels_all,ngd,cgd] = synthetic_generator(generator_param);

training_inds = 1:number_of_bags;
validation_inds = number_of_bags + 1:number_of_bags + number_of_bags_val;
test_inds = number_of_bags + number_of_bags_val + 1:number_of_bags + number_of_bags_val + number_of_bags_test;

coef = coef_all(training_inds);
coef_val = coef_all(validation_inds);
coef_test = coef_all(test_inds);


x = x_all(training_inds);
x_val = x_all(validation_inds);
x_test = x_all(test_inds);

bag_labels = bag_labels_all(:,training_inds);
bag_labels_val = bag_labels_all(:,validation_inds);
bag_labels_test = bag_labels_all(:,test_inds);

instance_labels = instance_labels_all(:,:,training_inds);
instance_labels_val = instance_labels_all(:,:,validation_inds);
instance_lablels_test = instance_labels_all(:,:,test_inds);


% UNSUPERVISED
x_instances = horzcat(x{:});
x_val_instances = horzcat(x_val{:});
x_test_instances = horzcat(x_test{:});

% unsupervised K-SVD
param.data = x_instances;
param.Tdata = sparsity_level;
param.iternum = number_of_ksvd_iterations;
param.dictsize = K_0 + sum(K);
[ul_ksvd_dct,ul_ksvd_coef,ul_error,ul_gerror] = ksvd(param);
ul_ksvd_Gmat = ul_ksvd_dct'*ul_ksvd_dct;
ul_ksvd_coef_val = omp(ul_ksvd_dct'*x_val_instances,ul_ksvd_Gmat,param.Tdata);
ul_ksvd_coef_test = omp(ul_ksvd_dct'*x_test_instances,ul_ksvd_Gmat,param.Tdata);

% unsupervised PCA
pca_param.r = pca_r;
pca_param.x = x_instances;
pca_param.normalize = false;
if pca_param.normalize
    [ul_pca_dct,ul_pca_coef,data_mean,normalization_factor] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*((x_val_instances - data_mean*ones(1,size(x_val_instances,2)))./(normalization_factor*ones(1,size(x_val_instances,2))));
    ul_pca_coef_test = ul_pca_dct'*(x_test_instances- data_mean*ones(1,size(x_test_instances,2))./(normalization_factor*ones(1,size(x_test_instaces,2))));
else
    [ul_pca_dct,ul_pca_coef,data_mean] = pca_DL(pca_param);
    ul_pca_coef_val = ul_pca_dct'*(x_val_instances - data_mean*ones(1,size(x_val_instances,2)));
    ul_pca_coef_test = ul_pca_dct'*(x_test_instances- data_mean*ones(1,size(x_test_instances,2)));
end

%unsupervised conversion to bags
ul_ksvd_coef_bags = cell(1,number_of_bags);
ul_ksvd_coef_bags_val = cell(1,number_of_bags_val);
ul_ksvd_coef_bags_test = cell(1,number_of_bags_test);

ul_pca_coef_bags = cell(1,number_of_bags);
ul_pca_coef_bags_val = cell(1,number_of_bags_val);
ul_pca_coef_bags_test = cell(1,number_of_bags_test);

m = 0;
for ii = 1:number_of_bags
   ul_ksvd_coef_bags{ii} = ul_ksvd_coef(:,m + 1:m + instances_per_bag);
   ul_pca_coef_bags{ii} = ul_pca_coef(:,m + 1:m + instances_per_bag);
   m = m + instances_per_bag;
end
m = 0;
for ii = 1:number_of_bags_val
   ul_ksvd_coef_bags_val{ii} = ul_ksvd_coef_val(:,m + 1:m + instances_per_bag);
   ul_pca_coef_bags_val{ii} = ul_pca_coef_val(:,m + 1:m + instances_per_bag);
   m = m + instances_per_bag;
end
m = 0;
for ii = 1:number_of_bags_test
   ul_ksvd_coef_bags_test{ii} = ul_ksvd_coef_test(:,m + 1:m + instances_per_bag);
   ul_pca_coef_bags_test{ii} = ul_pca_coef_test(:,m + 1:m + instances_per_bag);
   m = m + instances_per_bag;
end


% I believe 'gerror' is a quantification of the error after it has been
% projected onto some subspace.  Would have to look it up to be sure.

% 1 positive class vs rest
learned_class_dictionaries = cell(1,number_of_classes); % dictionary for chosen positive class
learned_negative_dictionaries = cell(1,number_of_classes); %dictionary for rest
learned_cc_coef = cell(1,number_of_classes); % coefficients for chosen positve class
cc_err = cell(1,number_of_classes); % representation error for chosen class
cc_gerr = cell(1,number_of_classes); % 'gerror' for chosen class
learned_other_coef = cell(1,number_of_classes); % coefficient for rest
other_err = cell(1,number_of_classes); % representation error for rest
other_gerr = cell(1,number_of_classes); % 'gerror' for rest

param.Tdata = sparsity_level;
param.iternum = number_of_ksvd_iterations;

cc_coef_bags = cell(1,number_of_classes);
other_coef_bags = cell(1,number_of_classes);
cc_coef_bags_val = cell(1,number_of_classes);
other_coef_bags_val = cell(1,number_of_classes);
cc_coef_bags_test = cell(1,number_of_classes);
other_coef_bags_test = cell(1,number_of_classes);
fzn_ksvd_coef_bags = cell(1,number_of_classes);
fzn_ksvd_coef_bags_val = cell(1,number_of_classes);
fzn_ksvd_coef_bags_test = cell(1,number_of_classes);
for cc = 1:number_of_classes
    param.dictsize = K_0 + sum(K) - K(cc);
    cc_bags = bag_labels(cc,:);
    %cc_bags_val = bag_labels_val(cc,:);
    %cc_bags_test = bag_labels_test(cc,:);
    x_cc = horzcat(x{logical(cc_bags)});
    %x_cc_val = horzcat(x{logical(cc_bags_val)});
    %cc_inds_val = 1:size(x_cc_val,2);
    %x_cc_test = horzcat(x{logical(cc_bags_test)});
    %cc_inds_test = (1:size(x_cc_test,2))+ size(x_cc_val,2);
    x_other = horzcat(x{~logical(cc_bags)});
    %other_inds = 1:size(x_other,2);
    %x_other_val = horzcat(x{~logical(cc_bags_val)});
    %other_inds_val = (1:size(x_other_val,2)) + size(x_other,2);
    %x_other_test = horzcat(x{~logical(cc_bags_test)});
    %other_inds_test = (1:size(x_other_test,2)) + size(x_other,2) + size(x_other_val,2);
    %x_other_all = horzcat(x_other,x_other_val,x_other_test);
    param.data = x_other;
    learned_negative_dictionaries{cc} = ksvd(param);
    param.dictsize = K_0 + sum(K);
    param.data = x_cc;
    param.frozendict = learned_negative_dictionaries{cc};
    [learned_class_dictionaries{cc},learned_cc_coef{cc},other_err{cc},other_gerr{cc}] = ksvd_frozen(param);
    
    %cc_coef_bags{cc} = cell(1,sum(cc_bags));
    %cc_coef_bags_val{cc} = cell(1,sum(cc_bags_val));
    %cc_coef_bags_test{cc} = cell(1,sum(cc_bags_test));
    
    %other_coef_bags{cc} = cell(1,sum(~cc_bags));
    %other_coef_bags_val{cc} = cell(1,sum(~cc_bags_val));
    %other_coef_bags_test{cc} = cell(1,sum(~cc_bags_test));
    
    fzn_ksvd_coef_bags{cc} = cell(1,number_of_bags);
    fzn_ksvd_coef_bags_val{cc} = cell(1,number_of_bags_val);
    fzn_ksvd_coef_bags_test{cc} = cell(1,number_of_bags_test);
    
    learned_class_dictionary_Gmat = learned_class_dictionaries{cc}'*learned_class_dictionaries{cc};
    fzn_ksvd_coef = omp(learned_class_dictionaries{cc}'*x_instances,learned_class_dictionary_Gmat,param.Tdata);
    fzn_ksvd_coef_val = omp(learned_class_dictionaries{cc}'*x_val_instances,learned_class_dictionary_Gmat,param.Tdata);
    fzn_ksvd_coef_test = omp(learned_class_dictionaries{cc}'*x_test_instances,learned_class_dictionary_Gmat,param.Tdata);
    
    m = 0;
    for ii = 1:number_of_bags
        fzn_ksvd_coef_bags{cc}{ii} = fzn_ksvd_coef(:,m + 1:m + instances_per_bag);
        m = m + instances_per_bag;
    end
    m = 0;
    for ii = 1:number_of_bags_val
        fzn_ksvd_coef_bags_val{cc}{ii} = fzn_ksvd_coef_val(:,m + 1:m + instances_per_bag);
        m = m + instances_per_bag;
    end
    m = 0;
    for ii = 1:number_of_bags_test
        fzn_ksvd_coef_bags_test{ii} = fzn_ksvd_coef_test(:,m + 1:m + instances_per_bag);
        m = m + instances_per_bag;
    end
    
    
    %m = 0;
    %for ii = 1:numel(cc_coef_bags{cc})
    %    cc_coef_bags{cc}{ii} = learned_cc_coef{cc}(:,m+1:m+instances_per_bag);
    %    m = m + instances_per_bag;
    %end
    %learned_other_coef_all = omp(learned_class_dictionaries{cc}'*x_other_all,learned_class_dictionaries{cc}'*learned_class_dictionaries{cc},param.Tdata);
    %learned_cc_coef_valtest = omp(learned_class_dictionaries{cc}'*horzcat(x_cc_val,x_cc_test),learned_class_dictionaries{cc}'*learned_class_dictionaries{cc},param.Tdata);
    
    %learned_cc_coef_val = learned_cc_coef_valtest(:,cc_inds_val);
    %learned_cc_coef_test = learned_cc_coef_valtest(:,cc_inds_test);
    
    %learned_other_coef = learned_other_coef_all(:,other_inds);
    %learned_other_coef_val = learned_other_coef_all(:,other_inds_val);
    %learned_other_coef_test = learned_other_coef_all(:,other_inds_test);
    %m = 0;
    %for ii = 1:numel(other_coef_bags{cc})
    %    other_coef_bags{cc}{ii} = learned_other_coef(:,m+1:m+instances_per_bag);
    %    if m + instances_per_bag <= size(learned_other_coef_val,2)
    %        other_coef_bags_val{cc}{ii} = learned_other_coef_val(:,m+1:m+instances_per_bag);
    %    end
    %    if m + instances_per_bag <= size(learned_other_coef_test,2)
    %        other_coef_bags_test{cc}{ii} = learned_other_coef_test(:,m+1:m+instances_per_bag);
    %    end
    %    if m + instances_per_bag <= size(learned_cc_coef_val,2)
    %        cc_coef_bags_val{cc}{ii} = learned_cc_coef_val(:,m+1:m+instances_per_bag);
    %    end
    %    if m + instances_per_bag <= size(learned_cc_coef_test,2)
    %        cc_coef_bags_test{cc}{ii} = learned_cc_coef_test(:,m+1:m+instances_per_bag);
    %    end
    %    m = m + instances_per_bag;
    %end
end


%{
%Compute Hausdorf distances
d_handle = @(x,y) sqrt(sum((x*ones(1,size(y,2)) - y).^2));
cc_train_cc_train_dist = cell(1,number_of_classes);
cc_train_other_train_dist= cell(1,number_of_classes);
cc_train_cc_val_dist= cell(1,number_of_classes);
cc_train_other_val_dist= cell(1,number_of_classes);
cc_train_cc_test_dist= cell(1,number_of_classes);
cc_train_other_test_dist= cell(1,number_of_classes);
other_train_cc_val_dist= cell(1,number_of_classes);
other_train_other_val_dist = cell(1,number_of_classes);
other_train_cc_test_dist= cell(1,number_of_classes);
other_train_other_test_dist= cell(1,number_of_classes);
for cc = 1:number_of_classes
    cc_train_cc_train_dist{cc} = haussdorf_distance(cc_coef_bags{cc},cc_coef_bags{cc},d_handle);
    cc_train_other_train_dist{cc} = haussdorf_distance(other_coef_bags{cc},cc_coef_bags{cc},d_handle);
    cc_train_cc_val_dist{cc} = haussdorf_distance(cc_coef_bags_val{cc},cc_coef_bags{cc},d_handle);
    cc_train_other_val_dist{cc} = haussdorf_distance(other_coef_bags_val{cc},cc_coef_bags{cc},d_handle);
    cc_train_cc_test_dist{cc} = haussdorf_distance(cc_coef_bags_test{cc},cc_coef_bags{cc},d_handle);
    cc_train_other_test_dist{cc} = haussdorf_distance(other_coef_bags_test{cc},cc_coef_bags{cc},d_handle);
    other_train_cc_val_dist{cc} = haussdorf_distance(cc_coef_bags_val{cc},other_coef_bags{cc},d_handle);
    other_train_other_val_dist{cc} = haussdorf_distance(other_coef_bags_val{cc},other_coef_bags{cc},d_handle);

    other_train_cc_test_dist{cc} = haussdorf_distance(cc_coef_bags_test{cc},other_coef_bags{cc},d_handle);

    other_train_other_test_dist{cc} =haussdorf_distance(other_coef_bags_test{cc},other_coef_bags{cc},d_handle);

end

my_breakpoint = 1;

%k-nn computations
negative_neighbors_negative = cell(1,number_of_classes);
negative_neighbors_positive = cell(1,number_of_classes);
positive_neighbors_negative = cell(1,number_of_classes);
positive_neighbors_positive = cell(1,number_of_classes);
negative_labels = cell(1,number_of_classes);
positive_labels = cell(1,number_of_classes);
h = cell(1,number_of_classes);
d_handle = @(x,y) sqrt(sum((x*ones(1,size(y,2)) - y).^2));

for cc = 1:number_of_classes
    negative_neighbors_negative{cc} = cell(1,9);
    negative_neighbors_positive{cc} = cell(1,9);
    positive_neighbors_negative{cc} = cell(1,9);
    positive_neighbors_positive{cc} = cell(1,9);
    negative_labels{cc} = cell(1,9);
    positive_labels{cc} = cell(1,9);
    
    curr_coef = vertcat(other_coef_bags{cc},cc_coef_bags{cc});
    curr_labels = [zeros(1,numel(other_coef_bags{cc})),ones(1,numel(cc_coef_bags{cc}))];
    h{cc} = haussdorf_distance(curr_coef,curr_coef,d_handle);

    for ii = 1:9
        k_nn = ii + 1;
        curr_coef = vertcat(other_coef_bags{cc},cc_coef_bags{cc});
        curr_labels = [zeros(1,numel(other_coef_bags{cc})),ones(1,numel(cc_coef_bags{cc}))];
        [negative_labels{cc}{ii},negative_neighbors_negative{cc}{ii},negative_neighbors_positive{cc}{ii}] = hausdorffKNN(curr_coef,curr_labels,other_coef_bags{cc},ii + 1);
        [positive_labels{cc}{ii},positive_neighbors_negative{cc}{ii},positive_neighbors_positive{cc}{ii}] = hausdorffKNN(curr_coef,curr_labels,cc_coef_bags{cc},ii + 1);
        %figure;
        %subplot(1,2,1);
        %hist(negative_neighbors_negative{cc}{ii} - 1,0:ii)
        %subplot(2,2,1);
        %hist(ii + 1 - positive_neighbors_positive{cc}{ii},0:ii)
    end
end
%}

%mi-SVM
inner = @(t) arrayfun(@(ii) py.list(full(t(:,ii)')),1:size(t,2),'UniformOutput',false);
outer = @(t) py.list(cellfun(@(t2) inner(t2),t,'UniformOutput',false));
bin2pm = @(t) 2*(t - 0.5);

frozen_ksvd_labels_test = cell(1,number_of_classes);
ul_ksvd_labels_test = cell(1,number_of_classes);
pca_labels_test = cell(1,number_of_classes);

save('data_representations.mat');


%{
for cc = 1:number_of_classes
    temp = bag_labels(cc,:);
    
    temp2 = py.test_module.my_classifier(outer(fzn_ksvd_coef_bags{cc}),outer(fzn_ksvd_coef_bags{cc}),bin2pm(temp));
    frozen_ksvd_labels_test{cc} = temp2;
    fznksvd_lbl_tst = temp2;
    save(sprintf('fzn_ksvd_lbl_tst%d.mat',cc),'fznksvd_lbl_tst');
    clear temp2;
     
    temp2 = py.test_module.my_classifier(outer(ul_ksvd_coef_bags),outer(ul_ksvd_coef_bags_test),bin2pm(temp));
    ulksvd_lbl_tst = temp2;
    save(sprintf('ul_ksvd_lbl_tst%d.mat',cc),'ulksvd_lbl_tst');
    ul_ksvd_labels_test{cc} = temp2;
    clear team 2;
    
    temp2 = py.test_module.my_classifier(outer(ul_pca_coef_bags),outer(ul_pca_coef_bags_test),bin2pm(temp));
    ulpca_lbl_tst = temp2;
    save(sprintf('ul_pca_lbl_tst%d.mat',cc),'ulpca_lbl_tst');
    pca_labels_test{cc} = temp2;
end
%}
%{
% some plots
for ii = 1:9
    figure;
    for cc = 1:number_of_classes
        subplot(4,2,1 + 2*(cc - 1));
        hist(negative_neighbors_negative{cc}{ii} - 1,0:ii)
        title(sprintf('Histogram for %d neighbors, negative class for class %d',ii,cc));
        xlabel('number of negatively labeled neighboring bags');
        subplot(4,2,2 + 2*(cc - 1));
        hist(ii + 1 - positive_neighbors_positive{cc}{ii},0:ii)
        title(sprintf('Histogram for %d neighbors, positive class for class %d',ii,cc));
        xlabel('number of negatively labeled neighboring bags');
    end
end
%}
