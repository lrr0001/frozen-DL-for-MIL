classdef nodeInstance
    properties
        parents
        children
        path
    end
    methods
        function obj = nodeInstance(parents,path)
            obj.parents = parents;
            if nargin > 1
                obj.path = path;
            end
        end
    end
end