function dependency = get_udl_ksvd_dependencies(ind)
    load('dependencies/udl_ksvd_dependencies.mat');
    dependency = dependencies(ind);
end