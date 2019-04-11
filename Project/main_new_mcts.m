%% Initialization
init_param;

%% Monte Carlo Tree Search (MCTS)
%Model Controller manages the simulations, proceeding by step `interval`
noo.ModelController.init_model_controller;

%MCTS uses the ModelController, notice that it needs to be defined as `simCtrl` because
%of Matlab scope handling
bestRobustness = Inf;      %Minimize robustness, then init as Inf
bestTrace = zeros(numCtrlPnts, length(inLimInf));
numSimulatedTraces = 0;     %Counter of simulated traces
t_init = toc(t0);
t0 = tic;
while budget>0
    %Debug
    fprintf("[Info] Budget: %d\n", budget);
    
    % Selection phase
    nodeID = noo.MCTS.selection();
    node = mcts.nodes(nodeID);
    if node.depth < numCtrlPnts
        mcts = noo.MCTS.expansion(nodeID);
        noo.MCTS.pre_rollout;
    end
    % Selection/Prerollout update MCTS.currentNodeID to the node from which
    % start the rollout phase.
    
    %fprintf("[Info] Expand Node %d (Throttle %f %f, Brake %f %f)\n", nodeID, node.regionInf(1), node.regionSup(1), node.regionInf(2), node.regionSup(2));
    
    % Rollout phase
    noo.MCTS.rollout;
    numSimulatedTraces = numSimulatedTraces + nSimulations;
    %Update best robustness and trace
    if MCTS.rolloutBestRob<bestRobustness
        bestRobustness = MCTS.rolloutBestRob;
        bestTrace = MCTS.rolloutBestTrace;
    end
    % Check falsification
    if bestRobustness<=-100000
        fprintf("FALSIFICATION: %d\n", rob);
        disp(bestTrace);
        return;
    end
    % Backpropagation phase
    mcts = noo.MCTS.backpropagation(MCTS.currentNodeID, rob);
    
    %Reduce budget
    budget = budget - 1;
end
t_mcts = toc(t0);

%Print results
noo.MCTS.plot();
printMainResults("URS", numSimulatedTraces, bestRobustness, bestTrace, t_mcts);

