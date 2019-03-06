function bags = bag_the_array(array,number_of_bags,instances_per_bag)

bags = cell(1,number_of_bags);

m = 0;
for ii = 1:number_of_bags
    bags{ii} = array(:,m + 1:m + instances_per_bag);
    m = m + instances_per_bag;
end