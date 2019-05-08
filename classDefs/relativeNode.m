classdef relativeNode
    properties
        node
        instance
    end
    methods
        function obj = relativeNode(node,instance)
            obj.node = node;
            obj.instance = instance;
        end
    end
end