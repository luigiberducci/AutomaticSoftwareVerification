function plotRobustnessResult(test_prefix)
    %% TODO: change input params with ALGO, TEST ID
    %% TODO: expand this function with average of the results
    fRob = sprintf("%s_rob.dat", test_prefix);
    fBestRob = sprintf("%s_best_rob.dat", test_prefix);
    rob = load(fRob);
    bestRob = load(fBestRob);
    xAxis = 1:length(rob);
    plot(xAxis, [rob bestRob]);
    legend('Robustness', 'Best Robustness');
    title(test_prefix);
end

