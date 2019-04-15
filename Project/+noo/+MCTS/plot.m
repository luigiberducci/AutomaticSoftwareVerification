function plot()
    global MCTS;
	n = size(MCTS.nodes);
	pather_vec = zeros(n);
    for node = MCTS.nodes
        pather_vec(node.nodeID) = node.parentID;
    end
    treeplot(pather_vec);
    [x,y] = treelayout(pather_vec);
    for i=1:length(x)
        nodeID = i;
        node = MCTS.nodes(nodeID);
        if node.depth == 0
        	ucb = node.score;
            label = sprintf("Bst Rob: %.2f\nn: %d\nh: %d", ucb, node.n, node.depth);
        else
            ucb = noo.MCTS.computeUCB(node);
            label = sprintf("UCB: %.2f\nn: %d\nh: %d", ucb, node.n, node.depth);
        end
                
        %label = sprintf("ID: %d\nT: [%.2f, %.2f]\nB: [%.2f, %.2f]\nUCB: %.2f\nn: %.0f",...
        %nodeID, node.regionInf(2), node.regionSup(1), node.regionInf(2), node.regionSup(2), node.score, node.n);
                
        text_shift_x = 0;
        text_shift_y = (1+rem(nodeID,2))/20;
        text(x(i)+text_shift_x, y(i)+text_shift_y, label);
        % text(x(i) = text_shift, y(i), num2str(i));
    end
    drawnow; %plot iteratively while building the tree
    %highlight(H, MCTS.currentNodeID);
end