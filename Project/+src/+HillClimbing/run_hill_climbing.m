%function [currentModel, bestRobustness, trace, nSims] = run(mdlCtrl, restarts)
[T, B] = src.HillClimbing.computeDiscreteInputSignal2(inLimInf, inLimSup, numInputSamples);
numNeigbours = prod(numInputSamples);
    
trial = HC.restarts;
nSims = 0;          %Counter of simulated traces

while trial > 0
	% DEBUG
    fprintf("[Info] HC - Remaining Trials: %d\n", trial);
        
    src.ModelController.init_model_controller;
    trace = []; % init trace that minimizes robustness
    
    trial = trial - 1;
    nSims = nSims + 1;
    curBestRobustness = Inf;
                
    while Sim.currentSnapshotTime < Sim.TIMEHORIZON
        moveFound = false;
        iAction = 0; % incremental index of actions
        Tprm = randperm(length(T)); % generate random permutation for neigbours
        Bprm = randperm(length(B)); % generate random permutation for neigbours
        while moveFound == false && iAction < HC.maxNumNeighbours
                iAction = iAction + 1; % consume next neigbours
                [it, ib] = ind2sub([length(T) length(B)], iAction);
                u = [T(Tprm(it)) B(Bprm(ib))];
                src.ModelController.set_visit_input(u);
                src.ModelController.visit_next;
                r = visitRobustness;
                if r <= curBestRobustness % a not worst neigbourd has being found
                    % go to neigbourd
                    src.ModelController.set_input(u);
                    src.ModelController.step_model_controller;
                    curBestRobustness = r;
                            
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


