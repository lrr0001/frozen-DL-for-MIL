function generate_sparse_codingPBS(noj)
if nargin < 1
    noj = 1;
end
load('r-eStatesAndPaths/absolute_paths.mat');

    myPBSstr = [experimentPathPACE,'sparse_codingPBS'];
    mkdir([myPBSstr,'Out/']);
    system([sprintf('seq 1 1 %d | sort - > "',noj),myPBSstr,'Out/.filelist"']);
    fid = fopen(myPBSstr,'w');
    fprintf(fid,'#PBS -N sparseCodingScript\n');
    fprintf(fid,'#PBS -l nodes=1:ppn=1\n');
    fprintf(fid,'#PBS -l walltime=2:00:00\n');
    fprintf(fid,'#PBS -l pmem=2gb\n');
    fprintf(fid,'#PBS -q iw-shared-6\n');
    fprintf(fid,'#PBS -j oe\n');
    fprintf(fid,'#PBS -o sparseCoding.out\n');

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
    fprintf(fid,'MATLABCODE="${MATLABCODE}dependency=get_sparse_coding_dependencies(${USER_JOBARRAYINDEX});"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}sparse_coding_PACE(dependency);"\n');
    fprintf(fid,'MATLABCODE="${MATLABCODE}exit;"\n');
    fprintf(fid,'matlab -nodesktop -nosplash -r "${MATLABCODE}"\n');
    fprintf(fid,['> "sparse_codingPBSOut/${USER_JOBARRAYINDEX}"\n']);
    fclose(fid);
fid2 = fopen([experimentPathPACE,'sparseCodingShellScript'],'w');
fprintf(fid2,sprintf('for INDEX in $(seq 1 1 %d); do\n',noj));
fprintf(fid2,'msub -v USER_JOBARRAYINDEX=${INDEX} sparse_codingPBS\n');
fprintf(fid2,'done\n');
fclose(fid2);
end
