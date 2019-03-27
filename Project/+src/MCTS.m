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
        quantumSize
        numInRegions
        %Search algo properties
        searchAlgo          %TODO Create a factory
        %Simulation properties
        simTimeHorizon
        numCtrlPoints
        numInputRegion
    end
    methods
        function obj = MCTS(modelFile, inLimInf, inLimSup, numInDisc, numInRegions, simTimeHorizon, numCtrlPnts)
            %% TODO Commentare segnatura input
            %Initialize model controller
            obj.modelFile = modelFile;
            interval = obj.computeTimeDiscretization(simTimeHorizon, numCtrlPnts);
            obj.modelCtrl = src.ModelController(obj.modelFile, interval);
            
            %Initialize search algorithm parameters
            obj.inputLimInf = inLimInf;
            obj.inputLimSup = inLimSup;
            obj.numInputDisc = numInDisc;
            obj.quantumSize = (inLimSup - inLimInf) ./ numInDisc;
            obj.numInRegions = numInRegions;
            
            %Create root node
            obj.availID = 1;
            root = MCNode(obj.availID, 0, [-1 -1], [-1 -1]); %The root is the only node with parent 0
            obj.nodes = [root];
            %Increment next available node identifier
            obj.availID = obj.availID + 1;
        end
        
        function curNodeID = selection(obj)
            curNodeID = 1;     %root
            obj.modelCtrl = obj.modelCtrl.reset();  %Reset to t0
            node = obj.nodes(curNodeID);
            children = obj.getChildren(curNodeID);
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
                %Pick the selected node and step ahed the simulation
                curNodeID = min_child;
                
                u = obj.chooseActionFromNodeID(curNodeID);
                obj.modelCtrl = obj.modelCtrl.setInput(u);
                obj.modelCtrl = obj.modelCtrl.step();
                children = obj.getChildren(curNodeID);
            end
        end
        
        function u = chooseActionFromNodeID(obj, nodeID)
            curNode = obj.nodes(nodeID);
            regionInf = curNode.regionInf;
            regionSup = curNode.regionSup;
                
            u = obj.chooseAction(regionInf, regionSup);
        end
        
        function u = chooseAction(obj, regionInf, regionSup)
            for i = 1:length(regionInf)
                u(i) = randsample([regionInf(i) : obj.quantumSize(i) : regionSup(i)], 1);
            end
        end
        
        function obj = expansion(obj, nodeID)
            for actionID = 1:prod(obj.numInRegions)
                [it,ib] = ind2sub(obj.numInRegions, actionID);
                inLimInf = [it*obj.quantumSize(1) ib*obj.quantumSize(2)];
                inLimSup = [(it+1)*obj.quantumSize(1) (ib+1)*obj.quantumSize(2)];
                child = MCNode(obj.availID, nodeID, inLimInf, inLimSup);
                obj.nodes = [obj.nodes child];
                obj.availID = obj.availID+1;
            end
        end
        
        function obj = preRollout(obj, nodeID)
            node = obj.nodes(nodeID);
            children = obj.getChildren(nodeID);
            ucb = zeros(size(children));
            for i = 1:length(children)
                childID = children(i);
                child = obj.nodes(childID);
                ucb(i) = obj.computeUCB(child);
            end
            % Choose min child
            [~, min_id] = min(ucb);
            % Move to child
            u = obj.chooseActionFromNodeID(children(min_id));
            obj.modelCtrl = obj.modelCtrl.setInput(u);
            obj.modelCtrl = obj.modelCtrl.step();
        end
        
        function rollout(obj, nodeID)
            searchAlgo = src.HillClimbing(obj.modelCtrl, obj.inLimInf, obj.inLimSup, obj.numInputDisc, obj.simTimeHorizon);
            
        end
        
        function backpropagation(obj)
        end
        
        function val = evalNode(obj, node)
            val = obj.computeUCB(node)
        end
        
        function ids = getChildren(obj, nodeID)
            ids = find([obj.nodes.parentID]==nodeID);
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
