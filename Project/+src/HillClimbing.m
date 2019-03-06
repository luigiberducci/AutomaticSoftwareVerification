classdef HillClimbing
    %% HillClimbing implementation built over a model with system+robustness evaluator.
    %  The explaination is written in the header of ModelController.
    
    properties
        mdlCtrl
        T
        B
        H
        numNeigbours
    end
    
    methods
        function obj = HillClimbing(modelCtrl, t, b, H)
            %% HillClimbing constructor
            % `model` is an instance of ModelController
            % `t` is a vector with possible values for Throttle signal
            % `b` is a vector with possible values for Brake signal
            obj.mdlCtrl = modelCtrl;
            [T,B] = meshgrid(t,b); % cartesian product of disturbances
            obj.T = T(:);
            obj.B = B(:);
            obj.numNeigbours = numel(obj.T);
            obj.H = H;
        end

        function [currentModel, bestRobustness, trace] = run(obj, restarts)
            trial = restarts;
            totNumIntervals = obj.H / obj.mdlCtrl.interval;
            currentModel = obj.mdlCtrl; % currentModel is a name better than obj.model
            while trial > 0
                currentModel = currentModel.reset();
                trace = []; % init trace that minimizes robustness
                allRobs = [];
                trial = trial - 1;
                bestRobustness = currentModel.lastRobustness;
                
                % DEBUG
                fprintf("[Info] Remaining Trials: %d\n", trial);
                
                while currentModel.numInterval < totNumIntervals
                    moveFound = false;
                    iAction = 0; % incremental index of actions
                    prm = randperm(length(obj.T)); % generate random permutation for neigbours
                    while moveFound == false && iAction < obj.numNeigbours
                        iAction = iAction + 1; % consume next neigbours
                        currentInput = [obj.T(prm(iAction)) obj.B(prm(iAction))];
                        r = currentModel.visit(currentInput);
                        if r <= bestRobustness % a not worst neigbourd has being found
                            % go to neigbourd
                            currentModel.setInput(currentInput);
                            currentModel = currentModel.step();
                            bestRobustness = r;
                            if bestRobustness <= 0
                                return
                            end
                            moveFound = true;
                            trace = [trace; currentInput]; % extend trace
                            allRobs = [allRobs; bestRobustness]; % extend robustness trace

                            
                            %Debug
                            fprintf("[Info] Best Robustness: %f\n\n", bestRobustness);
                            fprintf("Current Trace:\n");
                            fprintf("  Thr:\tBrk:\tRob:\n");
                            disp([trace allRobs]);
                        end
                    end
                    if moveFound == false 
                        break
                    end
                end
            end
        end

    end %methods
end %classdef

