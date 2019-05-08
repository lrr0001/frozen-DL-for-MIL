load('r-eStatesAndPaths/absolute_paths.mat');
experimentPathPACE = [experimentPath,sprintf('experiment_%s_PACE/',experiment_hash)];
save('r-eStatesAndPaths/absolute_paths.mat','-append','experimentPathPACE');
fid = fopen('r-eStatesAndPaths/EXPERIMENT-PATH-PACE.txt','w');
fprintf(fid,'%s\n',experimentPathPACE);
fclose(fid);
mkdir(experimentPathPACE);
mkdir([experimentPathPACE,'absolutePaths']);
clear('destinationDirectory');
mkdir([experimentPathPACE,'inputNodesMATLAB/']);
mkdir([experimentPathPACE,'outputNodesMATLAB/']);
mkdir([experimentPathPACE,'inputNodesPython/']);
mkdir([experimentPathPACE,'inputNodesPython/bag_labels/']);
mkdir([experimentPathPACE,'outputNodesPython/']);
mkdir([experimentPathPACE,'outputNodesPython/estimated_bag_labels/']);
mkdir([experimentPathPACE,'dependencies/']);
mkdir([experimentPathPACE,'tools']);
mkdir([experimentPathPACE,'functions_PACE']);
mkdir([experimentPathPACE,'classDefs']);
experimentPath = sprintf('/nv/hp20/lrichert3/scratch/experiment_%s_PACE/',experiment_hash);
ksvdPath = '~/ksvdbox13';
ompPath = '~/ompbox10';
vars = who;
[~,rmThisInd] = ismember(experimentPathPACE,vars);
save([experimentPathPACE,'absolutePaths/','absolute_paths.mat'],vars{(1:numel(vars)) ~= rmThisInd});
tf = copyfile('functions_PACE',[experimentPathPACE,'functions_PACE/']);
if ~tf
    error('copying PACE functions to PACE staging directory failed.');
end
tf = copyfile('tools',[experimentPathPACE,'tools/']);
if ~tf
    error('copying tools folder to PACE staging directory failed.');
end
tf = copyfile('classDefs',[experimentPathPACE,'classDefs']);
if ~tf
    error('copying class definitions folder to PACE staging directory failed.');
end
