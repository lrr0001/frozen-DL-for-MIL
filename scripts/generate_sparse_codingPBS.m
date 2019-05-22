function generate_sparse_codingPBS(noj)
if nargin < 1
    noj = 1;
end
load('r-eStatesAndPaths/absolute_paths.mat');
[jj_list,kk_list] = max_job_split(noj);
for ii = 1:numel(jj_list)
    jj = jj_list(ii);
    kk = kk_list(ii);


    myPBSstr = sprintf([experimentPathPACE,'sparse_codingPBS%d'],ii);
    mkdir([myPBSstr,'Out/']);
    system([sprintf('seq %d 1 %d | sort - > "',jj,kk),myPBSstr,'Out/.filelist"']);
    fid = fopen(myPBSstr,'w');
    fprintf(fid,sprintf('#PBS -N sparseCodingScript%d\n',ii));
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=2:00:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,sprintf('#PBS -t %d-%d\n',jj,kk));
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,sprintf('#PBS -o sparseCoding%d.out\n',ii));

    fprintf(fid,'cd ~/scratch/experiment_%s_PACE\n',experiment_hash);
    fprintf(fid,'module load matlab/r2017a\n');
    fprintf(fid,'module load anaconda3/latest\n');
    fprintf(fid,'source activate environment1\n');
    fprintf(fid,'MATLABCODE="load(''absolutePaths/absolute_paths.mat'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''functions_PACE'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''tools'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}addpath(''classDefs'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}cd(''tools'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}insert(py.sys.path,int32(0),'''');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}py.importlib.import_module(''python_save_tool'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}cd(''..'');"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}dependency=get_sparse_coding_dependencies(${PBS_ARRAYID});"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}sparse_coding_PACE(dependency);"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}fid = fopen(''sparse_codingPBS%dOut/${PBS_ARRAYID}'',''w'');"\n',ii);
    fprintf(fid,'MATLABCODE="${MATLABCODE}fclose(fid);"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}exit;"\n');
    fprintf(fid,'matlab -nodesktop -nosplash -r "${MATLABCODE}"\n');
    fclose(fid);
end
end
