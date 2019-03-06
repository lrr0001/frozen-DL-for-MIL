function [training_data,validation_data,testing_data] = split_data_tvt(data,num_of_train,num_of_val,num_of_test)
train_ind = 1:num_of_train;
val_ind = num_of_train + 1:num_of_train + num_of_val;
test_ind =  num_of_train + num_of_val + 1:num_of_train + num_of_val + num_of_test;

data_size = size(data);

if (data_size(1) == 1 || data_size(2) == 1) && prod(data_size) == prod(data_size(1:2))
    training_data = data(train_ind);
    validation_data = data(val_ind);
    testing_data = data(test_ind);
else
    subs = cell(1,numel(data_size));
    for ii = 1:numel(data_size) - 1
        subs{ii} = 1:data_size(ii);
    end
    
    subs{numel(data_size)} = train_ind;    
    training_data = reshape(data(sub2ind(data_size,subs{ii})),[data_size(1:end - 1),num_of_train]);
    subs{numel(data_size)} = val_ind;
    validation_data = reshape(data(sub2ind(data_size,subs{ii})),[data_size(1:end - 1),num_of_val]);
    subs{numel(data_size)} = test_ind;
    testing_data = reshape(data(sub2ind(data_size,subs{ii})),[data_size(1:end - 1),num_of_test]);
end
end