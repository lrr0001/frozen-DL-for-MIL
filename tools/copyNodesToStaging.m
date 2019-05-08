function copyNodesToStaging(nodename)
load('r-eStatesAndPaths/absolute_paths.mat');
mkdir([experimentPathPACE,'inputNodesMATLAB/',nodename,'/']);
copyfile([experimentPath,nodename,'/*'],[experimentPathPACE,'inputNodesMATLAB/',nodename,'/']);
end
