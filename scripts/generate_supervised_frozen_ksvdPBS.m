function sdl_ii = generate_supervised_frozen_ksvdPBS(noj)
if nargin < 1
    noj = 1;
end
load('r-eStatesAndPaths/absolute_paths.mat');
[jj_list,kk_list] = max_job_split(noj);
for ii = 1:numel(jj_list)
    jj = jj_list(ii);
    kk = kk_list(ii);
    myPBSstr = sprintf([experimentPathPACE,'supervised_frozen_ksvdPBS%d'],ii);
    mkdir([myPBSstr,'Out/']);
    system([sprintf('seq %d 1 %d | sort - > "',jj,kk),myPBSstr,'Out/.filelist"']);
    fid = fopen(myPBSstr,'w');
    fprintf(fid,sprintf('#PBS -N supervisedFrozenKSVDScript%d\n',ii));
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=3:30:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,sprintf('#PBS -o supervisedFrozenKSVD%d.out\n',ii));
    fprintf(fid,'#PBS -t %d-%d\n\n',jj,kk);

    fprintf(fid,'cd ~/scratch/experiment_%s_PACE\n',experiment_hash);
    fprintf(fid,'module load matlab/r2017a\n');
    fprintf(fid,'MATLABCODE="load(''absolutePaths/absolute_paths.mat'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''functions_PACE'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''tools'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''classDefs'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}dependency=get_sdl_fzn_ksvd_dependencies(${MOAB_JOBARRAYINDEX});"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}sdl_ksvd_PACE(dependency);"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}exit;"\n');
    fprintf(fid,'matlab -nodesktop -nosplash -r "${MATLABCODE}"\n');
    fprintf(fid,['> "',sprintf('supervised_frozen_ksvdPBS%d',ii),'Out/${MOAB_JOBARRAYINDEX}"\n']);
    fclose(fid);
end
sdl_ii = ii;
save([experimentPath,'number_of_PBS_scripts.mat'],'sdl_ii','-append');
end
