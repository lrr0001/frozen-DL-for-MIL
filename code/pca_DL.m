function [dictionary,coef,data_mean,row_normalization_factor] = pca_DL(param)
if ~isfield(param,'normalize')
    param.normalize = true;
end
data_mean = mean(param.x,2);
demeaned_x = param.x - data_mean*ones(1,size(param.x,2));
if param.normalize
    row_normalization_factor = sqrt(sum(demeaned_x.^2,2));
    if any(row_normalization_factor < 1e-10)
        warning('normalization factor for PCA close to zero');
        row_normalization_factor(row_normalization_factor < 1e-10) = 1;
    end
    normalized_x = demeaned_x./(row_normalization_factor*ones(1,size(param.x,2)));
else
    normalized_x = demeaned_x;
end
[U,S,V] = svd(normalized_x,'econ');
dictionary = U(:,1:param.r);
coef = S(1:param.r,1:param.r)*V(:,1:param.r)';