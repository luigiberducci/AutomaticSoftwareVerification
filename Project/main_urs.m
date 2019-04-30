%Uniform Random Sampling (URS) parameters
MAX_NUM_TRACE = 1;  %Bound on num of trace to be simulated
URS.numSimulatedTraces = 0; %Number of trace currently simulated

%% Uniform Random Sampling
%Loop untile falsification or max num traces
t0 = tic;
budget = URS.BUDGET;
while budget>0
    %Run a trace
    noo.UniformRandomSampling.run_uniform_random_sampling;
    rob = URS.lowerRobustness;
    if rob < URS.bestRobustness
        URS.bestRobustness = rob;
        URS.bestTrace = URS.trace;
    end
    
    % Logging
    TEST.logRob = [TEST.logRob; rob];
    TEST.logBestRob = [TEST.logBestRob; URS.bestRobustness];
    
    % Debug
    fprintf("[Info] URS - Remaining budget: %d - Cur Rob: %3f - Best Rob: %3f\n", budget, rob, URS.bestRobustness);
    
    %Update simulations counter
    URS.numSimulatedTraces = URS.numSimulatedTraces + 1;
    budget = budget - 1;
    
    % Check falsification
    if rob<=0
        fprintf("FALSIFICATION: %d\n", rob);
        disp(URS.bestTrace);
        break;
    end    
end
t_urs = toc(t0);

%Print result
src.printMainResults("URS", URS.numSimulatedTraces, URS.bestRobustness, URS.bestTrace, t_urs);

save('URS_S2');
