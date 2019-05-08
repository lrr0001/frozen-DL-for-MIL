function instance_labels = generate_synthetic_instance_labels(bag_labels,param)
instance_labels = zeros(param.C,param.ipb,param.nob);
for cc = 1:param.C
    cc_bags = find(bag_labels(cc,:));
    instance_labels(cc,:,cc_bags) = rand([1,param.ipb,numel(cc_bags)]) <= param.wr(cc);
    for ii = cc_bags
        instance_labels(cc,randi(param.ipb),ii) = 1;
    end
end
end