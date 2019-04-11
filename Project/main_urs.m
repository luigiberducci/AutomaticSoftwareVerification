%% Initialization
%Uniform Random Sampling (URS) parameters
MAX_NUM_TRACE = 5;  %Bound on num of trace to be simulated
numSimulatedTraces = 0; %Number of trace currently simulated

%% Uniform Random Sampling
finalBestRobustness = Inf;
%Loop untile falsification or max num traces
t0 = tic;
while numSimulatedTraces < MAX_NUM_TRACE
    %Debug
    fprintf("[Info] URS - Remaining budget: %d\n", (MAX_NUM_TRACE-numSimulatedTraces));
    
    %Run a trace
    noo.UniformRandomSampling.run_uniform_random_sampling;
    rob = URS.bestRobustness;
    if rob < finalBestRobustness
        bestRobustness = rob;
        bestTrace = URS.trace;
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
printMainResults("URS", numSimulatedTraces, bestRobustness, bestTrace, t_urs);

