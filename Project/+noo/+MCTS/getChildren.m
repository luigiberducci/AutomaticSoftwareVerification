function ids = getChildren(nodeID)
    global MCTS;
    ids = find([MCTS.nodes.parentID]==nodeID);
end
