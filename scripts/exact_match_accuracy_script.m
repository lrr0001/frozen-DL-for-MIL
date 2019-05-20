clear;
load('r-eStatesAndPaths/absolute_paths.mat');
% *** LOAD PARAMETERS ***
load([experimentPath,'param_file.mat'], ...
    'instances_per_bag', ...
    'number_of_bags');

% *** LOAD STRUCTURE AND SUPPORTING VARIABLES ***
load([experimentPath,'structure_file.mat']);

nodeCondition = @(node) isstreq(node,'bag_labels_identifier');


% *** LOOP: ESTIMATED BAG LABELS IDENTIFIERS***
for estimated_bag_labels_identifier_cell = fields(experimentLayout.n.('estimated_bag_labels_identifier'))'
est_bag_labels_id_inst_str = estimated_bag_labels_identifier_cell{1};
est_bag_labels_id = get_id_from_inst_field(est_bag_labels_id_inst_str);

for bag_labels_identifier_cell = fields(experimentLayout.n.('bag_labels_identifier'))'
    bag_labels_id_inst_str = bag_labels_identifier_cell{1};
    instantiationCondition = @(instantiation) isstreq(instantiation,bag_labels_id_inst_str);
    condition = @(node, instantiation) ~(nodeCondition(node) && instantiationCondition(instance));
    if experimentLayout.query('estimated_bag_labels_identifier',est_bag_labels_id_inst_str,condition)
        continue;
    end
    bag_labels_id = get_id_from_inst_field(bag_labels_id_inst_str);
    break;
end

for estimated_bag_labels_identifier_child = experimentLayout.n.('estimated_bag_labels_identifier').(est_bag_labes_id_inst_str).children
    if ~isstreq(estimated_bag_labels_identifier_child.node, 'estimated_bag_labels')
        continue;
    end
   estimated_bag_labels_inst_str = estimated_bag_labels_identifier_child.instance;

    
    
















end
end