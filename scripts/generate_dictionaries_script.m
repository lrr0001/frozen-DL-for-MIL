load('param_file.mat', ...
    'number_of_generating_dictionaries', ...
    'number_of_negative_dictionary_atoms', ...
    'K', ...
    'dimension', ...
    'number_of_classes');
load('structure_file.mat');    


for ii = 1:number_of_generating_dictionaries
    
    % dictionary generation code
gen_dict_param.K_0 = number_of_negative_dictionary_atoms;
gen_dict_param.K = K;
gen_dict_param.d = dimension;
gen_dict_param.C = number_of_classes;
generating_dictionary = generate_synthetic_dictionary(gen_dict_param);
dict_id = dec2hex(randi(2^28) - 1);
nodeName = 'generating_dictionary_identifier';
parents = [];
instantiationField = instanceNameFun.ms.(nodeName)(dict_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));


parents = [build_relative_node('generating_dictionary_identifier',dict_id), ...
    build_relative_node('number_of_classes',number_of_classes), ...
    build_relative_node('dimension',dimension), ...
    build_relative_node('number_of_negative_dictionary_atoms',number_of_negative_dictionary_atoms), ...
    build_relative_node('K',K)];
nodeName = 'dictionary';
instantiationField = instanceNameFun.ms.(nodeName)(dict_id);
experimentLayout.add_instantiation(nodeName,instantiationField,nodeInstance(parents));
end
save('structure_file.mat','experimentLayout','-append');