classdef MCTS
    properties
        nodes
        actions
        availID
    end
    methods
        function obj = MCTS(actionIDs)
            %Create root node
            obj.availID = 1;
            root = myNode(obj.availID, 0, 0); %The root is the only node with parent 0
            obj.nodes = [root];
            obj.actions = actionIDs;
            %Increment next available node identifier
            obj.availID = obj.availID + 1;
        end
        
        function nodeID = selection(obj)
            nodeID = 1;     %root
            node = obj.nodes(nodeID);
            children = obj.getChildren(nodeID);
            while not(isempty(children))
                min_val = Inf;
                min_child = 1;
                for childID = children
                    child = obj.nodes(childID);
                    childVal = obj.evalNode(child);
                    if childVal<min_val
                        min_val = childVal;
                        min_child = childID;
                    end
                end
                nodeID = min_child;
                nodeCnt = obj.nodes(nodeID);
                children = obj.getChildren(nodeID);
            end
        end
        
        function obj = expansion(obj, nodeID)
            node = obj.nodes(nodeID);
            for action = obj.actions
                child = myNode(obj.availID, nodeID, action);
                obj.nodes = [obj.nodes child];
                obj.availID = obj.availID+1;
            end
        end
        
        function rollout(obj)
        end
        
        function backpropagation(obj)
        end
        
        function val = evalNode(obj, node)
            val = obj.computeUCB(node)
        end
        
        function ids = getChildren(obj, nodeID)
            ids = find(obj.nodes.parentID==nodeID);
        end
        
        function ucb = computeUCB(obj, node)
            parent = obj.nodes(node.parentID);
            N = parent.n;           % Number of visit of parent node
            n = node.n;             % Number of visit of current node
            V = node.score/node.n;  % Score mean
            c = 2;                  % Weight factor
            
            ucb = Inf;
            if not(n==0)
                ucb = V + c*sqrt(log(N)/n);
            end
        end
    end
end