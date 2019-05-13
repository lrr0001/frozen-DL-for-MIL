function generate_misvm_retrialPBS
load('r-eStatesAndPaths/absolute_paths.mat');
    myPBSstr = [experimentPathPACE,'rebuild_misvmPBS'];
    fid = fopen(myPBSstr,'w');
    fprintf(fid,'#PBS -N rebuild_misvm\n');
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=30:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,'#PBS -o rebuild_misvm.out\n');

    fprintf(fid,'module load matlab/r2017a\n');

    fprintf(fid,[sprintf('if cd ~/scratch/experiment_%s_PACE/',experiment_hash),'misvmPBSOut/; then\n']);
    fprintf(fid,'TEMPVAR=$(ls | diff - .filelist | grep ">")\n');
    fprintf(fid,'cd ..\n');
    fprintf(fid,'rm misvmPBSOut/*\n');
    fprintf(fid,'if [ -z "$TEMPVAR" ]; then\n');
    fprintf(fid,'echo "All subtasks were completed."\n');
    fprintf(fid,'else\n');
    fprintf(fid,'echo "${TEMPVAR//> }" > misvmPBSOut/.filelist\n');
    fprintf(fid,'TEMPVAR="${TEMPVAR//$''\\n''> /,}"\n');
    fprintf(fid,'TEMPVAR="${TEMPVAR//> }"\n');
    fprintf(fid,'echo "${TEMPVAR} failed."\n'); 

    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''functions_PACE'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}regenerate_mi_svmPBS(''${TEMPVAR}'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}exit;"\n');
    fprintf(fid,'matlab -nodesktop -nosplash -r "${MATLABCODE}"\n');
    fprintf(fid,'fi\n');
    fprintf(fid,'fi\n');
    fclose(fid);
