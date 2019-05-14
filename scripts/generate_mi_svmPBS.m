function generate_mi_svmPBS(noj)
if nargin < 1
    noj = 1;
end
load('r-eStatesAndPaths/absolute_paths.mat');
[jj_list,kk_list] = max_job_split(noj);
for ii = 1:numel(jj_list)
    jj = jj_list(ii);
    kk = kk_list(ii);
    myPBSstr = sprintf([experimentPathPACE,'misvmPBS%d'],ii);
    mkdir([myPBSstr,'Out/']);
    system([sprintf('seq %d 1 %d | sort -  > "',jj,kk),myPBSstr,'Out/.filelist"']);
    fid = fopen(myPBSstr,'w');
    fprintf(fid,sprintf('#PBS -N misvmScript%d\n',ii));
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=12:00:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,sprintf('#PBS -t %d-%d\n',jj,kk));
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,sprintf('#PBS -o misvmPBS%d.out\n'));
    fprintf(fid,'cd ~/scratch/experiment_%s_PACE\n',experiment_hash);
    fprintf(fid,'module load anaconda3/latest\n');
    fprintf(fid,'source activate environment1\n');



% This MATLAB fprintf statement generates a line of bash code including bash string of python code.
% If you find this difficult to read, don't feel bad.
% I hope I got this right, because my preference would be not to debug this.
% The pairs of single quotes is how we get MATLAB to create a single quote. These single quotes start and stop strings in BASH, never reaching Python.
% The double quotes within pairs of single quotes pass through MATLAB and BASH unmodified. In Python, they begin and end strings.
% the double quotes outside the single quotes allow the Bash variable to be referenced.
    fprintf(fid,'python -c ''import sys; sys.path.insert(0,"functions_PACE"); import misvm_PACE; misvm_PACE.misvm_from_dependency_string("dependencies/est_label_misvm_dependencies/dependency''"${PBS_ARRAYID}"''.pickle")''\n');
    fprintf(fid,sprintf('> "misvmPBS%dOut/${PBS_ARRAYID}"\n',ii));
    fclose(fid);
end
