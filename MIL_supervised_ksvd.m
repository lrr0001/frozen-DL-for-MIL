function learned_dictionary = MIL_supervised_ksvd(x,bagLabels,MIL_supervised_param)
x_cc = horzcat(x{logical(bagLabels)});
x_other = horzcat(x{~logical(bagLabels)});
param.data = x_other;
param.dictsize = MIL_supervised_param.negative_dictsize;
param.Tdata = MIL_supervised_param.negative_Tdata;
param.iternum = MIL_supervised_param.negative_iternum;
learned_negative_dictionary = ksvd(param);
param.data = x_cc;
param.frozendict = learned_negative_dictionary;
param.dictsize = MIL_supervised_param.total_dictsize;
param.Tdata = MIL_supervised_param.total_tdata;
param.iternum = MIL_supervised_param.positive_iternum;
learned_dictionary = ksvd_frozen(param);
end