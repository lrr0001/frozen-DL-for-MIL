function generating_dictionary = generate_synthetic_dictionary(param)
negative_generating_dictionary = normc(randn(param.d,param.K0));
class_generating_dictionary = cell(number_of_classes,1);
for cc = 1:param.C
    class_generating_dictionary{cc} = normc(randn(param.d,param.K(cc)));
end
generating_dictionary = horzcat(negative_generating_dictionary,class_generating_dictionary{:});
end