classdef ModelController
    %% MODELCONTROLLER This class implements a controller for simulation.
    %  It offers a basic set of API to control the simulation and apply
    %  HillClimbing search. The basic idea is the following:
    %  1) Start a simulation from a random state
    %  2) At each time stage, visit the next states according to the
    %  available input signal changes. Collect the returned values of
    %  `visit`.
    %  3) Pick the best move, which minimize the robustness value.
    %  4) Step the simulation applying such best move.
    %  5) Continue until the end of simulation.
    %  6) If specification falsified (negative robustness) or max number of
    %  iterations is reached, ends. Otherwise, repeat from 1).
    
    properties
        model
    end
    
    methods
        function obj = ModelController(model)
            %MODELCONTROLLER Construct an instance of this class
            obj.model = model;
        end
        
        function obj = setInput(obj, u)
            %% SETINPUT Change the current input signals with `u`.
            obj = obj;
        end
        
        function obj = step(obj)
            %% STEP Step the simulation to the next time stage.
            obj = obj;
        end
        
        function val = visit(obj, u)
            %% VISIT Visit next state and return the robustness value.
            %  Set input vector `u` and simulate a time stage, then return
            %  the robustness value `val`.
            val = 0;
        end
        
        function obj = reset(obj)
            %% RESET Reset the simulation to an initial state.
            obj = obj;
        end
        
        function state = getInitialState(obj)
            %% GETINITIALSTATE Compute an initial state.
            %  The basic implementation is random.
            state = 0;
        end
    end
end

