function str = createMainResults(problemName, numSimulatedTraces, bestRobustness, bestTrace, elapsedTime)
    str = sprintf("*********** RESULTS %s ***********\n", problemName);
    str = str + sprintf("[Info] Simulation time:\t\t\t%f seconds\n", elapsedTime);
    str = str + sprintf("[Info] Approx. time x trace:\t%f seconds\n", elapsedTime/numSimulatedTraces);
    str = str + sprintf("[Info] Simulated trace:\t\t\t%d\n", numSimulatedTraces);
    str = str + sprintf("[Info] Best Robustness:\t\t\t%f\n", bestRobustness);
    str = str + sprintf("[Info] Best Trace:\n");
    for row = 1:length(bestTrace)
        str = str + mat2str(bestTrace(row, :)) + "\n";
    end
end