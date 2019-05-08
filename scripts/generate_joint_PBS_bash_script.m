% function generate_joint_PBS_bash_script

load('r-eStatesAndPaths/absolute_paths.mat');
load([experimentPath,'number_of_PBS_scripts.mat']);
fid = fopen(sprintf([experimentPathPACE,'call_PBS_scripts']),'w');
fprintf(fid,'#!/bin/bash\n');
udlJobs = cell(1,udl_ii);
for ii = 1:udl_ii
    udlJobs{ii} = sprintf('UDLJOBPBS%d',ii);
    fprintf(fid,'%s=$(qsub unsupervised_ksvdPBS%d)\n',udlJobs{ii},ii);
    fprintf(fid,'echo $%s\n',udlJobs{ii});
end
sdlJobs = cell(1,sdl_ii);
for ii = 1:sdl_ii
    sdlJobs{ii} = sprintf('SDLJOBPBS%d',ii);
    fprintf(fid,'%s=$(qsub supervised_frozen_ksvdPBS%d)\n',sdlJobs{ii},ii);
    fprintf(fid,'echo $%s\n',sdlJobs{ii});
end
prevJobsStr = sprintf(':$%s',udlJobs{:},sdlJobs{:});
scJobs = cell(1,sc_ii);
for ii = 1:sc_ii
    scJobs{ii} = sprintf('SCJOBPBS%d',ii);
    fprintf(fid,'%s=$(qsub -W depend=afterok%s sparse_codingPBS%d)\n',scJobs{ii},prevJobsStr,ii);
    fprintf(fid,'echo $%s\n',scJobs{ii});
end
prevJobsStr = sprintf(':$%s',scJobs{:});
misvmJobs = cell(1,misvm_ii);
for ii = 1:misvm_ii
    misvmJobs{ii} = sprintf('MISVMJOBPBS%d',ii);
    fprintf(fid,'%s=$(qsub -W depend=afterok%s misvmPBS%d)\n',misvmJobs{ii},prevJobsStr,ii);
    fprintf(fid,'echo $%s\n',misvmJobs{ii});
end
fclose(fid);


