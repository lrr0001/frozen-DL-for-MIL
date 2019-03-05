function [x,coef,bag_labels,instance_labels,negative_generating_dictionary,class_generating_dictionary] = synthetic_generator(param)
sparsity_level = param.L;
number_of_classes = param.C;
dimension = param.d;
witness_rate = param.wr;
unbalance_ratio = param.ur;
instances_per_bag = param.ipb;
number_of_bags = param.nob;

number_of_negative_dictionary_atoms = param.K0;
number_of_class_specific_dictionary_atoms = param.K(1);

K_0 = number_of_negative_dictionary_atoms;
%K(1:number_of_classes) = number_of_class_specific_dictionary_atoms;
K = param.K;
%offset = [0,cumsum(K)] + K_0;
%offset(end) = [];
offset = param.offset;


%L_i = zeros(number_of_classes + 1,1);
%L_0 = zeros(number_of_classes + 1,1);
L_i = param.Li;
L_0 = param.L0;
%L_i(1) = 0;
%L_i(2) = 2;
%L_i(3) = 1;
%L_i(4) = 1;
%L_i(5) = 1;

%for cc = 1:number_of_classes + 1
%    L_0(cc) = sparsity_level - L_i(cc)*(cc - 1); 
%end


negative_generating_dictionary = normc(randn(dimension,number_of_negative_dictionary_atoms));
class_generating_dictionary = cell(number_of_classes,1);
for cc = 1:number_of_classes
    class_generating_dictionary{cc} = normc(randn(dimension,number_of_class_specific_dictionary_atoms));
end
generating_dictionary = horzcat(negative_generating_dictionary,class_generating_dictionary{:});
bags = reshape(1:instances_per_bag*number_of_bags,instances_per_bag,number_of_bags);

bag_labels = zeros(number_of_classes,number_of_bags);

for cc = 1:number_of_classes
    bag_labels(cc,:) = rand(1,number_of_bags) <= unbalance_ratio;
end
instance_labels = zeros(number_of_classes,instances_per_bag,number_of_bags);

for cc = 1:number_of_classes
    cc_bags = find(bag_labels(cc,:));
    instance_labels(cc,:,cc_bags) = rand([1,instances_per_bag,numel(cc_bags)]) <= witness_rate;
    for ii = cc_bags
        instance_labels(cc,randi(instances_per_bag),ii) = 1;
    end
end
instance_number_of_classes = sum(instance_labels,1);


f = @(instance_labels_vector,number_of_labels) arrayfun(@(ii) {randperm(K(ii),L_i(number_of_labels + 1)*instance_labels_vector(ii)) + offset(ii)},(1:number_of_classes ));
coef = cell(1,number_of_bags);


for bb = 1:number_of_bags
    coef{bb} = spalloc(number_of_negative_dictionary_atoms + number_of_classes*number_of_class_specific_dictionary_atoms, instances_per_bag,sparsity_level*instances_per_bag);
    for ii = 1:instances_per_bag
        temp = f(instance_labels(:,ii,bb),instance_number_of_classes(1,ii,bb));
        coef{bb}(horzcat(randperm(K_0,L_0(instance_number_of_classes(1,ii,bb) + 1)),temp{:}),ii) = 1 + rand(sparsity_level,1); 
    end
end

x = cell(1,number_of_bags);

for bb = 1:number_of_bags
    x{bb} = generating_dictionary*coef{bb};
end

