function sparse_coding_PACE(dependency)
    load('absolutePaths/absolute_paths.mat');
    addpath(ompPath);
    load([experimentPath,'inputNodesMATLAB/',dependency.dataPath],'x_instances');
    load([experimentPath,'inputNodesMATLAB/',dependency.learnedDictionaryPath],'learned_dictionary','gmat');
    param = dependency.param;
    learned_coef = omp(learned_dictionary'*x_instances,gmat,param.sl);
    learned_coef_bags = bag_the_array(learned_coef,param.ipb);
    save([experimentPath,'outputNodesMATLAB/',dependency.outputPathMATLAB],'learned_coef','learned_coef_bags');
    save([experimentPath,'inputNodesMATLAB/',dependency.outputPathMATLAB],'learned_coef','learned_coef_bags');
    inner = @(t) arrayfun(@(ii) py.list(full(t(:,ii)')),1:size(t,2),'UniformOutput',false);
    outer = @(t) py.list(cellfun(@(t2) inner(t2),t,'UniformOutput',false));
    py.python_save_tool.pickleSave([experimentPath,'inputNodesPython/',dependency.outputPathPython],py.list({outer(learned_coef_bags)}));
    py.python_save_tool.pickleSave([experimentPath,'outputNodesPython/',dependency.outputPathPython],py.list({outer(learned_coef_bags)}));
end
