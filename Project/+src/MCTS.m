classdef MCTS
    properties
        %Tree properties
        nodes
        actions
        availID
        %Model properties
        modelFile
        modelCtrl
        inputLimInf
        inputLimSup
        numInputDisc
        %Search algo properties
        searchAlgo          %TODO Create a factory
        %Simulation properties
        simTimeHorizon
        numCtrlPoints
        numInputRegion
    end
    methods
        function obj = MCTS(modelFile, inLimInf, inLimSup, numInDisc, numInRegion, simTimeHorizon, numCtrlPnts)
            %Initialize model controller
            obj.modelFile = modelFile;
            interval = obj.computeTimeDiscretization(simTimeHorizon, numCtrlPnts);
            obj.modelCtrl = src.ModelController(obj.modelFile, interval);
            
            %Initialize search algorithm
            obj.inputLimInf = inLimInf;
            obj.inputLimSup = inLimSup;
            obj.numInputDisc = numInDisc;
            % obj.searchAlgo = src.SearchAlgo();
            
            %Create root node
            obj.availID = 1;
            root = MCNode(obj.availID, 0, 0); %The root is the only node with parent 0
            obj.nodes = [root];
            % obj.actions = actionIDs;
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
                child = MCNode(obj.availID, nodeID, action);
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
        
        function int = computeTimeDiscretization(obj, timeHorizon, numCtrlPnts)
            int = timeHorizon/numCtrlPnts;
        end

        function obj = step(obj)
        end

        function [T, B] = regionToSignal(obj, region)
            inLimInf = region * numInputRegion
            inLimSup = (region + 1) * numInputRegion
            [T B] = obj.computeDiscreteInputSignal(inLimInf, inLimSup, obj.numInputDisc)
        end

        function region = getRandomRegion(obj)
            for i = 1:length(obj.numInputRegion)
                region(i) = randi([1 obj.numInputRegion(i)])
            end
        end

        % TODO generalize to vector
        function [U1 U2] = computeDiscreteInputSignal(obj, inLimInf, inLimSup, numInputSamples)
            % To have `k` discretization, we have to divide by `k-1`. In
            % this way, we include lower/upperbound as legal input value.
            inputStep = (inLimSup - inLimInf) ./ (numInputSamples-1);
            U1 = inLimInf(1) : inputStep(1) : inLimSup(1);
            U2 = inLimInf(2) : inputStep(2) : inLimSup(2);
        end
    end
end
