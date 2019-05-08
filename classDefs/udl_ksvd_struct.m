classdef udl_ksvd_struct
    properties
        param
        dataPath
        outputPath
    end
    methods
        function obj = udl_ksvd_struct(dataPath,param,outputPath)
            if nargin == 0
                return;
            end
            obj.dataPath = dataPath;
            obj.param = param;
            obj.outputPath = outputPath;
        end
    end
end