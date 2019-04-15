function curNodeID = selection()
    global MCTS;
    global MODEL;
    global Sim;
    global IN;
    
    %First, reset the model controller to time0
    noo.ModelController.init_model_controller;
    
    curNodeID = 1;     %Starting from root
	children = noo.MCTS.getChildren(curNodeID);
    % init the trace with the full domain
    MCTS.traceInf = repmat(IN.inLimInf, Sim.NUMCTRLPOINTS+1,1); % doublecheck why +1
    MCTS.traceSup = repmat(IN.inLimSup, Sim.NUMCTRLPOINTS+1,1); % doublecheck why +1
    MCTS.tracePrefixLen = 0;
    while not(isempty(children))
        MCTS.tracePrefixLen = MCTS.tracePrefixLen + 1;
        max_val = 0;
        max_child = -1;     %%PROBLEM HERE
        for childID = children
            child = MCTS.nodes(childID);
            childVal = noo.MCTS.computeUCB(child);
            if childVal>max_val
                max_val = childVal;
                max_child = childID;
                % set the prefix of the trace according to ancestors
                % TODO: move trace prefix update out of the `for children` (because for large branching factor, we waste time)
                MCTS.traceInf(MCTS.tracePrefixLen,:) = child.regionInf;
                MCTS.traceSup(MCTS.tracePrefixLen,:) = child.regionSup;
            end
        end
        %Pick the selected node and step ahed the simulation
        curNodeID = max_child;
        
        % u = noo.MCTS.chooseActionFromNodeID(curNodeID);
        % TODO set row struct per prefisso regioni (trovi su nodo)
        % noo.ModelController.set_input(u);
        % noo.ModelController.step_model_controller;
        % TODO do not simuluate here, handled in HC
        
        children = noo.MCTS.getChildren(curNodeID);
    end
    MCTS.currentNodeID = curNodeID; % useless now that we have the full trace computed?
end
