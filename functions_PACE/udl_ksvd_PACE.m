function udl_ksvd_PACE(dependency)
    param = dependency.param;
    load('absolutePaths/absolute_paths.mat');
    addpath(ksvdPath);
    addpath(ompPath);
    load([experimentPath,'inputNodesMATLAB/',dependency.dataPath],'x_instances');
    param.data = x_instances;
    learned_dictionary = ksvd(param);
    gmat = learned_dictionary'*learned_dictionary;
    save([experimentPath,'inputNodesMATLAB/',dependency.outputPath],'learned_dictionary','gmat');
    save([experimentPath,'outputNodesMATLAB/',dependency.outputPath],'learned_dictionary','gmat');
end