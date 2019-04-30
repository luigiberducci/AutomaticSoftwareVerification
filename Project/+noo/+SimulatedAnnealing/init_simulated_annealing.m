%% Initialize/Reset SH struct
% Pre:  `Sim`struct must exist, global `SH` with static configuration exist
% Post: `SH` struct exist and dynamic fields are empty

% Notice: SH.restarts, SH.maxNumNeighbors are already declared in init_param
% because they are constant and no subject to change during simulation
SH.bestRobustness = Inf;
SH.bestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);
SH.numSimulatedTraces = 0;

%TODO add struct for regions
