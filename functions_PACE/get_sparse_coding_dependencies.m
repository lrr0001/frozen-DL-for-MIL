function dependency = get_sparse_coding_dependencies(ind)
    load('dependencies/sc_dependencies.mat');
    dependency = dependencies(ind);
end