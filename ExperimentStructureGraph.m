classdef ExperimentStructureGraph < handle
    properties
        n
    end
    methods
        function obj = ExperimentStructureGraph()
        end
        function obj = add_instantiation(obj,nodeField,instantiationField,instantiation)
            % need to check whether instantiation already exists.  If
            % instantiation already exists, it will not be overwritten.
            if isfield(obj.n,nodeField)
                if isfield(obj.n.(nodeField),instantiationField)
                    parentsInGraph = obj.n.(nodeField).(instantiationField).parents;
                    proposedParents = instantiation.parents;
                    for proposedParent = proposedParents
                        found = false;
                        for graphParent = parentsInGraph
                            if numel(proposedParent.node) == numel(graphParent.node) && numel(proposedParent.instance) == numel(graphParent.instance)
                                if all(proposedParent.node == graphParent.node) && all(proposedParent.instance == graphParent.instance)
                                    found = true;
                                    break;
                                end
                            end
                        end
                        if ~found
                            error('added instantiation conflicts with earlier instantiation! (added parent)');
                        end
                    end
                    for graphParent = parentsInGraph
                        for proposedParent = proposedParents
                            if all(proposedParent.node == graphParent.node) && all(proposedParent.instance == graphParent.instance)
                                found = true;
                                break;
                            end
                        end
                        if ~found
                            error('added instantiation conflicts with earlier instantiation! (ommitted parent)');
                        end
                    end
                    return
                end
            end
            
            obj.n.(nodeField).(instantiationField) = instantiation;
                
            for parent = obj.n.(nodeField).(instantiationField).parents
                obj.n.(parent.node).(parent.instance).children = [obj.n.(parent.node).(parent.instance).children,relativeNode(nodeField,instantiationField)];
            end
        end
        function tf = subDirectionQuery(obj,nodeField,instantiationField,condition,direction)
            if ~condition(nodeField,instantiationField)
                tf = false;
            else
                tf = true;
                if ~isempty(obj.n.(nodeField).(instantiationField).(direction))
                    for relative = obj.n.(nodeField).(instantiationField).(direction)
                        if ~subDirectionQuery(obj,relative.node,relative.instantiation,condition,direction)
                            tf = false;
                            break;
                        end
                    end
                end
            end
        end
        function tf = query(obj,nodeField,instantiationField,condition)
            if ~subDirectionQuery(obj,nodeField,instantiationField,condition,'parents')
                tf = false;
            elseif ~subDirectionQuery(obj,nodeField,instantiationField,condition,'children')
                tf = false;
            else
                tf = true;
            end
        end
        function obj = remove_instantiation(obj,nodeField,instantiationField)
            % this function will remove an instantiation and all its
            % descendents.
            instantiationList = [relativeNode(nodeField,instantiationField), obj.n.(nodeField).(instantiationField).children];
            for instantiationChild = obj.(nodeField).(instantiationField).children
                instantiationList = [instantiationList,get_descendents(obj,obj.(instantiationChild.node).(instantiationChild.instance))];
            end
            uniqueInds = ones(1,numel(instantiationList));
            for ii = 1:numel(instantiationList) - 1
                for jj = ii + 1:numel(instantiationList)
                    if all(instantiationList(jj).instance == instantiationList(ii).instance)
                        if all(instantiationList(jj).node == instantiationList(ii).node)
                            uniqueInds(jj) = 0;
                        end
                    end
                end
            end
            % clean up parent references to children
            for currentInstantiation = instantiationList(uniqueInds)
                for instantiationParent = obj.n.(currentInstantiation.node).(currentInstantiation.instance).parents
                    sibblings = obj.n.(instantiationParent.node).(instantiationParent.instance).children;
                    for ii = 1:numel(sibblings)
                        sibbling = sibblings(ii);
                        if all(currentInstantiation.instance == sibbling.instance) && all(currentInstantiation.node == sibbling.node)
                            obj.(instantiationParent.node).(instantiationParent.instance).children(ii) = [];
                            break;
                        end
                    end
                end
            end
            % remove instantiations
            for currentInstantiation = instantiationList(uniqueInds)
                obj.(currentInstantiation.node) = rmfield(obj.n.(currentInstantiation.node),currentInstantiation.instance);
            end
        end
        function descendents = get_descendents(obj,nodeField,instantiationField)
            descendents = obj.n.(nodeField).(instantiationField).children
            for child = obj.n.(nodeField).(instantiationField).children
                descendents = [descendents,get_descendents(obj,child.node,child.instance)];
            end
        end
    end
end