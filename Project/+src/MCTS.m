classdef MCTS
    properties
        %Tree properties
        nodes
        maxRobustness % max robustness value yet found
        actions
        availID
        %Model properties
        modelFile
        modelCtrl
        inLimInf
        inLimSup
        numInputDisc
        quantumSize
        numInRegions
        %Search algo properties
        %searchAlgo          %TODO Create a factory
        maxNumRestarts
        %Simulation properties
        simTimeHorizon
        numCtrlPoints
        numInputRegion
    end
    methods
        function obj = MCTS(modelCtrl, inLimInf, inLimSup, numInDisc, numInRegions, simTimeHorizon, numCtrlPnts)
            %% TODO Commentare segnatura input
            %Initialize model controller
            obj.modelCtrl = modelCtrl;
            obj.simTimeHorizon = simTimeHorizon;
            obj.numCtrlPoints = numCtrlPnts;
            
            %Search algo
            obj.maxNumRestarts = 5;
            
            %Initialize search algorithm parameters
            obj.inLimInf = inLimInf;
            obj.inLimSup = inLimSup;
            obj.numInputDisc = numInDisc;
            obj.quantumSize = (inLimSup - inLimInf) ./ numInDisc;
            obj.numInRegions = numInRegions;
            
            %Create root node
            obj.availID = 1;
            root = MCNode(obj.availID, 0, [-1 -1], [-1 -1], 0); %The root is the only node with parent 0 and depth 0
            obj.nodes = [root];
            obj.maxRobustness = -Inf;
            obj.plot()

            %Increment next availablplote node identifier
            obj.availID = obj.availID + 1;
        end
        
        function curNodeID = selection(obj)
            curNodeID = 1;     %root
            obj.modelCtrl = obj.modelCtrl.reset();  %Reset to t0
            children = obj.getChildren(curNodeID);
            while not(isempty(children))
                max_val = 0;
                max_child = -1;
                for childID = children
                    child = obj.nodes(childID);
                    childVal = obj.evalNode(child);
                    if childVal>max_val
                        max_val = childVal;
                        max_child = childID;
                    end
                end
                %Pick the selected node and step ahed the simulation
                curNodeID = max_child;
                
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
            parent = obj.nodes(nodeID);
            for actionID = 1:prod(obj.numInRegions)
                [it,ib] = ind2sub(obj.numInRegions, actionID);
                inLimInf = [it*obj.quantumSize(1) ib*obj.quantumSize(2)];
                inLimSup = [(it+1)*obj.quantumSize(1) (ib+1)*obj.quantumSize(2)];
                child = MCNode(obj.availID, nodeID, inLimInf, inLimSup, parent.depth+1);
                obj.nodes = [obj.nodes child];
                obj.availID = obj.availID+1;
                obj.plot()
            end
        end
        
        function [obj, childID] = preRollout(obj, nodeID)
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
            childID = children(min_id);
            u = obj.chooseActionFromNodeID(childID);
            obj.modelCtrl = obj.modelCtrl.setInput(u);
            obj.modelCtrl = obj.modelCtrl.step();
        end
        
        function [bestRob, bestTrace, nSimulations] = rollout(obj, modelCtrl)
            searchAlgo = src.HillClimbing(modelCtrl, obj.inLimInf, obj.inLimSup, obj.numInputDisc, obj.simTimeHorizon);
            [~, bestRob, bestTrace, nSimulations] = searchAlgo.run(obj.maxNumRestarts);
        end
        
        function obj = backpropagation(obj, nodeID, score)
            obj.maxRobustness = max(obj.maxRobustness, score);
            while nodeID>=1
                node = obj.nodes(nodeID);
                node.score = min(node.score, score);
                node.n = node.n+1;
                obj.nodes(nodeID) = node; %Save node modified
                nodeID = node.parentID;
            end
            obj.plot()
        end
        
        function val = evalNode(obj, node)
            val = obj.computeUCB(node);
        end
        
        function ids = getChildren(obj, nodeID)
            ids = find([obj.nodes.parentID]==nodeID);
        end
        
        function ucb = computeUCB(obj, node)
            parent = obj.nodes(node.parentID);
            N = parent.n;           % Number of visit of parent node
            n = node.n;             % Number of visit of current node
            V = 1 - node.score /obj.maxRobustness;
            % V = node.score/node.n;  % Score mean
            c = 0.0;                % Weight factor
            
            ucb = Inf;
            if not(n==0)
                ucb = V + c*sqrt(2*log(N)/n);
            end
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

        function plot(obj)
            n = size(obj.nodes);
            pather_vec = zeros(n);
            for node = obj.nodes
                pather_vec(node.nodeID) = node.parentID;
            end
            treeplot(pather_vec);
            [x,y] = treelayout(pather_vec);
            for i=1:length(x)
                nodeID = i;
                node = obj.nodes(nodeID);
                if node.depth == 0
                    ucb = node.score;
                else
                    ucb = obj.computeUCB(node);
                end
                
                %label = sprintf("ID: %d\nT: [%.2f, %.2f]\nB: [%.2f, %.2f]\nUCB: %.2f\nn: %.0f",...
                %nodeID, node.regionInf(2), node.regionSup(1), node.regionInf(2), node.regionSup(2), node.score, node.n);
                label = sprintf("UCB: %.2f\nn: %d\nh: %d", ucb, node.n, node.depth);
                
                text_shift_x = 0;
                text_shift_y = (1+rem(nodeID,2))/20;
                text(x(i)+text_shift_x, y(i)+text_shift_y, label);
                % text(x(i) = text_shift, y(i), num2str(i));
            end
            drawnow %plot iteratively while building the tree
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
