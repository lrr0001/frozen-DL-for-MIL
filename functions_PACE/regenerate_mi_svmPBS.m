function regenerate_mi_svmPBS(taskstr)
load('absolutePaths/absolute_paths.mat');
    myPBSstr = [experimentPath,'misvmPBS'];
    fid = fopen([myPBSstr,'_retry'],'w');
    fprintf(fid,'#PBS -N misvmScript%d\n');
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=1:12:00:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q eceforce-6\n');
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,'#PBS -o misvm.out\n');
    fprintf(fid,'#PBS -t %s\n\n',taskstr);

    fprintf(fid,'cd %s\n',experimentPath);
    fprintf(fid,'module load anaconda3/latest\n');
    fprintf(fid,'source activate environment1\n');



% This MATLAB fprintf statement generates a line of bash code including bash string of python code.
% If you find this difficult to read, you are not alone.
% I hope I got this right, because my preference would be not to debug this.
% The pairs of single quotes is how we get MATLAB to create a single quote. These single quotes start and stop strings in BASH, never reaching Python.
% The double quotes within pairs of single quotes pass through MATLAB and BASH unmodified. In Python, they begin and end strings.
% the double quotes outside the single quotes allow the Bash variable to be referenced.
    fprintf(fid,'python -c ''import sys; sys.path.insert(0,"functions_PACE"); import misvm_PACE; misvm_PACE.misvm_from_dependency_string("dependencies/est_label_misvm_dependencies/dependency''"${PBS_ARRAYID}"''.pickle")''\n');
    fprintf(fid,['> "',sprintf('misvmPBS%d',ii),'Out/${PBD_ARRAYID}"\n']);
    fclose(fid);
end

