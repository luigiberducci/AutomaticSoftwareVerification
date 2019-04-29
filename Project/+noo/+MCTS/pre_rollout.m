children = noo.MCTS.getChildren(MCTS.currentNodeID);
ucb = zeros(size(children));
%% TODO: ha senso scorrere tutti i figli? non si tratta sempre di un nodo appena espanso?
for i = 1:length(children)
	childID = children(i);
    child = MCTS.nodes(childID);
    ucb(i) = noo.MCTS.computeUCB(child);
end
% Choose min child
[~, min_id] = min(ucb);
% Move to child
childID = children(min_id);
    
% TODO set row struct per prefisso regioni (trovi su nodo)
% u = noo.MCTS.chooseActionFromNodeID(childID);
% noo.ModelController.set_input(u);
% noo.ModelController.step_model_controller;
% TODO do not simuluate here, handled in SH

%update simulation trace with the node currently selected for rollout
MCTS.tracePrefixLen = MCTS.tracePrefixLen + 1;
rolloutNode = MCTS.nodes(childID);
MCTS.traceInf(MCTS.tracePrefixLen,:) = rolloutNode.regionInf;
MCTS.traceSup(MCTS.tracePrefixLen,:) = rolloutNode.regionSup;

MCTS.currentNodeID = childID;
