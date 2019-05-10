function generate_mi_svmPBS(noj)
load('r-eStatesAndPaths/absolute_paths.mat');
myPBSstr = [experimentPathPACE,'misvmPBS'];
mkdir([myPBSstr,'Out/']);
system([sprintf('seq 1 1 %d | sort -  > "',noj),myPBSstr,'Out/.filelist"']);
fid = fopen(myPBSstr,'w');
fprintf(fid,'#PBS -N misvmScript\n');
fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
fprintf(fid,'#PBS -l walltime=12:00:00\n');
fprintf(fid,'#PBS -l pmem=2gb\n');
fprintf(fid,'#PBS -q iw-shared-6\n');
fprintf(fid,'cd ~/scratch/experiment_%s_PACE\n',experiment_hash);
fprintf(fid,'module load anaconda3/latest\n');
fprintf(fid,'source activate environment1\n');



% This MATLAB fprintf statement generates a line of bash code including bash string of python code.
% If you find this difficult to read, you are not alone.
% I hope I got this right, because my preference would be not to debug this.
% The pairs of single quotes is how we get MATLAB to create a single quote. These single quotes start and stop strings in BASH, never reaching Python.
% The double quotes within pairs of single quotes pass through MATLAB and BASH unmodified. In Python, they begin and end strings.
% the double quotes outside the single quotes allow the Bash variable to be referenced.
fprintf(fid,'python -c ''import sys; sys.path.insert(0,"functions_PACE"); import misvm_PACE; misvm_PACE.misvm_from_dependency_string("dependencies/est_label_misvm_dependencies/dependency''"${USER_JOBARRAYINDEX}"''.pickle")''\n');
fprintf(fid,'> "misvmPBSOut/${USER_JOBARRAYINDEX}"\n');
fclose(fid);
fid2 = fopen([experimentPathPACE,'misvmShellScript'],'w');
fprintf(fid2,sprintf('for INDEX in $(seq 1 1 %d); do\n',noj));
fprintf(fid2,'msub -v USER_JOBARRAYINDEX=${INDEX} misvmPBS\n');
fprintf(fid2,'done\n');
fclose(fid2);
end
