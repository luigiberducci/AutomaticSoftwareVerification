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
        xInitial
        currentSnapshotTime
        currentInput
        interval
        numInterval
        lastRobustness;
        paramNameValStruct
    end
    
    methods
        function obj = ModelController(model, interval)
            %MODELCONTROLLER Construct an instance of this class
            obj.model = model;        
            obj.interval    = interval;
            obj.numInterval = 0;
            epsilon     = 1e-3;
            
            load_system(model)

            obj.paramNameValStruct.SaveFinalState            = 'on';
            obj.paramNameValStruct.SaveCompleteFinalSimState = 'on';
            obj.paramNameValStruct.FinalStateName            = 'xFinal';
            obj.paramNameValStruct.LoadInitialState          = 'off';
            %% IMPORTANT the object must be called simCtrl in the workspace
            obj.paramNameValStruct.InitialState              = 'simCtrl.xInitial';
            obj.paramNameValStruct.StopTime                  = string(epsilon);
            obj.paramNameValStruct.SaveOutput                = 'on';
            obj.paramNameValStruct.OutputSaveName            = 'Robustness';
            
            obj = obj.setInput([0 0]);
            
            simOut = sim(obj.model, obj.paramNameValStruct);
            obj.lastRobustness = simOut.Robustness.signals.values(end);
            obj.xInitial = simOut.get('xFinal');
            obj.currentSnapshotTime = simOut.get('xFinal').snapshotTime;
            obj.numInterval = 0;
            obj.paramNameValStruct.LoadInitialState = 'on';
        end
        
        function obj = setInput(obj, u)
            %% SETINPUT Change the current input signals with `u`.
            obj.currentInput = u;
            set_param(obj.model+"/Throttle", "Value", string(u(1)));
            set_param(obj.model+"/Brake", "Value", string(u(2)));
        end
        
        function obj = step(obj)
            %% STEP Step the simulation to the next time stage.
            simCtrl = obj;
            obj.numInterval = obj.numInterval + 1;
            time_slice = obj.currentSnapshotTime + obj.interval;
            obj.paramNameValStruct.StopTime = sprintf('%ld', time_slice);

            simOut = sim(obj.model, obj.paramNameValStruct);
            obj.xInitial = simOut.get('xFinal');
            obj.currentSnapshotTime = simOut.get('xFinal').snapshotTime;
            obj.lastRobustness = simOut.Robustness.signals.values(end);
        end
        
        function val = visit(obj, u)
            %% VISIT Visit next state and return the robustness value.
            %  Set input vector `u` and simulate a time stage, then return
            %  the robustness value `val`.
            originalInput = obj.currentInput;
            obj = obj.setInput(u);
            obj = obj.step();
            obj.setInput(originalInput);
            val = obj.lastRobustness;
        end
        
        function obj = reset(obj)
            %% RESET Reset the simulation to an initial state.
            obj = src.ModelController(obj.model, obj.interval);
        end
    end
end

