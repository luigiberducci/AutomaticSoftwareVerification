function curNodeID = selection()
    global MCTS;
    global MODEL;
    global Sim;
    
    %First, reset the model controller to time0
    noo.ModelController.init_model_controller;
    
    curNodeID = 1;     %Starting from root
	children = noo.MCTS.getChildren(curNodeID);
    while not(isempty(children))
        max_val = 0;
        max_child = -1;
        for childID = children
            child = MCTS.nodes(childID);
            childVal = noo.MCTS.computeUCB(child);               
            if childVal>max_val
                max_val = childVal;
                max_child = childID;
            end
        end
        %Pick the selected node and step ahed the simulation
        curNodeID = max_child;
        
        u = noo.MCTS.chooseActionFromNodeID(curNodeID);
        % TODO set row struct per prefisso regioni (trovi su nodo)
        noo.ModelController.set_input(u);
        noo.ModelController.step_model_controller;
        % TODO do not simuluate here, handled in HC
        
        children = noo.MCTS.getChildren(curNodeID);
    end
    MCTS.currentNodeID = curNodeID;
end