classdef HillClimbing
    %% HillClimbing implementation built over a model with system+robustness evaluator.
    %  The explaination is written in the header of ModelController.
    
    properties
        model
        T
        K
    end
    
    methods
        function obj = HillClimbing(model, T, K)
            % HillClimbing constructor
            obj.model = model;
            obj.T = T;
            obj.K = K;
        end
    end
end

