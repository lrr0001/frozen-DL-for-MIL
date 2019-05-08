#!/bin/bash
read REPLICABLEEXPERIMENTDIRECTORY < "r-eStatesAndPaths/REPLICABLE-EXPERIMENT.txt"
source "${REPLICABLEEXPERIMENTDIRECTORY}/REPLICABLEEXPERIMENTFUNCTIONS.sh"
setup_replicable_experiment_script $(basename -- "$0")

if /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "addpath('main_scripts');cd('tools');insert(py.sys.path,int32(0),'');py.importlib.import_module('python_save_tool');cd('..');rng('shuffle');main_build_synthetic_data;exit;"
then
    :
else
    echo "Error: code failed to run!"
    gracefully_exit_with_lock
fi

gracefully_exit_successful_replicable_experiment_script
