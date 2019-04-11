%function [currentModel, bestRobustness, trace, nSims] = run(mdlCtrl, restarts)
[T, B] = noo.HillClimbing.computeDiscreteInputSignal(IN.inLimInf, IN.inLimSup, IN.numInputSamples);
numNeigbours = prod(numInputSamples);
    
trial = HC.restarts;
nSims = 0;          %Counter of simulated traces

while trial > 0
	% DEBUG
    fprintf("[Info] HC - Remaining Trials: %d\n", trial);
        
    noo.ModelController.init_model_controller;
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
                noo.ModelController.set_visit_input(u);
                noo.ModelController.visit_next;
                r = visitRobustness;
                if r <= curBestRobustness % a not worst neigbourd has being found
                    % go to neigbourd
                    noo.ModelController.set_input(u);
                    noo.ModelController.step_model_controller;
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


