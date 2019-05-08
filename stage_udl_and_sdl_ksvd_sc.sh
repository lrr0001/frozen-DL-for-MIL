#!/bin/bash
read REPLICABLEEXPERIMENTDIRECTORY < "r-eStatesAndPaths/REPLICABLE-EXPERIMENT.txt"
source "${REPLICABLEEXPERIMENTDIRECTORY}/REPLICABLEEXPERIMENTFUNCTIONS.sh"
setup_replicable_experiment_script $(basename -- "$0")

if /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "addpath('main_scripts');rng('shuffle');dbstop if error;main_stage_udl_sdl_ksvd_sc;exit;"
then
    :
else
    echo "Error: code failed to run!"
    gracefully_exit_with_lock
fi

gracefully_exit_successful_replicable_experiment_script
