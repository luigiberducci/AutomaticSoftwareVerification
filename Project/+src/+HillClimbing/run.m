function [currentModel, bestRobustness, trace, nSims] = run(mdlCtrl, restarts)
    [T, B] = src.HillClimbing.computeDiscreteInputSignal();
    totNumIntervals = timeHorizon / mdlCtrl.interval;
    
    currentModel = mdlCtrl;
    
    trial = restarts;
    nSims = 0;          %Counter of simulated traces
    while trial > 0
        % DEBUG
        fprintf("[Info] HC - Remaining Trials: %d\n", trial);
        
        currentModel = mdlCtrl;
        trace = []; % init trace that minimizes robustness
        %allRobs = [];
        trial = trial - 1;
        nSims = nSims + 1;
        bestRobustness = currentModel.lastRobustness;
                
        while currentModel.numInterval < totNumIntervals
            moveFound = false;
            iAction = 0; % incremental index of actions
            Tprm = randperm(length(T)); % generate random permutation for neigbours
            Bprm = randperm(length(B)); % generate random permutation for neigbours
            while moveFound == false && iAction < HCnumNeigbours
                iAction = iAction + 1; % consume next neigbours
                [it, ib] = ind2sub([length(T) length(B)], iAction);
                currentInput = [T(Tprm(it)) B(Bprm(ib))];
                r = currentModel.visit(currentInput);
                if r <= bestRobustness % a not worst neigbourd has being found
                    % go to neigbourd
                    currentModel.setInput(currentInput);
                    currentModel = currentModel.step();
                    bestRobustness = r;
                            
                    moveFound = true;
                    trace = [trace; currentInput]; % extend trace
                    %allRobs = [allRobs; bestRobustness]; % DEBUG extend robustness trace

                    if bestRobustness <= 0
                        return
                    end
                end
            end
            if moveFound == false 
                break
            end
        end
	end
end

