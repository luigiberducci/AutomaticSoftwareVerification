clear all;
%% Initialization
clear all
init_param
%Uniform Random Sampling (URS) parameters
MAX_NUM_TRACE = 1;  %Bound on num of trace to be simulated
numSimulatedTraces = 0; %Number of trace currently simulated

%% Uniform Random Sampling
bestRobustness = Inf;
%Loop untile falsification or max num traces
t0 = tic;
budget = URS.BUDGET;
while budget>0
    %Run a trace
    noo.UniformRandomSampling.run_uniform_random_sampling;
    rob = URS.bestRobustness;
    if rob < bestRobustness
        bestRobustness = rob;
        bestTrace = URS.trace;
    end
    
    %Debug
    fprintf("[Info] URS - Remaining budget: %d - Cur Rob: %3f - Best Rob: %3f\n", budget, rob, bestRobustness);
    
    %Update simulations counter
    numSimulatedTraces = numSimulatedTraces + 1;
    budget = budget - 1;
    
    % Check falsification
    if rob<=0
        fprintf("FALSIFICATION: %d\n", rob);
        disp(bestTrace);
        break;
    end    
end
t_urs = toc(t0);

%Print result
src.printMainResults("URS", numSimulatedTraces, bestRobustness, bestTrace, t_urs);

save('URS_S2');
