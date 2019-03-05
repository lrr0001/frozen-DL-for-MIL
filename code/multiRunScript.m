ir_set = 10:10:50;
wr_set = [15,20,30,40,50];

for ir = ir_set
    for wr = wr_set
        curr_folder = sprintf('wr%dir%d',wr,ir);
        %{
        mkdir(curr_folder);
        copyfile('pca_DL.m',curr_folder);
        copyfile('syn_experiment_script.m',curr_folder);
        %}
        copyfile('syn_experiment_validation_param_search.m',curr_folder);
        %{
        copyfile('synthetic_generator.m',curr_folder);
        copyfile('ValidationRuns',curr_folder);
        copyfile('test_module.py',curr_folder);
        unbalance_ratio = ir/100;
        witness_rate = wr/100;
        curr_folder = sprintf('wr%dir%d',wr,ir);
        save(horzcat(curr_folder,'/folder_param'),'witness_rate','unbalance_ratio');
        %}
    end
end

py.sys.setdlopenflags(int32(10));
py.importlib.import_module('test_module')
py.test_module.pickleSave('folder_param.pickle',py.list({ir_set,wr_set}));

for ii = 1:numel(ir_set)
    ir = ir_set(ii);
    for jj = 1:numel(wr_set)
        wr = wr_set(jj);
        cd(sprintf('wr%dir%d',wr,ir));
        save('temp','ir','wr','ir_set','wr_set','ii','jj');
        %{
        if ii == 1 && jj == 1
             syn_experiment_script;
             py.sys.setdlopenflags(int32(10));
             py.importlib.import_module('test_module')
        else
            syn_experiment_script;
        end
        %}
        syn_experiment_validation_param_search;
        clear;
        load('temp');
        cd('..');
    end
end

