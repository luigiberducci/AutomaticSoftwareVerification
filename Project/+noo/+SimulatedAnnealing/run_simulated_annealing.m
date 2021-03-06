[T_full, B_full] = noo.HillClimbing.computeDiscreteInputSignal(IN.inLimInf, IN.inLimSup, IN.numInputSamples);
    
trial = SH.restarts;
%SH.numSimulatedTraces = 0; %Moved into init_hill_climbing

save("SH_state", 'MODEL','Sim');

% DEBUG
fprintf("[Info] SA - Starting with %d trials\n", trial);
while trial > 0
	% DEBUG
    fprintf("[Info] SA - Remaining Trials: %d\n", trial);
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
        iAction = 0; % incremental index of actions
        Tprm = randperm(length(T)); % generate random permutation for neigbours
        Bprm = randperm(length(B)); % generate random permutation for neigbours
        
        % Accept "best worst" action if no improvement
        bestWorstU = [0 0];
        bestWorstRob = Inf;
        while moveFound == false && iAction < SH.maxNumNeighbours
                %Debug
                %MCTS.traceInf
                %trace
                %MCTS.traceSup
                iAction = iAction + 1; % consume next neigbours
                [it, ib] = ind2sub([length(T) length(B)], iAction);
                u = [T(Tprm(it)) B(Bprm(ib))];
                noo.ModelController.set_visit_input(u);
                noo.ModelController.visit_next;
                r = Sim.visitRobustness;
                if SH.temperature == 0
                    % a not worst neigbourd has being found
                    % go to neigbourd
                    noo.ModelController.set_input(u);
                    noo.ModelController.step_model_controller;
                    curBestRobustness = Sim.lastRobustness;
                    moveFound = true;
                    trace = [trace; u]; % extend trace
                else
                    % temperature > 0
                    delta = curBestRobustness - r;
                    if delta > 0 
                        noo.ModelController.set_input(u);
                        noo.ModelController.step_model_controller;
                        curBestRobustness = Sim.lastRobustness;
                        moveFound = true;
                        trace = [trace; u]; % extend trace
                    else
                        prob = exp(delta/SH.temperature);
                        if rand <= prob
                            noo.ModelController.set_input(u);
                            noo.ModelController.step_model_controller;
                            curBestRobustness = Sim.lastRobustness;
                            moveFound = true;
                            trace = [trace; u]; % extend trace
                        else
                            if r <= bestWorstRob 
                                bestWorstRob = r;
                                bestWorstU = u;
                            end
                        end
                    end
                end
        end
        % This check is to avoid incomplete trace (it finished the neighs)
        if moveFound == false 
            noo.ModelController.set_input(bestWorstU);
            noo.ModelController.step_model_controller;
            trace = [trace; bestWorstU];
        end
        SH.temperature = SH.temperature + 1;
    end
    
    if curBestRobustness < SH.bestRobustness
        SH.bestRobustness = curBestRobustness;
        SH.bestTrace = trace;
    end
    if curBestRobustness<=0
        break
    end
end

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
clear bestWorstRob;
clear bestWorstU;