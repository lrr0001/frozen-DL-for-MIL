function x = generate_synthetic_data(dictionary,coef,param)
x = cell(1,param.nob);
for bb = 1:number_of_bags
    x{bb} = dictionary*coef{bb};
end