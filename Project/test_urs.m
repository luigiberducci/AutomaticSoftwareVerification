clear all;
init_param;

% Repeat test
for test = 1:TEST.NUMTEST
    clearvars -except test;
    %% Initialization
    t0 = tic;
    init_param;     %Simulation parameters and other config
    SPEC = 2;
    inner_prefix = sprintf("URS_%d", SPEC);
    out_dir = "test/" + inner_prefix;
    t_init = toc(t0);
    
    t0 = tic;
    noo.ModelController.init_model_controller; %Simulation Manager 
    main_urs;
    t_urs = toc(t0);
    
    % Create out directory
    mkdir(out_dir);
    
    % Save current workspace
    resultString = src.createMainResults(inner_prefix, URS.numSimulatedTraces, URS.bestRobustness, URS.bestTrace, t_urs);
    outFilename = sprintf("%s/%s_%s_%d_%f", out_dir, TEST.PREFIX, inner_prefix, test, URS.bestRobustness);
    outFilename = strrep(outFilename, '.', '_');
    save(outFilename)

    % Save rob profiling to text file    
    logRob = TEST.logRob;
    save(sprintf("%s_rob.dat", outFilename), 'logRob', '-ascii');
    
    % Save best rob profiling to text file    
    logBestRob = TEST.logBestRob;
    save(sprintf("%s_best_rob.dat", outFilename), 'logBestRob', '-ascii');

    % Save result to text file    
    fid = fopen(sprintf("%s.txt", outFilename), 'w');
    fprintf(fid, resultString);
    fclose(fid);
end