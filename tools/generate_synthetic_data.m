function x = generate_synthetic_data(dictionary,coef,param)
x = cell(1,param.nob);
for bb = 1:param.nob
    x{bb} = dictionary*coef{bb};
end