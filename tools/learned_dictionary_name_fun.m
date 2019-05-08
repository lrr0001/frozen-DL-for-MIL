function str = learned_dictionary_name_fun(nodeAbrev,id,c)
if nargin == 3
    str = sprintf('%s_class%d_%s',nodeAbrev,c,id);
elseif nargin == 2
    str = sprintf('%s_%s',nodeAbrev,id);
end