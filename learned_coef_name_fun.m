function str = learned_coef_name_fun(nodeAbrev,id,c,dt)
if nargin < 4
    dt = c;
end
if nargin == 3
    str = sprintf('%s_%s_%s',nodeAbrev,id,dt);
elseif nargin == 4
    str = sprintf('%s_class%d_%s_%s',nodeAbrev,c,id,dt);
end