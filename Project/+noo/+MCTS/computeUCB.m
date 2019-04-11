function ucb = computeUCB(node)
    global MCTS;
	parent = MCTS.nodes(node.parentID);
    N = parent.n;           % Number of visit of parent node
    n = node.n;             % Number of visit of current node
    V = 1 - node.score /MCTS.maxRobustness;
    c = 0.0;                % Weight factor
            
	ucb = Inf;
    if not(n==0)
        ucb = V + c*sqrt(2*log(N)/n);
    end
end
