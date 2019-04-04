%% Initialization
t0 = tic;
%Model filename
model = 'automatic_transmission_model_S1';
model = 'automatic_transmission_model_S2';
%model = 'automatic_transmission_model_S4';

%MCTS Parameters
budget = 10;       %Maximum number of iteration of MCTS
BIGM   = 1000000;   %High constant used for score normalization

% Input definition and Simulation parameters
[inLimInf, inLimSup, numInDisc, numInRegion] = defineInputDomains();
simTimeHorizon = 30;    %Simulation time limit
numCtrlPnts    = 10;    %Discretization of time

%% Monte Carlo Tree Search (MCTS)
%Model Controller manages the simulations, proceeding by step `interval`
interval = src.computeTimeDiscretization(simTimeHorizon, numCtrlPnts);
simCtrl = src.ModelController(model, interval);

%MCTS uses the ModelController, notice that it needs to be defined as `simCtrl` because
%of Matlab scope handling
mcts = src.MCTS(simCtrl, inLimInf, inLimSup, numInDisc, numInRegion, simTimeHorizon, numCtrlPnts);
bestRobustness = Inf;      %Minimize robustness, then init as Inf
bestTrace = zeros(numCtrlPnts, length(inLimInf));
numSimulatedTraces = 0;     %Counter of simulated traces
t_init = toc(t0);
t0 = tic;
while budget>0
    %Debug
    fprintf("[Info] Budget: %d\n", budget);
    
    % Selection phase
    nodeID = mcts.selection();
    node = mcts.nodes(nodeID);
    %fprintf("[Info] Expand Node %d (Throttle %f %f, Brake %f %f)\n", nodeID, node.regionInf(1), node.regionSup(1), node.regionInf(2), node.regionSup(2));
    % Expansion phase
    mcts = mcts.expansion(nodeID);
    [mcts, expandedNodeID] = mcts.preRollout(nodeID);
    % Rollout phase
    [rob, trace, nSimulations] = mcts.rollout(simCtrl);
    numSimulatedTraces = numSimulatedTraces + nSimulations;
    %Update best robustness and trace
    if rob<bestRobustness
        bestRobustness = rob;
        bestTrace = trace;
    end
    % Check falsification
    if bestRobustness<=0
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
t_mcts = toc(t0);

%Print results
printResult(numSimulatedTraces, bestRobustness, bestTrace, t_init, t_mcts);

%% Helper Functions
function [inLimInf, inLimSup, numInDisc, numInRegion] = defineInputDomains()
    ThrottleLimInf = 0;     %Lowerbound of Throttle signal
    ThrottleLimSup = 100;   %Upperbound of Throttle signal
    BrakeLimInf = 0;        %Lowerbound of Brake signal
    BrakeLimSup = 325;      %Upperbound of Brake signal

    numSamplesThrottle = 10;    %Discretization of Throttle signal
    numSamplesBrake    = 30;    %Discretization of Brake signal
    
    numRegionThrottle = 2;
    numRegionBrake    = 2;

    %Create input structure to give as input
    inLimInf = [ThrottleLimInf BrakeLimInf];
    inLimSup = [ThrottleLimSup BrakeLimSup];
    numInDisc   = [numSamplesThrottle numSamplesBrake];
    numInRegion = [numRegionThrottle numRegionBrake];
end

function printResult(numSimulatedTraces, bestRobustness, bestTrace, initTime, elapsedTime)
    fprintf("*********** RESULTS MCTS ***********\n");
    fprintf("[Info] Initialization time:\t%f seconds\n", initTime);
    fprintf("[Info] Simulation time:\t\t%f seconds\n", elapsedTime);
    fprintf("[Info] Simulated trace:\t\t%d\n", numSimulatedTraces);
    fprintf("[Info] Best Robustness:\t\t%f\n", bestRobustness);
    fprintf("[Info] Best Trace:\n");
    disp(bestTrace);
end