classdef MCNode
    %NODE Node of Monte Carlo Tree   
    properties
        nodeID
        regionInf
        regionSup
        score
        n
        parentID
        depth
    end
    
    methods
        function obj = MCNode(id, parentID, regInf, regSup, depth)
            obj.nodeID = id;
            obj.regionInf = regInf;
            obj.regionSup = regSup;
            obj.score = 0;
            obj.n = 0;
            obj.parentID = parentID;
            obj.depth = depth;
        end
    end
end

