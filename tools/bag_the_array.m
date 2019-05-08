function bags = bag_the_array(array,number_of_bags,instances_per_bag)
if nargin == 2
    instances_per_bag = number_of_bags;
    number_of_bags = size(array,2)/instances_per_bag;
end
bags = cell(1,number_of_bags);

m = 0;
for ii = 1:number_of_bags
    bags{ii} = array(:,m + 1:m + instances_per_bag);
    m = m + instances_per_bag;
end
