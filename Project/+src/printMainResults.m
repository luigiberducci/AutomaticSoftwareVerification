function printMainResults(problemName, numSimulatedTraces, bestRobustness, bestTrace, elapsedTime)
    fprintf("*********** RESULTS %s ***********\n", problemName);
    fprintf("[Info] Simulation time:\t\t\t%f seconds\n", elapsedTime);
    fprintf("[Info] Approx. time x trace:\t%f seconds\n", elapsedTime/numSimulatedTraces);
    fprintf("[Info] Simulated trace:\t\t\t%d\n", numSimulatedTraces);
    fprintf("[Info] Best Robustness:\t\t\t%f\n", bestRobustness);
    fprintf("[Info] Best Trace:\n");
    disp(bestTrace);
end