clear all;
%% Initialization
t0 = tic;
init_param;     %Simulation parameters and other config
noo.ModelController.init_model_controller; %Simulation Manager 
t_init = toc(t0);

%% Monte Carlo Tree Search (MCTS)
t0 = tic;
bestRobustness = Inf;      %Minimize robustness, then init as Inf
bestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);
numSimulatedTraces = 0;     %Counter of simulated traces
budget = MCTS.BUDGET;
while budget>0
    %Debug
    fprintf("[Info] Budget: %d\n", budget);
    
    % Selection phase
    nodeID = noo.MCTS.selection();
    node = MCTS.nodes(nodeID);
    if node.depth < Sim.NUMCTRLPOINTS
        noo.MCTS.expansion(nodeID);
        noo.MCTS.pre_rollout;
    end
    % Selection/Prerollout update MCTS.currentNodeID to the node from which
    % start the rollout phase.
    
    fprintf("[Info] Expand Node %d (Throttle %f %f, Brake %f %f)\n", nodeID, node.regionInf(1), node.regionSup(1), node.regionInf(2), node.regionSup(2));
    
    % Rollout phase
    noo.MCTS.rollout;
    numSimulatedTraces = numSimulatedTraces + MCTS.rolloutNumSimTraces;
    %Update best robustness and trace
    if MCTS.rolloutBestRob<bestRobustness
        bestRobustness = MCTS.rolloutBestRob;
        bestTrace = MCTS.rolloutBestTrace;
    end
    % Check falsification
    if bestRobustness<0
        fprintf("FALSIFICATION: %d\n", rob);
        disp(bestTrace);
        return;
    end
    % Backpropagation phase
    noo.MCTS.backpropagation(MCTS.currentNodeID, MCTS.rolloutBestRob);
    
    %Reduce budget
    budget = budget - 1;
    %noo.MCTS.plot;
end
t_mcts = toc(t0);

%Print results
noo.MCTS.plot();
src.printMainResults("MCTS - Test C=0", numSimulatedTraces, bestRobustness, bestTrace, t_mcts);

save('S2')
