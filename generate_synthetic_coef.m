function coef = generate_synthetic_coef(instance_labels,param)
instance_number_of_classes = sum(instance_labels,1);
L_i = param.Li;
L_0 = param.L0;
offset = param.offset;
K = param.K;
f = @(instance_labels_vector,number_of_labels) arrayfun(@(ii) {randperm(K(ii),L_i(number_of_labels + 1)*instance_labels_vector(ii)) + offset(ii)},(1:param.C));
coef = cell(1,number_of_bags);
for bb = 1:param.nob
    coef{bb} = spalloc(param.K0 + sum(param.K),param.ipb,param.L*param.ipb);
    for ii = 1:param.ipb
        temp = f(instance_labels(:,ii,bb),instance_number_of_classes(1,ii,bb));
        coef{bb}(horzcat(randperm(param.K0,L_0(instance_number_of_classes(1,ii,bb) + 1)),temp{:}),ii) = 1 + rand(param.L,1);
    end
end