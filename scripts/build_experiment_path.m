destinationDirectory = getDestination();
experiment_hash = dec2hex(randi(2^28) - 1);
if destinationDirectory(end) == '/'
    experimentPath = [destinationDirectory,sprintf('experiment_%s/',experiment_hash)];
else
    experimentPath = [destinationDirectory,sprintf('/experiment_%s/',experiment_hash)];
end
mkdir(experimentPath);

ksvdPath = getKSVD;
ompPath = getOMP;

save('r-eStatesAndPaths/absolute_paths.mat');