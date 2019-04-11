function u = chooseActionFromNodeID(nodeID)
    global MCTS;
    global IN;
    curNode = MCTS.nodes(nodeID);
    regionInf = curNode.regionInf;
    regionSup = curNode.regionSup;
                
    u = noo.MCTS.chooseAction(regionInf, regionSup, IN.quantumSize);
end
