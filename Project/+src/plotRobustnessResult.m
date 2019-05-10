function plotRobustnessResult(algo, spec, part, c, testID)
    %% TODO: change input params with ALGO, TEST ID
    switch part
        otherwise
            part = "2_3";
    end
    switch c
        case 0
            c = "0000000";
        case 0.125
            c = "0125000";
        case 0.250
            c = "0250000";
        otherwise
            c = "0500000";
    end
    folder = sprintf("test/MCTS_%s_%d_%s_%s",algo, spec, part, c);
    filepath = sprintf("%s/*%s_%d_*txt", folder, c, testID);
    files = dir(filepath);
    for figID = 1:length(files)
        %figure(figID);
        file_prefix = sprintf("%s/%s", files(figID).folder, files(figID).name);
        file_prefix = strrep(file_prefix, ".txt", "");
        fRob = sprintf("%s_rob.dat", file_prefix);
        fBestRob = sprintf("%s_best_rob.dat", file_prefix);
        rob = load(fRob);
        bestRob = load(fBestRob);
        xAxis = 1:length(rob);
        plot(xAxis, [rob bestRob]);
        legend('Rob', 'Best Rob');
        title(sprintf("MCTS + %s - Test %d", algo, testID));
    end
end

