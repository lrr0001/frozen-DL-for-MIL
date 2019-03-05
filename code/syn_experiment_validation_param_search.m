clear
load('data_representations.mat','number_of_classes','bag_labels','bag_labels_val','outer','coef','coef_val','fzn_ksvd_coef_bags','fzn_ksvd_coef_bags_val','bin2pm','ul_ksvd_coef_bags','ul_ksvd_coef_bags_val','ul_pca_coef_bags','ul_pca_coef_bags_val');
class_set = 1:number_of_classes;
cost_exp_set = 4:2:12;
pca_r = 6:3:12;
py.test_module.pickleSave('ValidationRuns/searchSpace.pickle',py.list({class_set,cost_exp_set,pca_r}));

for cc = class_set
    train_labels = bin2pm(bag_labels(cc,:));
    val_labels = bin2pm(bag_labels_val(cc,:));

    
    
    
            curr_str = sprintf('ValidationRuns/true_coef_val%d.pickle',cc);
            train_bags = outer(coef);
            val_bags = outer(coef_val);
            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels})); 
    
    
            curr_str = sprintf('ValidationRuns/fzn_ksvd_lbl_val%d.pickle',cc);
            train_bags = outer(fzn_ksvd_coef_bags{cc});
            val_bags = outer(fzn_ksvd_coef_bags_val{cc});
            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels})); 

            
            curr_str = sprintf('ValidationRuns/ul_ksvd_lbl_val%d.pickle',cc);
            train_bags = outer(ul_ksvd_coef_bags);
            val_bags = outer(ul_ksvd_coef_bags_val);
            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels}));

            
            curr_str = sprintf('ValidationRuns/ul_pca_lbl_val%d.pickle',cc);
            train_bags = outer(ul_pca_coef_bags);
            val_bags = outer(ul_pca_coef_bags_val);
            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels}));
            

%    for gamm_ind = 1:numel(gamm_exp_set)
%        gamm_exp = gamm_exp_set(gamm_ind);
%        for cost_ind = 1:numel(cost_exp_set)
%            cost_exp = cost_exp_set(cost_ind);
%            curr_str = sprintf('ValidationRuns/fzn_ksvd_lbl_val%d_gamm%d_cost%d.pickle',cc,gamm_exp,cost_exp);
%            train_bags = outer(fzn_ksvd_coef_bags{cc});
%            val_bags = outer(fzn_ksvd_coef_bags_val{cc});
%            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels})); 

            
%            curr_str = sprintf('ValidationRuns/ul_ksvd_lbl_val%d_gamm%d_cost%d.pickle',cc,gamm_exp,cost_exp);
%            train_bags = outer(ul_ksvd_coef_bags);
%            val_bags = outer(ul_ksvd_coef_bags_val);
%            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels}));

            
%            curr_str = sprintf('ValidationRuns/ul_pca_lbl_val%d_gamm%d_cost%d.pickle',cc,gamm_exp,cost_exp);
%            train_bags = outer(ul_pca_coef_bags);
%            val_bags = outer(ul_pca_coef_bags_val);
%            py.test_module.pickleSave(curr_str,py.list({train_bags,val_bags,train_labels,val_labels}));
           
%            temp2 = py.test_module.my_classifier(outer(fzn_ksvd_coef_bags{cc}),outer(fzn_ksvd_coef_bags_val{cc}),bin2pm(temp),2^gamm_exp,2^cost_exp);
            %frozen_ksvd_labels_test{cc} = temp2;
%            fznksvd_lbl_val = temp2;
%            save(sprintf('fzn_ksvd_lbl_val%d_gamm%d_cost%d.mat',cc,gamm_exp,cost_exp),'fznksvd_lbl_val');
%            clear temp2;
     
%            temp2 = py.test_module.my_classifier(outer(ul_ksvd_coef_bags),outer(ul_ksvd_coef_bags_val),bin2pm(temp),2^gamm_exp,2^cost_exp);
%            ulksvd_lbl_val = temp2;
%            save(sprintf('ul_ksvd_lbl_val%d_gamm%d_cost%d.mat',cc,gamm_exp,cost_exp),'ulksvd_lbl_val');
            %ul_ksvd_labels_test{cc} = temp2;
%            clear team 2;
    
%            temp2 = py.test_module.my_classifier(outer(ul_pca_coef_bags),outer(ul_pca_coef_bags_val),bin2pm(temp),2^gamm_exp,2^cost_exp);
%            ulpca_lbl_val = temp2;
%            save(sprintf('ul_pca_lbl_val%d.mat_gamm%d_cost%d',cc,gamm_exp,cost_exp),'ulpca_lbl_val');
            %pca_labels_test{cc} = temp2;
%        end
%    end
end
