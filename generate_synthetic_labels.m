function [bag_labels,instance_labels] = generate_synthetic_labels(param)
bag_labels = rand(param.C,param.nob) <= param.ur;
instance_labels = zeros(param.C,param.ipb,param.nob);
for cc = 1:param.C
    cc_bags = find(bag_labels(cc,:));
    instance_labels(cc,:,cc_bags) = rand([1,param.ipb,numel(cc_bags)]) <= param.wr;
    for ii = cc_bags
        instance_labels(cc,randi(param.ipb),ii) = 1;
    end
end
