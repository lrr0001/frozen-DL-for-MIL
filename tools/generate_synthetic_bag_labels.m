function bag_labels = generate_synthetic_bag_labels(param)
bag_labels = rand(param.C,param.nob) <= param.ur;
end