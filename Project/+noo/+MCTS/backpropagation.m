function backpropagation(nodeID, score)
    global MCTS;
    MCTS.maxRobustness = max(MCTS.maxRobustness, score);
	while nodeID>=1
        node = MCTS.nodes(nodeID);
        node.score = min(node.score, score);
        node.n = node.n+1;
        MCTS.nodes(nodeID) = node; %Save node modified
        nodeID = node.parentID;
    end
	%noo.MCTS.plot();
end

