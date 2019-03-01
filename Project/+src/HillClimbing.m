classdef HillClimbing
    %% HillClimbing implementation built over a model with system+robustness evaluator.
    %  The explaination is written in the header of ModelController.
    
    properties
        model
        T
        B
        numNeigbours
    end
    
    methods
        function obj = HillClimbing(model, t, b)
            %% HillClimbing constructor
            % model is an instance of ModelController
            % t is a vector with possible disturbances for Throttle
            % b is a vector with possible disturbances for Brake
            obj.model = model;
            [T,B] = meshgrid(t,b); % cartesian product of disturbances
            % pi = randperm(length(X)) % generate random permutation for neigbours
            obj.T = T(:); %(pi);
            obj.B = B(:); %(pi);
            obj.numNeigbours = size(obj.T)
        end

        function [currentModel, robustness, trace] = run(obj)
            trace = []; % init trace that minimizes robustness
            currentModel = obj.model; % set model to initial state of the problem
            robustness = currentModel.lastRobustness;
            while true
                moveFound = false;
                i = 0; % seen neigbours
                pi = randperm(length(obj.T)); % generate random permutation for neigbours
                while moveFound == false & i < obj.numNeigbours
                    i = i + 1; % consume next neigbours
                    disturbance = [obj.T(pi(i)) obj.B(pi(i))];
                    r = currentModel.visit(disturbance);
                    if r <= robustness % a not worst neigbourd has being found
                        % go to neigbourd
                        currentModel.setInput(disturbance);
                        currentModel = currentModel.step();
                        robustness = r;
                        moveFound = true;
                        trace = [trace ; disturbance] % update trace
                    end
                end
                if moveFound == false 
                    return
                end
            end
        end

    end %methods
end %classdef

