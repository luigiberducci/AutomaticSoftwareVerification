classdef HillClimbing
    %% HillClimbing implementation built over a model with system+robustness evaluator.
    %  The explaination is written in the header of ModelController.
    
    properties
        mdlCtrl
        inLimInf
        inLimSup
        numInputSamples
        H
        numNeigbours
    end
    
    methods
        function obj = HillClimbing(modelCtrl, inLimInf, inLimSup, numInDisc, timeHorizon)
            %% HillClimbing constructor
            % `model` is an instance of ModelController
            % `inLimInf` is a vector of lowerbound of each input signal
            % `inLimSup` is a vector of upperbound of each input signal
            % `numInDisc` is a vector of number of values to sample for
            %             each input signal
            obj.mdlCtrl = modelCtrl;
            obj.inLimInf = inLimInf;
            obj.inLimSup = inLimSup;
            obj.numInputSamples = numInDisc;
            
            obj.numNeigbours = prod(obj.numInputSamples);
            obj.H = timeHorizon;
        end

        function [currentModel, bestRobustness, trace, nSims] = run(obj, restarts)
            [T, B] = obj.computeDiscreteInputSignal();
            trial = restarts;
            nSims = 0;
            totNumIntervals = obj.H / obj.mdlCtrl.interval;
            currentModel = obj.mdlCtrl; % currentModel is a name better than obj.model
            while trial > 0
                currentModel = obj.mdlCtrl;
                trace = []; % init trace that minimizes robustness
                allRobs = [];
                trial = trial - 1;
                nSims = nSims + 1;
                bestRobustness = currentModel.lastRobustness;
                
                % DEBUG
                fprintf("[Info] Remaining Trials: %d\n", trial);
                
                while currentModel.numInterval < totNumIntervals
                    moveFound = false;
                    iAction = 0; % incremental index of actions
                    Tprm = randperm(length(T)); % generate random permutation for neigbours
                    Bprm = randperm(length(B)); % generate random permutation for neigbours
                    while moveFound == false && iAction < obj.numNeigbours
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
                            allRobs = [allRobs; bestRobustness]; % extend robustness trace

                            %Debug
                            %fprintf("[Info] Best Robustness: %f\n\n", bestRobustness);
                            %fprintf("Current Trace:\n");
                            %fprintf("  Thr:\tBrk:\tRob:\n");
                            %disp([trace allRobs]);
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
        
        % TODO moved to MCTS
        function [U1 U2] = computeDiscreteInputSignal(obj)
            % To have `k` discretization, we have to divide by `k-1`. In
            % this way, we include lower/upperbound as legal input value.
            inputStep = (obj.inLimSup - obj.inLimInf) ./ (obj.numInputSamples-1);
            U1 = obj.inLimInf(1) : inputStep(1) : obj.inLimSup(1);
            U2 = obj.inLimInf(2) : inputStep(2) : obj.inLimSup(2);
        end

    end %methods
end %classdef

