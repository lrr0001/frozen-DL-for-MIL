classdef sc_struct
    properties
        param
        learnedDictionaryPath
        dataPath
        outputPathMATLAB
        outputPathPython
    end
    methods
        function obj = sc_struct(learnedDictionaryPath,dataPath,param,outputPath)
            if nargin == 0
                return;
            end
            obj.learnedDictionaryPath = learnedDictionaryPath;
            obj.dataPath = dataPath;
            obj.param = param;
            obj.outputPathMATLAB = [outputPath,'.mat'];
            obj.outputPathPython = [outputPath,'.pickle'];
        end
    end
end
