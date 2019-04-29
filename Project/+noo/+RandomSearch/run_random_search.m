%global MCTS

[T_full, B_full] = noo.HillClimbing.computeDiscreteInputSignal(IN.inLimInf, IN.inLimSup, IN.numInputSamples);
    
trial = SH.restarts;
%SH.numSimulatedTraces = 0; %Moved into init_hill_climbing

save("SH_state", 'MODEL','Sim');

% DEBUG
%fprintf("[Info] RND - Starting with %d trials\n", trial);
while trial > 0
	% DEBUG
    %fprintf("[Info] RND - Remaining Trials: %d\n", trial);
    %TODO Remove saving/restore of this state
    clear Sim;
    load("SH_state");
    
    % init trace that minimizes robustness    
    trace = [];
    trial = trial - 1;
    SH.numSimulatedTraces = SH.numSimulatedTraces + 1;
    curBestRobustness = Inf;
                
    simStep = 1;
    while Sim.currentSnapshotTime < Sim.TIMEHORIZON
        %Update the simStep only when simulation time is greater than the
        %one associated to the step. Otherwise, sometimes happen out of
        %index error
        if Sim.currentSnapshotTime > simStep*Sim.INTERVAL
            simStep = simStep + 1;
        end
        moveFound = false;
        % select only signals in current (=simStep) region
        T = T_full(find(MCTS.traceInf(simStep,1) <= T_full & T_full <= MCTS.traceSup(simStep,1)));
        B = B_full(find(MCTS.traceInf(simStep,2) <= B_full & B_full <= MCTS.traceSup(simStep,2)));
        % iAction = 0; % incremental index of actions
        % Tprm = randperm(length(T)); % generate random permutation for neigbours
        % Bprm = randperm(length(B)); % generate random permutation for neigbours
        % while moveFound == false && iAction < SH.maxNumNeighbours
                %Debug
                %MCTS.traceInf
                %trace
                %MCTS.traceSup
                % iAction = iAction + 1; % consume next neigbours
        % [it, ib] = ind2sub([length(T) length(B)], iAction);
        t = datasample(T,1);
        b = datasample(B,1);
                % u = [T(Tprm(it)) B(Bprm(ib))];
        u = [t b];
        noo.ModelController.set_visit_input(u);
                % noo.ModelController.visit_next;
                % r = Sim.visitRobustness;
                % if r <= curBestRobustness % a not worst neigbourd has being found
                    % go to neigbourd
        noo.ModelController.set_input(u);
        noo.ModelController.step_model_controller;
        curBestRobustness = Sim.lastRobustness;
                    % moveFound = true;
        trace = [trace; u]; % extend trace
                % end
        % end
        % if moveFound == false 
            % break
        % end
    end % while H
    disp(trace');
    
    if curBestRobustness<SH.bestRobustness
        SH.bestRobustness = curBestRobustness;
        SH.bestTrace = trace;
    end
    if curBestRobustness<=0
        break
    end
end %WHILE Trials

%Remove useless variables from the global scope (it is a script,
%unfortunately)
clear trial;
clear curBestRobustness;
clear trace;
clear T;
clear B;
clear Tprm;
clear Bprm;
clear moveFound;
clear iAction;
