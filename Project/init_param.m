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
Sim.NUMCTRLPOINTS = 2;
Sim.INTERVAL = src.computeTimeDiscretization(Sim.TIMEHORIZON, Sim.NUMCTRLPOINTS);
Sim.currentInput = [0 0];
Sim.visitInput = [0 0];
Sim.lastRobustness = Inf;
Sim.visitRobustness = Inf;
Sim.xInitial = 0;
Sim.currentSnapshotTime = 0;
Sim.numInterval = 0;

%% Input definition
%IN = inLimInf, inLimSup, quantumSize, numInputSamples, numInputRegion
IN = inputDefinition();

%% MCTS
MCTS.BUDGET = 10;
MCTS.C = 0.0;
noo.MCTS.init_mcts;

%% Hill climbing
HC.restarts = 5;
HC.maxNumNeighbours = 100;
noo.HillClimbing.init_hill_climbing;    %Initialize dynamic fields

%% Uniform Random Sampling
URS.bestRobustness = Inf;   %Robustness has to be minimized, then init as Inf
URS.bestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);

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

    numSamplesThrottle = 100;    %Discretization of Throttle signal
    numSamplesBrake    = 300;    %Discretization of Brake signal

    numRegionThrottle = 2;
    numRegionBrake    = 2;

    %Create input structure to give as input
    IN.inLimInf = [ThrottleLimInf BrakeLimInf];
    IN.inLimSup = [ThrottleLimSup BrakeLimSup];
    IN.numInputSamples = [numSamplesThrottle numSamplesBrake];
    IN.numInputRegions = [numRegionThrottle numRegionBrake];
    IN.quantumSize = (IN.inLimSup - IN.inLimInf) ./ IN.numInputRegions;
end