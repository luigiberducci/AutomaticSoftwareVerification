%% Global variables
global Sim;
global MODEL;
global IN;
global MCTS;
global HC;

%% Model filename
MODEL = 'automatic_transmission_model_S1';

%% Simulation parameters
Sim.NUMINPUTSIGNALS = 2;
Sim.TIMEHORIZON = 30;
Sim.NUMCTRLPOINTS = 4;
Sim.INTERVAL = src.computeTimeDiscretization(Sim.TIMEHORIZON, Sim.NUMCTRLPOINTS);
Sim.currentInput = [0 0];
Sim.visitInput = [0 0];
Sim.lastRobustness = Inf;
Sim.xInitial = 0;
Sim.currentSnapshotTime = 0;
Sim.numInterval = 0;

%% MCTS
%Create root node
MCTS.availID = 1;
root = MCNode(MCTS.availID, 0, [-1 -1], [-1 -1], 0); %The root is the only node with parent 0 and depth 0
MCTS.nodes = [root];
MCTS.maxRobustness = -Inf;
MCTS.currentNodeID = 0;
MCTS.availID = MCTS.availID + 1; %Increment next availablplote node identifier
MCTS.rolloutBestRob = Inf;
MCTS.rolloutBestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);

%% Hill climbing
HC.restarts = 5;
HC.maxNumNeighbours = 100;
HC.bestRobustness = Inf;
HC.trace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);

%% Uniform Random Sampling
URS.bestRobustness = Inf;   %Robustness has to be minimized, then init as Inf
URS.bestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);

%% Input definition
%IN = inLimInf, inLimSup, quantumSize, numInputSamples, numInputRegion
IN = inputDefinition();

%% Open model
load_system(MODEL);

%% Helper functions
function IN = inputDefinition()
    % I prefered to maintain a separate function to avoid to fill the
    % workspace with useless variables.
    ThrottleLimInf = 0;     %Lowerbound of Throttle signal
    ThrottleLimSup = 100;   %Upperbound of Throttle signal
    BrakeLimInf = 0;        %Lowerbound of Brake signal
    BrakeLimSup = 325;      %Upperbound of Brake signal

    numSamplesThrottle = 10;    %Discretization of Throttle signal
    numSamplesBrake    = 30;    %Discretization of Brake signal

    numRegionThrottle = 2;
    numRegionBrake    = 2;

    %Create input structure to give as input
    IN.inLimInf = [ThrottleLimInf BrakeLimInf];
    IN.inLimSup = [ThrottleLimSup BrakeLimSup];
    IN.numInputSamples = [numSamplesThrottle numSamplesBrake];
    IN.numInputRegions = [numRegionThrottle numRegionBrake];
    IN.quantumSize = (IN.inLimSup - IN.inLimInf) ./ IN.numInputSamples;
end