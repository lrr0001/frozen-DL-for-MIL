#!/bin/bash
read REPLICABLEEXPERIMENTDIRECTORY < "r-eStatesAndPaths/REPLICABLE-EXPERIMENT.txt"
source "${REPLICABLEEXPERIMENTDIRECTORY}/REPLICABLEEXPERIMENTFUNCTIONS.sh"
setup_replicable_experiment_script $(basename -- "$0")

if read EXPERIMENTPATHPACE < "r-eStatesAndPaths/EXPERIMENT-PATH-PACE.txt"
then
    :
else
    echo "Error: code failed to run!"
    gracefully_exit_with_lock
fi


if scp -r "${EXPERIMENTPATHPACE}" lrichert3@iw-dm-4.pace.gatech.edu:"~/scratch"
then
    :
else
    echo "Error: code failed to run!"
    gracefully_exit_with_lock
fi

gracefully_exit_successful_replicable_experiment_script
