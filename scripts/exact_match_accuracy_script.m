function exact_match_accuracy_script

load('r-eStatesAndPaths/absolute_paths.mat');
% *** LOAD PARAMETERS ***
load([experimentPath,'param_file.mat'], ...
    'instances_per_bag', ...
    'number_of_bags');

% *** LOAD STRUCTURE AND SUPPORTING VARIABLES ***
load([experimentPath,'structure_file.mat']);

nodeCondition = @(node) isstreq(node,'bag_labels_identifier');


% *** LOOP: ESTIMATED BAG LABELS IDENTIFIERS***
for estimated_bag_labels_group_identifier_cell = fields(experimentLayout.n.('estimated_bag_labels_group_identifier'))'
est_bag_labels_group_id_inst_str = estimated_bag_labels_group_identifier_cell{1};
est_bag_labels_group_id = get_id_from_inst_field(est_bag_labels_group_id_inst_str);

for bag_labels_identifier_cell = fields(experimentLayout.n.('bag_labels_identifier'))'
    bag_labels_id_inst_str = bag_labels_identifier_cell{1};
    instantiationCondition = @(instantiation) isstreq(instantiation,bag_labels_id_inst_str);
    condition = @(node, instantiation) ~(nodeCondition(node) && instantiationCondition(instance));
    if experimentLayout.query('estimated_bag_labels_group_identifier',est_bag_labels_group_id_inst_str,condition)
        continue;
    end
    bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);
    break;
end

for bag_labels_node = experimentLayout.n.bag_labels_identifier.(bag_labels_id_inst_str).children
    if ~isstreq(bag_labels_node.node,'bag_labels')
        continue;
    end
    load(experimentLayout.n.bag_labels.(bag_labels_node.instance).path);
    bag_labels_struct.(datatype) = bag_labels;
end

for estimated_bag_labels_group_identifier_child = experimentLayout.n.('estimated_bag_labels_group_identifier').(est_bag_labels_group_id_inst_str).children
if ~isstreq(estimated_bag_labels_group_identifier_child.node, 'estimated_bag_labels_identifier')
    continue;
end
estimated_bag_labels_id_inst_str = estimated_bag_labels_group_identifier_child.instance;
estimated_bag_labels_id = get_id_from_inst_filed(estimated_bag_labels_id_inst_str);

datatype_list = fields(bag_labels_struct)';
for ii = 1:numel(datatype_list)
    datatype = datatype_list{ii};
    exact_match_matrix.(datatype) = true(number_of_classes,number_of_bags.(datatype));
end

for estimated_bag_labels_node = experimentLayout.n.('estimated_bag_labels_identifier').(estimated_bag_labels_id_inst_str).children
if ~isstreq(estimated_bag_labels_node.node,'estimated_bag_labels')
    continue;
end
estimated_bag_labels_inst_str = estimated_bag_labels_node.inst;

% identify class
for estimated_bag_labels_parent = experimentLayout.n.('estimated_bag_labels').(estimated_bag_labels_inst_str).parents
    if ~isstreq(estimated_bag_labels_parent.node,'class')
        continue;
    end
    class_inst_str = estimated_bag_labels_parent.instance;
    cc = get_class_from_inst_field(class_inst_str);
    break;
end

% need to write seperate script to convert from .pickle to .mat and add
% path to experiment layout graph
load(experimentLayout.n.estimated_bag_labels.(estimated_bag_labels_inst_str).path);

exact_match_matrix.(datatype)(cc,:) = exact_match_matrxix.(datatype)(cc,:) & (bag_labels_struct.(datatype)(cc,:) == estimated_bag_labels);    

% need to create new nodes and save off results



end
end
end
end