function instantiationField = estimated_bag_labels_name_fun(nodeAbrev,ebli_id,cost_exp,class,dt,pca_r)
if nargin < 6
    instantiationField = sprintf('%s_%s_cost%d_class%d_%s',nodeAbrev,ebli_id,cost_exp,class,dt);
else
    instantiationField = sprintf('%s_%s_cost%d_class%d_r%d_%s',nodeAbrev,ebli_id,cost_exp,class,pca_r,dt);
end
end