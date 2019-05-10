function generate_misvm_retrialPBS(nof)
if nargin < 1
    nof = 1;
end
load('r-eStatesAndPaths/absolute_paths.mat');
for ii = 1:nof
    myPBSstr = sprintf([experimentPathPACE,'rebuild_misvmPBS%d'],ii);
    fid = fopen(myPBSstr,'w');
    fprintf(fid,sprintf('#PBS -N rebuild_misvm%d\n',ii));
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=30:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,sprintf('#PBS -o rebuild_misvm%d.out\n',ii));

    fprintf(fid,'module load matlab/r2017a\n');

    fprintf(fid,[sprintf('if cd ~/scratch/experiment_%s_PACE/',experiment_hash),sprintf('misvmPBS%dOut/; then\n',ii)]);
    fprintf(fid,'TEMPVAR=$(ls | diff - .filelist | grep ">")\n');
    fprintf(fid,'cd ..\n');
    fprintf(fid,sprintf('rm misvmPBS%dOut/*\n',ii));
    fprintf(fid,'if [ -z $TEMPVAR ]; then\n');
    fprintf(fid,'echo "All subtasks were completed."\n');
    fprintf(fid,'else\n');
    fprintf(fid,'echo "${TEMPVAR//> }" > .filelist\n');
    fprintf(fid,'TEMPVAR=${TEMPVAR//$''\\n''> /,}\n');
    fprintf(fid,'TEMPVAR=${TEMPVAR//> }\n');
    fprintf(fid,'echo "${TEMPVAR} failed."\n'); 

    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''functions_PACE'');"\n');
    fprintf(fid,sprintf('MATLABCODE="${MATLABCODE}regenerate_mi_svmPBS(%d,''${TEMPVAR}'');"\n',ii));
    fprintf(fid,'MATLABCODE="${MATLABCODE}exit;"\n');
    fprintf(fid,'matlab -nodesktop -nosplash -r "${MATLABCODE}"\n');
    fprintf(fid,'fi\n');
    fprintf(fid,'fi\n');
    fclose(fid);
end
end
