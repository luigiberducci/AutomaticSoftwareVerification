%% Initialization
t0 = tic;
%Model parameters
model = 'automatic_transmission_model_S1';  %Model filename
model = 'automatic_transmission_model_S2';

%Uniform Random Sampling (URS) parameters
MAX_NUM_TRACE = 2000;  %Bound on num of trace to be simulated
numSimulatedTraces = 0; %Number of trace currently simulated

%Simulation parameters
simTimeHorizon = 30;    %Time horizon
numCtrlPnts    = 10;    %Discretization of time

%Input signal definition
[inLimInf, inLimSup, numInDisc] = defineInputDomains();

%% Uniform Random Sampling
%Model Controller manages the simulation and use `interval` as time step
interval = src.computeTimeDiscretization(simTimeHorizon, numCtrlPnts);
simCtrl = src.ModelController(model, interval);

%URS manages the random search using the ModelController
% Notice that the ModelController as to be defined in the workspace as
% `simCtrl` because of Matlab scope handling
urs = src.URS(simCtrl, inLimInf, inLimSup, numInDisc, simTimeHorizon, numCtrlPnts);

%Structure to collect the best result obtained
bestRobustness = Inf;   %Robustness has to be minimized, then init as Inf
bestTrace = zeros(numCtrlPnts, length(inLimInf));

%Loop untile falsification or max num traces
t_init = toc(t0);
t0 = tic;
while numSimulatedTraces < MAX_NUM_TRACE
    %Debug
    fprintf("[Info] Remaining trace: %d\n", (MAX_NUM_TRACE-numSimulatedTraces));
    
    %Run a trace
    [rob, trace] = urs.runRandomTrace();   
    if rob < bestRobustness
        bestRobustness = rob;
        bestTrace = trace;
    end
    %Update simulations counter
    numSimulatedTraces = numSimulatedTraces + 1;
    
    % Check falsification
    if rob<=0
        fprintf("FALSIFICATION: %d\n", rob);
        disp(trace);
        break;
    end    
end
t_urs = toc(t0);

%Print result
printResult(numSimulatedTraces, bestRobustness, bestTrace, t_init, t_urs);

%% Helper Functions
function [inLimInf, inLimSup, numInDisc] = defineInputDomains()
    ThrottleLimInf = 0;     %Lowerbound of Throttle signal
    ThrottleLimSup = 100;   %Upperbound of Throttle signal
    BrakeLimInf = 0;        %Lowerbound of Brake signal
    BrakeLimSup = 325;      %Upperbound of Brake signal

    numSamplesThrottle = 10;    %Discretization of Throttle signal
    numSamplesBrake    = 30;    %Discretization of Brake signal

    %Create input structure to give as input
    inLimInf = [ThrottleLimInf BrakeLimInf];
    inLimSup = [ThrottleLimSup BrakeLimSup];
    numInDisc   = [numSamplesThrottle numSamplesBrake];
end

function printResult(numSimulatedTraces, bestRobustness, bestTrace, initTime, elapsedTime)
    fprintf("************* RESULTS *************\n");
    fprintf("[Info] Initialization time:\t%f seconds\n", initTime);
    fprintf("[Info] Simulation time:\t\t%f seconds\n", elapsedTime);
    fprintf("[Info] Simulated trace:\t\t%d\n", numSimulatedTraces);
    fprintf("[Info] Best Robustness:\t\t%f\n", bestRobustness);
    fprintf("[Info] Best Trace:\n");
    disp(bestTrace);
end

