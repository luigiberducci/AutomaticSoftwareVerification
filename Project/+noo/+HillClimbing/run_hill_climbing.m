global MCTS

[T_full, B_full] = noo.HillClimbing.computeDiscreteInputSignal(IN.inLimInf, IN.inLimSup, IN.numInputSamples);
    
trial = HC.restarts;
HC.numSimulatedTraces = 0;          %Counter of simulated traces

save("hc_state", 'MODEL','Sim');

while trial > 0
	% DEBUG
    fprintf("[Info] HC - Remaining Trials: %d\n", trial);
    clear Sim;
    load("hc_state");
    
    % init trace that minimizes robustness    
    trace = [];
    trial = trial - 1;
    HC.numSimulatedTraces = HC.numSimulatedTraces + 1;
    curBestRobustness = Inf;
                
    simStep = 0;
    while Sim.currentSnapshotTime < Sim.TIMEHORIZON
        simStep = simStep + 1;
        moveFound = false;
        % select only signals in current (=simStep) region
        T = T_full(find(MCTS.traceInf(simStep,1) <= T_full & T_full <= MCTS.traceSup(simStep,1)));
        B = B_full(find(MCTS.traceInf(simStep,2) <= B_full & B_full <= MCTS.traceSup(simStep,2)));
        iAction = 0; % incremental index of actions
        Tprm = randperm(length(T)); % generate random permutation for neigbours
        Bprm = randperm(length(B)); % generate random permutation for neigbours
        while moveFound == false && iAction < HC.maxNumNeighbours
                MCTS.traceInf
                trace
                MCTS.traceSup
                iAction = iAction + 1; % consume next neigbours
                [it, ib] = ind2sub([length(T) length(B)], iAction);
                u = [T(Tprm(it)) B(Bprm(ib))];
                noo.ModelController.set_visit_input(u);
                noo.ModelController.visit_next;
                r = Sim.visitRobustness;
                if r <= curBestRobustness % a not worst neigbourd has being found
                    % go to neigbourd
                    noo.ModelController.set_input(u);
                    noo.ModelController.step_model_controller;
                    curBestRobustness = Sim.lastRobustness;
                    moveFound = true;
                    trace = [trace; u]; % extend trace
                end
        end
        if moveFound == false 
            break
    	end
    end
    if curBestRobustness<HC.bestRobustness
        HC.bestRobustness = curBestRobustness;
        HC.bestTrace = trace;
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
