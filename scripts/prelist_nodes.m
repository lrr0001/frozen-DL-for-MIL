clear;


experimentLayout = ExperimentStructureGraph();

instanceNameFun = struct_with_handle;
build_relative_node = @(nodeName,varargin) relativeNode(nodeName,instanceNameFun.ms.(nodeName)(varargin{:}));
get_id_from_inst_field = @(instField) instField(5:end);
get_class_from_inst_field = @(instField) str2double(instField(6:end));
isstreq = @(str1,str2) numel(str1) == numel(str2) && all(str1 == str2);
dlm_issupervised = @(instField) isstreq(instField(1:3),'sup');

nodeName = 'generating_dictionary_identifier';
nodeAbrev = 'gdi';
instanceNameFun.ms.(nodeName) = @(gdi) sprintf('%s_%s',nodeAbrev,gdi);

nodeName = 'bag_labels_identifier';
nodeAbrev = 'bli';
instanceNameFun.ms.(nodeName) = @(bli) sprintf('%s_%s',nodeAbrev,bli);

nodeName = 'instance_labels_identifier';
nodeAbrev = 'ili';
instanceNameFun.ms.(nodeName) = @(ili) sprintf('%s_%s',nodeAbrev,ili);

nodeName = 'generating_coefficients_identifier';
nodeAbrev = 'gci';
instanceNameFun.ms.(nodeName) = @(gci) sprintf('%s_%s',nodeAbrev,gci);

nodeName = 'data_identifier';
nodeAbrev = 'did';
instanceNameFun.ms.(nodeName) = @(id) sprintf('%s_%s',nodeAbrev,id);

nodeName = 'data_mean_identifier';
nodeAbrev = 'dmi';
instanceNameFun.ms.(nodeName) = @(id) sprintf('%s_%s',nodeAbrev,id);

nodeName = 'learned_dictionary_identifier';
nodeAbrev = 'ldi';
instanceNameFun.ms.(nodeName) = @(ldi) sprintf('%s_%s',nodeAbrev,ldi);

nodeName = 'learned_coefficients_identifier';
nodeAbrev = 'lci';
instanceNameFun.ms.(nodeName) = @(lci) sprintf('%s_%s',nodeAbrev,lci);

nodeName = 'estimated_bag_labels_identifier';
nodeAbrev = 'ebi';
instanceNameFun.ms.(nodeName) = @(ebi) sprintf('%s_%s',nodeAbrev,ebi);

nodeName = 'number_of_classes';
nodeAbrev = 'C';
instanceNameFun.ms.(nodeName) = @(noc) sprintf('%s%d',nodeAbrev,noc);

nodeName = 'dimension';
nodeAbrev = 'dim';
instanceNameFun.ms.(nodeName) = @(dim) sprintf('%s%d',nodeAbrev,dim);

nodeName = 'number_of_negative_dictionary_atoms';
nodeAbrev = 'K0_';
instanceNameFun.ms.(nodeName) = @(K0) sprintf('%s%d',nodeAbrev,K0);

nodeName = 'K';
nodeAbrev = 'K';
instanceNameFun.ms.(nodeName) = @(Ki) [sprintf('%s',nodeAbrev),sprintf('_%d',nodeAbrev,Ki)];

nodeName = 'dictionary';
nodeAbrev = 'd';
instanceNameFun.ms.(nodeName) = @(id) sprintf('%s_%s',nodeAbrev,id);

nodeName = 'imbalance_ratio';
nodeAbrev = 'ir';
instanceNameFun.ms.(nodeName) = @(ir) sprintf('%s%d',nodeAbrev,ir*100);

nodeName = 'number_of_bags';
nodeAbrev = 'nob';
instanceNameFun.ms.(nodeName) = @(nob,dt) sprintf('%s%d_%s',nodeAbrev,nob,dt);

nodeName = 'bag_labels';
nodeAbrev = 'bl';
instanceNameFun.ms.(nodeName) = @(id,dt) sprintf('%s_%s_%s',nodeAbrev,id,dt);

nodeName = 'instances_per_bag';
nodeAbrev = 'ipg';
instanceNameFun.ms.(nodeName) = @(ipg) sprintf('%s%d',nodeAbrev,ipg);

nodeName = 'witness_rate';
nodeAbrev = 'wr';
instanceNameFun.ms.(nodeName) = @(wr) [sprintf('%s',nodeAbrev),sprintf('_%d',uint8(wr*100))];

nodeName = 'instance_labels';
nodeAbrev = 'il';
instanceNameFun.ms.(nodeName) = @(id,dt) sprintf('%s_%s_%s',nodeAbrev,id,dt);

