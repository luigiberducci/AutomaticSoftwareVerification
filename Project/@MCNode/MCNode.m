classdef myNode
    %NODE Node of Monte Carlo Tree   
    properties
        nodeID
        action
        score
        n
        parentID
    end
    
    methods
        function obj = myNode(id, parent, act)
            obj.nodeID = id;
            obj.action = act;
            obj.score = 0;
            obj.n = 0;
            obj.parentID = parent;
        end
    end
end

