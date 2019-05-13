function kk = mi_svm_script()

kk = 0;
load('r-eStatesAndPaths/absolute_paths.mat');
% load all relevant parameters from param_file.mat'
load([experimentPath,'param_file.mat']);

load([experimentPath,'structure_file.mat']);

est_label_dependencies_path = [experimentPathPACE,'dependencies/est_label_misvm_dependencies/'];
mkdir(est_label_dependencies_path);
mkdir([experimentPathPACE,'outputNodesMATLAB/estimated_bag_labels/']);
prestr = ['/nv/hp20/lrichert3/scratch/',sprintf('experiment_%s_PACE/',experiment_hash)];
ext = '.pickle'; % don't change this. Must match other functions.  Better programmer would have put it in structure_file.
dataTypes = {'train','val','test'};

% Loop through learned learned-coefficient identifiers
for learned_coef_id_inst_cell = fields(experimentLayout.n.('learned_coefficients_identifier'))'
learned_coef_id_inst_str = learned_coef_id_inst_cell{1};
learned_coef_id = get_id_from_inst_field(learned_coef_id_inst_str);

% Find data identifier corresponding to current learned coef ID.
for lci_parent = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).parents
    if ~isstreq(lci_parent.node,'data_identifier')
        continue;
    end
    data_id_inst_str = lci_parent.instance;
    break;
end
data_id = get_id_from_inst_field(data_id_inst_str);

% Determine whether DLM is supervised
for lci_parent = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).parents
    if ~isstreq(lci_parent.node,'learned_dictionary_identifier')
        continue;
    end
    ldi_inst_str = lci_parent.instance;
    break;
end
for ldi_parent = experimentLayout.n.('learned_dictionary_identifier').(ldi_inst_str).parents
    if ~isstreq(ldi_parent.node,'dictionary_learning_method')
        continue;
    end
    supervised = dlm_issupervised(ldi_parent.instance);
    if isstreq(ldi_parent.instance,'PCA')
        pca = true;
    else
        pca = false;
    end
end

% Find the bag-labels identifier corresponding to the current
% data identifier.
for data_parent = experimentLayout.n.('data_identifier').(data_id_inst_str).parents
    if ~isstreq(data_parent.node,'generating_coefficients_identifier')
        continue;
    end
    coef_relative = data_parent;
    break
end
for coef_parent = experimentLayout.n.(coef_relative.node).(coef_relative.instance).parents
    if ~isstreq(coef_parent.node,'instance_labels_identifier')
        continue;
    end
    instance_labels_relative = coef_parent;
    break;
end
for inst_labels_parent = experimentLayout.n.(instance_labels_relative.node).(instance_labels_relative.instance).parents
    if ~isstreq(inst_labels_parent.node,'bag_labels_identifier')
        continue;
    end
    bag_labels_id_inst_str = inst_labels_parent.instance;
    break;
end
bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);

% save relative paths to bag labels
bag_labels_train_str = ['bag_labels/',instanceNameFun.ms.('bag_labels')(bag_labels_id,'train'),ext];
bag_labels_val_str = ['bag_labels/',instanceNameFun.ms.('bag_labels')(bag_labels_id,'val'),ext];
bag_labels_test_str = ['bag_labels/',instanceNameFun.ms.('bag_labels')(bag_labels_id,'test'),ext];
bl_strs = {bag_labels_train_str,bag_labels_val_str,bag_labels_test_str};

% add estimated-bag-labels identifier to structure graph
estimated_bag_labels_id = dec2hex(randi(2^28) - 1);
nodeName = 'estimated_bag_labels_identifier';
parents = [build_relative_node('bag_labels_identifier',bag_labels_id), ...
    build_relative_node('learned_coefficients_identifier',learned_coef_id)];
instantiationField = instanceNameFun.ms.(nodeName)(estimated_bag_labels_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


% build class list for current learned-cofficient set
%{
if supervised
    class_list = [];
    for learned_coef_relativeNode = experimentLayout.n.('learned_coefficients_identifier').(learned_coef_id_inst_str).children
        if ~isstreq(learned_coef_relativeNode.node,'learned_coef')
            continue;
        end
        for class_relativeNode = experimentLayout.n.('learned_coef').(learned_coef_relativeNode.instance).parents
            if ~isstreq(class_relativeNode.node,'class')
                continue;
            end
            class_list = [class_list,get_class_from_inst_field(class_relativeNode.instance)];
            break;
        end
    end
else
    class_list = 1:number_of_classes;
end
%}
class_list = 1:number_of_classes;

% build pca_r list for current learned-coefficient set
if pca
    curr_pca_r_list = list_of_pca_r;
else
    curr_pca_r_list = 1;
end

% build dependency sets for classification
for cc = class_list
    if supervised
        learned_coef_train_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'train'),ext];
        learned_coef_val_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'val'),ext];
        learned_coef_test_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,cc,'test'),ext];
        parent_learned_coef = @(dt) build_relative_node('learned_coef',learned_coef_id,cc,dt);
    else
        learned_coef_train_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,'train'),ext];
        learned_coef_val_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,'val'),ext];
        learned_coef_test_str = ['learned_coef/',instanceNameFun.ms.('learned_coef')(learned_coef_id,'test'),ext];
        parent_learned_coef = @(dt) build_relative_node('learned_coef',learned_coef_id,dt);
    end
    
    lc_strs = {learned_coef_train_str,learned_coef_val_str,learned_coef_test_str};
    
    for cost_exp = list_of_cost_exp
        for pca_r = curr_pca_r_list
            if pca
                estimated_bag_labels_train_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'train',pca_r),ext];
                estimated_bag_labels_val_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'val',pca_r),ext];
                estimated_bag_labels_test_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'test',pca_r),ext];
                
                parent_pca_r = build_relative_node('pca_r',pca_r);
                pca_r_cell = {pca_r};    
         
            else
                estimated_bag_labels_train_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'train'),ext];
                estimated_bag_labels_val_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'val'),ext];
                estimated_bag_labels_test_str = ['estimated_bag_labels/',instanceNameFun.ms.('estimated_bag_labels')(learned_coef_id,cost_exp,cc,'test'),ext];
                
                parent_pca_r = [];
                pca_r_cell = {};
            end
            ebl_strs = {estimated_bag_labels_train_str,estimated_bag_labels_val_str,estimated_bag_labels_test_str};

            coreParents = [build_relative_node('estimated_bag_labels_identifier',estimated_bag_labels_id), ...
                build_relative_node('class',cc), ...
                build_relative_node('cost_exp',cost_exp), ...
                parent_pca_r];
            
            
            nodeName = 'estimated_bag_labels';

            for dataTypeInd = 1:numel(dataTypes)
                dataType = dataTypes{dataTypeInd};
                parents = [coreParents, ...
                    relativeNode('dataset_type',dataType), ...
                    build_relative_node('bag_labels',bag_labels_id,dataType), ...
                    parent_learned_coef(dataType)];
                instantiationField = instanceNameFun.ms.(nodeName)(estimated_bag_labels_id,cost_exp,cc,dataType,pca_r_cell{:});
                experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
            end
            kk = kk + 1;
            py.python_save_tool.pickleSave([est_label_dependencies_path,sprintf('dependency%d%s',kk,ext)],py.list([{prestr},bl_strs,lc_strs,ebl_strs,{cc},{cost_exp},{pca},{pca_r}]));
        end

    end
end
end

save([experimentPath,'structure_file.mat'],'experimentLayout','-append');
end
