load('r-eStatesAndPaths/absolute_paths.mat');

load([experimentPath,'param_file.mat'], ...
    'number_of_classes');

load([experimentPath,'structure_file.mat']);


mkdir([experimentPath,'estimated_bag_labels/']);

currDirectory = pwd;

cd([experimentPathPACE,'outputNodesPython/estimated_bag_labels/']);

list_of_files_str = ls;
list_of_files = strsplit(list_of_files_str);

cd(currDirectory);
for filename = list_of_files
    fn = filename{1};
    if numel(fn) == 0
        continue;
    end
    instField = fn(1:end - 7);
    filelocation = [experimentPathPACE,'outputNodesPython/estimated_bag_labels/',fn];
    python_output = cell(py.python_save_tool.pickleLoad(py.str(filelocation),int32(2)));
    estimated_bag_labels_python_array = python_output{1};
    estimated_bag_labels_array = double(py.array.array('f',py.numpy.nditer(estimated_bag_labels_python_array)));
    estimated_bag_labels = (sign(estimated_bag_labels_array) + 1)/2;
    
    datatype = python_output{2};
    ebl_path = [experimentPath,'estimated_bag_labels/',instField,'.mat'];
    save(ebl_path,'estimated_bag_labels','datatype');
    experimentLayout.add_instantiation('estimated_bag_labels',instField,nodeInstance(experimentLayout.n.estimated_bag_labels.(instField).parents,ebl_path));
end