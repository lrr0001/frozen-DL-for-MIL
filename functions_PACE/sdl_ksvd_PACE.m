function sdl_ksvd_PACE(dependency)
    load('absolutePaths/absolute_paths.mat');
    addpath(ksvdPath);
    addpath(ompPath);
    load([experimentPath,'inputNodesMATLAB/',dependency.dataPath],'x');
    x_train = x;
    load([experimentPath,'inputNodesMATLAB/',dependency.bagLabelPath],'bag_labels');
    bag_labels_train = bag_labels;
    cc = dependency.class;
    learned_dictionary = MIL_supervised_ksvd(x_train,bag_labels_train(cc,:),dependency.param);
    gmat = learned_dictionary'*learned_dictionary;
    save([experimentPath,'outputNodesMATLAB/',dependency.outputPath],'learned_dictionary','gmat');
    save([experimentPath,'inputNodesMATLAB/',dependency.outputPath],'learned_dictionary','gmat');
end
