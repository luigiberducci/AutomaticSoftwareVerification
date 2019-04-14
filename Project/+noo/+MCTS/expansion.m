function expansion(nodeID)
    global MCTS;
    global IN;
    
    MCTS.currentNodeID = nodeID; %CHECK is't it already in MCTS from expansion?
    parent = MCTS.nodes(nodeID);
    for actionID = 1:prod(IN.numInputRegions)
        [it,ib] = ind2sub(IN.numInputRegions, actionID);
        inLimInf = [it*IN.quantumSize(1) ib*IN.quantumSize(2)];
        inLimSup = [(it+1)*IN.quantumSize(1) (ib+1)*IN.quantumSize(2)];
        child = MCNode(MCTS.availID, nodeID, inLimInf, inLimSup, parent.depth+1);
        MCTS.nodes = [MCTS.nodes child];
        MCTS.availID = MCTS.availID+1;
        %obj.plot()
    end
end
