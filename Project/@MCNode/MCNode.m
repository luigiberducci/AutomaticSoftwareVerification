classdef MCNode
    %NODE Node of Monte Carlo Tree   
    properties
        nodeID
        regionInf
        regionSup
        score
        n
        parentID
    end
    
    methods
        function obj = MCNode(id, parent, regInf, regSup)
            obj.nodeID = id;
            obj.regionInf = regInf;
            obj.regionSup = regSup;
            obj.score = 0;
            obj.n = 0;
            obj.parentID = parent;
        end
    end
end

