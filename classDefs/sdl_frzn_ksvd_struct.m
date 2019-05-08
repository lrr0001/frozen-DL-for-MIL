classdef sdl_frzn_ksvd_struct
    properties
        param
        dataPath
        bagLabelPath
        outputPath
        class
    end
    methods
        function obj = sdl_frzn_ksvd_struct(dataPath,bagLabelPath,param,class,outputPath)
            if nargin == 0
                return;
            end
            obj.dataPath = dataPath;
            obj.bagLabelPath = bagLabelPath;
            obj.param = param;
            obj.class = class;
            obj.outputPath = outputPath;
        end
    end
end