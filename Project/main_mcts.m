% model controller
%tic;
model = 'automatic_transmission_model_S1';
%model = 'automatic_transmission_model_S2';

%init_time = toc;

%MCTS Parameters
budget = 10;

% Input definition
BIGM = 1000000;
tic;
ThrottleLimInf = 0;
BrakeLimInf = 0;
ThrottleLimSup = 100;
BrakeLimSup = 325;

numSamplesThrottle = 10;
numSamplesBrake    = 11;

numRegionThrottle = 2;
numRegionBrake    = 5;

inLimInf = [ThrottleLimInf BrakeLimInf];
inLimSup = [ThrottleLimSup BrakeLimSup];
numInDisc   = [numSamplesThrottle numSamplesBrake];

numInRegion = [numRegionThrottle numRegionBrake];

simTimeHorizon = 30;
numCtrlPnts = 5;

%Begin
interval = src.computeTimeDiscretization(simTimeHorizon, numCtrlPnts);
simCtrl = src.ModelController(model, interval);

mcts = src.MCTS(simCtrl, inLimInf, inLimSup, numInDisc, numInRegion, simTimeHorizon, numCtrlPnts);
bestRobustness = BIGM;
while budget>0
    %Debug
    fprintf("[Info] Budget: %d\n", budget);
    
    % Selection phase
    nodeID = mcts.selection();
    node = mcts.nodes(nodeID);
    fprintf("[Info] Expand Node %d (Throttle %f %f, Brake %f %f)\n", nodeID, node.regionInf(1), node.regionSup(1), node.regionInf(2), node.regionSup(2));
    % Expansion phase
    mcts = mcts.expansion(nodeID);
    [mcts, expandedNodeID] = mcts.preRollout(nodeID);
    % Rollout phase
    [rob, trace] = mcts.rollout(simCtrl);
    bestRobustness = min(bestRobustness, rob);
    % Check falsification
    if rob<=0
        fprintf("FALSIFICATION: %d\n", rob);
        disp(trace);
        return;
    end
    % Backpropagation phase
    score = BIGM/(rob+BIGM);   %First attempt
    mcts = mcts.backpropagation(expandedNodeID, score);
    
    %Reduce budget
    budget = budget - 1;
end



