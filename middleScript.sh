read REPLICABLEEXPERIMENTDIRECTORY < "r-eStatesAndPaths/REPLICABLE-EXPERIMENT.txt"
source "${REPLICABLEEXPERIMENTDIRECTORY}/REPLICABLEEXPERIMENTFUNCTIONS.sh"
setup_replicable_experiment_script $(basename -- "$0")

#if <code that might fail>
#then
#    :
#else
#    echo "Error: code failed to run!"
#    gracefully_exit_with_lock
#fi

gracefully_exit_successful_replicable_experiment_script