nodeName = 'gen_sparsity_level';
nodeAbrev = 'gL';
instanceNameFun.ms.(nodeName) = @(L) sprintf('%s%d',nodeAbrev,L);

nodeName = 'Li';
nodeAbrev = 'Li';
instanceNameFun.ms.(nodeName) = @(Li) [sprintf('%s',nodeAbrev),sprintf('_%d_',Li)];

nodeName = 'coef';
nodeAbrev = 'coef';
instanceNameFun.ms.(nodeName) = @(id,dt) sprintf('%s_%s_%s',nodeAbrev,id,dt);

nodeName = 'data';
nodeAbrev = 'data';
instanceNameFun.ms.(nodeName) = @(id,dt) sprintf('%s_%s_%s',nodeAbrev,id,dt);

nodeName = 'DL_sparsity_level';
nodeAbrev = 'DL_L';
instanceNameFun.ms.(nodeName) = @(dl_L) sprintf('%s%d',nodeAbrev,dl_L);

nodeName = 'DL_number_of_iterations';
nodeAbrev = 'iterNum';
instanceNameFun.ms.(nodeName) = @(iterNum) sprintf('%s%d',nodeAbrev,iterNum);

nodeName = 'UDL_dictionary_size';
nodeAbrev = 'UDL_K';
instanceNameFun.ms.(nodeName) = @(udl_K) sprintf('%s%d',nodeAbrev,udl_K);

nodeName = 'learned_dictionary';
nodeAbrev = 'LD';
instanceNameFun.ms.(nodeName) = @(varargin) learned_dictionary_name_fun(nodeAbrev,varargin{:});

nodeName = 'learned_coef_sparsity_level';
nodeAbrev = 'LC_L';
instanceNameFun.ms.(nodeName) = @(lc_L) sprintf('%s%d',nodeAbrev,lc_L);

nodeName = 'learned_coef';
nodeAbrev = 'LC';
instanceNameFun.ms.(nodeName) = @(id,varargin) learned_coef_name_fun(nodeAbrev,id,varargin{:});

nodeName = 'PCA_normalize';
nodeAbrev = 'PCA_norm';
instanceNameFun.ms.(nodeName) = @(PCA_normalize) sprintf('%s%d',nodeAbrev,PCA_normalize);

nodeName = 'data_mean_and_normalization_factor';
instanceNameFun.ms.(nodeName) = @(id) sprintf('data_mean_%s',id);

nodeName = 'SDL_negative_dictionary_size';
nodeAbrev = 'SDL_nnoa';
instanceNameFun.ms.(nodeName) = @(SDL_neg_K) sprintf('%s%d',nodeAbrev,SDL_neg_K);

nodeName = 'SDL_total_dictionary_size';
nodeAbrev = 'SDL_noa';
instanceNameFun.ms.(nodeName) = @(SDL_K) sprintf('%s%d',nodeAbrev,SDL_K);

nodeName = 'SDL_negative_sparsity_level';
nodeAbrev = 'SDL_nL';
instanceNameFun.ms.(nodeName) = @(nL) sprintf('%s%d',nodeAbrev,nL);

nodeName = 'SDL_negative_number_of_iterations';
nodeAbrev = 'SDL_neg_iternum';
instanceNameFun.ms.(nodeName) = @(iter) sprintf('%s%d',nodeAbrev,iter);

nodeName = 'SDL_positive_number_of_iterations';
nodeAbrev = 'SDL_pos_iternum';
instanceNameFun.ms.(nodeName) = @(iter) sprintf('%s%d',nodeAbrev,iter);

nodeName = 'SDL_positive_sparsity_level';
nodeAbrev = 'SDL_pL';
instanceNameFun.ms.(nodeName) = @(pL) sprintf('%s%d',nodeAbrev,pL);

nodeName = 'class';
nodeAbrev = 'class';
instanceNameFun.ms.(nodeName) = @(c) sprintf('%s%d',nodeAbrev,c);

nodeName = 'estimated_bag_labels';
nodeAbrev = 'ebl';
instanceNameFun.ms.(nodeName) = @(varargin) estimated_bag_labels_name_fun(nodeAbrev,varargin{:});

nodeName = 'cost_exp';
nodeAbrev = 'cost';
instanceNameFun.ms.(nodeName) = @(cost) sprintf('%s%d',nodeAbrev,cost);

nodeName = 'max_PCA_r';
nodeAbrev = 'max_r';
instanceNameFun.ms.(nodeName) = @(r) sprintf('%s%d',nodeAbrev,r);

vars = who;
load('r-eStatesAndPaths/absolute_paths.mat');
save([experimentPath,'structure_file.mat'],vars{:});
