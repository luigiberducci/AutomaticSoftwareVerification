%% Initialize/Reset HC struct
% Pre:  `Sim`struct must exist, global `HC` with static configuration exist
% Post: `HC` struct exist and dynamic fields are empty

% Notice: HC.restarts, HC.maxNumNeighbors are already declared in init_param
% because they are constant and no subject to change during simulation
HC.bestRobustness = Inf;
HC.bestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);
HC.numSimulatedTraces = 0;