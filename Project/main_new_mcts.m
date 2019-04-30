fprintf("[Info] Starting MCTS+%s with Spec %d\n", ALGOSRC, SPEC);

%% Monte Carlo Tree Search (MCTS)
budget = MCTS.BUDGET;
while budget>0
    %Debug
    fprintf("[Info] MCTS Budget: %d\n - Best Rob: %3f\n", budget, MCTS.bestRobustness);
    
    % Selection phase
    nodeID = noo.MCTS.selection();
    %noo.MCTS.plot;
    node = MCTS.nodes(nodeID);
    if node.depth < Sim.NUMCTRLPOINTS
        noo.MCTS.expansion(nodeID);
        %noo.MCTS.plot;
        noo.MCTS.pre_rollout;
    end
    % Selection/Prerollout update MCTS.currentNodeID to the node from which
    % start the rollout phase.
    
    fprintf("[Info] Expand Node %d (Depth: %d, Throttle %f %f, Brake %f %f)\n", nodeID, node.depth, node.regionInf(1), node.regionSup(1), node.regionInf(2), node.regionSup(2));
    
    % Rollout phase
    noo.MCTS.rollout;
    %noo.MCTS.plot;

    MCTS.numSimulatedTraces = MCTS.numSimulatedTraces + MCTS.rolloutNumSimTraces;
    %Update best robustness and trace
    if MCTS.rolloutBestRob<MCTS.bestRobustness
        MCTS.bestRobustness = MCTS.rolloutBestRob;
        MCTS.bestTrace = MCTS.rolloutBestTrace;
    end
    
    % Logging
    TEST.logRob = [TEST.logRob; MCTS.rolloutBestRob];
    TEST.logBestRob = [TEST.logBestRob; MCTS.bestRobustness];
    
    % Check falsification
    if MCTS.bestRobustness<=0
        fprintf("[Info] FALSIFICATION: %d\n", rob);
        disp(MCTS.bestTrace);
        break;
    end
    % Backpropagation phase
    noo.MCTS.backpropagation(MCTS.currentNodeID, MCTS.rolloutBestRob);
    
    %Reduce budget
    budget = budget - 1;
    %noo.MCTS.plot;
end


%Print results
noo.MCTS.plot();
src.printMainResults("MCTS", numSimulatedTraces, bestRobustness, bestTrace, t_mcts);
